---
title: HTTP Representation Variants
abbrev:
docname: draft-nottingham-variants-02
date: 2018
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

This specification introduces an alternative way to communicate a secondary cache key for a HTTP resource, using the HTTP "Variants" and "Variant-Key" response header fields. Its aim is to make HTTP proactive content negotiation more cache-friendly.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/variants>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/variants/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/variants>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-variants/>.

--- middle

# Introduction

HTTP proactive content negotiation ({{!RFC7231}}, Section 3.4.1) is seeing renewed interest in negotiation for language and other, newer attributes (for example, see {{?I-D.ietf-httpbis-client-hints}}).

Successfully reusing negotiated responses that have been stored in a HTTP cache requires establishment of a secondary cache key ({{!RFC7234}}, Section 4.1). Currently, the Vary header ({{!RFC7231}}, Section 7.1.4) does this by nominating a set of request headers.

HTTP's caching model allows a certain amount of latitude in normalising request header field values, so as to increase the chances of a cache hit while still respecting the semantics of that header. However, this is often inadequate; even when the headers' semantics are understood, a cache does not know enough about the possible alternative representations available on the origin server to make an appropriate decision.

For example, if a cache has stored the following request/response pair:

~~~
GET /foo HTTP/1.1
Host: www.example.com
Accept-Language: en;q=1.0, fr;q=0.5

HTTP/1.1 200 OK
Content-Type: text/html
Content-Language: fr
Vary: Accept-Language
Transfer-Encoding: chunked

[French content]
~~~

Provided that the cache has full knowledge of the semantics of Accept-Language and Content-Language, it will know that a French representation is available and might be able to infer that an English representation is not available. But, it does not know (for example) whether a Japanese representation is available without making another request, incurring possibly unnecessary latency.

This specification introduces the HTTP Variants response header field ({{variants}}) to enumerate the available variant representations on the origin server, to provide clients and caches with enough information to properly satisfy requests -- either by selecting a response from cache or by forwarding the request towards the origin -- by following an algorithm defined in {{cache}}.

Its companion the Variant-Key response header field ({{variant-key}}) indicates which representation was selected, so that it can be reliably reused in the future. When this specification is in use, the example above might become:

~~~
GET /foo HTTP/1.1
Host: www.example.com
Accept-Language: en;q=1.0, fr;q=0.5

HTTP/1.1 200 OK
Content-Type: text/html
Content-Language: fr
Vary: Accept-Language
Variants: Accept-Language;fr;de;en;jp
Variant-Key: fr
Transfer-Encoding: chunked

[French content]
~~~

Proactive content negotiation mechanisms that wish to be used with Variants need to define how to do so explicitly; see {{define}}. It is best suited for negotiation over request headers that are well-understood. Variants also works best when content negotiation takes place over a constrained set of representations; since each variant needs to be listed in the header field, it is ill-suited for open-ended sets of representations.

Variants can be seen as a simpler version of the Alternates header field introduced by {{?RFC2295}}; unlike that mechanism, Variants does not require specification of each combination of attributes, and does not assume that each combination has a unique URL.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

This specification uses the Augmented Backus-Naur Form (ABNF) notation of {{!RFC5234}} with a list extension, defined in Section 7 of {{!RFC7230}}, that allows for compact definition of comma-separated lists using a '#' operator (similar to how the '*' operator indicates repetition).

Additionally, it uses the "field-name", "OWS" and "token" rules from {{!RFC7230}}.


# The "Variants" HTTP Header Field {#variants}

The Variants HTTP response header field indicates what representations are available for a given resource at the time that the response is produced, by enumerating the request header fields that it varies on, along with the values that are available for each.

~~~
Variants        = 1#variant-item
variant-item    = field-name *( OWS ";" OWS available-value )
available-value = token
~~~

Each "variant-item" indicates a request header field that carries a value that clients might proactively negotiate for; each parameter on it indicates a value for which there is an available representation on the origin server.

So, given this example header field:

~~~
Variants: Accept-Encoding;gzip
~~~

a recipient can infer that the only content-coding available for that resource is "gzip" (along with the "identity" non-encoding; see {{content-encoding}}).

Given:

~~~
Variants: accept-encoding
~~~

a recipient can infer that no content-codings (beyond identity) are supported. Note that as always, field-name is case-insensitive.

A more complex example:

~~~
Variants: Accept-Encoding;gzip;br, Accept-Language;en ;fr
~~~

