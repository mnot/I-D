---
title: URI Design and Ownership
abbrev: URI Design Ownership
docname: draft-ietf-appsawg-uri-get-off-my-lawn-03
date: 2014
category: bcp
updates: 3986

ipr: trust200902
area: General
workgroup: appsawg
keyword: URI structure

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
  RFC4395:
  RFC6838:

informative:
  RFC5785:
  RFC5988:
  RFC6570:
  RFC6943:
  webarch:
    target: http://www.w3.org/TR/2004/REC-webarch-20041215
    title: Architecture of the World Wide Web, Volume One
    author:
     -
        ins: I. Jacobs
        name: Ian Jacobs
        org: 
     -
        ins: N. Walsh
        name: Norman Walsh
        org:
    date: 2004-12-15


--- abstract

RFC3986 Section 1.1.1 defines URI syntax as "a federated and extensible naming system wherein each
scheme's specification may further restrict the syntax and semantics of identifiers using that
scheme." In other words, the structure of a URI is defined by its scheme. While it is common for
schemes to further delegate their substructure to the URI's owner, publishing independent standards
that mandate particular forms of URI substructure is inappropriate, because the essentially usurps
ownership. This document clarifies both this problematic practice and some acceptable alternatives
in standards.

--- middle

# Introduction

URIs {{RFC3986}} very often include structured application data. This might include artifacts
from filesystems (often occurring in the path component), and user information (often in the query
component). In some cases, there can even be application-specific data in the authority component
(e.g., some applications are spread across several hostnames to enable a form of partitioning or
dispatch).

Furthermore, constraints upon the structure of URIs can be imposed by an implementation; for
example, many Web servers use the filename extension of the last path segment to determine the
media type of the response. Likewise, pre-packaged applications often have highly structured URIs
that can only be changed in limited ways (often, just the hostname and port they are deployed upon).

Because the owner of the URI (as defined in {{webarch}} Section 2.2.2.1) is choosing to use the
server or the software, this can be seen as reasonable delegation of authority. When such
conventions are mandated by a party other than the owner, however, it can have several potentially
detrimental effects:

* Collisions - As more ad hoc conventions for URI structure become standardized, it becomes more
  likely that there will be collisions between them (especially considering that servers,
  applications and individual deployments will have their own conventions).

* Dilution - When the information added to a URI is ephemeral, this dilutes its utility by reducing
  its stability (see {{webarch}} Section 3.5.1), and can cause several alternate forms of the URI
  to exist (see {{webarch}} Section 2.3.1).

* Rigidity - Fixed URI syntax often interferes with desired deployment patterns. For example, if an
  authority wishes to offer several applications on a single hostname, it becomes difficult to
  impossible to do if their URIs do not allow the required flexibility.

* Operational Difficulty - Supporting some URI conventions can be difficult in some
  implementations. For example, specifying that a particular query parameter be used precludes the
  use of Web servers that serve the response from a filesystem. Likewise, an application that fixes
  a base path for its operation (e.g., "/v1") makes it impossible to deploy other applications with
  the same prefix on the same host.

* Client Assumptions - When conventions are standardized, some clients will inevitably assume that
  the standards are in use when those conventions are seen. This can lead to interoperability
  problems; for example, if a specification documents that the "sig" URI query parameter indicates
  that its payload is a cryptographic signature for the URI, it can lead to undesirable behavior.

Publishing an independent standard that constrains an existing URI structure in ways which aren't
explicitly allowed by {{RFC3986}} (e.g., by defining it in the URI scheme) is usually
inappropriate, because the structure of a URI needs to be firmly under the control of its owner,
and the IETF (as well as other organizations) should not usurp it.

This document explains best current practices for establishing URI structures, conventions and
formats in standards. It also offers strategies for specifications to avoid violating these
guidelines in {{alternatives}}.


## Who This Document Is For

This document's requirements primarily target a few different types of specifications:

* Protocol Extensions ("extensions") - specifications that offer new capabilities to potentially
  any identifier, or a large subset; e.g., a new signature mechanism for 'http' URIs, or metadata
  for any URI.

* Applications Using URIs ("applications") - specifications that use URIs to meet specific needs;
  e.g., a HTTP interface to particular information on a host.

