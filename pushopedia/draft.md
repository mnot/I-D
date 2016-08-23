---
title: Defining HTTP/2 Server Push More Carefully
abbrev: HTTP/2 Pushing
docname: draft-nottingham-pushopedia-00
date: 2016
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft
keyword: http2
keyword: server push
keyword: push

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

informative:
  WHATWG.fetch:
    target: https://fetch.spec.whatwg.org/
    title: Fetch
    author:
      -
        organization: WHAT Working Group
    date: 2016

--- abstract

This document explores the use and implementation of HTTP/2 Server Push, in order to forumlate
recommendations about use and implementation. 

--- middle

# Introduction

HTTP/2 {{!RFC7540}} defines Server Push as a mechanism for servers to "push" request/response pairs
to clients.

The initial use case for Server Push is saving a round trip of latency when additional content is
referenced. For example, when a HTML page references CSS and JavaScript resources, the browser
needs to receive the HTML response before it can fetch those resources. Server Push allows the
server to proactively send them, in anticipation of the browser's imminent need.

Server Push is now supported by most Web browsers, and sites are starting to experiment with it. In
doing so, it's become apparent that client handling of server push is not well-defined, leading to
divergence in browser behaviour.

Furthermore, it appears that some deployments tend to treat Server Push like a "magic bullet",
pushing far more data that could usefully fill the idle time on the connection.

To improve this, this document explores how Server Push interacts with various HTTP features, with
recommendations both for using Server Push in servers, and handling it by clients.

It's not so much of a specification, for now, as it is a collection of ideas about how Server Push
**ought** to work.

It also does not address other use cases for Server Push, such as store-and-forward or
publish-and-subscribe.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Server Push and HTTP Semantics

## HTTP Methods {#method}

{{!RFC7540}}, Section 8.2 requires that promised requests be cacheable, safe, and not have a request
body.

In practice, this means that GET and HEAD can be pushed. A few other methods are cacheable and
safe, but since a request body is prohibited (both by the HTTP/2 spec and wire format), it's not
practical to use them.

GET operates as we'd expect; it makes a representation available as if it had been previously
requested and cached, roughly.

In theory, HEAD should operate in a similar fashion; it would be as if the client had performed a
HEAD and used the pushed response to update the cache, as per {{!RFC7234}}, Section 4.3.5
("Freshening Responses via HEAD"). This might be useful, for example, to update the metadata of
that response. However, the same effect can also be achieved by using a conditional request; see
{{conditional}}.

Of other status codes, perhaps the most interesting would be OPTIONS, because of its use by CORS
({{WHATWG.fetch}}). See {{cors}}.


## HTTP Status Codes {#status}

In principle, any HTTP status code can be pushed in a response. Success (2xx), redirection (300,
301, 302, 303, 307, 308) and eror (4xx and 5xx) status codes all have the same caching semantics,
described in {{RFC7234}}.

This implies that if they are pushed to the client, any of these status codes should behave as if
the client had requested them previously and stored the response. For example, a 403 (Forbidden)
can be pushed and stored just as a 200 (OK) -- even if this would be of very limited use.

There are a few complications to consider, however. 

* 304 (Not Modified) has special interaction with caches and validation that is described in 
  {{conditional}}.

* Other 3xx Redirection codes indicate, when pushed, that if the client were to make that request,
  it will be redirected. That does not mean that the `Location` header's URL should be followed
  immediately; it is only upon an actual request from the client that it should be acted upon.
  Therefore, the caching semantics of 3xx redirects take effect.

* 1xx Informational codes don't make much sense as a Push payload, because the headers they convey
  are lost in most implementations (to be subsumed by the headers in the final response). For
  example, the headers on a 100 (Continue) response are a no-op; effectively, it's a one-bit "go
  ahead" signal. Since HTTP/2 already has protocol-level signalling mechanisms, it's probably best
  to say that 1xx responses SHOULD NOT be sent in Server Push, and MUST be ignored when received.

* 401 (Unauthenticated) and 407 (Proxy-Authenticate) are covered in {{auth}}.

* Many other 4xx and 5xx status codes don't have any practical use in Server Push; e.g., 405
  (Method Not Allowed), 408 (Request Timeout), 411 (Length Required) and 414 (URI Too Long) are all
  reactions to problems with the request. Since the server has sent that request, their use is
  somewhat self-defeating; however, this does not mean that a client encountering them should
  generate an error, or fail to use the response. At the very least, if the response is available
  in devtools, debugging will be easier; additionally, someone might find a creative, appropriate
  use for them some day.