Here, recipients can infer that two content-codings in addition to "identity" are available, as well as two content languages. Note that, as with all HTTP header fields that use the "#" list rule (see {{!RFC7230}}, Section 7), they might occur in the same header field or separately, like this:

~~~
Variants: Accept-Encoding;gzip;brotli
Variants: Accept-Language;en ;fr
~~~

The ordering of available-values after the field-name is significant, as it might be used by the header's algorithm for selecting a response (see {{content-encoding}} for an example of this). 

The ordering of the request header fields themselves indicates descending application of preferences; for example, in the headers above, a cache will serve gzip'd content regardless of language if it is available.

Origin servers SHOULD consistently send Variant header fields on all cacheable (as per {{!RFC7234}}, Section 3) responses for a resource, since its absence will trigger caches to fall back to Vary processing.

Likewise, servers MUST send the Variant-Key response header field when sending Variants.


## Relationship to Vary {#vary}

Caches that fully implement this specification SHOULD ignore request header fields in the `Vary` header for the purposes of secondary cache key calculation ({{!RFC7234}}, Section 4.1) when their semantics are implemented as per this specification and their corresponding response header field is listed in `Variants`.

If any member of the Vary header does not have a corresponding variant that is understood by the implementation, it is still subject to the requirements there.


# The "Variant-Key" HTTP Header Field {#variant-key}

The Variant-Key HTTP response header field is used to indicate the value(s) from the Variants header field that identify the representation it occurs within.

~~~
Variant-Key     = 1#available-value
~~~

Each value indicates the selected available-value, in the same order as the variants listed in the Variants header field.

Therefore, Variant-Key MUST be the same length (in comma-separated members) as Variants, and each member MUST correspond in position to its companion in Variants.

For example:

~~~
Variants: Content-Encoding;gzip;br, Content-Language;en ;fr
Variant-Key: gzip, fr
~~~

This header pair indicates that the representation is used for responses that have a "gzip" content-coding and "fr" content-language.

Note that the contents of Variant-Key are only used to indicate what request attributes are identified with the response containing it; this is different from headers like Content-Encoding, which indicate attributes of the response. In the example above, it might be that a gzip'd version of the French content is not available, in which case it will not include "Content-Encoding: gzip", but still have "gzip" in Variant-Key.


## Generating a Normalised Variant-Key {#gen-variant-key}

This algorithm generates a normalised string for Variant-Key, suitable for comparison with values generated by {{cache}}.

Given incoming-headers, a set of headers from an incoming request, a normalised variant-key for that message can be generated by:

1. Let variant-headers be the result of selecting all field-values of incoming-headers whose field-name is "Variant-Key".
2. Let variant-key-segments be an empty list.
3. For each variant-header in variant-headers:
   1. Remove all whitespace from variant-header
   2. Let segments be the result splitting variant-header on the comma (",") character; if there are no commas, it will be a list containing variant-header.
   3. Append each member of segments to variant-key-segments.
4. Let variant-key be the result of joining variant-key-segments with SP (" ").
5. Return variant-key.


# Defining Content Negotiation Using Variants {#define}

To be usable with Variants, proactive content negotiation mechanisms need to be specified to take advantage of it. Specifically, they:

* MUST define a request header field that advertises the clients preferences or capabilities, whose field-name SHOULD begin with "Accept-".
* MUST define the syntax of available-values that will occur in Variants and Variant-Key.
* MUST define an algorithm for selecting a result. It MUST return a list of available-values that are suitable for the request, in order of preference, given the value of the request header nominated above and an available-values list from the Variants header. If the result is an empty list, it implies that the cache cannot satisfy the request.

{{backports}} fulfils these requirements for some existing proactive content negotiation mechanisms in HTTP.


# Cache Behaviour {#cache}

Caches that implement the Variants header field and the relevant semantics of the field-name it contains can use that knowledge to either select an appropriate stored representation, or forward the request if no appropriate representation is stored.

They do so by running this algorithm (or its functional equivalent) upon receiving a request, incoming-request:

