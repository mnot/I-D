---
title: Home Documents for HTTP APIs
abbrev: 
docname: draft-nottingham-json-home-03
date: 2013
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
  RFC3986:
  RFC4627:
  RFC5988:
  RFC6570:
  I-D.ietf-httpbis-p6-cache:
  
informative:
  RFC4288:
  RFC5789:
  I-D.ietf-httpbis-p4-conditional:
  I-D.ietf-httpbis-p5-range:
  I-D.ietf-httpbis-p7-auth:
  I-D.snell-http-prefer:
  WADL:
    target: http://www.w3.org/Submission/wadl/
    title: Web Application Description Language
    author:
      - ins: M. Hadley
      - organization: Sun Microsystems
  MICROFORMATS:
    target: http://microformats.org/
    title: Microformats
    author:
      - organization: microformats.org

--- abstract

This document proposes a "home document" format for non-browser HTTP clients.

--- middle

Introduction
============

There is an emerging preference for non-browser Web applications
(colloquially, "HTTP APIs") to use a link-driven approach to their
interactions to assure loose coupling, thereby enabling extensibility and API
evolution.

This is based upon experience with previous APIs that specified static URI
paths (such as "http://api.example.com/v1.0/widgets/abc123/properties"), which
have resulted in brittle, tight coupling between clients and servers.

Sometimes, these APIs are documented by a document format like {{WADL}} that
is used as a design-time description; i.e., the URIs and other information
they describe are "baked into" client implementations.

In contrast, a "follow your nose" API advertises the resources available to
clients using link relations {{RFC5988}} and the formats they support using
internet media types {{RFC4288}}. A client can then decide -- at run time --
which resources to interact with based upon its capabilities (as described by
link relations), and the server can safely add new resources and formats
without disturbing clients that are not yet aware of them.

As such, clients need to be able to discover this information quickly and
efficiently use it to interact with the server. Just as with a human-targeted
"home page" for a site, we can create a "home document" for a HTTP API that
describes it to non-browser clients.

Of course, an HTTP API might use any format to do so; however, there are
advantages to having a standard home document format. This specification
suggests one for consideration, using the JSON format {{RFC4627}}.


Notational Conventions
----------------------

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.


JSON Home Documents
===================

A JSON Home Document uses the format described in {{RFC4627}} and has the
media type "application/json-home".

Its content consists of a root object with a "resources" property, whose
member names are link relation types (as defined by {{RFC5988}}), and values
are Resource Objects, defined below.

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
    "resources": {
      "http://example.org/rel/widgets": {
        "href": "/widgets/"
      },
      "http://example.org/rel/widget": {
        "href-template": "/widgets/{widget_id}",
        "href-vars": {
          "widget_id": "http://example.org/param/widget"
        },
        "hints": {
          "allow": ["GET", "PUT", "DELETE", "PATCH"],
          "representations": ["application/json"],
          "accept-patch": ["application/json-patch"],
          "accept-post": ["application/xml"],
          "accept-ranges": ["bytes"]
        }
      }      
    }
  }
~~~

Here, we have a home document that links to a resource, "/widgets/" with the
relation "http://example.org/rel/widgets". It also links to an unknown
number of resources with the relation type "http://example.org/rel/widget"
using a URI Template {{RFC6570}}, along with a mapping of identifiers to a
variable for use in that template.

It also gives several hints about interacting with the latter "widget"
resources, including the HTTP methods usable with them, the patch formats they
accept, and the fact that they support partial requests
{{I-D.ietf-httpbis-p5-range}} using the "bytes" range-specifier.

It gives no such hints about the "widgets" resource. This does not mean that
it (for example) doesn't support any HTTP methods; it means that the client
will need to discover this by interacting with the resource, and/or examining
the documentation for its link relation type.


Resource Objects
================

A Resource Object links to resources of the defined type using one of two
mechanisms; either a direct link (in which case there is exactly one resource
of that relation type associated with the API), or a templated link, in which
case there are zero to many such resources.

