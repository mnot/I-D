---
title: Well-Known Resources for HTTP OPTIONS
abbrev: HTTP Options Resources
docname: draft-nottingham-http-options-resources-00
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
    organization: Akamai Technologies
    email: mnot@mnot.net
    uri: http://www.mnot.net/

normative:
  RFC2119:
  RFC5785:

informative:
  RFC7231:
  RFC7232:
  RFC7233:
  RFC7234:
  W3C.REC-cors-20140116:

--- abstract

This document defines a well-known URI that "http://" and "https://" origin servers can use to
assign distinct URLs for their OPTIONS responses, thereby making them fully available as resources
on the Web, as well as cacheable.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/http-options-resources>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/http-options-resources/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/http-options-resources>.


--- middle

# Introduction

HTTP says the OPTIONS method "allows a client to determine the options and/or requirements
associated with a resource, or the capabilities of a server, without implying a resource action."
{{RFC7231}}

CORS {{W3C.REC-cors-20140116}} uses OPTIONS to perform a "pre-flight" request to determine whether
a given resource will allow a state-changing cross-origin request.

This has some unfortunate deployment characteristics. In particular, because OPTIONS is not
cacheable, an intermediary will forward each and every pre-flight request to the origin server,
adding potentially substantial delay to interaction. For high-volume services, the bandwidth
overhead can be more than trivial, since OPTIONS does not support conditional requests {{RFC7232}}.

Furthermore, because OPTIONS responses don't have distinct URLs, it's difficult to incorporate them
into the Web; for example, if they were to be cached, a cache invalidation mechanism would have to
convey the method as well as the URL to be able to invalidate them separately.

This document defines a well-known URI {{RFC5785}} that "http://" and "https://" origin servers can
use to assign distinct URLs for their OPTIONS responses, thereby making them fully available as
resources on the Web, as well as cacheable.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The "options" well-known URI

The 'options' well-known URI {{RFC5785}} defines a space whereby an origin server exposes a set of
options resources, each which operates in an identical fashion to the corresponding target resource
on the origin server, except that they respond to GET requests as if the method had been OPTIONS.

A given options URL can be calculated for a target URL by appending the well-known URI. Examples of
paired target URLs and options URLs follow:

~~~~
http://example.com/ -> http://example.com/.well-known/options/
https://example.com/ -> https://example.com/.well-known/options/
http://example.org/foo -> http://example.org/.well-known/options/foo
http://example.org/?bar -> http://example.org/.well-known/options/?bar
~~~~

This means that the following HTTP/1.1 requests will return the same representation:

~~~~
OPTIONS /foo HTTP/1.1
Host: example.com

GET /.well-known/options/foo HTTP/1.1
Host: example.com
~~~~

The well-known URI "/.well-known/options" (note the lack of a trailing "/") itself is used as a
resource for "OPTIONS *".

## Client Operation {#clients}

A HTTP client that implements this specification can probe the origin server for support by
optimistically making a GET request for either the root options URL "/.well-known/options" (note
the lack of a trailing "/"), or the options URL for the specific resource to be queried (e.g,.
"/.well-known/options/example/").

A 404 (Not Found) or 410 (Gone) response indicates that the origin server does not support this
specification, and the client SHOULD retry the request using the OPTIONS method on the target
resource. Clients SHOULD negatively cache the availability of OPTIONS resources for a given origin
server; if the 404 or 410 response lacks explicit freshness information, they SHOULD use a
heuristic freshness lifetime (e.g., one day).

Alternatively, clients can discover support for this specification by examining the
Content-Location header field on responses to OPTIONS requests; if it is present and contains a
value beginning with "/.well-known/options", the client MAY assume that the origin server supports
it.

Clients MAY cache responses to options URLs {{RFC7234}}, MAY send conditional requests for them
{{RFC7232}}, and MAY request partial content {{RFC7233}}. Clients SHOULD follow redirects from
options URLs {{RFC7231}}.


## Origin Server Operation

A HTTP origin server that implements this specification MUST respond to requests for options URLs
as if the client had performed the same request using the OPTIONS method upon the target resource,
except that:

* The origin server SHOULD send appropriate caching metadata {{RFC7234}}
* The origin server SHOULD respond to conditional requests appropriately {{RFC7232}}
* The origin server MAY respond to range requests with partial content {{RFC7233}}

In particular, origin servers should note that 200 (OK) responses from options URLs are cacheable
by default {{RFC7234}}, and so if they are not intended to be cached, the need to include
appropriate metadata (e.g., Cache-Control: no-store).

Origin servers that implement this specification MUST do so for all resources they are
authoritative for; i.e., implementation is origin-wide, and cannot be selectively applied to
specific resources.

For backwards compatibility, origin servers that implement this specification MUST continue to
respond to OPTIONS requests as they would have otherwise. These responses SHOULD have an
appropriate Content-Location header field {{RFC7231}}.


## Intermediary Operation

An intermediary MAY optimistically translate OPTIONS requests into GET requests on options URLs,
provided that they fall back to making OPTIONS requests if the origin server does not implement
this specification.

Such intermediaries are required to respect the max-forwards header, as per {{RFC7232}}.

Note that an intermediary MAY use options URLs entirely for internal purposes; i.e., client might
make OPTIONS requests, and they might be forwarded as OPTIONS requests due to lack of server-side
support, but the intermediary can still use options URLs internally to effect caching, offer
additional services such as cache invalidation using those URLs, etc.

# IANA Considerations

This document registers the value "options" in the Well-Known URI Registry {{RFC5785}}.

* URI suffix: options
* Change controller: Mark Nottingham <mailto:mnot@mnot.net>
* Specification document(s): [this document]
* Related information: Registered for "http" and "https" URI schemes.


# Security Considerations

Options URLs have similar security considerations to using OPTIONS on target URLs. However, because
they can be cached, servers need to be careful to set appropriate caching policy.


--- back

# Deployment

The obvious benefit of deploying this specification is that it allows HTTP "reverse" proxies and
Content Delivery Networks to cache and serve OPTIONS responses. However, this requires OPTIONS
requests to be transformed into options URLs at some point.

This transformation can be done in user agents, intermediaries and origin servers.

For example, user agents can decide to use options URLs for internal caching purposes, and emit
requests for them when they know the server supports this specification.

Intermediaries can translate incoming OPTIONS requests into options URLs when they know the origin
server supports them, and can reason about OPTIONS requests using them internally.

Origin servers can translate options URLs into OPTIONS requests internally with a fairly simple
modification.

These transformations need not be coordinated, and can happen concurrently as long as clients
conform to the requirements upon them in {{clients}}.
