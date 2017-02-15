---
title: Home Documents for HTTP APIs
abbrev:
docname: draft-nottingham-json-home-06
date: 2017
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
    uri: https://www.mnot.net/

normative:
  RFC2119:
  RFC3986:
  RFC5226:
  RFC5988:
  RFC6570:
  RFC7159:
  RFC7234:

informative:
  RFC5789:
  RFC6838:
  RFC7232:
  RFC7233:
  RFC7235:
  RFC7240:

--- abstract

This document proposes a "home document" format for non-browser HTTP clients.

--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/json-home>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/json-home/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/json-home>.

For information about implementations, see <https://github.com/mnot/I-D/wiki/json-home>.

--- middle

# Introduction

It is becoming increasingly common to use HTTP {{RFC7230}} for applications other than traditional
Web browsing. Such "HTTP APIs" are used to integrate processes on disparate systems, make
information available to machines across the Internet, and as part of the implementation of
"micro-services."

By using HTTP, these applications realise a number of benefits, from message framing to caching,
and well-defined semantics that are broadly understood and useful.

However, one of the core architectural tenants of the Web is the use of links {{RFC3986}} to
navigate between states; typically, these applications document static URLs that clients need to
know and servers need to implement, and any interaction outside of these bounds is uncharted
territory.

In contrast, a link-driven application discovers relevant resources at run time, using a shared
vocabulary of link relations {{RFC5988}} and internet media types {{RFC6838}} to support a "follow
your nose" style of interaction.

A client can then decide which resources to interact with "on the fly" based upon its
capabilities (as described by link relations), and the server can safely add new resources and
formats without disturbing clients that are not yet aware of them.

Doing so can provide any of a number of benefits, including:

* Extensibility - Because new server capabilities can be expressed as link relations, new features can be layered in without introducing a new API version; clients will discover them in the home document. This promotes loose coupling between clients and servers.

* Evolvability - Likewise, interfaces can change gradually by introducing a new link relation and/or format while still supporting the old ones.

* Customisation - Home documents can be tailored for the client, allowing diffrent classes of service or different client permissions to be exposed naturally.

* Flexible deployment - Since URLs aren't baked into documentation, the server can choose what URLs to use for a given service.

* API mixing - Likewise, more than one API can be deployed on a given server, without fear of collisions.

Whether an application ought to use links in this fashion depends on how it is deployed; generally,
the most benefit will be received when multiple instances of the service are deployed, possibly
with different versions, and they are consumed by clients with different capabilities. In
particular, Internet Standards that use HTTP as a substrate are likely to require the attributes
described above.

Clients need to be able to discover information about these applications to use it efficiently;
just as with a human-targeted "home page" for a site, there is a need for a "home document" for a
HTTP API that describes it to non-browser clients.

Of course, an HTTP API might use any format to do so; however, there are advantages to having a
common home document format. This specification defines one, using the JSON format {{RFC7159}}.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# API Home Documents

An API Home Document (or, interchangeably, "home document") uses the format described in {{RFC7159}}
and has the media type "application/json-home".

Its content consists of a root object with:

* A "resources" member, whose value is an object that describes the resources associated with the
  API. Its member names are link relation types (as defined by {{RFC5988}}), and their values are
  Resource Objects ({{resource-object}}).

* Optionally, a "api" member, whose value is an API Object ({{api-object}}) that contains
  information about the API as a whole.

For example:

~~~
  GET / HTTP/1.1
  Host: example.org
  Accept: application/json-home

  HTTP/1.1 200 OK
  Content-Type: application/json-home
  Cache-Control: max-age=3600
  Connection: close

  {
    "api": {
      "title": "Example API",
      "links": {
        "author": "mailto:api-admin@example.com",
        "describedBy": "https://example.com/api-docs/"
      }
    }
    "resources": {
      "tag:me@example.com,2016:widgets": {
        "href": "/widgets/"
      },
      "tag:me@example.com,2016:widget": {
        "hrefTemplate": "/widgets/{widget_id}",
        "hrefVars": {
          "widget_id": "https://example.org/param/widget"
        },
        "hints": {
          "allow": ["GET", "PUT", "DELETE", "PATCH"],
          "formats": {
            "application/json": {}
          },
          "acceptPatch": ["application/json-patch+json"],
          "acceptRanges": ["bytes"]
        }
      }
    }
  }
~~~

