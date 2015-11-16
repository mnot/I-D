---
title: Cache Digests for HTTP/2
abbrev:
docname: draft-nottingham-h2-cache-digest-00
date: 2015
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: 
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  RFC3986:
  RFC6234:
  RFC6454:
  RFC7234:
  RFC7540:

informative:
  RFC6265:


--- abstract

This specification defines a HTTP/2 frame type to allow clients to inform the server of their
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

This specification defines a HTTP/2 frame type to allow clients to inform the server of their
cache's contents using a Golumb-Rice Coded Set. Servers can then use this to inform their choices
of what to push to clients.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The CACHE_DIGEST Frame

The CACHE_DIGEST frame type is 0xf1. 

NOTE: This is an experimental value; if standardised, a permanent value will be assigned.

A CACHE_DIGEST frame can be sent from a client to a server on any stream in the "open" state, and
conveys a digest of the contents of the cache associated with that stream, as explained in
{{computing}}.

In typical use, a client will send CACHE_DIGEST immediately after the first request on a connection
for a given origin, on the same stream, because there is usually a short period of inactivity then,
and servers can benefit most when they understand the state of the cache before they begin pushing
associated assets (e.g., CSS, JavaScript and images).

Clients MAY send CACHE_DIGEST at other times, but servers ought not expect frequent updates;
instead, if they wish to continue to utilise the digest, they will need update it with responses
sent to that client on the connection.

Servers MUST NOT use any but the most recent CACHE_DIGEST for a given origin as current, and MUST
treat an empty Digest-Value as effectively clearing all stored digests for that origin.

CACHE_DIGEST has no defined meaning when sent from servers to clients, and MAY be ignored.

~~~~
+-------------------------------+-------------------------------+
|            N (16)             |             P (16)            |
+---------------------------------------------------------------+
|          Digest-Len (16)      |
+-------------------------------+-------------------------------+
|         Digest-Value? (*)                    ...
+-------------------------------+-------------------------------+
~~~~

The CACHE_DIGEST frame payload has the following fields:

* N: An unsigned 16-bit integer indicating the number of entries in the digest.
* P: An unsigned 16-bit integer indicating the false positive probability, expressed as 1/P.
* Digest-Len: An unsigned, 16-bit integer indicating the length, in octets, of the Digest-Value field.
* Digest-Value: An optional sequence of octets containing the digest as computed in {{computing}}.

## Computing the Digest-Value {#computing}

The set of URLs that is used to compute Digest-Value MUST only include URLs that share origins
{{RFC6454}} with the stream that CACHE_DIGEST is sent on, and their cached responses MUST be fresh
{{RFC7234}}.

A client MAY choose appropriate values for N and P, based upon available bandwidth and other
resources. Specifically, it MAY choose to only include some cached responses in the digest.
However, P MUST be a power of 2.

To compute a digest-value for a given set of URLs, N and P:

1. Let 'hash-values' be an empty array.
2. Let 'digest-value' be an empty bit array.
3. For each URL, follow these steps:
  1. Convert URL to an ascii string by percent-encoding as appropriate {{RFC3986}}.
  2. Let 'key' be the SHA-256 message digest {{RFC6234}} of URL, expressed as an integer.
  3. Append key modulo ( N * P ) to hash-values.
4. Sort hash-values in ascending order.
5. For each hash-value V:
  1. Let 'Q' be the integer result of V / N.
  2. Let 'R' be the result of V modulo N.
  3. Write Q '1' bits to digest-value.
  4. Write 1 '0' bit to digest-value.
  5. Write R to digest-value as binary.
6. Return digest-value.


# IANA Considerations

This draft currently has no requirements for IANA. If the CACHE_DIGEST frame is standardised, it
will need to be assigned a frame type.

# Security Considerations

The contents of a User Agent's cache can be used to re-identify or "fingerprint" the user over
time, even when other identifiers (e.g., Cookies {{RFC6265}}) are cleared. 

CACHE_DIGEST allows such cache-based fingerprinting to become passive, since it allows the server
to discover the state of the client's cache without any visible change in server behaviour.

As a result, clients MUST mitigate for this threat when the user attempts to remove identifiers
(e.g., "clearing cookies"). This could be achieved in a number of ways; for example: by clearing
the cache, by changing one or both of N and P, or by adding new, synthetic entries to the digest to
change its contents.

TODO: discuss how effective the suggested mitigations actually would be.

Additionally, User Agents SHOULD NOT send CACHE_DIGEST when in "privacy mode."


--- back


# Acknowledgements

Many thanks to Kazuho Oku, who prototyped the ideas presented here and talked about them at the
HTTP Study Group (Japan) in October 2015. See:
<http://www.slideshare.net/kazuho/cache-awareserverpush-in-h2o-version-15>.

Thanks to Adam Langley and Giovanni Bajo for their explorations of Golumb-coded sets. In
particular, see
<http://giovanni.bajo.it/post/47119962313/golomb-coded-sets-smaller-than-bloom-filters>, which
refers to sample code.
