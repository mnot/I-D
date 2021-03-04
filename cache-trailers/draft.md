---
title: Updating HTTP Caching Policy in Trailers
abbrev:
docname: draft-nottingham-cache-trailers-00
date: 2021
category: std

ipr: trust200902
area: General
workgroup:
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    city: Prahran
    region: VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/
 -
    ins: J. Snell
    name: James Snell
    organization:
    email: jasnell@gmail.com

normative:
  RFC2119:
  I-D.ietf-httpbis-cache:

informative:


--- abstract

This specification defines how to update caching policy for a response in HTTP trailer fields, after the content has been sent.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/cache-trailers>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/cache-trailers/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/cache-trailers>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-cache-trailers/>.

--- middle

# Introduction

Web content that is "dynamically" generated -- i.e., with the response body streamed by the server to the client as it is created -- is often assumed to be uncacheable. In practice, though, there are some scenarios where caching is beneficial; for example, when a private cache might be able to reuse a personalised, dynamic response for a period, or when such a response can be shared by a number of clients.

A server choosing a caching policy for such a response faces a conundrum: if an error or other unforeseen condition happens during the generation of the response, that caching policy might be too liberal. Currently, the only available solutions are to:

1. prevent or severely curtail downstream caching, or
2. buffer the response until a caching policy can be confidently assigned.

In both cases, performance suffers; in the former, caching efficiency is less than it could be in the common case, In the latter, the server consumes additional resources and delays the response.

This specification provides a third solution: updating the caching policy in HTTP trailer fields, after the content has been sent. Doing so allows content to be streamed, while caching policy can be determined after the content is actually generated.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.


# The "trailer-update" HTTP Cache Directive

The "trailer-update" cache response directive indicates that the caching policy for that response (as indicated by the header field that contains the directive) might be updated by a corresponding trailer field.

When it is present as a cache directive in a header field and a trailer field with the same field name is received, a cache that implements this specification MUST completely replace the stored header field value for that response with the trailer field's value, MUST update its handling of that response to account for the new field value (after any outstanding requests are satisfied), and MUST use that value for the header field in responses to future requests satisfied from that cache entry (i.e., the trailer field is "promoted" to a header field).

In responses where the trailer field value has replaced the header field value, the "trailer-update" directive will have been removed as part of that process. Note that the presence of "trailer-update" does not guarantee that a trailer field will follow.

Caches MAY temporarily store a response that has a caching policy with both the "no-store" and "trailer-update" directives, but MUST NOT reuse that response until the caching policy is updated in a manner that allows it. If the caching policy is not updated or the "no-store" directive is still present in the updated response, the cache MUST immediately and permanently discard the temporarily stored response.

For purposes of calculating a stored response's age ({{I-D.ietf-httpbis-cache, Section 4.2.3}}), caches receiving such a trailer SHOULD consider the response_time to be when the trailer is received, but only when calculating resident_time (not response_delay, as that would be counterproductive for the purpose of estimating network delay).

## Examples

Given a resource that supports this specification but encounters no errors in the generation of a response's content, that response might look like this:

~~~ http-message
HTTP/1.1 200 OK
Content-Type: text/html
Cache-Control: max-age=3600, trailer-update

[body]
~~~

Caches that do not implement this specification will cache it by the header policy; caches that do implement will see no updates in the trailer and do the same.

If a change in caching policy is encountered during the generation of the response content, the resource can prevent reuse by caches that implement this specification by sending:

~~~ http-message
HTTP/1.1 200 OK
Content-Type: text/html
Cache-Control: max-age=3600, trailer-update

[body]
Cache-Control: no-store
~~~

In this case, caches that do not implement this specification will again act as instructed by the header policy, but caches that do implement will see the update in the trailers and prevent reuse of the response after the trailer is received (although it might have been used to satisfy requests that were received in the meantime).

If a resource wishes to prevent non-implementing caches from storing the response, they can send:

~~~ http-message
HTTP/1.1 200 OK
Content-Type: text/html
Cache-Control: no-store; trailer-update

[body]
Cache-Control: max-age=3600
~~~

Here, a non-implementing cache will only see "no-store", and so will not store the response. An implementing cache can optimistically store the response based upon "trailer-update", but only allow its reuse after the caching policy is updated to something which permits that in trailers.

Note that when a downstream cache does not implement this specification, and also does not forward a message's trailer section (as allowed by HTTP), any updates will effectively be lost, even if further downstream caches do implement.


# IANA Considerations

_TBD_

# Security Considerations

_TBD_


--- back