Here, we have a home document for the API "Example API", whose author can be contacted at the
e-mail address "api-admin@example.com", and whose documentation is at
"https://example.com/api-docs/".

It links to a resource "/widgets/" with the relation "tag:me@example.com,2016:widgets". It also
links to an unknown number of resources with the relation type "tag:me@example.com,2016:widget"
using a URI Template {{RFC6570}}, along with a mapping of identifiers to a variable for use in that
template.

It also gives several hints about interacting with the latter "widget" resources, including the
HTTP methods usable with them, the PATCH and POST formats they accept, and the fact that they
support partial requests {{RFC7233}} using the "bytes" range-specifier.

It gives no such hints about the "widgets" resource. This does not mean that it (for example)
doesn't support any HTTP methods; it means that the client will need to discover this by
interacting with the resource, and/or examining the documentation for its link relation type.

Effectively, this names a set of behaviors, as described by a resource object, with a link relation
type. This means that several link relations might apply to a common base URL; e.g.:

~~~
{
  "resources": {
    "tag:me@example.com,2016:search-by-id": {
      "hrefTemplate": "/search?id={widget_id}",
      "hrefVars": {
        "widget_id": "https://example.org/param/widget_id"
      }
    },
    "tag:me@example.com,2016:search-by-name": {
      "hrefTemplate": "/search?name={widget_name}",
      "hrefVars": {
        "widget_name": "https://example.org/param/widget_name"
      }
    }
  }
}
~~~

Note that the examples above use both tag {{?RFC4151}} and https {{?RFC7230}} URIs; any URI scheme can be used to identify link relations and other artefacts in home documents.


# API Objects {#api-object}

An API Object contains links to information about the API itself.

Two members are defined:

* "title" has a string value indicating the name of the API;

* "links" has an object value, whose member names are link relation types {{RFC5988}}, and values
  are URLs {{RFC3986}}. The context of these links is the API home document as a whole.

Future members MAY be defined by specifications that update this document.


# Resource Objects {#resource-object}

A Resource Object links to resources of the defined type using one of two mechanisms; either a
direct link (in which case there is exactly one resource of that relation type associated with the
API), or a templated link, in which case there are zero to many such resources.

Direct links are indicated with an "href" property, whose value is a URI {{RFC3986}}.

Templated links are indicated with an "hrefTemplate" property, whose value is a URI Template
{{RFC6570}}. When "hrefTemplate" is present, the Resource Object MUST have a "hrefVars" property;
see "Resolving Templated Links".

Resource Objects MUST have exactly one of the "href" and "href-vars" properties.

In both forms, the links that "href" and "hrefTemplate" refer to are URI-references {{RFC3986}}
whose base URI is that of the API Home Document itself.

Resource Objects MAY also have a "hints" property, whose value is an object that uses named
Resource Hints (see {{resource_hints}}) as its properties.

## Resolving Templated Links

A URI can be derived from a Templated Link by treating the "hrefTemplate" value as a Level 3 URI
Template {{RFC6570}}, using the "hrefVars" property to fill the template.

The "hrefVars" property, in turn, is an object that acts as a mapping between variable names
available to the template and absolute URIs that are used as global identifiers for the semantics
and syntax of those variables.

For example, given the following Resource Object:

~~~
  "https://example.org/rel/widget": {
    "hrefTemplate": "/widgets/{widget_id}",
    "hrefVars": {
      "widget_id": "https://example.org/param/widget"
    },
    "hints": {
      "allow": ["GET", "PUT", "DELETE", "PATCH"],
      "formats": {
        "application/json": {}
      },
      "acceptPatch": ["application/json-patch+json"],
      "acceptRanges": ["bytes"]
    }
  }
~~~

If you understand that "https://example.org/param/widget" is an numeric identifier for a widget, you
can then find the resource corresponding to widget number 12345 at
"https://example.org/widgets/12345" (assuming that the Home Document is located at
"https://example.org/").


# Resource Hints {#resource_hints}

Resource hints allow clients to find relevant information about interacting with a resource
beforehand, as a means of optimizing communications, as well as advertising available behaviors
(e.g., to aid in laying out a user interface for consuming the API).

Hints are just that -- they are not a "contract", and are to only be taken as advisory. The runtime
behavior of the resource always overrides hinted information.

