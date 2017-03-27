---
title: Managing IANA Registries with Custodians
abbrev: Registry Custodians
docname: draft-nottingham-registry-custodian-00
date: 2017
category: std

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

informative:

--- abstract

This document defines a new well-known IANA registration policy; appointing a "Custodian".

--- middle

# Introduction

This document defines a new well-known IANA registration policy {{!RFC5226}}; appointing a
"Custodian".

This policy is designed to be used when a registry is likely to have a large number of
entries from outside the standards community, because it gives an individual limited powers to
maintain the registry's contents, while still having a low bar to entry.

The goal of a custodial registry is to reflect the deployed protocol as closely as possible; in
other words, if a protocol element is in use on the Internet, it ought to appear in the registry.

It is a non-goal to use the registry as a measure of quality (e.g., allowing only "good"
registrations, imposing architectural constraints onto registrations).

Usually, a registry defined as Expert Review or Specification Required will define the Expert as a
Custodian. However, registries with more stringent requirements can also use this process.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{!RFC2119}} and indicate requirement levels for compliant CoAP implementations.

# The Custodian's Role

The Custodian's primary duty is to maintain the registry's contents by assisting new registrations,
updating existing entries, and making new registrations when a protocol element is widely deployed
but unregistered.

As such, they have considerable power, in that they can make material changes to the registry
content without oversight, beyond that offered by the community at large.

However, in practice this power is quite limited. The Custodian is not charged with acting as a
gatekeeper, nor imposing requirements on new registrations. Rather, they are responsible for
assuring that the registry is kept up-to-date, reflecting the reality of deployment.

In particular, a Custodian:

* MAY make suggestions to new registrations (e.g., "have you considered...?")
* MUST NOT act as a "gatekeeper" to the registry (e.g., refusing registrations based upon perceived
  or actual architectural or aesthetic issues)
* SHOULD consult with the applicable community when there are disputes or questions about pending
  or existing registrations
* MAY proactively register values in common use
* MAY update contact details and specification references, in consultation with the registrants
* MAY update change control for a registration, with appropriate consent or community consensus, as
  appropriate
* MAY annotate registrations (e.g., with implementation notes, additional context)
* MAY update the status of a registration (e.g., to "deprecated", "obsoleted") as appropriate

Members of the community who disagree with a Custodian's actions MAY appeal to the Area Director(s)
identified by the registry. However, such appeals will be judged upon the criteria above, along
with any criteria specific to the registry.


# Specifying Custodial Registries

Registries using the custodial process:

* SHOULD define a 'status' (or functionally similar) field that indicates registration disposition,
  and SHOULD enumerate possible values.
* SHOULD nominate a mailing list for discussion of registrations; usually, this will be a
  pre-existing list (rather than a dedicated one).
* MUST nominated the area whose Area Directors are responsible for appointing Custodians and
  handling appeals.


# IANA Considerations

For custodial registries, IANA:

* MUST send requests for registrations to the Custodian
* SHOULD respond to requests from the Custodian promptly
* SHOULD notify the responsible Area Directors if the Custodian is unresponsive


# Security Considerations

TBD.


--- back
