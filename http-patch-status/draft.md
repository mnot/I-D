---
title: The 2xx Patch HTTP Status Code
abbrev: 2xx Patch
docname: draft-nottingham-http-patch-status-00
date: 2014
category: info
updates: 5789

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
    uri: http://www.mnot.net/

normative:
  RFC2119:
  RFC5246:
  RFC5789:
  I-D.ietf-httpbis-p4-conditional:

informative:
  I-D.ietf-httpbis-p2-semantics:
  I-D.ietf-httpbis-p6-cache:
  RFC3864:


--- abstract

This document specifies the 2xx Patch HTTP status code to allow servers to
perform partial updates of stored responses in client caches.

--- middle

# Introduction

{{RFC5246}} defines the HTTP PATCH method as a means of selectively updating
the state of a resource on a server. This document complements that
specification by specifying a means for a server to selectively update a stored
response on a client -- usually, in a cache {{I-D.ietf-httpbis-p6-cache}}.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.

This document uses the Augmented BNF defined by {{RFC5246}}, and additionally
uses the entity-tag rule defined in {{I-D.ietf-httpbis-p4-conditional}}.

# The 2xx Patch Status Code {#status}

The 2xx (Patch) status code allows a response to patch a stored response in a
cache, by reusing some mechanisms from {{RFC5789}}. In some sense, it is the
complement of the HTTP PATCH request method.

TODO: is this a 2xx or 3xx?

Clients can advertise support for 2xx (Patch), along with the patch formats
supported in it, by using the Accept-Patch header field in requests. For
example:

    GET /foo HTTP/1.1
    Host: api.example.com
    Accept-Patch: application/patch+json
    If-None-Match: "abcdef", "ghijkl"
    User-Agent: Example/1.0

If the server can generate a patch for either of the entity tags provided in
If-None-Match in one of the accepted patch formats, it can generate a 2xx
(Patch) response:

    HTTP/1.1 2xx Patch
    Content-Type: application/patch+json
    Patched: "ghijkl"
    ETag: "mnopqrs"
    
The entity tag carried by the ETag header field is associated with the selected
representation - i.e., the stored response after the patch is applied. 

The Patched header field identifies the representation to apply the patch to,
as indicated by the entity-tag provided in If-None-Match request header field.

    Patched = entity-tag

Therefore, in the example above, the stored response "ghijkl" is being patched,
with the resulting stored response having the entity tag "mnopqrs".

When applying a patch response, clients MUST adjust the value of the
Content-Length header, if it exists. Other headers MUST be updated in the same
manner that a 304 (Not Modified) response updates a stored response; see {{}}.

TODO: needs a lot more granularity / detail; exceptions for ETag, Patched,
Content-Type.

The 2xx (Patch) status code SHOULD NOT be generated if the request did not
include If-None-Match, unless conflicts are handled by the patch format itself
(e.g., allowing a patch to append to an array), or externally.

Intermediaries MAY append the Accept-Patch header field to requests, or append
new values to it, if they will process 2xx responses for the patch format(s)
they add. Likewise, intermediaries MAY generate 2xx (Patch) responses under the
conditions specified here.

The 2xx status code is not cacheable by default, and is not a representation of
any identified resource.


## The Patched-ETag Header Field

The Patched-ETag header field identifies the stored representation that a patch
is to be applied to in a 2xx (Patch) response. 

    Patched-ETag = entity-tag


# IANA Considerations

## 2xx Patch HTTP Status Code

This document defines the 2xx (Patch) HTTP status code, as per
{{I-D.ietf-httpbis-p2-semantics}}.

*  Status Code (3 digits): TBD
*  Short Description: Patch
*  Pointer to specification text: {{status}}

## Accept-Patch Header Field

This document updates {{RFC5789}} to allow the Accept-Patch HTTP header field
to be used in requests, which ought to be reflected in the registry.

## Patched Header Field

This document defines a new HTTP header, field, "Patched", to be registered
in the Permanent Message Header Registry, as per {{RFC3864}}.

* Header field name: Patched
* Applicable protocol: http
* Status: standard
* Author/Change controller: IETF
* Specification document(s): [this document]
* Related information:

# Security Considerations

2xx (Patch) can be brittle when the application of a patch fails, because the
client has no way to report the failure of a patch to the server. This
assymetry might be exploited by an attacker, but can be mitigated by judicious
use of strong ETags.

Some patch formats might have additional security considerations.



--- back

# 2xx Patch and HTTP/2 Server Push

In HTTP/2 {{}}, it is possible to "push" a request/response pair into a
client's cache. 2xx (Patch) can be used with this mechanism to perform partial
updates on stored responses.

For example, if a cache has this response stored for "http://example.com/list":

    200 OK
    Content-Type: application/json
    Cache-Control: max-age=3600
    ETag: "aaa"
    
    { "items": ["a"]}

A HTTP/2 server could partially update it by sending the request/response pair
(using pseudo-HTTP/1 syntax for purposes of illustration):

    GET /list
    Host: example.com
    If-None-Match: "aaa"
    Accept-Patch: application/patch+json
    
    2xx Patch
    Content-Type: application/patch+json
    ETag: "aab"
    Patched: "aaa"
    
    { TODO }

Once the patch is applied, the stored response is now:

    200 OK
    Content-Type: application/json
    Cache-Control: max-age=3600
    ETag: "aab"
    
    { "items": ["a", "b"]}

Note that this approach requires a server pushing partial responses to know the
stored response's ETag, since the client cache will silently ignore the push if
it does not match that provided in "Patched". Likewise, clients that are not
conformant to this specification will silently drop such pushes, since the status
code is not recognised (as per {{p6-caching}}).

However, it is possible to do some partial updates without strong consistency. For
example, if the stored response is as above, and the server simply wishes to append
an value to an array, without regard for the current content of the array (because,
presumably, ordering of its content is not important), it can push:

    GET /list
    Host: example.com
    Accept-Patch: application/patch+json
    
    2xx Patch
    Content-Type: application/patch+json
    
    { TODO }

Here, the resulting document would be as above, but since ETags are not provided, the
operation will succeed as long as the patch application succeeds.