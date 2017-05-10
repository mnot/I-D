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
keyword: HTTP
keyword: Web
keyword: substrate

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

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

* familiarity by implementers, specifiers, administrators, developers and users,
* availability of a variety of client, server and proxy implementations,
* ease of use,
* ubiquity of Web browsers,
* reuse of existing mechanisms like authentication and encryption,
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
applications other than Web browsing. {{used}} defines what applications it applies to;
{{overview}} surveys the properties of HTTP that are important to preserve, and {{bp}} conveys best
practices for those applications that do use HTTP.

It is written primarily to guide IETF efforts, but might be applicable in other situations.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{!RFC2119}}.


# Is HTTP Being Used? {#used}

Different applications have different goals when using HTTP. In this document, we say an
application is _using HTTP_ when any of the following conditions are true:

* The transport port (or default port) is 80 or 443,
* The URL scheme is "http" or "https",
* The ALPN protocol ID {{!RFC7301}} is "http/1.1", "h2" or "h2c", or
* The message formats described in {{RFC7320}} and/or {{RFC7540}} are used in conjunction with the IANA registries defined for HTTP.

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

Protocols that are based upon HTTP MUST NOT reuse HTTP's URL schemes, transport ports, ALPN
protocol IDs or IANA registries; rather, they are encouraged to establish their own.


# What's Important About HTTP {#overview}

There are many ways that HTTP applications are defined and deployed, and sometimes they are brought
to the IETF for standardisation. In that process, what might be workable for deployment in a
limited fashion isn't appropriate for standardisation and the corresponding broader deployment.
This section examines the facets of the protocol that are important to preserve in these situations.


## Generic Semantics

When writing an application's specification, it's often tempting to specify exactly how HTTP is to
be implemented, supported and used.

However, this can easily lead to an unintended profile of HTTP's behaviour. For example, it's
common to see specifications with language like this:

    A `200 OK` response means that the widget has successfully been updated.

This sort of specification is bad practice, because it is adding new semantics to HTTP's status
codes and methods, respectively; a recipient -- whether it's an origin server, client library,
intermediary or cache -- now has to know these extra semantics to understand the message.

Some applications even require specific behaviours, such as:

    A `POST` request MUST result in a `201 Created` response.

This forms an expectation in the client that the response will always be `201 Created`, when in
fact there are a number of reasons why the status code might differ in a real deployment. If the
client does not anticipate this, the application's deployment is brittle.

Much of the value of HTTP is in its _generic semantics_ -- that is, the protocol elements defined
by HTTP are potentially applicable to every resource, not specific to a particular context.
Application-specific semantics are expressed in the payload; mostly, in the body, but also in
header fields.

This allows a HTTP message to be examined by generic HTTP software, and its handling to be
correctly determined. It also allows people to leverage their knowledge of HTTP semantics without
special-casing them for a particular application.

Therefore, applications that use HTTP MUST NOT re-define, refine or overlay the semantics of
defined protocol elements. Instead, they SHOULD focus their specifications on protocol elements
that are specific to them; namely their HTTP resources.

See {{resource}} for details.


## Links

Another common practice is assuming that the HTTP server's name space (or a portion thereof) is
exclusively for the use of a single application. This effectively overlays special,
application-specific semantics onto that space, precludes other applications from using it.

As explained in {{!RFC7320}}, such "squatting" on a part of the URL space by a standard usurps the
server's authority over its own resources, can cause deployment issues, and is therefore bad
practice in standards.

Instead of statically defining URL paths, applications are encouraged to define links in payloads,
to allow flexibility in deployment. For example, navigating with a link allows a request to be
routed to a different server without the overhead of a redirection, thereby supporting deployment
across machines well.


## HTTP Capabilities

The simplest possible use of HTTP is to POST data to a single URL, thereby effectively tunnelling
through the protocol.

This "RPC" style of communication does get some benefit from using HTTP -- namely, message framing and the availability of implementations -- but fails to realise many others:

* Caching for server scalability, latency and bandwidth reduction, and reliability;
* Authentication and access control;
* Automatic redirection;
* Partial content to selectively request part of a response;
* Natural support for extensions and versioning through protocol extension; and
* The ability to interact with the application easily using a Web browser.

