---
title: Cache Digests for HTTP/2
abbrev:
docname: draft-kazuho-h2-cache-digest-00
date: 2016
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: K. Oku
    name: Kazuho Oku
    organization: DeNA Co, Ltd.
    email: kazuhooku@gmail.com

 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: 
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  RFC2818:
  RFC3986:
  RFC4648:
  RFC6234:
  RFC6454:
  RFC7234:
  RFC7540:

informative:
  RFC6265:


--- abstract

This specification defines a HTTP request header to allow clients to inform the server of their
cache's contents. Servers can then use this to inform their choices of what to push to clients.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/h2-cache-digest>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/h2-cache-digest/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/h2-cache-digest>.


--- middle

# Introduction

HTTP/2 {{RFC7540}} allows a server to "push" synthetic request/response pairs into a client's cache
optimistically. While there is strong interest in using this facility to improve perceived Web
browsing performance, it is sometimes counterproductive because the client might already have
cached the "pushed" response.

When this is the case, the bandwidth used to "push" the response is effectively wasted, and
represents opportunity cost, because it could be used by other, more relevant responses. HTTP/2
allows a stream to be cancelled by a client using a RST_STREAM frame in this situation, but there
is still at least one round trip of potentially wasted capacity even then.

This specification defines a HTTP request header to allow clients to inform the server of their
cache's contents using a Golumb-Rice Coded Set. Servers can then use this to inform their choices
of what to push to clients.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Cache-Digest Header Field

The Cache-Digest HTTP request header field conveys a digest of the contents of the cache
associated with that request, as explained in
{{computing}}.

In typical use, a server will use the value of the request header to determine which associated
assets (e.g., CSS, JavaScript and images) should be pushed to the client along with the response
to the request.

~~~~
  cache-digest            = 1#cache-digest-element
  cache-digest-element    = cache-digest-value *(OWS ";" OWS cache-digest-parameter)
  cache-digest-value      = unreserved
  cache-digest-parameter  = token "=" (token / quoted-string)
~~~~

Cache-digest-value contains a digest of the contents of the cache associated with the request
as computed in {{computing}}.  Scope and Role of the value is defined by the four parameters
defined by this specification: "type", "codec", "host", "path".  A server MUST ignore unknown
parameters.

The only value of the "type" parameter defined in this specification is "fresh".  The only
value of the "codec" parameter defined in this specification is "gcs-sha256".  A client MAY
omit the parameters; if not present, the values are assumed to be "fresh" and "gcs-sha256".

A server MUST ignore a cache-digest-element with unknown "type" or "codec".

The use of "host" parameter and "path" parameter is mutually exclusive; a server MUST ignore
a cache-digest-element having both parameters set.

As an example, the cache-digest header of the HTTP request below contains a cache digest
of resources obtained from "example.com", indicating that the "https://example.com/style.css"
and "https://example.com/script.js" exist as fresh entries in the cache.

~~~~
  GET / HTTP/1.1
  Host: example.com
  Cache-Digest: AQgRSl8
~~~~

## The Host Parameter

The "host" parameter widens the scope of the cache-digest-value.

If present, the parameter MUST either convey the host of the target URI, or the authenticated
server identify for the "https" scheme (see {{RFC2818}, Section 3).

If not present, the scope of the cache-digest-value is the authority of the target URI.

Typically, a client can use the field to specify that it is sending a cache digest for entire
host, or for multiple hosts that match against a wildcard certificate provided by a server.

## The Path Parameter

The "path" parameter narrows the scope of the cache-digest-value.

If present, the scope of the cache-digest-value is the resources of the target authority
matching to at least one of the following conditions:

* the parameter is identical to the path of the resource
* the paramater is a prefix of the path of the resource, and the parameter ends with "/"
* the parameter is a prefix of the path of the resource, and the first character of the path not included in the parameter is "/"

If not present, the scope is governed by the rules described for the "host" parameter.

### Computing the Cache-Digest-Value {#computing}

The set of URLs that is used to compute cache-digest-value MUST only include URLs that share the
scheme with the target URI, fall into the scopes defined by the "host" and "path" parameters,
and they MUST be fresh {{RFC7234}}.

A client MAY choose a subset of the available stored responses to include in the set. Additionally,
it MUST choose a parameter, `P`, that indicates the probability of a false positive it is willing
to tolerate, expressed as `1/P`.

`P` MUST be a power of 2.

To compute a digest-value for the set `URLs` and `P`:

1. Let N be the count of `URLs`' members, rounded up to power of 2.
2. Let `hash-values` be an empty array of integers.
3. Append 0 to `hash-values`.
4. For each `URL` in URLs, follow these steps:
    1. Convert `URL` to an ASCII string by percent-encoding as appropriate {{RFC3986}}.
    2. Let `key` be the SHA-256 message digest {{RFC6234}} of URL, expressed as an integer.
    3. Append `key` modulo ( `N` * `P` ) to `hash-values`.
5. Sort `hash-values` in ascending order.
6. Let `digest` be an empty array of bits.
7. Write log base 2 of `N` and `P` to `digest` as octets.
8. For each `V` in `hash-values`:
    1. Let `W` be the value following `V` in `hash-values`.
    2. If `W` and `V` are equal, continue to the next `V`.
    3. Let `D` be the result of `W - V - 1`.
    4. Let `Q` be the integer result of `D / P`.
    5. Let `R` be the result of `D modulo P`.
    6. Write `Q` '1' bits to `digest`.
    7. Write 1 '0' bit to `digest`.
    8. Write `R` to `digest` as binary, using log2(P) bits.
    9. If `V` is the second-to-last member of `hash-values`, stop iterating through `hash-values` and continue to the next step.
9. If the length of `digest` is not a multiple of 8, pad it with 1s until it is.
10. Encode the value of the `digest` using base64url {{RFC4648}} encoding.

# IANA Considerations

This draft currently has no requirements for IANA. If the Cache-Digest header is standardised, it
will need to be registered to the "Message Headers" registry.

# Security Considerations

The contents of a User Agent's cache can be used to re-identify or "fingerprint" the user over
time, even when other identifiers (e.g., Cookies {{RFC6265}}) are cleared. 

Cache-Digest header allows such cache-based fingerprinting to become passive, since it allows the server
to discover the state of the client's cache without any visible change in server behaviour.

As a result, clients MUST mitigate for this threat when the user attempts to remove identifiers
(e.g., "clearing cookies"). This could be achieved in a number of ways; for example: by clearing
the cache, by changing one or both of N and P, or by adding new, synthetic entries to the digest to
change its contents.

TODO: discuss how effective the suggested mitigations actually would be.

Additionally, User Agents SHOULD NOT send Cache-Digest header when in "privacy mode."


--- back


# Acknowledgements

Thanks to Adam Langley and Giovanni Bajo for their explorations of Golumb-coded sets. In
particular, see
<http://giovanni.bajo.it/post/47119962313/golomb-coded-sets-smaller-than-bloom-filters>, which
refers to sample code.
