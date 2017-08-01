---
title: 
abbrev:
docname: draft-nottingham-for-everyone-00
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

informative:


--- abstract


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-everyone>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-everyone/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-everyone>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-for-everyone/>.

--- middle

# Introduction

{{RFC3935}} declares that the goal of the IETF "is to make the Internet work better."

It goes on to define the Internet as:

> A large, heterogeneous collection of interconnected systems that can be used for communication of many different types between any interested parties connected to it. The term includes both the "core Internet" (ISP networks) and "edge Internet" (corporate and private networks, often connected via firewalls, NAT boxes, application layer gateways and similar devices.

But later, in Section 4.2, goes on to say:

> In attempting to resolve the question of the IETF's scope, perhaps the fairest balance is struck by this formulation: "protocols and practices for which secure and scalable implementations are expected to have wide deployment and interoperation on the Internet, or to form part of the infrastructure of the Internet."

When a new proposal is brought to the IETF, this scope is important to keep in mind; if the proposal is inappropriate to "have wide deployment and interoperation on the Internet" as a whole, special care needs to be taken.

For example, a datacentre network might want to change how congestion control operates (or remove it entirely) inside its confines. While this might be advantageous in a controlled environment, it would be disastrous to do so on the open Internet, as it would result in congestion collapse {{?I-D.draft-ietf-tcpm-dctcp}}. 

Or, a financial institution might need to conform to regulations specific to them, and thus need to change how encrypted protocols on their network operate to enable efficient monitoring of activity, while still adhering to their security requirements. While this might be seen as pragmatic in that environment, using such techniques on the open Internet would be widely seen as a step (or many steps) backwards in security, as it would sacrifice Forward Security {{}}, and furthermore be prone to abuse for attacks such as pervasive monitoring {{?RFC7258}}.

In discussing such proposals, there is often a question of whether it is appropriate to promote something to Internet Standard, or even publish it at all, if it could be harmful when deployed inappropriately.

Clearly, every Internet Standard need not be deployable on every Internet-connected network; likewise, the very possibility of harm does not automatically preclude standardisation. However, when the potential consequences and/or likelihood of deployment outside the intended environment are too great, such a proposal needs much more careful vetting.

This document explores the properties of such proposals and suggests guidelines for evaluating whether they should become Internet Standards.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Internet is for Everyone




## Diversity and the Internet

Engineers often concentrate on the problems immediately in front of them, and propose solutions that minimally solve those problems. While this is acceptable practice in a limited, known environment, this style of engineering often fails when proposing changes to the Internet, because it is such a diverse environment.

## Undesireable Deployment

## The Impact of Standardisation



# IANA Considerations

This document has no actions for IANA.

# Security Considerations

TBD

--- back