Direct links are indicated with an "href" property, whose value is a URI
{{RFC3986}}.

Templated links are indicated with an "href-template" property, whose value is
a URI Template {{RFC6570}}. When "href-template" is present, the Resource
Object MUST have a "href-vars" property; see "Resolving Templated Links".

Resource Objects MUST have exactly one of the "href" and "href-vars"
properties.

In both forms, the links that "href" and "href-template" refer to are
URI-references {{RFC3986}} whose base URI is that of the JSON Home Document
itself.

Resource Objects MAY also have a "hints" property, whose value is an object
that uses named Resource Hints as its properties.

Resolving Templated Links
-------------------------

A URI can be derived from a Templated Link by treating the "href-template"
value as a Level 3 URI Template {{RFC6570}}, using the "href-vars" property to
fill the template.

The "href-vars" property, in turn, is an object that acts as a mapping between
variable names available to the template and absolute URIs that are used as
global identifiers for the semantics and syntax of those variables.

For example, given the following Resource Object:

~~~
  "http://example.org/rel/widget": {
    "href-template": "/widgets/{widget_id}",
    "href-vars": {
      "widget_id": "http://example.org/param/widget"
    },
    "hints": {
      "allow": ["GET", "PUT", "DELETE", "PATCH"],
      "representations": ["application/json"],
      "accept-patch": ["application/json-patch"],
      "accept-post": ["application/xml"],
      "accept-ranges": ["bytes"]
    }
  }      
~~~

If you understand that "http://example.org/param/widget" is an numeric
identifier for a widget (perhaps by dereferencing that URL and reading the
documentation), you can then find the resource corresponding to widget number
12345 at "http://example.org/widgets/12345" (assuming that the Home Document
is located at "http://example.org/").


Resource Hints
==============

Resource hints allow clients to find relevant information about interacting
with a resource beforehand, as a means of optimising communications, as well
as advertising available behaviours (e.g., to aid in laying out a user
interface for consuming the API).

Hints are just that -- they are not a "contract", and are to only be taken as
advisory. The runtime behaviour of the resource always overrides hinted
information.

For example, a resource might hint that the PUT method is allowed on all
"widget" resources. This means that generally, the user has the ability to PUT
to a particular resource, but a specific resource might reject a PUT based
upon access control or other considerations. More fine-grained information
might be gathered by interacting with the resource (e.g., via a GET), or by
another resource "containing" it (such as a "widgets" collection) or
describing it (e.g., one linked to it with a "describedby" link relation).

This specification defines a set of common hints, based upon information
that's discoverable by directly interacting with resources. A future draft
will explain how to define new hints.

allow
-----

Hints the HTTP methods that the current client will be able to use to interact
with the resource; equivalent to the Allow HTTP response header.

Content MUST be an array of strings, containing HTTP methods.

representations
---------------

Hints the representation types that the resource produces and consumes, using
the GET and PUT methods respectively, subject to the 'allow' hint.

Content MUST be an array of strings, containing media types.

accept-patch
------------

Hints the PATCH {{RFC5789}} request formats accepted by the resource for this
client; equivalent to the Accept-Patch HTTP response header.

Content MUST be an array of strings, containing media types.

When this hint is present, "PATCH" SHOULD be listed in the "allow" hint.

accept-post
-----------

Hints the POST request formats accepted by the resource for this client.

Content MUST be an array of strings, containing media types.

When this hint is present, "POST" SHOULD be listed in the "allow" hint.

accept-ranges
-------------

Hints the range-specifiers available to the client for this resource;
equivalent to the Accept-Ranges HTTP response header
{{I-D.ietf-httpbis-p5-range}}.

Content MUST be an array of strings, containing HTTP range-specifiers. 

accept-prefer
-------------

Hints the preferences {{I-D.snell-http-prefer}} supported by the
resource. Note that, as per that specifications, a preference can be ignored
by the server.