Requirements that target the generic class "Specifications" apply to all specifications, including
both those enumerated above and others.

Note that this specification ought not be interpreted as preventing the allocation of control of
URIs by parties that legitimately own them, or have delegated that ownership; for example, a
specification might legitimately define the semantics of a URI on the IANA.ORG Web site as part of
the establishment of a registry.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Best Current Practices for Standardizing Structured URIs

Best practices differ depending on the URI component, as described in this section.

## URI Schemes

Applications and extensions MAY require use of specific URI scheme(s); for example, it is perfectly
acceptable to require that an application support 'http' and 'https' URIs. However, applications
SHOULD NOT preclude the use of other URI schemes in the future, unless they are clearly specific to
the nominated schemes.

A specification that defines substructure within a URI scheme MUST do so in the defining document
for that URI scheme, or by modifying {{RFC4395}}.


## URI Authorities

Scheme definitions define the presence, format and semantics of an authority component in URIs; all
other specifications MUST NOT constrain, or define the structure or the semantics for URI
authorities, unless they update the scheme registration itself.

For example, an extension or application cannot say that the "foo" prefix in "foo_app.example.com"
is meaningful or triggers special handling in URIs.


## URI Paths

Scheme definitions define the presence, format, and semantics of a path component in URIs; all
other specifications MUST NOT constrain, or define the structure or the semantics for any path
component.

The only exception to this requirement is registered "well-known" URIs, as specified by {{RFC5785}}.
See that document for a description of the applicability of that mechanism.

For example, an application cannot specify a fixed URI path "/myapp", since this usurps the host's
control of that space. Specifying a fixed path relative to another (e.g., {whatever}/myapp) is also
bad practice, since it "locks" the URIs in use; while doing so might prevent collisions, it does
not avoid the other issues discussed.


## URI Queries

The presence, format and semantics of the query component of URIs is dependent upon many factors,
and MAY be constrained by a scheme definition. Often, they are determined by the implementation of
a resource itself.

Applications SHOULD NOT directly specify the syntax of queries, as this can cause operational
difficulties for deployments that do not support a particular form of a query.

Extensions MUST NOT specify the format or semantics of queries.

For example, an extension cannot be minted that indicates that all query parameters with the name
"sig" indicate a cryptographic signature.


## URI Fragment Identifiers

Media type definitions (as per {{RFC6838}}) SHOULD specify the fragment identifier syntax(es) to be
used with them; other specifications MUST NOT define structure within the fragment identifier,
unless they are explicitly defining one for reuse by media type definitions.


# Alternatives to Specifying Structure in URIs {#alternatives}

Given the issues above, the most successful strategy for applications and extensions that wish to
use URIs is to use them in the fashion they were designed; as links that are exchanged as part of
the protocol, rather than statically specified syntax. Several existing specifications can aid in
this.

{{RFC5988}} specifies relation types for Web links. By providing a framework for linking on the
Web, where every link has a relation type, context and target, it allows applications to define a
link's semantics and connectivity.

{{RFC6570}} provides a standard syntax for URI Templates that can be used to dynamically insert
application-specific variables into a URI to enable such applications while avoiding impinging upon
URI owners' control of them.

{{RFC5785}} allows specific paths to be 'reserved' for standard use on URI schemes that opt into
that mechanism ('http' and 'https' by default). Note, however, that this is not a general "escape
valve" for applications that need structured URIs; see that specification for more information.

Specifying more elaborate structures in an attempt to avoid collisions is not adequate to conform
to this document. For example, prefixing query parameters with "myapp_" does not help, because the
prefix itself is subject to the risk of collision (since it is not "reserved").


# Security Considerations

This document does not introduce new protocol artifacts with security considerations. It prohibits
some practices that might lead to vulnerabilities; for example, if a security-sensitive mechanism
is introduced by assuming that a URI path component or query string has a particular meaning, false
positives might be encountered (due to sites that already use the chosen string). See also
{{RFC6943}}.


# IANA Considerations

There are no direct IANA actions specified in this document.


--- back

# Acknowledgments

Thanks to David Booth, Dave Crocker, Tim Bray, Anne van Kesteren, Martin Thomson, Erik Wilde and
Dave Thaler for their suggestions and feedback.