1. Let selected-responses be a list of the stored responses suitable for reuse as defined in {{!RFC7234}} Section 4, excepting the requirement to calculate a secondary cache key.
2. Order selected-responses by the "Date" header field, most recent to least recent.
3. If the freshest (as per {{!RFC7234}}, Section 4.2) has one or more "Variants" header field(s):
   1. Select one member of selected_responses and let its "Variants" header field-value(s) be variants-header. This SHOULD be the most recent response, but MAY be from an older one as long as it is still fresh.
   2. Let sorted-variants be an empty list.
   3. For each variant in variants-header:
      1. If variant's field-name corresponds to the response header field identified by a content negotiation mechanism that the implementation supports:
         1. Let request-value be the field-value of the request header field(s) identified by the content negotiation mechanism.
         2. Let available-values be a list containing all available-value for variant.
         3. Let sorted-values be the result of running the algorithm defined by the content negotiation mechanism with request-value and available-values.
         4. Append sorted-values to sorted-variants.
                  
      At this point, sorted-variants will be a list of lists, each member of the top-level list corresponding to a variant-item in the Variants header field-value, containing zero or more items indicating available-values that are acceptable to the client, in order of preference, greatest to least.

   4. If any member of sorted-variants is an empty list, stop processing and forward the request towards the origin, since an acceptable response is not stored in the cache.
   5. Let sorted-keys be the result of running Find Available Keys ({{find}}) on sorted-variants, an empty string and an empty list.

This will result in a list of strings, where each member of the list indicates, in client preference order, a key for an acceptable response to the request.

A Cache MAY satisfy the request with any response whose Variant-Key header, after normalisation (see {{gen-variant-key}}), is a character-for-character match of a member of sorted-keys. When doing so, it SHOULD use the most preferred available response, but MAY use a less-preferred response.

See also {{vary}} regarding handling of Vary.


## Find Available Keys {#find}

Given sorted-variants, a list of lists, and key-stub, a string representing a partial key, and possible-keys, a list:

1. Let sorted-values be the first member of sorted-variants.
2. For each sorted-value in sorted-values:
   1. If key-stub is an empty string, let this-key be a copy of sorted-value.
   1. Otherwise:
      1. Let this-key be a copy of key-stub.
      2. Append a SP (" ") to this-key.
      3. Append sorted-value to this-key.
   3. Let remaining-variants be a copy of all of the members of sorted-variants except the first.
   4. If remaining-variants is empty, append this-key to possible-keys.
   5. Else, run Find Available Keys on remaining-variants, this-key and possible-keys.
3. Return possible-keys.


## Example of Cache Behaviour

For example, if the selected variants-header was:

~~~
Variants: Accept-Language;en;fr,de, Accept-Encoding;gzip,br
~~~

and the request contained the headers:

~~~
Accept-Language: fr;q=1.0, en;q=0.1
Accept-Encoding: gzip
~~~

Then the sorted-variants would be:

~~~
[
  ["fr", "en"]           // prefers French, will accept English
  ["gzip", "identity"]   // prefers gzip encoding, will accept identity
]
~~~

Which means that the sorted-keys would be:

~~~
[
  'fr gzip', 
  'fr identity', 
  'en gzip', 
  'en identity'
]
~~~

Representing a first preference of a French, gzip'd response. Thus, if a cache has a response with:

~~~
Variant-Key: fr, gzip
~~~

it could be used to satisfy the first preference. If not, responses corresponding to the other keys could be returned, or the request could be forwarded towards the origin.



# Example Headers {#examples}

## Single Variant

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
Variant-Key: en
Vary: Accept-Language
Transfer-Encoding: chunked
~~~

Upon receipt of this response, the cache knows that two representations of this resource are available, one with a `Content-Language` of "en", and another whose `Content-Language` is "de".

Subsequent requests (while this response is fresh) will cause the cache to either reuse this response or forward the request, depending on what the selection algorithm determines.

So, if a request with "en" in `Accept-Language` is received and its q-value indicates that it is acceptable, the stored response is used. A request that indicates that "de" is acceptable will be forwarded to the origin, thereby populating the cache. A cache receiving a request that indicates both languages are acceptable will use the q-value to make a determination of what response to return.

A cache receiving a request that does not list either language as acceptable (or does not contain an Accept-Language at all) will return the "en" representation (possibly fetching it from the origin), since it is listed first in the `Variants` list.

Note that `Accept-Language` is listed in Vary, to assure backwards-compatibility with caches that do not support `Variants`.


## Multiple Variants

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
Variant-Key: en, br
Vary: Accept-Language, Accept-Encoding
Transfer-Encoding: chunked
~~~

Here, the cache knows that there are two axes that the response varies upon; `Content-Language` and `Content-Encoding`. Thus, there are a total of nine possible representations for the resource (including the `identity` encoding), and the cache needs to consider the selection algorithms for both axes.