Content MUST be an array of strings, contain preferences.

docs
----

Hints the location for human-readable documentation for the relation type of
the resource.

Content MUST be a string containing an absolute-URI {{RFC3986}} referring to
documentation that SHOULD be in HTML format.
            
precondition-req
----------------

Hints that the resource requires state-changing requests (e.g., PUT, PATCH) to
include a precondition, as per {{I-D.ietf-httpbis-p4-conditional}}, to avoid
conflicts due to concurrent updates.

Content MUST be an array of strings, with possible values "etag" and
"last-modified" indicating type of precondition expected.
            
auth-req
--------

Hints that the resource requires authentication using the HTTP Authentication
Framework {{I-D.ietf-httpbis-p7-auth}}.

Content MUST be an array of objects, each with a "scheme" property containing
a string that corresponds to a HTTP authentication scheme, and optionally a
"realms" property containing an array of zero to many strings that identify
protection spaces that the resource is a member of.

For example, a Resource Object might contain the following hint:

~~~            
  {
    "auth-req": [
      {
        "scheme": "Basic",
        "realms": ["private"]
      }
    ]
  }
~~~

status
------

Hints the status of the resource.

Content MUST be a string; possible values are:


* "deprecated" - indicates that use of the resource is not recommended, but it
  is still available.
* "gone" - indicates that the resource is no longer available; i.e., it will
  return a 410 Gone HTTP status code if accessed.


Creating and Serving Home Documents
===================================

When making a home document available, there are a few things to keep in mind:

* A home document is best located at a memorable URI, because its URI will
  effectively become the URI for the API itself to clients.
* Home documents can be personalised, just as "normal" home pages can. For
  example, you might advertise different URIs, and/or different kinds of link
  relations, depending on the client's identity.
* Home documents SHOULD be assigned a freshness lifetime (e.g.,
  "Cache-Control: max-age=3600") so that clients can cache them, to avoid
  having to fetch it every time the client interacts with the service.
* Custom link relation types, as well as the URIs for variables, should lead
  to documentation for those constructs.


Managing Change in Home Documents
---------------------------------

The URIs used in home documents MAY change over time. However, changing them
can cause issues for clients that are relying on cached home documents
containing old links.

To mitigate these risks, servers changing links SHOULD consider:

* Reducing the freshness lifetime of home documents before a link change, so
  that clients are less likely to refer to an "old" document.
* Assure that they handle requests for the "old" URIs appropriately; e.g.,
  with a 404 Not Found, or by redirecting the client to the new URI.
* Alternatively, considering the "old" and "new" URIs as equally valid
  references for an "overlap" period.

Generally, servers ought not to change URIs without good cause.


Evolving and Mixing APIs with Home Documents
--------------------------------------------

Using home documents affords the opportunity to change the "shape" of the API
over time, without breaking old clients. 

This includes introducing new functions alongside the old ones -- by adding
new link relation types with corresponding resource objects -- as well as
adding new template variables, media types, and so on.

It's important to realise that a home document can serve more than one "API"
at a time; by listing all relevant relation types, it can effectively "mix"
different APIs, allowing clients to work with different resources as they see
fit.


Documenting APIs that use Home Documents
----------------------------------------

Another use case for "static" API description formats like WSDL and WADL is to
generate documentation for the API from them.

An API that uses the home document format correctly won't have a need to do
so, provided that the link relation types and media types it uses are
well-documented already.


Consuming Home Documents
========================

Clients might use home documents in a variety of ways. 

In the most common case -- actually consuming the API -- the client will scan
the Resources Object for the link relation(s) that it is interested in, and
then to interact with the resource(s) referred to. Resource Hints can be used
to optimise communication with the client, as well as to inform as to the
permissible actions (e.g., whether PUT is likely to be supported).

