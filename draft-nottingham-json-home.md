---
title: Home Documents for HTTP APIs
abbrev:
docname: draft-nottingham-json-home-latest
date: {DATE}
category: info

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/json-home"

github-issue-label: json-home

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:

informative:


--- abstract

This document proposes a "home document" format for non-browser HTTP clients.


--- middle

# Introduction

It is becoming increasingly common to use HTTP {{!RFC7230}} for applications other than traditional Web browsing. Such "HTTP APIs" are used to integrate processes on disparate systems, make information available to machines across the Internet, and as part of the implementation of "microservices."

By using HTTP, these applications realise a number of benefits, from message framing to caching, and well-defined semantics that are broadly understood and useful.

Often, these applications of HTTP are defined by documenting static URLs that clients need to know and servers need to implement. Any interaction outside of these bounds is uncharted territory.

For some applications, this approach brings issues, especially when the interface changes, either due to evolution, extension or drift between implementations. Furthermore, implementing more than one instance of interface can bring further issues, as different environments have different requirements.

The Web itself offers one way to address these issues, using links {{!RFC3986}} to navigate between states. A link-driven application discovers relevant resources at run time, using a shared vocabulary of link relations {{!RFC8288}} and internet media types {{!RFC6838}} to support a "follow your nose" style of interaction -- just as a Web browser does to navigate the Web.

A client can then decide which resources to interact with "on the fly" based upon its capabilities (as described by link relations), and the server can safely add new resources and formats without disturbing clients that are not yet aware of them.

Doing so can provide any of a number of benefits, including:

* Extensibility - Because new server capabilities can be expressed as resources typed by link relations, new features can be layered in without introducing a new API version; clients will discover them in the home document. This promotes loose coupling between clients and servers.

* Evolvability - Likewise, interfaces can change gradually by introducing a new link relation and/or format while still supporting the old ones.

* Customisation - Home documents can be tailored for the client, allowing different classes of service or different client roles and permissions to be exposed naturally.

* Flexible deployment - Since URLs aren't baked into documentation, the server can choose what URLs to use for a given service.

* API mixing - Likewise, more than one API can be deployed on a given server, without fear of collisions.

Whether an application ought to use links in this fashion depends on how it is deployed; generally, the most benefit will be received when multiple instances of the service are deployed, possibly with different versions, and they are consumed by clients with different capabilities. In particular, Internet Standards that use HTTP as a substrate are likely to require the attributes described above.

This document defines a "home document" format using the JSON format {{!RFC7159}} for APIs to use as a launching point for the interactions they offer, using links. Having a well-defined format for this purpose promotes good practice and development of tooling.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

# API Home Documents

An API Home Document (or "home document") uses the format described in {{!RFC7159}} and has the media type "application/json-home".

**Note: this media type is not final, and will change before final publication.**

Its content consists of a root object with:

* A "resources" member, whose value is an object that describes the resources of the API. Its member names are link relation types (as defined by {{!RFC8288}}), and their values are Resource Objects ({{resource-object}}).

* Optionally, a "api" member, whose value is an API Object ({{api-object}}) that contains information about the API as a whole.

For example:

~~~ http-message
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
  },
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

Here, we have a home document for the API "Example API", whose author can be contacted at the e-mail address "api-admin@example.com", and whose documentation is at "https://example.com/api-docs/".

It links to a resource "/widgets/" with the relation "tag:me@example.com,2016:widgets". It also links to an unknown number of resources with the relation type "tag:me@example.com,2016:widget" using a URI Template {{!RFC6570}}, along with a mapping of identifiers to a variable for use in that template.

It also gives several hints about interacting with the latter "widget" resources, including the HTTP methods usable with them, the PATCH and POST formats they accept, and the fact that they support partial requests {{!RFC7233}} using the "bytes" range-specifier.

It gives no such hints about the "widgets" resource. This does not mean that it (for example) doesn't support any HTTP methods; it means that the client will need to discover this by interacting with the resource, and/or examining the documentation for its link relation type.

Effectively, this names a set of behaviors, as described by a resource object, with a link relation type. This means that several link relations might apply to a common base URL; e.g.:

~~~ json
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

Note that the examples above use both tag {{?RFC4151}} and https {{?RFC7230}} URIs; any URI scheme can be used to identify link relations and other artefacts in home documents. Typically, these are not links to be followed; they are only used to identify things.


# API Objects {#api-object}

An API Object contains links to information about the API itself.

Two optional members are defined:

* "title" has a string value indicating the name of the API;

* "links" has an object value, whose member names are link relation types {{!RFC8288}}, and values
  are URLs {{!RFC3986}}. The context of these links is the API home document as a whole.

No links are required to be conveyed, but APIs might benefit from setting the following:

* author - a suitable URL (e.g., mailto: or https:) for the author(s) of the API
* describedBy - a link to documentation for the API
* license - a link to the legal terms for using the API

Future members of the API Object MAY be defined by specifications that update this document.


# Resource Objects {#resource-object}

A Resource Object links to resources of the type indicated in their name using one of two mechanisms; either a direct link (in which case there is exactly one resource of that relation type associated with the API), or a templated link, in which case there are zero to many such resources.

Direct links are indicated with an "href" property, whose value is a URI {{!RFC3986}}.

Templated links are indicated with an "hrefTemplate" property, whose value is a URI Template {{!RFC6570}}. When "hrefTemplate" is present, the Resource Object MUST have a "hrefVars" property; see "Resolving Templated Links".

Resource Objects MUST have exactly one of the "href" or "href-vars" properties.

In both forms, the links that "href" and "hrefTemplate" refer to are URI-references {{!RFC3986}} whose base URI is that of the API Home Document itself.

