---
title: The Version-Target HTTP Response Header Field
abbrev: Version-Target
docname: draft-nottingham-http-version-target-00
date: 2014
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
    uri: http://www.mnot.net/

normative:
  RFC2119:
  RFC5234:
  RFC7230:
  RFC7231:
  I-D.ietf-tls-applayerprotoneg:

informative:
  I-D.ietf-httpbis-http2:


--- abstract

The 505 (HTTP Version Not Supported) status code does not clearly indicate, on its own, the scope
of the assertion that the HTTP version in use isn't supported. This document introduces a new
header field, "Version-Target" to indicate what it applies to, as well as what protocol version(s)
to use.

--- middle

# Introduction

The semantics of the 505 (Version Not Supported) status code are defined by {{RFC7231}} as:

    The 505 (HTTP Version Not Supported) status code indicates that the 
    server does not support, or refuses to support, the major version of 
    HTTP that was used in the request message. The server is indicating 
    that it is unable or unwilling to complete the request using the same 
    major version as the client, as described in Section 2.6 of 
    [RFC7230], other than with this error message. The server should 
    generate a representation for the 505 response that describes why 
    that version is not supported and what other protocols are supported 
    by that server.

This document defines a new HTTP response header, "Version-Target", to be used in 505 responses
to specify the protocol version(s) that can be used, what resource(s) that assertion applies to, and how long it is valid for (leveraging Cache-Control).

## Use Case: TLS Client Authentication

While Version-Target might have a variety of applications, the primary use case for them is the
signalling that a resource (or set of resources) requires TLS Client Authentication in HTTP/2
{{I-D.ietf-httpbis-http2}}. Since TLS renegotiation has been forbidden in that protocol, a means of
signalling that a particular request should be made on a HTTP/1.1 connection is needed, so that a
client can use that protocol, allowing the server to perform renegotiation to initiate client
authentication.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.

Furthermore, this document uses the Augmented BNF defined in {{RFC5234}}, along with the #rule
list extension defined in {{RFC7230}}, Section 7.

# The Version-Target HTTP Header Field

The Version-Target HTTP Header field, when occurring in 505 (Version Not Supported) responses,
asserts the version or versions of HTTP that are supported, and what resource(s) the assertion
applies to, and optionally how long it lasts.

    Version-Target = 1*( OWS ";" OWS parameter )

This document specifies the following version-target parameters:

* "scope" - one of "origin", "resource" or "prefix" (see below)

* "version-id" - a space-separated list of ALPN protocol identifiers {{I-D.ietf-tls-applayerprotoneg}}.

Additionally, when Version-Target is in use, it indicates that the Cache-Control header conveys a
cache policy that is applicable to this information (as well as the response itself).
    
For example:

    HTTP/1.1 505 Version Not Supported
    Version-Target: scope="prefix", version-id="h2"
    Cache-Control: max=age=60
    
This response indicates that the requested resource and its children (i.e., resources sharing a
common origin that have the requested resources's path as a prefix) cannot be reached over the
current protocol version, and that for the next 60 seconds, the client can successfully request
them using the "h2" protocol (in this case, HTTP/2).


## Version-Target Scopes

This document defines the following values for the "scope" parameter;

* "origin" - indicates that the version-target applies to all resources on the origin of the request

* "resource" - indicates that the version-target applies to the requested resource only (i.e., matching origin, path, and query)

* "prefix" - indicates that the version-target applies to resources when the origin matches and the requested resource's path segments are a prefix. For example, if the requested resource's path is "/foo" then "/foo", "/foo?bar", "/foo/bar", "/foo/bar/baz" would share the version-target, while "/bar",  "/foobar" and "/bar/foo" would not.

# Security Considerations

Version-Target can be used to effect a downgrade attack by a man-in-the-middle. When recieved over an insecure channel, it SHOULD be ignored.

Version-Target can also be used to effect a downgrade attack by a party that has the ability to inject response headers on the same origin. The "origin" scope in particular is able to be misused, and SHOULD be ignored unless the security properties of the new protocol are equal to or better than the existing one.




--- back
