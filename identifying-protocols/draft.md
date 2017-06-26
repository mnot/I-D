---
title: Identifying Protocols
docname: draft-nottingham-identifying-protocols-00
date: 2017
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
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This document explores different means of identifying protocols, the reasons for doing so, and
defines best practices for their use.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/identifying-protocols>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/identifying-protocols/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/identifying-protocols>.


--- middle

# Introduction

For a variety of reasons, it's often necessary to identify Internet protocols. This includes:

- Assuring that the endpoints positively support the intended protocol (e.g., to avoid cross-protocol attacks)
- Configuring protocol details, such as transport parameters, or optional features
- Discriminating traffic based upon protocol, for policy enforcement or quality of service
- Establishing a name space for extensions and other protocol artefacts

Internet standards define a number of ways to identify a protocol. Less is said about the
appropriate use of these identifiers for various purposes. This document defines best practices for
the use of several kinds of protocol identifiers.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# "Magic"

It's very common for protocols to specify an initial set of octets that are to be sent by endpoints
on a connection, so-called "magic."



# Port Numbers

Transport protocols like TCP {{}} and UDP {{}} commonly use port numbers to identify protocols.


## Service Names

getservbyname()

Service names are the unique key in the Service Name and Transport
   Protocol Port Number registry.  This unique symbolic name for a
   service may also be used for other purposes, such as in DNS SRV
   records [RFC2782].

{{?RFC6335}}

> Because the port number space is finite (and therefore conservation is an important goal), the
> alternative of using service names instead of port numbers is RECOMMENDED whenever possible.


# URI Schemes

URI schemes {{}} occur as part of a resource identifier that's often end user-visible.

# ALPN Protocol IDs

ALPN {{}} establishes a name space of Protocol Identifiers.


# IANA Considerations

This document has no requirements for IANA.

# Security Considerations


--- back