## Conditional Requests {#conditional}

### If-Match / If-Unmodified-Since

If the server has immediate access to the response being pushed (e.g., if the server is authoritative for it, or it is fresh in cache), it might want to send conditional headers in the `PUSH_PROMISE` request.

For example, a request can be sent with `If-Match` and/or `If-Unmodified-Since` to give the client
the earliest possible chance to send a `RST_STREAM` on the promise, without the server starting the
pushed response.

~~~
:method: GET
:scheme: https
:authority: www.example.com
:path: /images/1234.jpg
Host: www.example.com
If-Match: "abcdef"
~~~

Here, when a client receives these headers in a `PUSH_PROMISE`, it can send a `RST_STREAM` if it
has a fresh cached response for `https://www.example.com/images/1234.jpg` with the `ETag` "abcdef".
If it does not do so, the server will continue to push the successful (`2xx`) response (since the
`ETag` does in fact match what is pushed).


###  If-None-Match / If-Modified-Since

If the server does not have a fresh local copy of the response, but does have access to a stale one
(in the meaning of {{!RFC7234}}), it can `PUSH_PROMISE` with `If-None-Match` and/or
`If-Modified-Since`:

~~~
:method: GET
:scheme: https
:authority: www.example.com
:path: /images/5678.jpg
Host: www.example.com
If-None-Match: "lmnop"
~~~

That way, the client again has an opportunity to send `RST_STREAM` if it already has a fresh copy
in cache. 

Once the server has obtained a fresh (possibly validated) response, it can either push a `304 (Not
Modified)` response in the case that the `ETag` hasn't changed, or a successful (`2xx`) response if
it has.

Note that if the client has a fresh copy in cache, but the server does not, the client can still
use the fresh copy; it has not been invalidated just because the server has not kept its copy fresh.


### 304 (Not Modified) without a Conditional

If the server believes that the client does have a stale but valid copy in its cache (e.g., through
the use of a cache digest; see {{?I-D.ietf-httpbis-cache-digest}}), it can send a `PUSH_PROMISE`
followed by a pushed `304 (Not Modified)` response to revalidate that cached response, thereby
making it fresh in the client's cache.

If the server has a local copy of the response that it wishes to use, it can send the PUSH_PROMISE
with an `If-None-Match` and/or `If-Modified-Since` conditional, as above. 

However, if it does not, it will still be desirable to generate the `PUSH_PROMISE` as soon as
possible, so as to avoid the race described in {{!RFC7540}}, Section 8.2.1.

To allow this, a request without a conditional can be sent:

~~~
:method: GET
:scheme: https
:authority: www.example.com
:path: /images/9012.jpg
Host: www.example.com
~~~

When the response body is available to the server, it can send a `304 (Not Modified)` if it
believes that the client already holds a copy (fresh or stale); however, it MUST include the
validators to allow the client to confirm this. For example:

~~~
:status: 304
ETag: "abc123"
Date: Tue, 3 Sep 2016 04:34:12 GMT
Content-Type: image/jpeg
Cache-Control: max-age=3600
~~~

In this case, if the client's cached response does not have the same `ETag` it SHOULD re-issue the
request to obtain a fresh response.

On the other hand, if the server determines that the client does not have the appropriate cached response, it can send the full, successful (`2xx`) response:

~~~
:status: 200
ETag: "abc123"
Date: Tue, 3 Sep 2016 04:34:12 GMT
Content-Type: image/jpeg
Cache-Control: max-age=3600

[ body ]
~~~

**EDITOR'S NOTE**: This approach relies upon an _implicit conditional_ in the PUSH_PROMISE request.
If felt necessary, this can be made explicit, for example by defining a new conditional header
`If-In-Digest`.


## Content Negotiation {#conneg}

The interaction of Content Negotiation and Server Push is tricky, because it requires the server to
guess what the client would have sent, in order to negotiate upon it.

However, it becomes much simpler if we assume that the client SHOULD NOT check a `PUSH_PROMISE` request's headers to see whether or not it would have sent that request.

This means, for example, that if you `PUSH_PROMISE` the "wrong" `User-Agent`, `Accept-Encoding`,
`User-Agent` or even `Cookie` header field, the client SHOULD still use the pushed response; all
they're looking for is a matching request method and URL.

However, this does imply a few things:

* The pushed request and response MUST still "agree"; i.e., if you're using gzip encoding, `Accept-Encoding` and `Content-Encoding` should be pushed with appropriate values.
* The pushed response MUST have an appropriate `Vary` header field, if it is cacheable. This is so that the cache operates properly.

Additionally, the server needs to know what the base capabilities and preferences of the client
are, to allow it to select the appropriate responses to push. To aid this, we suggest that servers
create a response by copying the values of the request header fields mentioned in the `Vary`
response header field from the request that is identified by the `PUSH_PROMISE` frame's Stream ID.

So, for example, if the first request for a page had the following headers:

~~~
:method: GET
:scheme: https
:authority: www.example.com
:path: /
User-Agent: FooAgent/1.0
Accept-Encoding: gzip, br
Accept-Language: en, fr
Accept: text/html,s application/example, image/*
Cookie: abc=123
~~~

and the server wishes to push these response headers for `/images/123.png`:

~~~
:status: 200
Vary: Accept-Encoding
Content-Type: image/png
Cache-Control: max-age=3600
~~~

then it should use these headers for the `PUSH_PROMISE`:

~~~
:method: GET
:scheme: https
:authority: www.example.com
:path: /images/123.png
Accept-Encoding: gzip, br
Vary: Accept-Encoding
~~~

This approach has its limits. For example, use of {{?I-D.ietf-httpbis-client-hints}} might not be
practical with server push (since in some circumstances, hints might change between the base page
request and the request for what's been pushed).

## Caching {#cache}

Server Push has a strong tie to HTTP caching ({{!RFC7234}}).


### Caching and Scope of Server Push {#scope}

Currently, browser implementations of Server Push will not inject the pushed response into the HTTP
cache until there is a reference to it from the stream that the PUSH_PROMISE was sent upon.

This is not specified behaviour, and it has confused some. Reportedly, Firefox ties the affinity of
a push to a "load group", whereas Edge is using a "navigation handle."

Effectively, doing so creates yet another kind of HTTP-ish cache in the browser. See also
<https://github.com/whatwg/fetch/issues/354>.

Discussion about why these implementations feel this is necessary would be helpful. Possible
reasons that have been posited include:

* Avoiding cache flooding. However, sites already have many ways to flood a cache with responses.

* Avoiding cache poisoning. However, an attacker that has the ability to send a push for an origin can also (presumably) get that push referenced by content there.

* Restricting use of push. Some developers want to push not only the assets for a given page to the client, but also push the next page that they might navigate to. This can be seen as abuse, but again, it's already possible to fetch that into the cache in the background.


### Matching Pushes to Cache Entries

Canonicalisation of request URLs is not specified for server push; presumably, limited
canonicalisation (e.g., removing default ports, case-normalising the scheme and authority) are
reasonable.

This might be specified in terms of origins in {{!RFC6454}}, since that already specifies a match
algorithm that's believed to conform with reality (roughly).

It can be derived from the various specifications, but it would also be good to explicitly say that
pushed URLs MUST NOT contain a fragment identifier.s


### Pushing Uncacheable Content

{{!RFC7540}}, Section 8.2 says:

> Pushed responses that are not cacheable MUST NOT be stored by any HTTP cache. They MAY be made
available to the application separately.

As a result, any response that cannot be stored as per the rules in {{RFC7234}}, Section 3 cannot
be stored by a receiving cache.

"Being made available to the application separately" could mean many things. It could be that a
truly uncacheable response (e.g., with `Cache-Control: no-store`) would bypass the HTTP cache but
then be stored by the application in anticipation of a future request, but this might lead to some
surprising results for Web developers, because it's effectively specifying yet another kind of
browser caching (see {{scope}}).

However, they might still be usable if a browser API for Server Push emerges. See
<https://github.com/whatwg/fetch/issues/51>.


### Pushing with max-age=0, no-cache

{{!RFC7540}}, Section 8.2 says:

> Pushed responses are considered successfully validated on the origin server (e.g., if the "no-cache" cache response directive is present ({{!RFC7234}}, Section 5.2.2)) while the stream identified by the promised stream ID is still open.

This implies that, while that stream is open, the pushed response can be considered fresh, even
when it contains any (or all) of the following cache directives:

* max-age=0
* no-cache
* s-maxage=0 (for shared caches)

The underlying principle here is that while the response stream is still open, it's semantically
equivalent to a "normal" response. So, this would also naturally apply to `Expires` when the value
matches that of the `Date` header. It's less clear whether it would apply to pushed responses with
a positive `Age` header, or `Expires` in the past, but on general principles they SHOULD be
considered as just revalidated on the server, and therefore useable without revalidation.

This means that the client can:
* Pass the response on to the application for consumption
* Store the response as stale in the cache

Note that HTTP does not put constraints on _how_ the application uses that response; it might use
it multiple times (e.g., an image might occur more than once on a page, or more than one downstream
client might have made the request). It's just that this reuse isn't in the context of a HTTP
cache's operation.


### Pushing Stale Content

How client caches should handle a pushed stale response (e.g., with some combination of `Expires`,
`Date`, `Cache-Control` and `Age` that results in it being considered not fresh, as per
{{RFC7234}}, Section 4.2) is not defined by HTTP/2.

This also applies to content that was fresh when it was pushed, but has become stale since that
stream closed.

Strictly interpreting the specifications, it would be necessary to issue a revalidation request for
that response. While this seems counter-intuitive at first, it might be interesting to consider
doing so as a way of optimistically pre-fetching content into cache, while still giving the server
control when it is actually used; if the server wants to permit its use, it can send a simple 304 (Not Modified). Otherwise, it can send a different response.


### Pushing and Invalidation

When a server wants to remove the contents of a client's cache for a given URL, but doesn't know
what it's to be replaced with yet, it needs to invalidate.

The only native HTTP mechanism for cache invalidation is described in {{!RFC7234}}, Section 4.4:

> A cache MUST invalidate the effective Request URI (Section 5.5 of {{!RFC7230}}) as well as the URI(s) in the Location and Content-Location response header fields (if present) when a non-error status code is received in response to an unsafe request method.

Since it is triggered by unsafe request methods (like POST), this can't be used in Server Push.

We _could_ use this loophole a bit further down:

> A cache MUST invalidate the effective request URI (Section 5.5 of {{!RFC7230}}) when it receives a non-error response to a request with a method whose safety is unknown.

... by defining a method that is defined to have a method whose safety is unknown (since if it's defined, it either won't be pushable, or won't trigger invalidation). E.g.

~~~
:method: INVALIDATE
:scheme: https
:authority: www.example.com
:path: /thing
~~~

However, doing that might cause problems with IANA, since we'd have to pick a value to register.

Another approach would be to push a 404 (Not Found) or 410 (Gone) to trigger invalidation. However,
Such a push would need to be uncacheable (e.g,. with `Cache-Control: no-store`) to assure that the
error response wasn't returned; however, this falls afoul of HTTP/2's requirement that uncacheable
responses not interact with the HTTP cache.

If invalidation is an important use case, we'll need to change one of these specifications, or
invent a new protocol mechanism. Maybe a `CACHE_INVALIDATE` frame?



## Partial Content {#partial}

Conceivably, it might be interesting to push partial content ({{!RFC7233}}) to make some kinds of
content available to the client, when pushing the entire response would consume too much bandwidth;
e.g.:

* The index portion of a PDF file
* The first segments or a video or audio file (and, in some formats, the last)
* The header of an image file, as it might contain layout-critical metadata

However, it's believed that support for partial content in many caches (in particular, browser
caches) is poor. 


## Authentication {#auth}

401 (Unauthorized) has the side effect of prompting the user for their credentials. Again, this
does not mean that the User Agent ought to do so when receiving a pushed 401; rather, this could be
seen as a mechanism to avoid the round trip that would otherwise be required -- just as in other
intended uses of Server Push.

Presumably, the PUSH_PROMISE for such a request would omit the `Authentication` header field.

407 (Proxy Authenticate) is probably best not to push, since it's confusing authority of the
network vs. the origin. Clients SHOULD ignore such pushes.


## Push and Other HTTP Headers {#headers}

{{!RFC7540}}, Section 8.2.1 says:

> If a client receives a PUSH_PROMISE that does not include a complete and valid set of header fields or the :method pseudo-header field identifies a method that is not safe, it MUST respond with a stream error (Section 5.4.2) of type PROTOCOL_ERROR.

"Complete" in this context is a bit fuzzy. The strictest reading would be that it MUST include the required pseudo-headers, along with any request headers specified by a later `Vary` (as discussed in {{conneg}}). 

There are a few headers that are interesting to consider, however.

Use of the `Host` request header field is discouraged in HTTP/2, and SHOULD be omitted.

The following request headers could be copied from the parent Stream ID's request, but are unlikely to be useful (unless specified in `Vary`), and SHOULD be omitted otherwise:
* `User-Agent` 
* `Cookie`
* `DNT`
 
The `Referer` header could be copied from the parent Stream ID's request, but in most cases this would be a waste of bytes; it SHOULD be omitted.

`Expect` doesn't make much sense in a push, as discussed in {{status}}; it SHOULD be omitted.

`Origin` is discussed in {{cors}}. 

As described in {{conneg}}, none of these headers should cause a client to ignore the push or generate an error. 


## CORS {#cors}

{{!WHATWG.fetch}} defines CORS, which uses the OPTIONS method to pre-flight certain requests to
assure that the server has opted into them, as well as discover what headers and methods are
allowed on such a request.

OPTIONS is safe and (in this case) does not have a request body (although technically, it has a
zero-length body, that can probably be overlooked).

Pushing OPTIONS as a means of pre-seeding CORS information would only work in very limited
circumstances; because CORS is, by nature, cross-origin, the two origins in question would need
some way of coordinating the push; the first origin would effectively tell the second origin that a
request is imminent, so it should initiate a push.

This seems fairly unlikely, unless the origins have an unusually close relationship. Conceivably,
this might be possible if the origins are coalesced onto the same connection, since they would be
represented by the same server. 

Whether or not it's worth the specification and implementation work remains a separate question,
especially when conveying site-wide CORS information via other mechanisms is under discussion.

CORS also defines the use of several headers to control the reuse of content across origins.
Presumably these would operate the same way whether or not they are pushed. Notably, the `Origin`
request header is used to determine where the content that originated the request is from.

For example, a HTML page at `https://www.example.com/thing` would send:

> Origin: https://www.example.com/

when loading content from `https://other.example.net/foo`. 

If the returned content has a header:

> Access-Control-Allow-Origin: https://www.example.com/

then the browser will allow the page to have access to that content.

It's not clear how this interacts with server push. Presumably, it will ignore the value of any
`Origin` header in the PUSH_PROMISE, synthesising an appropriate value.

However, the PUSH_PROMISE might still need to send an Origin header value, if the response contains
`Vary: Origin`; otherwise, a cached response might be incorrectly used for another origin's request.


# Interaction with HTTP/2 Features {#h2}

## Priorities {#priority}

See recent discussion on-list.


## Connection Coalescing {#coalesce}

{{!RFC7540}}, Section 8.2 says:

> The server MUST include a value in the :authority pseudo-header field for which the server is authoritative (see Section 10.1). A client MUST treat a PUSH_PROMISE for which the server is not authoritative as a stream error (Section 5.4.2) of type PROTOCOL_ERROR.

Interestingly, it does not say anything about the relationship of the authority of the stream which
a PUSH_PROMISE appears upon and its embedded request. Is it valid (and a good idea) for a stream
from `foo.example.com` to push a stream to `bar.example.net` (for example)?


## Refusing Pushes

{{!RFC7540}}, Section 8.2.2 says:

> Once a client receives a PUSH_PROMISE frame and chooses to accept the pushed response, the client SHOULD NOT issue any requests for the promised response until after the promised stream has closed.
> If the client determines, for any reason, that it does not wish to receive the pushed response from the server or if the server takes too long to begin sending the promised response, the client can send a RST_STREAM frame, using either the CANCEL or REFUSED_STREAM code and referencing the pushed stream's identifier.

Unfortunately, this doesn't give the server much information about why the push was refused. New
HTTP error codes are collected below, in an attempt to start to give this information.


### PUSH_IS_CACHED

* Name: PUSH_IS_CACHED
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates that the sender already had a fresh cached response, and did not need to update it.
* Specification: [this document]


### PUSH_UNAUTHORITATIVE

* Name: PUSH_UNAUTHORITATIVE
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates that the server is not considered authoritative for the origin of the pushed request.
* Specification: [this document]

Note that this would need to overrule the following requirement in {{RFC7540}}, Section 8.2:

> The server MUST include a value in the :authority pseudo-header field for which the server is authoritative (see Section 10.1). A client MUST treat a PUSH_PROMISE for which the server is not authoritative as a stream error (Section 5.4.2) of type PROTOCOL_ERROR.


### PUSH_CONTENT_ENCODING_NOT_SUPPORTED

* Name: PUSH_CONTENT_ENCODING_NOT_SUPPORTED
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates that the content-coding of the response is not supported by the client.
* Specification: [this document]



# IANA Considerations

TBD


# Security Considerations

Undoubtedly.



--- back
