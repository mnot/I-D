---
title: Interesting Uses for HTTP/2 Server Push
abbrev: HTTP/2 Pushing
docname: draft-nottingham-http2-pushing-00
date: 2016
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft
keyword: http2
keyword: websockets
keyword: server push
keyword: push
keyword: pubsub
keyword: store and forward

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


--- abstract



--- middle

# Introduction

HTTP/2 {{!RFC7540}} defines Server Push as a mechanism for servers to "push" request/response pairs to clients preemptively.

The initial use case for Server Push is saving a round trip of latency when additional content is referenced. For example, when a HTML page references CSS and JavaScript resources, the browser needs to receive the HTML response before it can fetch those resources. Server Push allows the server to proactively send them.

Server Push is now supported by most Web browsers, and sites are starting to experiment with it. In doing so, it's become apparent that client handling of server push is not well-defined, leading to divergence in browser behaviour.

Furthermore, it appears that some deployments tend to treat Server Push like a "magic bullet", pushing far more data that could usefully fill the idle time on the connection.

To improve this, this document:

* Gathers use cases for Server Push with browser caches
* Suggests best practices for generating pushes
* Specifies client behaviours when handling pushes 

It does not contemplate other use cases, such as store-and-forward, 


However, the ability to send an unsolicited message from a server to a client
in HTTP has long been interesting, leading to the development of Comet {{}} as
well as WebSockets {{}}.

These mechanisms have seen some success in deployment, but do not natively
offer a way to scale out to a large number of clients, nor to a distributed
network, because they are relatively low-level protocols (i.e., they do not
offer semantics such as "store-and-forward" or "publish/subscribe").

Furthermore, Server push is defined in terms of HTTP caching {{p6-caching}}, so
as to avoid creaing a backwards-incompatible extension to the protocol. In
other words, it is thought of as "pushing" into the client's cache. Any
additional uses of server push need to be compatible with this use, so as to
avoid interoperability problems with deployed software (e.g., intermediary
caches), unless a new ALPN protocol identifier is used (which would be
undesireable).

This memo explores how to meet these use cases using Server Push, in a manner
that is compatible with its existing uses. It identifies ways to use existing
protocol elements to acheive some goals, while also defining new protocol
elements where necessary.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in {{RFC2119}}.

This document uses the Augmented BNF defined by {{RFC5246}}, and additionally uses the entity-tag rule defined in {{p4-conditional}}.


## Push

  - not magic
  - preload
  - no cookies
  - conneg
  - cache state
  - promise header best practices
  - push api in browsers?
  - pushing uncacheable
  - best practices for content re pushing too much
  - pushing HEAD
  - pushing stale
  - pushing 304
  - pushing redirects
  - partial push
  - trickle push
  - push telemetry
  - dependencies?
  - link @rel as=''
  - clients rejecting pushes
  - visualising with devtools
  - long wait (server think, back end)
  - incoming request effects - cancel? deprioritise others?
  - pushing content of next page 
  - push direct into cache
  - affinity of push -- load group (FF), navigation handle (Edge)
  - "we don't want you to put anything into the cache that the user as not explicitly accessed"
  - constructing push URIs (fragment, headers needed, allowed, disallowed?)
  - matching push_promise headers
  - cookies?
  - canonicalisation when receiving
  - relative priority
  - client behaviour when push is cancelled
  





# Processing Server Push


# Updating Stored Responses

Often, it is necessary to update a stored response, rather than completely
replace it. For example, it may be desireable to update an index of all
available message for a particular client by adding one new message.

One way to achieve this in HTTP/2 is by pushing partial responses {{p5-range}},
along with the corresponding partial requests.

For example, the following request/response pair, when pushed to a client,
would update that client's stored index of messages:

    GET /bob/messages
    Host: api.jitter.com
    Range: bytes 2048-4096
    If-Match: "abcdef"

    206 Partial Content
    Content-Type: application/json
    ETag: "ghijkl"
    Content-Range: bytes 2048-4096/*

Here, the pushed request specifies a range to update, as well as an ETag in
If-Match; if the provided ETag does not match that which has been stored, or if
there is not stored response, the update will silently fail. The pushed
response is a 206 (signifying partial update), and carries a matching
Content-Range header, along with a new ETag header that replaces taht fo the
stored response.

This allows a server to partially update a stored response, but has the
disadvantage of requiring the server to know its exact (byte-for-byte) content,
so we define a different mechanism; the 207 Patch response status code.



# Identifying Push Targets

When clients have more than one server that they could connect to (e.g.,
because the servers are actually intermediary gateways, load balanced using
DNS), it becomes necessary to direct pushes to the appropriate intermediary or
intermediaries (depending upon the use case).

There are many ways to achieve this. Although out-of-band configuration might
be suitable in many cases (since often such networks are), a standard mechanism
is desireable to facilitiate interoperability.

To do so, we assume the following deployment characteristics:

* A very large number of clients.

* A set of gateways. The purpose of this layer is to keep connections open to
  the clients as much as possible, in order to reduce apparent latency. Note
  that this can actually consist of several layers of successive
  intermediaries, used to consolidate connections and/or route traffic.
  
* The origin server or origin servers. 

When a client connects to a gateway, it sends a request that might be satisfied
by a cache, or might be forwarded to the origin. In either case, the response
denotes the cached response(s) to push to that client.



    Push-To: success="/bob"

# Managing Storage

# Backwards Compatibility with HTTP/1.1

    Cache-Control: max-age=0, connpush
    
connpush makes the response fresh as long as the client is connected to the
server. connpush MUST NOT be forwarded or stored beyond the lifetime of the
server connection.

FIXME: is this really a CC directive, or a different header, or...?
Probably a different header, since it needs to be hop-by-hop.



# IANA Considerations

This document registers the following entries in the HTTP/2 Error Code registry:

## PUSH_TO_CACHED

* Name: PUSH_TO_CACHED
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates that the sender already had a fresh cached response, and did not need to update it.
* Specification: [this document]

## PUSH_UNAUTHORITATIVE

* Name: PUSH_UNAUTHORITATIVE
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates
* Specification: [this document]

## PUSH_NOT_MATCH

* Name: PUSH_NOT_MATCH
* Code: 0xNN
* Description: On a RST_STREAM sent on a pushed stream, indicates
* Specification: [this document]



# Security Considerations





--- back