For example, a resource might hint that the PUT method is allowed on all "widget" resources. This
means that generally, the user has the ability to PUT to a particular resource, but a specific
resource might reject a PUT based upon access control or other considerations. More fine-grained
information might be gathered by interacting with the resource (e.g., via a GET), or by another
resource "containing" it (such as a "widgets" collection) or describing it (e.g., one linked to it
with a "describedBy" link relation).

This specification defines a set of common hints, based upon information that's discoverable by
directly interacting with resources. See {{resource_hint_registry}} for information on defining new
hints.

## allow

* Resource Hint Name: allow
* Description: Hints the HTTP methods that the current client will be able to use to interact with
  the resource; equivalent to the Allow HTTP response header.
* Specification: [this document]

Content MUST be an array of strings, containing HTTP methods.

## formats

* Resource Hint Name: formats
* Description: Hints the representation types that the resource produces and consumes, using the
  GET and PUT methods respectively, subject to the 'allow' hint.
* Specification: [this document]

Content MUST be an object, whose keys are media types, and values are objects, currently empty.

## acceptPatch

* Resource Hint Name: accept-Patch
* Description: Hints the PATCH {{RFC5789}} request formats accepted by the resource for this
  client; equivalent to the Accept-Patch HTTP response header.
* Specification: [this document]

Content MUST be an array of strings, containing media types.

When this hint is present, "PATCH" SHOULD be listed in the "allow" hint.

## acceptPost

* Resource Hint Name: acceptPost
* Description: Hints the POST request formats accepted by the resource for this client.
* Specification: [this document]

Content MUST be an array of strings, containing media types.

When this hint is present, "POST" SHOULD be listed in the "allow" hint.

## acceptRanges

* Resource Hint Name: acceptRanges
* Description: Hints the range-specifiers available to the client for this resource; equivalent to
  the Accept-Ranges HTTP response header {{RFC7233}}.
* Specification: [this document]

Content MUST be an array of strings, containing HTTP range-specifiers (typically, "bytes").

## acceptPrefer

* Resource Hint Name: acceptPrefer
* Description: Hints the preferences {{RFC7240}} supported by the resource. Note that, as per that
  specifications, a preference can be ignored by the server.
* Specification: [this document]

Content MUST be an array of strings, containing preferences.

## docs

* Resource Hint Name: docs
* Description: Hints the location for human-readable documentation for the relation type of the
  resource.
* Specification: [this document]

Content MUST be a string containing an absolute-URI {{RFC3986}} referring to documentation that
SHOULD be in HTML format.

## preconditionRequired

* Resource Hint Name: preconditionRequired
* Description: Hints that the resource requires state-changing requests (e.g., PUT, PATCH) to
  include a precondition, as per {{RFC7232}}, to avoid conflicts due to concurrent updates.
* Specification: [this document]

Content MUST be an array of strings, with possible values "etag" and "last-modified" indicating
type of precondition expected.

## authSchemes

* Resource Hint Name: authSchemes
* Description: Hints that the resource requires authentication using the HTTP Authentication
  Framework {{RFC7235}}.
* Specification: [this document]

Content MUST be an array of objects, each with a "scheme" property containing a string that
corresponds to a HTTP authentication scheme, and optionally a "realms" property containing an array
of zero to many strings that identify protection spaces that the resource is a member of.

For example, a Resource Object might contain the following hint:

~~~
  {
    "authSchemes": [
      {
        "scheme": "Basic",
        "realms": ["private"]
      }
    ]
  }
~~~

## status

* Resource Hint Name: status
* Description: Hints the status of the resource.
* Specification: [this document]

Content MUST be a string; possible values are:

* "deprecated" - indicates that use of the resource is not recommended, but it is still available.

* "gone" - indicates that the resource is no longer available; i.e., it will return a 404 (Not
  Found) or 410 (Gone) HTTP status code if accessed.



# Security Considerations

Clients need to exercise care when using hints. For example, a naive client might send credentials
to a server that uses the auth-req hint, without checking to see if those credentials are
appropriate for that server.

# IANA Considerations

## HTTP Resource Hint Registry {#resource_hint_registry}

This specification defines the HTTP Resource Hint Registry. See {{resource_hints}} for a general
description of the function of resource hints.

In particular, resource hints are generic; that is, they are potentially applicable to any
resource, not specific to one application of HTTP, nor to one particular format. Generally, they
ought to be information that would otherwise be discoverable by interacting with the resource.

Hint names MUST be composed of the lowercase letters (a-z), digits (0-9), underscores ("_") and
hyphens ("-"), and MUST begin with a lowercase letter.

