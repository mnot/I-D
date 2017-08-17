---
title: Scoping Protocols for the Internet
abbrev: Scoping Protocols
docname: draft-nottingham-scoping-protocols-00
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

This document explores the properties of changes to protocols that might be harmful if widely deployed, and suggests guidelines for evaluating whether they should be published.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-everyone>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-everyone/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-everyone>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-for-everyone/>.

--- middle

# Introduction

{{?RFC3935}} declares that the goal of the IETF "is to make the Internet work better."

It goes on to define the Internet as:

> A large, heterogeneous collection of interconnected systems that can be used for communication of many different types between any interested parties connected to it. The term includes both the "core Internet" (ISP networks) and "edge Internet" (corporate and private networks, often connected via firewalls, NAT boxes, application layer gateways and similar devices.

But later, in Section 4.2, goes on to say:

> In attempting to resolve the question of the IETF's scope, perhaps the fairest balance is struck by this formulation: "protocols and practices for which secure and scalable implementations are expected to have wide deployment and interoperation on the Internet, or to form part of the infrastructure of the Internet."

When a new proposal is brought to the IETF, this scope is important to keep in mind; if the proposal is specified to certain kinds of deployments, but might cause harm in others, it could be inappropriate to "have wide deployment and interoperation on the Internet" as a whole.

For example, a datacentre network might want to change how congestion control operates (or remove it entirely) inside its confines. While this might be advantageous in a controlled environment, it would be disastrous to do so on the open Internet, as it would result in congestion collapse {{?I-D.draft-ietf-tcpm-dctcp}}.

Or, a financial institution might need to conform to regulations specific to them, and thus need to change how encrypted protocols on their network operate to enable efficient monitoring of activity, while still adhering to their security requirements. While this might be seen as pragmatic in that environment, using such techniques on the open Internet would be widely seen as a step (or many steps) backwards in security, as it would sacrifice forward security, and furthermore be prone to abuse for attacks such as pervasive monitoring {{?RFC7258}}.

In discussing such proposals, there is often a question of whether it is appropriate to promote something to Internet Standard, or even publish it at all.

Clearly, every Internet specification need not be deployable on every Internet-connected network; likewise, the very possibility of harm does not automatically preclude standardisation. However, when the potential consequences and/or likelihood of deployment outside the intended environment are too great, such a proposal needs much more careful vetting.

This document explores the properties of such "limited scope" proposals and suggests guidelines for evaluating whether they should be published.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Scoping Protocols for the Internet

Engineers often concentrate on the problems immediately in front of them, and propose solutions that minimally solve those problems. While this is acceptable practice in a limited, known environment, this style of engineering often fails when proposing changes to the Internet, because it is such a diverse environment.

In a limited environment, it's not uncommon to be able to make a variety of assumptions about deployment architecture, user expectations, traffic characteristics, and so on. On the Internet as a whole, this is not true; not only is it diverse, but it is also open; we do not know all of the ways in which is is used, deployed, or operated.

Therefore, proposals to change it need to consider what effect they will have when deployed generally, not just specifically within the scope they were designed for.


## Defining Limited Scope

A proposal is said to have "limited scope" if it is designed with deployment on a subset of the Internet, or if it is known to only be suitable for deployment on a subset of the Internet.

A subset of the Internet could be a single network, or a single type of Internet-connected network. Generally, it would be considered "edge Internet", using {{RFC3935}} terminology.

A proposal could be a new protocol, an extension to an existing protocol, or a change to an existing protocol.


## What is "Harmful"?

"Harm" is not defined in this document; that is something that the relevant body (e.g.,
Working Group) needs to discuss. The IETF has already established a body of guidance for such
decisions, including (but not limited to) {{?RFC7754}} on filtering, {{?RFC7258}} and {{?RFC7624}}
on pervasive surveillance, {{?RFC7288}} on host firewalls, and {{?RFC6973}} regarding privacy
considerations.


## Can Harmful Deployment Be Avoided?

A key consideration when evaluating a limited-scope proposal is whether harmful deployment can be avoided. This is most often done by considering the incentives for various parties to deploy -- or avoid deploying -- the proposal more widely.

For example, a proposal to disable congestion control in TCP needs to be enabled in the operating system (in most current implementations). The operating system vendor has a strong incentive to deliver flexible yet safe systems; congestion collapse due to irresponsible deployment will lead to less use of that operating system, so the vendor will assure that it is deployed responsibly, most likely by requiring the administrator of the machine to explicitly configure their machine to do so.

The administrator, in turn, has a strong incentive to make sure that all applications on the machine have fair network access, and that the machine is no penalised as a bad actor by the network it operates within; operating without congestion control on an ISP network, for example, will eventually get noticed, and likely result in access being terminated.

These incentives suggest that it is safe for the IETF to define limited-deployment modifications to congestion control, because wider deployment on the Internet -- where it would be harmful -- is against the interests of the relevant parties.

A counterexample would be a proposal to weaken encryption to make it possible to monitor it in enterprise networks. While there might be a reasonable argument for deploying this in a constrained network, the potential harm if it is deployed on the broader Internet is considerable; it could be used to enable pervasive monitoring {{?RFC7624}}, for example.

It's much less clear whether the appropriate incentives are in place to avoid harmful deployment of such a proposal. Depending on the specifics of how it worked, deployment could be compelled, for example.


## Considering the Impact of Standardisation

When the IETF determines that a limited-scope proposal cannot be published due to its potential harm, a few counter-arguments usually surface.

It is sometimes argued that if the IETF withholds standards-track status (or publication
altogether) the proponents can still have their proposal published as an Individual Submission, or
by another standards organisation.

This might be true, but it ignores the imprimatur of the IETF Standards Track; becoming an IETF standard *does* have demonstrable value, otherwise participants would not have invested significant resources into creating them, and indeed the proponents would not have brought their proposal to the IETF.

Likewise, publication as an RFC -- even on another track -- is perceived by many as an implied endorsement by the IETF.

A similar argument is that by accepting such work into the IETF, we can minimise harm and avoid something worse being published elsewhere. Again, this might be true, but if we compromise our values (as expressed in existing Internet Standards and Best Current Practices) to do so, this is a loss much greater than the area of the proposal in question; it establishes a precedent for further erosion of them, and dilutes their current expression. This must be avoided.

While the bar is lower for other documents (e.g., Informational), it is expected that the same considerations will apply for any document that is an IETF work product.


# IANA Considerations

This document has no actions for IANA.

# Security Considerations

TBD

--- back
