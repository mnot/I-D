---
title: On the use of HTTP as a Substrate
docname: draft-nottingham-bcp56bis-00
date: 2017
category: bcp
obsoletes: 3205

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi:
  symrefs: no
  toc: no
  sortrefs: no
  strict:
  compact:
  comments:
  inline:

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    email: mnot@mnot.net
    uri: https://www.mnot.net/


--- abstract

HTTP is often used as a substrate for other application protocols. This document specifies best
practices for these protocols' use of HTTP.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/bcp56bis>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/bcp56bis/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/bcp56bis>.


--- middle

# Introduction

HTTP {{!RFC7230}} is often used as a substrate for other application protocols. This is done for a
variety of reasons:

* familiarity by implementers, specifiers, administrators, developers and users;
* availability of a variety of client, server and proxy implementations;
* ease of use;
* reuse of existing mechanisms like authentication and encryption; 
* presence of HTTP servers and clients in target deployments, and
* its ability to traverse firewalls.

The Internet community has a long tradition of protocol reuse, dating back to the use of Telnet
{{?RFC0854}} as a substrate for FTP {{?RFC0959}} and SMTP {{?RFC2821}}. However, layering new
protocols over HTTP brings its own set of issues:

* Should an application using HTTP define a new URL scheme? Use new ports?
* Should it use standard HTTP methods and status codes, or define new ones?
* How can the maximum value be extracted from the use of HTTP?
* How can interoperability problems and "protocol dead ends" be avoided?

This document contains best current practices regarding these issues in the use of HTTP by
applications. {{used}} defines what applications it applies to; {{elements}} conveys best practices
for specific HTTP protocol elements.

It is intended primarily for use by IETF efforts, but might be applicable in other situations.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{!RFC2119}}.


# Is HTTP Being Used? {#used}

Different applications have different goals when using HTTP. In this document, we say an
application is _using HTTP_ when any of the following conditions are true:

* The transport port used (or default port) is 80 or 443
* The URL scheme used is "http" or "https"
* The message format is as described in {{RFC7320}}, or the connection handshake is as described in
  {{RFC7540}}.

When an application is using HTTP, all of the requirements of the HTTP protocol suite (including
but not limited to {{!RFC7320}}, {{!RFC7321}}, {{!RFC7322}}, {{!RFC7233}}, {{!RFC7234}},
{{!RFC7325}} and {{!RFC7540}}) are in force.

An application might not be _using HTTP_ according to this definition, but still relying upon the
HTTP specifications in some manner. For example, an application might wish to avoid re-specifying
parts of the message format, but change others; or, it might want to use a different set of methods.

Such applications are referred to as _protocols based upon HTTP_ in this document. These have more
freedom to modify protocol operation, but are also likely to lose at least a portion of the
benefits outlined above, as most HTTP implementations won't be easily adaptable to these changes,
and as the protocol diverges from HTTP, the benefit of mindshare will be lost.

Protocols that are based upon HTTP MUST NOT reuse the HTTP URL schemes, HTTP transport ports, or
HTTP IANA registries; rather, they are encouraged to establish their own.



# Getting the Most out of HTTP {#overview}

TBD - examples, outline a sample application with best practices, explain the overall preferred
approach.



# Using HTTP Protocol Elements {#elements}

This section contains best practices regarding the use of specific HTTP protocol elements.

## URL Schemes

Applications that use HTTP SHOULD use the "http" and/or "https" URL schemes.

Using other schemes to denote an application using HTTP makes it more difficult to use with
existing implementations (e.g., Web browsers), and is likely to fail to meet the requirements of
{{!RFC7595}}.

If it is necessary to advertise the application in use, this SHOULD be done in message payloads,
not the URL scheme.


## Transport Ports

Applications that use HTTP SHOULD use the default port for the URL scheme in use. If it is felt
that networks might need to distinguish the application's traffic for operational reasons, it MAY
register a separate port, but be aware that this has privacy implications for that protocol's users.


## HTTP URLs

In HTTP, URLs are opaque identifiers under the control of the server. As outlined in {{!RFC7320}},
standards cannot usurp this space, since it might conflict with existing resources, and constrain
implementation and deployment.

In other words, applications that use HTTP MUST NOT associate application semantics with specific
URL paths. For example, specifying that a "GET to the URL /foo retrieves a bar document" is bad
practice. Likewise, specifying "The widget API is at the path /bar" violates {{!RFC7320}}.

Instead, applications that use HTTP are encouraged to use typed links {{?RFC5988}} to convey the
URIs that are in use, as well as the semantics of the resources that they identify.


### Initial URL Discovery

Generally, a client with begin interacting with a given application server by requesting an initial
document that contains information about that particular deployment, potentially including links to
other relevant resources.

Applications that use HTTP SHOULD allow an arbitrary URL as that entry point. For example, rather
than specifying "the initial document is at "/foo/v1", they should allow a deployment to give an
arbitrary URL as the entry point for the application.

In cases where doing so is impractical (e.g., it is not possibly to convey a whole URL, but only a
hostname) applications that use HTTP MAY define a well-known URL {{?RFC5785}} as an entry point to
their operation.


## HTTP Methods

Applications that use HTTP are encouraged to use existing HTTP methods.

New HTTP methods are rare; they are required to be registered with IETF Review (see {{!RFC7232}}),
and are also required to be *generic*. That means that they need to be potentially applicable to
all resources, not just those of one application.

While historically some applications (e.g., {{?RFC6352}} and {{?RFC4791}}) have defined non-generic
methods, {{!RFC7231}} now forbids this.

This means that, typically, applications will use GET, POST, PUT, DELETE, PATCH, and other
registered methods.

When it is believed that a new method is required, authors are encouraged to engage with the HTTP
community early, and document their proposal as a separate HTTP extension, rather than as part of
an application's specification.


## HTTP Status Codes

Applications that use HTTP are encouraged to use existing HTTP status codes. 

As with methods, new HTTP status codes are rare, and required (by {{!RFC7231}}) to be registered
with IETF review. Similarly, HTTP status codes are generic; they are required (by {{!RFC7231}}) to
be potentially applicable to all resources, not just to those of one application.

When it is believed that a new status code is required, authors are encouraged to engage with the
HTTP community early, and document their proposal as a separate HTTP extension, rather than as part
of an application's specification.

Status codes' primary function is to convey HTTP semantics for the benefit of generic HTTP
software, not application-specific semantics. Therefore, applications SHOULD NOT specify additional
semantics or refine existing semantics for status codes.

In particular, specifying that a particular status code has a specific meaning in the context of an
application is harmful, as these are not generic semantics, since the consumer needs to be in the
context of the application to understand them.

Furthermore, applications using HTTP SHOULD NOT re-specify the semantics of HTTP status codes, even
if it is only by copying their definition.

Typically, applications using HTTP will convey application-specific information in the message body and/or HTTP header fields, not the status code.


## HTTP Header Fields

Applications that use HTTP MAY define new HTTP header fields, following the advice in {{RFC7321}},
Section 8.3.1.




# IANA Considerations

This document has no requirements for IANA.

# Security Considerations

TBD


--- back


# Getting Value out of HTTP