Using such a high-level protocol to tunnel simple semantics has downsides too; because of its more
advanced capabilities, breadth of deployment and age, HTTP's complexity can cause interoperability
problems that could be avoided by using a simpler substrate (e.g., WebSockets {{?RFC6455}}, if
browser support is necessary, or TCP {{?RFC0793}} if not), or making the application be _based upon
HTTP_, instead of using it (as defined in {{used}}).

Applications that use HTTP are encouraged to accommodate the various features that the protocol
offers, so that their users receive the maximum benefit from it. This document does not require
specific features to be used, since the appropriate design tradeoffs are highly specific to a given
situation. However, following the practices in {{bp}} will help make them available.



# Best Practices for Using HTTP {#bp}

This section contains best practices regarding the use of HTTP by applications, including practices
for specific HTTP protocol elements.


## Specifying the Use of HTTP

When specifying the use of HTTP, an application SHOULD use {{!RFC7230}} as the primary reference,
MAY specify a minimum version to be supported (HTTP/1.1 is suggested), and SHOULD NOT specify a
maximum version.

Likewise, applications need not specify what HTTP mechanisms -- such as redirection, caching,
authentication, proxy authentication, and so on -- are to be supported. Full featured support for
HTTP SHOULD be taken for granted in servers and clients, and the application's function SHOULD
degrade gracefully if they are not (although this might be achieved by informing the user that
their task cannot be completed).

For example, an application can specify that it uses HTTP like this:

    Foo Application uses HTTP {{!RFC7230}}. Implementations MUST support 
    HTTP/1.1, and MAY support later versions. Support for common HTTP 
    mechanisms such as redirection and caching are assumed.


## Defining HTTP Resources {#resource}

HTTP Applications SHOULD focus on defining the following application-specific protocol elements:

* Media types {{!RFC6838}}, often based upon a format convention such as JSON {{?RFC7159}},
* HTTP header fields, as per {{headers}}, and
* The behaviour of resources, as identified by link relations {{!RFC5988}}.

By composing these protocol elements, an application can define a set of resources, identified by
link relations, that implement specified behaviours, including:

* Retrieval of their state using GET, in one or more formats identified by media type;
* Resource creation or update using POST or PUT, with an appropriately identified request body format;
* Data processing using POST and identified request and response body format(s); and
* Resource deletion using DELETE.

For example, an application could specify:

    Resources linked to with the "example-widget" link relation type are
    Widgets. The state of a Widget can be fetched in the
    "application/example-widget+json" format, and can be updated by PUT
    to the same link. Widget resources can be deleted.

    The "Example-Count" response header field on Widget representations
    indicates how many Widgets are held by the sender.

    The "application/example-widget+json" format is a JSON {{?RFC7159}}
    format representing the state of a Widget. It contains links to
    related information in the link indicated by the Link header field
    value with the "example-other-info" link relation type.


## URL Schemes

Applications that use HTTP MUST use the "http" and/or "https" URL schemes.

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

In cases where doing so is impractical (e.g., it is not possible to convey a whole URL, but only a
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
if it is only by copying their definition. They MUST NOT require specific status phrases to be
used; the status phrase has no function in HTTP, and is not guaranteed to be preserved by
implementations.

Typically, applications using HTTP will convey application-specific information in the message body
and/or HTTP header fields, not the status code.

Specifications sometimes also create a "laundry list" of potential status codes, in an effort to be
helpful. The problem with doing so is that such a list is never complete; for example, if a network
proxy is interposed, the client might encounter a `407 Proxy Authentication Required` response; or,
if the server is rate limiting the client, it might receive a `429 Too Many Requests` response.

Since the list of HTTP status codes can be added to, it's safer to refer to it directly, and point
out that clients SHOULD be able to handle all applicable protocol elements gracefully (i.e.,
falling back to the generic `n00` semantics of a given status code; e.g., `499` can be safely
handled as `400` by clients that don't recognise it).


## HTTP Header Fields {#headers}

Applications that use HTTP MAY define new HTTP header fields, following the advice in {{RFC7321}},
Section 8.3.1.




# IANA Considerations

This document has no requirements for IANA.

# Security Considerations

TBD


--- back


