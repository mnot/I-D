---
title: HTTP Variants
abbrev:
docname: draft-nottingham-variant-00
date: 2017
category: std
updates: 7234

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
    organization: Fastly
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This specification introduces the HTTP `Variants` response header field to communicate what representations are available for a given resource.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/variant>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/variant/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/variant>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-variant/>.

--- middle

# Introduction

HTTP proactive content negotiation ({{!RFC7231}}, Section 3.4.1) is increasingly being used to determine not only a response's content-coding, but also its language, as well as newer axes (for example, see {{?I-D.ietf-httpbis-client-hints}}).

Successfully reusing negotiated responses that have been stored in a HTTP cache requires establishment of a secondary cache key ({{!RFC7234}}, Section 4.1) using the Vary header ({{!RFC7231}}, Section 7.1.4).

HTTP's caching model allows a certain amount of latitude in normalising request header fields to match those stored in the cache, so as to increase the chances of a cache hit while still respecting the semantics of that header. However, this is often inadequate; even with understanding of the headers' semantics to facilitate such normalisation, a cache does not know enough about the possible alternative representations available on the origin server to make an appropriate decision.

For example, if a cache has stored the following request/response pair:

~~~
GET /foo HTTP/1.1
Host: www.example.com
Accept-Language: en;q=1.0, fr;q=0.5

HTTP/1.1 200 OK
Content-Type: text/html
Content-Language: fr
Vary: Accept-Language

[French content]
~~~

a downstream (client or intermediary) cache that has full knowledge of the semantics of `Accept-Language` and `Content-Language` will know that a French representation is available, and might be able to infer that an English representation is not available, but it does not know, for example, whether a Japanese representation is available without making another request, thereby incurring possibly unnecessary latency.

This specification introduces the HTTP `Variants` response header field to address this shortcoming, by communicating what representations are available for a given resource.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.

This specification uses the Augmented Backus-Naur Form (ABNF) notation of {{!RFC5234}} with a list extension, defined in Section 7 of {{!RFC7230}}, that allows for compact definition of comma-separated lists using a '#' operator (similar to how the '*' operator indicates repetition).

Additionally, it uses the "field-name", "OWS" and "token" rules from {{!RFC7230}}.

# The "Variant" HTTP Header Field

The `Variant` HTTP response header field is used to indicate what other representations are available for a given resource at the time that the response is produced.

~~~
Variants = 1#( field-name *( OWS ";" OWS token ))
~~~

Each `field-name` in the list indicates a response header field that carries a value that clients might proactively negotiate for; each `token` parameter on the `field-name` is an available value.

So, given this example header field:

~~~
Variants: Content-Encoding;gzip
~~~

a recipient can infer that the only content-coding available for that resource is "gzip".

Given:

~~~
Variants: content-encoding
~~~

a recipient can infer that no content-codings are supported. Note that as always with header field names, it is case-insensitive.

A more complex example:
~~~
Variants: DPR;1.0;2.0, Content-Language;en ;fr
~~~

Here, recipients can infer that two Device Pixel Ratios are available, as well as two content languages. Note that, as with all HTTP header fields that use the "#" list rule (see {{!RFC7230}}, Section 7), they might occur in the same header field or separately.

Note that the ordering of values after the field-name is significant, as it might be used by the header's algorithm for selecting a response.

Senders SHOULD consistently send `Variant` on all cacheable (as per {{!RFC7234}}, Section 3) responses for a resource, since its absence will trigger caches to fall back to `Vary` processing.


## Defining Content Negotiation Using Variants

To be usable with Variants, proactive content negotiation mechanisms need to be specified to take advantage of it. Specifically, they:

* MUST define a request header field that advertises the clients preferences or capabilities, whose field-name SHOULD begin with "Accept-"
* MUST define a response header field that indicates the result of selection, whose field-name SHOULD begin with "Content-" and whose field-value SHOULD be a token
* MUST define a way for selecting a result, given a request header field value.

{{backports}} fulfils these requirements for some existing proactive content negotiation mechanisms in HTTP.


## Cache Behaviour

Caches that implement the `Variants` header field and the relevant semantics of the field-name it contains SHOULD use that knowledge to either select an appropriate stored representation, or forward the request if no appropriate representation is stored.

They do so by running the defined algorithm to normalise the relevant request header field to a value, which they can then either locate in their cache or fetch from the origin server.

The information in the `Variants` header field is usable so long as the response that conveyed it remains fresh (as per {{!RFC7234}}, Section 4.2). Caches SHOULD use the most recent response's `Variant` field-value(s), but MAY use older ones as long as they are still fresh.

### Relationship to Vary

Caches that fully implement this specification MUST ignore request header-fields in the `Vary` header for the purposes of secondary cache key calculation ({{!RFC7234}}, Section 4.1) when their semantics are understood, implemented as per this specification, and their corresponding response header field is listed in `Variants`.

Request header fields listed in `Vary` that are not implemented in terms of this specification or not present in the `Variants` field SHOULD still form part of the secondary cache key.

## Examples

### Single Variant

Given a request/response pair:

