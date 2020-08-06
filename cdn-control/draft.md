---
title: The CDN-Control HTTP Response Header Field
abbrev: CDN-Control
docname: draft-nottingham-cdn-control-00
date: {NOW}
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
    organization: Fastly
    street: made in
    city: Prahran
    region: VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

this specification defines a HTTP header field that conveys HTTP cache directives to gateway caches.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/cdn-control>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/cdn-control/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/cdn-control>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-cdn-control/>.

--- middle

# Introduction

Many HTTP origins servers use gateway caches to distribute their content, either locally (sometimes called a "reverse proxy cache") or in a distributed fashion ("Content Delivery Networks").

While HTTP defines Cache-Control as a means of controlling cache behaviour, it is often desirable to give gateway caches different instructions. To meet this need, this specification defines a separate header field that conveys HTTP cache directives to gateway caches.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.



# The CDN-Control Response Header Field

The CDN-Control Response Header Field allows origin servers to control the behaviour of gateway caches interposed between them and clients, separately from other caches that might handle the response.

It is a Dictionary Structured Header {{!I-D.ietf-httpbis-header-structure}}, whose members can be any directive registered in the HTTP Cache Directive Registry <https://www.iana.org/assignments/http-cache-directives/http-cache-directives.xhtml>.

When CDN-Control is present in a response, caches that use it MUST behave as if the Cache-Control and Expires header fields were not present in the response. In other words, CDN-Control "turns off" other cache directives, and is a wholly separate way to control the cache. Note that this is on a response-by-response basis; if CDN-Control is not present, caches fall back to other control mechanisms as required by HTTP {{!I-D.ietf-httpbis-cache}}.

Caches that use CDN-Control MUST implement the semantics of the following directives:

* max-age
* must-revalidate
* no-store
* no-cache
* private

Precedence of directies in CDN-Control is the same as in Cache-Control; in particular, no-store and no-cache make max-age inoperative.

Typically, caches that use CDN-CONTROL will remove the header field from a response before forwarding it, but MAY leave it intact (e.g., if the downstream client is known to be using its value).

## Examples

For example, the following header fields would instruct a gateway cache to consider the response fresh for 600 seconds, other shared caches for 120 seconds and any remaining caches for 60 seconds:

~~~ example
Cache-Control: max-age=60, smax-age=120
CDN-Control: 600
~~~

These header fields would instruct a gateway cache to consider the response fresh for 600 seconds, while all other caches would be prevented from storing it:

~~~ example
Cache-Control: no-store
CDN-Control: max-age=600
~~~

Because CDN-Control is not present, this header field would prevent all caches from storing the response:

~~~ example
Cache-Control: no-store
~~~

Whereas these would prevent all caches except for gateway caches from storing the response:

~~~ example
Cache-Control: no-store
CDN-Control: none
~~~

(note that 'none' is not a registered cache directive; it is here to avoid sending a header field with an empty value, because such a header might not be preserved in all cases)


## Parsing

CDN-Control is specified a a Structured Field {{!I-D.ietf-httpbis-header-structure}}, and implementations are encouraged to use a parser for that format in the interests of robustness, interoperability and security.

However, some implementers might initially reuse a Cache-Control parser for simplicity. If they do so, they SHOULD observe the following points, to aid in a smooth transition to a full Structured Field parser and prevent interoperability issues:

* If a directive is repeated in the field value (e.g., "max-age=30, max-age=60"), the last value 'wins' (60, in this case)
* Members of the list can have parameters (e.g., "max-age=30;a=b;c=d"), which should be ignored by default

When an implementation does parse CDN-Control as a Structured Field, each directive will be assigned value; for example, max-age has an Integer value, no-store's value is Boolean true, and no-cache's value can either be Boolean true or contain a list of field names. Implementations SHOULD NOT accept other values (e.g. coerce a max-age with a Decimal value into an Integer). Likewise, implementations SHOULD ignore parameters on directives, unless otherwise specified.


# Security Considerations

The security considerations of HTTP caching {{!I-D.ietf-httpbis-cache}} apply.


--- back

# Frequently Asked Questions

## Why not Surrogate-Control?

The Surrogate-Control header field is used by a variety of cache implementations, but their interpretation of it is not consistent; some only support 'no-store', others support a few directives, and still more support a larger variety of implementation-specific directives. These implementations also differ in how they relate Surrogate-Control to Cache-Control and other mechanisms.

Rather than attempt to align all of these different behaviours (which would likely fail, because may existing deployments depend upon them) or define a very small subset, a new header field seems more likely to provide good functionality and interoperability.

## Why not mix with Cache-Control?

An alternative design would be to have gateway caches combine the directives found in Cache-Control and CDN-Control, considering their union as the directives that must be followed.

While this would be slightly less verbose in some cases, it would make interoperability considerable more complex to achieve. Consider the case when there are syntax errors in the argument of a directive; e.g., 'max-age=n60'. Should that directive be ignored, or does it invalidate the entire header field value? If the directive is ignored in CDN-Control, should the cache fall back to a value in Cache-Control? And so on.

Also, this approach would make it difficult to direct the gateway cache to store something while directing other caches to avoid storing it (because no-store overrides max-age).

## Is this just for CDNs?

No; any gateway cache can use it. The name is chosen for convenience and brevity.

