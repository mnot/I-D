---
title: Designing HTTP-based APIs
abbrev: HTTP APIs
docname: draft-nottingham-http-api-design-00
date: 2013
category: bcp

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

informative:


--- abstract

Increasingly, HTTP is being used not only for transferring Hypertext content
to Web browsers, but also for conveying information to and from automated
agents.

This memo documents Best Current Practice for such uses of HTTP, sometimes
known as "HTTP APIs" or "RESTful Web Services."

--- middle

Introduction
============

This memo explains how HTTP can be used as the basis of new protocols,
colloquially known as "HTTP APIs."


Applicability
-------------

The advice in this memo reflects Best Current Practice for IETF specifications
that design protocols build upon HTTP. However, much of it is applicable to
non-IETF efforts, whether they be in other organisations, or private.

This document is applicable to application-specific, machine-to-machine
communication using HTTP. It does not address human user concerns, nor those
specific to generic extensions to HTTP.

For example, a new HTTP method, status code or header field that is
potentially usable by any HTTP resource is a generic extension; an API (or
part thereof) designed to allow HTTP-based control of a particular function
(whether it be a user record or a network configuration) is not.


Notational Conventions
----------------------

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.

The Benefits of Using HTTP
==========================

Mindshare / familiarity
Code reuse
Browser compatibility
Affordances


Kinds of HTTP APIs
==================

Single Instance

Multiple Instance

The HTTP Protocol
=================

Methods
-------

GET
PUT
DELETE
POST
PATCH

Status Codes
------------

HTTP Status codes indicate 


Partial Responses
-----------------


Content Negotiation
-------------------


Caching
-------



Representation Formats
======================

JSON
----

XML
---

Other Formats
-------------

Evolving Formats
----------------


Identifying and Linking to Resources
====================================

URLs, URIs and URNs
-------------------

Identifiers and resources
-------------------------

Resource Granularity
--------------------


Common Patterns for HTTP APIs
=============================

Creating Resources
------------------

Updating Resources
------------------

Collections
-----------

Discovery
---------

Indicating Errors
-----------------

Events and Notifications
------------------------

Filtering
---------

Querying
--------

Access Control
--------------

Evolving the API
----------------

Documenting HTTP APIs
=====================


HTTP API Smells
===============

"Special" meanings for methods, status codes
--------------------------------------------

"Closed World" lists of status codes
------------------------------------

Application-specific artefacts
------------------------------

Specifying a particular version of HTTP
---------------------------------------

Abstracting out HTTP (a.k.a. "Bindings")
----------------------------------------

Baked-in URLs
-------------

Implementation vs. Interface
----------------------------


Guidance for Clients
====================

API and Browsers
----------------

Security 

CORS



Security Considerations
=======================


--- back
