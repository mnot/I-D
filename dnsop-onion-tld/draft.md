---
title: The .onion Special-Use Domain Name
abbrev: .onion
docname: draft-appelbaum-dnsop-onion-00
date: 2015
category: std

ipr: trust200902
area: General
workgroup: dnsop
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 - 
    ins: J. Appelbaum
    name: Jacob Appelbaum
    organization: Tor Project Inc.
    email: jacob@appelbaum.net
 -
    ins: A. Muffett
    name: Alex Muffett
    organization: Facebook
    email: alecm@fb.com    

normative:
  RFC2119:
  RFC6761:

informative:
  RFC1928:
  RFC3986:
  Dingledine2004:
    target: "https://www.onion-router.net/Publications/tor-design.pdf"
    title: "Tor: the second-generation onion router"
    author:
      - ins: R. Dingledine
      - ins: N. Mathewson
      - ins: P. Syverson
    date: 2004
  tor-address:
    target: "https://gitweb.torproject.org/torspec.git/plain/address-spec.txt"
    title: "Special Hostnames in Tor"
    author:
      - ins: N. Mathewson
      - ins: R. Dingledine
    date: September 2001
  tor-rendezvous:
    target: "https://gitweb.torproject.org/torspec.git/plain/rend-spec.txt"
    title: "Tor Rendezvous Specification"
    author: 
      - ins: N. Mathewson
      - ins: R. Dingledine
    date: April 2014  

--- abstract

This document registers the ".onion" Special-Use Domain Name {{RFC6761}}.

--- middle

# Introduction

The Tor network {{Dingledine2004}} has the ability to host "hidden" services
using the ".onion" Top-Level Domain. Such addresses can be used as other domain
names can (e.g., in URLs {{RFC3986}}), but instead of using the DNS
infrastructure, .onion names are hashes that correspond to the identity of a
given service, thereby conflating location and authentication.

In this way, .onion names are "special" in the sense defined by {{RFC6761}}
Section 3; they require hardware and software implementations to change their
handling, in order to achieve the desired properties of the name (see
{{security}}). These differences are listed in {{onion}}.

See {{tor-address}} and {{tor-rendezvous}} for the details of the creation and
use of .onion names.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.


# The ".onion" Special-Use TLD {#onion}

These properties have the following effects upon parties using or processing
.onion names (as per {{RFC6761}}):

1. Users: human users are expected to recognize .onion names as having
different security properties, and also being only available through software
that is aware of Onion routing.

2. Application Software: Applications SHOULD recognize .onion names as special
by either invoking Onion routing directly, or using a proxy (e.g., SOCKS
{{RFC1928}}) to do so. Applications that are not able or configured to do so
SHOULD generate an error upon use of .onion, and SHOULD NOT perform a DNS
lookup.

3. Name Resolution APIs and Libraries: Resolvers SHOULD either respond to
requests for .onion names by invoking Onion routing (directly or with a proxy),
or by responding with NXDOMAIN.

4. Caching DNS Servers: Caching servers SHOULD NOT attempt to look up records
for .onion names. They SHOULD generate NXDOMAIN for all such queries.

5. Authoritative DNS Servers: Authoritative servers SHOULD respond to queries
for .onion with NXDOMAIN.

6. DNS Server Operators: Operators SHOULD NOT try to configure an authoritative
DNS server to answer queries for .onion. If they do so, client software is 
likely ignore any results (see above).

7. DNS Registries/Registrars: Registrars MUST NOT register .onion names; all
such requests MUST be denied.


# IANA Considerations

This document registers the "onion" TLD in the  registry of Special-Use Domain Names {{RFC6761}}. See {{onion}} for the registration template.

# Security Considerations {#security}

.onion names provide access to "hidden" services; that is, the identity and
location of the server is obscured from the client.

This property can be compromised if:

* The server "leaks" its identity in another way (e.g., in an application-level message), or
* The access protocol is implemented or deployed incorrectly, or
* The access protocol itself is found to have a flaw.

.onion names are self-authenticating, in that they are derived from the
cryptographic key used by the service in establishing the Tor circuit. As a
result, the cryptographic label component of a .onion name is not intended to
be human-meaningful.

Because the Tor network is designed to not be subject to any central
controlling authorities with regards to routing and service publication, .onion
names cannot be registered, assigned, transferred or revoked. "Ownership" of a
.onion name is derived solely from control of a public/private key pair which
corresponds to the algorithmic derivation of the name according to the rules of
the Tor network.

Users must take special precautions to ensure that the .onion name they are
communicating with is correct, as attackers may be able to find keys which
produce service names that are visually or apparently semantically similar to
the desired service.

As the number of bits used in generating the .onion name is less than the size
of the corresponding private key, an attacker may also be able to find a key
that produces the same .onion name with substantially less work than a
cryptographic attack on the full strength key. If this is possible the attacker
may be able to impersonate the service on the network.

If client software attempts to resolve a .onion name, it can leak the identity
of the service that the user is attempting to access to DNS resolvers,
authoritative DNS servers, and observers on the intervening network. This can
be mitigated by following the recommendations in {#onion}.


--- back