Note that the home document is a "living" document; it does not represent a
"contract", but rather is expected to be inspected before each interaction. In
particular, links from the home document MUST NOT be assumed to be valid
beyond the freshness lifetime of the home document, as per HTTP's caching
model {{I-D.ietf-httpbis-p6-cache}}.

As a result, clients SHOULD cache the home document (as per
{{I-D.ietf-httpbis-p6-cache}}), to avoid fetching it before every interaction
(which would otherwise be required).

Likewise, a client encountering a 404 Not Found on a link SHOULD obtain a
fresh copy of the home document, to assure that it is up-to-date.


Security Considerations
=======================

Clients need to exercise care when using hints. For example, a naive client
might send credentials to a server that uses the auth-req hint, without
checking to see if those credentials are appropriate for that server.

IANA Considerations
===================

TBD


--- back

Acknowledgements
================

Thanks to Jan Algermissen, Mike Amundsen, Bill Burke, Graham Klyne, Leif
Hedstrom, Jeni Tennison, Erik Wilde and Jorge Williams for their suggestions
and feedback.


Frequently Asked Questions
==========================

Why not Microformats?
---------------------

Browser-centric Web applications use HTML as their representation format of
choice. While it is possible to augment HTML for non-browser clients (using
techniques like Microformats {{MICROFORMATS}}), a few issues become evident
when doing so:

* HTML has a very forgiving syntax. While this is appropriate for browsers
  (especially considering that there are many million HTML authors in the
  world), it makes for a less-than-precise language for machines, resulting in
  both overhead (parsing and transmission) as well as lack of precision.
* HTML is presentation-centric, making it tempting to reformat it from time to
  time, to improve the "look and feel" of a page. However, doing so can cause
  comparatively brittle non-browser clients to lose their understanding of the
  content's semantics, unless very careful controls are in place.
  
Because of this, it's most practical to define a separate format, and JSON is
easily machine-readable, precise, and has a better chance of being managed for
stability.

What about authentication?
--------------------------

In HTTP, authentication is discoverable by interacting with the resource
(usually, by getting a 401 Unauthorized response status code, along with one
or more challenges). While the home document could hint it, this isn't yet
done, to avoid possible security complications.

What about "Faults" (i.e., errors)?
-----------------------------------

In HTTP, errors are conveyed by HTTP status codes. While this specification
could (and even may) allow enumeration of possible error conditions, there's a
concern that this will encourage applications to define many such "faults",
leading to tight coupling between the application and its clients.

So, this is an area of possible future development; if any such mechanism
appears here, it's likely to be quite restricted.

How Do I find the schema for a format?
--------------------------------------

That isn't addressed by home documents. Ultimately, it's up to the media type
accepted and generated by resources to define and constrain (or not) their
syntax. 

How do I express complex query arguments?
-----------------------------------------

Complex queries -- i.e., those that exceed the expressive power of Link
Templates or would require ambiguous properties of a "resources" object --
aren't intended to be defined by a home document. The appropriate way to do
this is with a "form" language, much as HTML defines.

Future revisions of this specification may define or accommodate the use of
such a form in the home document.


Open Issues
===========

The following is a list of placeholders for open issues.

* Refining and extending representation formats - "application/xml", for
  example, isn't enough. While a media type for every representation is one
  answer, something like 'profile' might be good too.
* Object for contact details - do we need an object that describes who's
  running the API, API/software version, etc?
* Defining new hints - guidance is needed on minting new hints. Possibly a
  registry.
* Defining new top-level properties - how new ones are minted, registry, etc.
* Defining new Resource Object properties - how new ones are minted, registry,
  etc.
* Hint to indicate a POST to 201 Created pattern
* Hint to indicate an "action" POST
* Describe the extensibility model
* Allow resources to expose their links
* Negotiating for HTML Home vs. JSON Jome
* Refining and extending representation formats
* Further details on use of URI Templates 
* Object for ToS, rate limiting?
* Figure out API profiles