Hint content SHOULD be described in terms of JSON {{RFC7159}} constructs.

New hints are registered using the Expert Review process described in {{RFC5226}} to enforce the
criteria above. Requests for registration of new resource hints are to use the following template:

* Resource Hint Name: [hint name]
* Description: [a short description of the hint's semantics]
* Specification: [reference to specification document]

Initial registrations are enumerated in {{resource_hints}}.


## Media Type Registration

TBD


--- back

# Acknowledgements

Thanks to Jan Algermissen, Mike Amundsen, Bill Burke, Sven Dietze, Graham Klyne, Leif Hedstrom,
Joe Hildebrand, Jeni Tennison, Erik Wilde and Jorge Williams for their suggestions and feedback.


# Considerations for Creating and Serving Home Documents

When making an API home document available, there are a few things to keep in mind:

* A home document is best located at a memorable URI, because its URI will effectively become the
  URI for the API itself to clients.
* Home documents can be personalized, just as "normal" home pages can. For example, you might
  advertise different URIs, and/or different kinds of link relations, depending on the client's
  identity.
* Home documents ought to be assigned a freshness lifetime (e.g., "Cache-Control: max-age=3600") so
  that clients can cache them, to avoid having to fetch it every time the client interacts with the
  service.
* Custom link relation types, as well as the URIs for variables, should lead to documentation for
  those constructs.


## Managing Change in Home Documents

The URIs used in API home documents MAY change over time. However, changing them can cause issues
for clients that are relying on cached home documents containing old links.

To mitigate the impact of such changes, servers ought to consider:

* Reducing the freshness lifetime of home documents before a link change, so that clients are less
  likely to refer to an "old" document.
* Regarding the "old" and "new" URIs as equally valid references for an "overlap" period.
* After that period, handling requests for the "old" URIs appropriately; e.g., with a 404 Not
  Found, or by redirecting the client to the new URI.


## Evolving and Mixing APIs with Home Documents

Using home documents affords the opportunity to change the "shape" of the API over time, without
breaking old clients.

This includes introducing new functions alongside the old ones -- by adding new link relation types
with corresponding resource objects -- as well as adding new template variables, media types, and
so on.

It's important to realise that a home document can serve more than one "API" at a time; by listing
all relevant relation types, it can effectively "mix" different APIs, allowing clients to work with
different resources as they see fit.


# Considerations for Consuming Home Documents

Clients might use home documents in a variety of ways.

In the most common case -- actually consuming the API -- the client will scan the Resources Object
for the link relation(s) that it is interested in, and then to interact with the resource(s)
referred to. Resource Hints can be used to optimize communication with the client, as well as to
inform as to the permissible actions (e.g., whether PUT is likely to be supported).

Note that the home document is a "living" document; it does not represent a "contract", but rather
is expected to be inspected before each interaction. In particular, links from the home document
MUST NOT be assumed to be valid beyond the freshness lifetime of the home document, as per HTTP's
caching model {{RFC7234}}.

As a result, clients ought to cache the home document (as per {{RFC7234}}), to avoid fetching it
before every interaction (which would otherwise be required).

Likewise, a client encountering a 404 Not Found on a link is encouraged obtain a fresh copy of the
home document, to assure that it is up-to-date.


# Frequently Asked Questions

## Why doesn't the format allow references or inheritance?

Adding inheritance or references would allow more modularity in the format and make it more
compact, at the cost of considerable complexity and the associated potential for errors (both in
the specification and by its users).

Since good tools and compression are effective ways to achieve the same ends, this specification
doesn't attempt them.

## What about "Faults" (i.e., errors)?

In HTTP, errors are conveyed by HTTP status codes. While this specification could (and even may)
allow enumeration of possible error conditions, there's a concern that this will encourage
applications to define many such "faults", leading to tight coupling between the application and
its clients.

## How Do I find the schema for a format?

That isn't addressed by home documents. Ultimately, it's up to the media type accepted and
generated by resources to define and constrain (or not) their syntax.

## How do I express complex query arguments?

Complex queries -- i.e., those that exceed the expressive power of Link Templates or would require
ambiguous properties of a "resources" object -- aren't intended to be defined by a home document.
The appropriate way to do this is with a "form" language, much as HTML defines.

Note that it is possible to support multiple query syntaxes on the same base URL, using more than
one link relation type; see the example at the start of the document.