Resource Objects MAY also have a "hints" property, whose value is an object that uses HTTP Link Hints (see {{!I-D.nottingham-link-hint}}) as its properties.

## Resolving Templated Links

A URI can be derived from a Templated Link by treating the "hrefTemplate" value as a Level 3 URI Template {{!RFC6570}}, using the "hrefVars" property to fill the template.

The "hrefVars" property, in turn, is an object that acts as a mapping between variable names available to the template and absolute URIs that are used as global identifiers for the semantics and syntax of those variables.

For example, given the following Resource Object:

~~~ json
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

If you understand that "https://example.org/param/widget" is an numeric identifier for a widget, you can then find the resource corresponding to widget number 12345 at "https://example.org/widgets/12345" (assuming that the Home Document is located at "https://example.org/").


# Discovering Home Documents {#discovery}

Home documents are useful starting points for interacting with APIs, both for using the API itself and for discovering additional information about the API. Home documents are distinct resources with their own URIs, and it is possible that home document resources are linked to from other resources, such as from (possibly select) resources of the API itself, or from resources that provide API directory or discovery services.

In these cases, the question is how to establish the link to a home document. This specification defines and registers a specific link relation type for this purpose, so that links to home documents can be made and identified by using this specific link relation type.


## The "home" Link Relation Type {#link-relation}

The "home" link relation type is used to establish a link to a "home document" resource that provides context and/or starting points for the context resource.

The format of the linked home document is not constrained by the "home" link relation type. A home resource can be either machine-readable or human-readable, and the "home" link relation type is appropriate to link to both kinds of home documents.


# Security Considerations

Clients need to exercise care when using hints. For example, a naive client might send credentials to a server that uses the auth-req hint, without checking to see if those credentials are appropriate for that server.

# IANA Considerations


## Media Type Registration

TBD

## Link Relation Type Registration

This specification registers the "home" link relation type in the registry of link relation types {{!RFC8288}}.

* Relation Name: home
* Description: Links to a "home document" resource that provides context and/or starting points for the context resource.
* Reference: This specification


--- back

# Acknowledgements

Thanks to Jan Algermissen, Mike Amundsen, Bill Burke, Sven Dietze, Graham Klyne, Leif Hedstrom, Joe Hildebrand, Jeni Tennison, Erik Wilde and Jorge Williams for their suggestions and feedback.


# Creating and Serving Home Documents

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

The URIs used in API home documents MAY change over time. However, changing them can cause issues for clients that are relying on cached home documents containing old links.

To mitigate the impact of such changes, servers ought to consider:

* Reducing the freshness lifetime of home documents before a link change, so that clients are less likely to refer to an "old" document.
* Regarding the "old" and "new" URIs as equally valid references for an "overlap" period.
* After that period, handling requests for the "old" URIs appropriately; e.g., with a 404 Not Found, or by redirecting the client to the new URI.


## Evolving and Mixing APIs with Home Documents

Using home documents affords the opportunity to change the "shape" of the API over time, without breaking old clients.

This includes introducing new functions alongside the old ones -- by adding new link relation types with corresponding resource objects -- as well as adding new template variables, media types, and so on.

It's important to realise that a home document can serve more than one "API" at a time; by listing all relevant relation types, it can effectively "mix" different APIs, allowing clients to work with different resources as they see fit.


# Consuming Home Documents

Clients might use home documents in a variety of ways.

In the most common case -- actually consuming the API -- the client will scan the Resources Object for the link relation(s) that it is interested in, and then to interact with the resource(s) referred to. Resource Hints can be used to optimize communication with the client, as well as to inform as to the permissible actions (e.g., whether PUT is likely to be supported).

Note that the home document is a "living" document; it does not represent a "contract", but rather is expected to be inspected before each interaction. In particular, links from the home document MUST NOT be assumed to be valid beyond the freshness lifetime of the home document, as per HTTP's caching model {{!RFC7234}}.

As a result, clients ought to cache the home document (as per {{!RFC7234}}), to avoid fetching it before every interaction (which would otherwise be required).

Likewise, a client encountering a 404 (Not Found) on a link is encouraged obtain a fresh copy of the home document, to assure that it is up-to-date.


# Frequently Asked Questions

## Why not use (insert other service description format)?

There are a fair number of existing service description formats, including those that specialise in "RESTful" interactions. However, these formats generally are optimised for pairwise integration, or one-server-to-many-client integration, and less capable of describing protocols where both the server and client can evolve and be extended.

## Why doesn't the format allow references or inheritance?

Adding inheritance or references would allow more modularity in the format and make it more compact, at the cost of considerable complexity and the associated potential for errors (both in the specification and by its users).

Since good tools and compression are effective ways to achieve the same ends, this specification doesn't attempt them.

## What about "Faults" (i.e., errors)?

In HTTP, errors are conveyed by HTTP status codes. While this specification could (and even may) allow enumeration of possible error conditions, there's a concern that this will encourage applications to define many such "faults", leading to tight coupling between the application and its clients. See {{?RFC7807}} for further considerations.

## How Do I find the schema for a format?

That isn't addressed by home documents. Ultimately, it's up to the media type accepted and generated by resources to define and constrain (or not) their syntax.

## How do I express complex query arguments?

Complex queries -- i.e., those that exceed the expressive power of Link Templates or would require ambiguous properties of a "resources" object -- aren't intended to be defined by a home document. The appropriate way to do this is with a "form" language, much as HTML defines.

Note that it is possible to support multiple query syntaxes on the same base URL, using more than one link relation type; see the example at the start of the document.