Upon a subsequent request, if both selection algorithms return a stored representation, it can be served from cache; otherwise, the request will need to be forwarded to origin.


## Partial Coverage

Now, consider the previous example, but where only one of the Vary'd axes is listed in `Variants`:

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
Variant-Key: br
Vary: Accept-Language, Accept-Encoding
Transfer-Encoding: chunked
~~~

Here, the cache will need to calculate a secondary cache key as per {{!RFC7234}}, Section 4.1 -- but considering only `Accept-Language` to be in its field-value -- and then continue processing `Variants` for the set of stored responses that the algorithm described there selects.


# IANA Considerations

This specification registers two values in the Permanent Message Header Field Names registry established by {{?RFC3864}}:

* Header field name: Variants
* Applicable protocol: http
* Status: standard
* Author/Change Controller: IETF
* Specification document(s): [this document]
* Related information:

* Header field name: Variant-Key
* Applicable protocol: http
* Status: standard
* Author/Change Controller: IETF
* Specification document(s): [this document]
* Related information:


# Security Considerations

If the number or advertised characteristics of the representations available for a resource are considered sensitive, the `Variants` header by its nature will leak them.

Note that the `Variants` header is not a commitment to make representations of a certain nature available; the runtime behaviour of the server always overrides hints like `Variants`.


# Acknowledgments

This protocol is conceptually similar to, but simpler than, Transparent Content Negotiation {{?RFC2295}}. Thanks to its authors for their inspiration.

It is also a generalisation of a Fastly VCL feature designed by Rogier 'DocWilco' Mulhuijzen.

Thanks to Hooman Beheshti for his review and input.

--- back


# Variants for Existing Content Negotiation Mechanisms {#backports}

This appendix defines the required information to use existing proactive content negotiation mechanisms (as defined in {{!RFC7231}}, Section 5.3) with the `Variants` header field.


## Accept {#content-type}

This section defines handling for `Accept` variants, as per {{!RFC7231}} Section 5.3.2.

To perform content negotiation for Accept given a request-value and available-values:

1. Let preferred-available be an empty list.
2. Let preferred-types be a list of the types in the request-value, ordered by their weight, highest to lowest, as per {{!RFC7231}} Section 5.3.2 (omitting any coding with a weight of 0). If "Accept" is not present or empty, preferred-types will be empty. If a type lacks an explicit weight, an implementation MAY assign one.
3. If preferred-types is empty, append "*/*".
4. For each preferred-type in preferred-types:
   1. If any member of available-values matches preferred-type, using the media-range matching mechanism specified in {{!RFC7231}} Section 5.3.2 (which is case-insensitive), append those members of available-values to preferred-available (preserving the precedence order implied by the media ranges' specificity).
5. Return preferred-available.

## Accept-Encoding {#content-encoding}

This section defines handling for `Accept-Encoding` variants, as per {{!RFC7231}} Section 5.3.4.

To perform content negotiation for Accept-Encoding given a request-value and available-values:

1. Let preferred-available be an empty list.
2. Let preferred-codings be a list of the codings in the request-value, ordered by their weight, highest to lowest, as per {{!RFC7231}} Section 5.3.1 (omitting any coding with a weight of 0). If "Accept-Encoding" is not present or empty, preferred-codings will be empty. If a coding lacks an explicit weight, an implementation MAY assign one.
3. If "identity" is not a member of preferred-codings, append "identity".
4. Append "identity" to available-values.
5. For each preferred-coding in preferred-codings:
   1. If there is a case-insensitive, character-for-character match for preferred-coding in available-values, append that member of available-values to preferred-available.
6. Return preferred-available.

## Accept-Language {#content-language}

This section defines handling for `Accept-Language` variants, as per {{!RFC7231}} Section 5.3.5.

To perform content negotiation for Accept-Language given a request-value and available-values:

1. Let preferred-available be an empty list.
2. Let preferred-langs be a list of the language-ranges in the request-value, ordered by their weight, highest to lowest, as per {{!RFC7231}} Section 5.3.1 (omitting any language-range with a weight of 0). If a language-range lacks a weight, an implementation MAY assign one.
3. Append the first member of available-values to preferred-langs (thus making it the default).
4. For each preferred-lang in preferred-langs:
   1. If any member of available-values matches preferred-lang, using either the Basic or Extended Filtering scheme defined in {{!RFC4647}} Section 3.3, append those members of available-values to preferred-available (preserving their order).
5. Return preferred-available.