~~~
GET /foo HTTP/1.1
Host: www.example.com
Accept-Language: en;q=1.0, fr;q=0.5

HTTP/1.1 200 OK
Content-Type: image/gif
Content-Language: en
Cache-Control: max-age=3600
Variants: Content-Language;en;de
Vary: Accept-Language
~~~

Upon receipt of this response, the cache knows that two representations of this resource are available, one with a `Content-Language` of "en", and another whose `Content-Language` is "de".

Subsequent requests (while this response is fresh) will cause the cache to either reuse this response or forward the request, depending on what the selection algorithm `Accept-Language` and `Content-Language` determines.

So, a request with "en" in `Accept-Language` is received and its q-value indicates that it is acceptable, the stored response is used. A request that indicates that "de" is acceptable will be forwarded to the origin, thereby populating the cache. A cache receiving a request that indicates both languages are acceptable will use the q-value to make a determination of what response to return.

A cache receiving a request that does not list either language as acceptable (or does not contain an Accept-Language at all) will return the "en" representation (possibly fetching it from the origin), since it is listed first.

Note that `Accept-Language` is listed in Vary, to assure backwards-compatibility with caches that do not support `Variants`.

Also, note that response header is listed in `Variants`, not the request header (as is the case with `Vary`).

### Multiple Variants

A more complicated request/response pair:

~~~
GET /bar HTTP/1.1
Host: www.example.net
Accept-Language: en;q=1.0, fr;q=0.5
Accept-Encoding: gzip, br

HTTP/1.1 200 OK
Content-Type: image/gif
Content-Language: en
Content-Encoding: br
Variants: Content-Language;en;jp;de
Variants: Content-Encoding;br;gzip
Vary: Accept-Language, Accept-Encoding
~~~

Here, the cache knows that there are two axes that the response varies upon; `Content-Language` and `Content-Encoding`. Thus, there are a total of six possible representations for the resource, and the cache needs to consider the selection algorithms for both axes.

Upon a subsequent request, if both selection algorithms return a stored representation, it can be served from cache; otherwise, the request will need to be forwarded to origin.

### Partial Coverage

Now, consider the previous example, but where only one of the varied axes is listed in `Variants`:

~~~
GET /bar HTTP/1.1
Host: www.example.net
Accept-Language: en;q=1.0, fr;q=0.5
Accept-Encoding: gzip, br

HTTP/1.1 200 OK
Content-Type: image/gif
Content-Language: en
Content-Encoding: br
Variants: Content-Encoding;br;gzip
Vary: Accept-Language, Accept-Encoding
~~~

Here, the cache will need to calculate a secondary cache key as per {{!RFC7234}}, Section 4.1 -- but considering only `Accept-Language` to be in its field-value -- and then continue processing `Variants` for the set of stored responses that the algorithm described there selects.


# IANA Considerations

This specification registers one value in the Permanent Message Header Field Names registry established by {{?RFC3864}}:

* Header field name: Variants
* Applicable protocol: http
* Status: standard
* Author/Change Controller: IETF
* Specification document(s): [this document]
* Related information:

# Security Considerations

If the number or advertised characteristics of the representations available for a resource are considered sensitive, the `Variants` header by its nature will leak them.

Note that the `Variants` header is not a commitment to make representations of a certain nature available; the runtime behaviour of the server always overrides hints like `Variants`.


--- back

# Variants and Defined Content Negotiation Mechanisms {#backports}

This appendix defines the required information to use existing proactive content negotiation mechanisms (as defined in {{RFC7231}}, Section 5.3) with the `Variants` header field.

## Content-Encoding

When negotiating for the `Content-Encoding` response header field's value, the applicable request header field is `Accept-Encoding`, as per {{!RFC7231}} Section 5.3.4.

Caches SHOULD use Quality Values ({{!RFC7231}}, Section 5.3.1) to determine whether there is an acceptable stored response, in conjunction with the information carried in the Variants response header field.

If no acceptable representation can be found using quality values, the first value listed in the relevant `Variant` field-value SHOULD be selected.

The "identity" encoding (which as per {{!{{RFC7231}} Section 5.3.4 represents "no encoding") is always implicitly available at the lowest priority; if the server wishes to change its priority, it can be explicitly listed. Responses are not required to carry "identity" in the `Content-Encoding` response header field by this specification.

Caches MAY assign a minimum quality value to trigger a request to origin. For example, a cache might decide to send a request to origin if there is not a stored response to which the client has assigned a quality value above 0.2.

## Content-Language

When negotiating for the `Content-Language` response header field's value, the applicable request header field is `Accept-Language`, as per {{!RFC7231}} Section 5.3.5.

Caches SHOULD use Quality Values ({{!RFC7231}}, Section 5.3.1) to determine whether there is an acceptable stored response, in conjunction with the information carried in the Variants response header field.

If no acceptable representation can be found using quality values, the first value listed in the relevant `Variant` field-value SHOULD be selected.

Caches MAY assign a minimum quality value to trigger a request to origin. For example, a cache might decide to send a request to origin if there is not a stored response to which the client has assigned a quality value above 0.2.
