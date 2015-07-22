---
title: User Impact of Transport Metadata
abbrev: Transport Metadata Impact
docname: draft-nottingham-transport-metadata-impact-00
date: 2015
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
 -
    ins: W. Seltzer
    name: Wendy Seltzer
    organization: W3C
    email: wseltzer@w3.org
    uri: http://wendy.seltzer.org
 -
    ins: N. ten Oever
    name: Niels ten Oever
    organization: Article19
    email: niels@article19.org    
 -
    ins: J. Hall
    name: Joseph Lorenzo Hall
    organization: CDT
    email: joe@cdt.org

normative:

informative:
  I-D.nottingham-gin:
  I-D.sprecher-mobile-tg-exposure-req-arch:
  I-D.hildebrand-spud-prototype:
  RFC7258:
  IAB-confidentiality:
    title: IAB Statement on Internet Confidentiality
    target: "http://www.iab.org/2014/11/14/iab-statement-on-internet-confidentiality/"
    date: 14 November 2014
    author:
      organization: Internet Architecture Board
  TAG-securing-web:
    title: Securing the Web
    target: http://www.w3.org/2001/tag/doc/web-https
    date: 22 January 2015
    author:
      organization: W3C Technical Architecture Group
  I-D.trammell-stackevo-newtea:
  I-D.hardie-spud-use-cases:
  X-UIDH:
    title: Verizon Injecting Perma-Cookies to Track Mobile Customers, Bypassing Privacy Controls
    target: "https://www.eff.org/deeplinks/2014/11/verizon-x-uidh"
    date: 3 November 2014
    author:
      ins: J. Hoffman-Andrews
      name: Jacob Hoffman-Andrews
      organization: Electronic Frontier Foundation
  RFC3864:
  RFC7230:
  RFC1984:
  AU-data-retention:
    title: "Your guide to the data retention debate: what it is and why it’s bad"
    target: "http://www.crikey.com.au/2015/03/18/your-guide-to-the-data-retention-debate-what-it-is-and-why-it’s-bad/"
    date: 18 March 2015
    author:
      ins: B. Keane
      name: Bernard Keane
      organization: Crikey


--- abstract

This draft attempts to identify potential impacts associated with new metadata facilities in Internet protocols, and suggest possible mitigations. Its goal is to have the discussion of these tradeoffs up-front, rather than after the development of such mechanisms.

--- middle

# Introduction

Recently, there has been an increasing amount of discussion in the IETF about adorning protocol flows with metadata about the network's state for consumption by applications, as well as that of the application in order to inform decisions in the network. For examples, see {{I-D.nottingham-gin}}, {{I-D.sprecher-mobile-tg-exposure-req-arch}} and {{I-D.hildebrand-spud-prototype}}.

These discussions are being at least partially motivated by the increasing use of encryption, both in deployment (thanks to the Snowden revelations) and standards (thanks in some part to {{RFC7258}}, {{IAB-confidentiality}}, and {{TAG-securing-web}}); while it's becoming widely accepted that networks don't have legitimate need to access the content of flows in most cases, they still wish to meet certain use cases that require more information.

For example, networks may wish to communicate their state to applications, so that link limitations and transient problems can be accounted for in applications, by doing things like degrading (or improving) video streaming quality. 

Applications also need to give enough information to networks to enable proper function; e.g., packets in UDP flows need to be associated to be able to cleanly transit NAT and firewalls. See {{I-D.trammell-stackevo-newtea}} and {{I-D.hardie-spud-use-cases}} for more discussion.

At the same time, it has been widely noted that "metadata" in various forms can be profoundly sensitive information, particularly when aggregated into large sets over extensive periods of time.  Information that may be correlated can even leak from encrypted connections in explicit ways (such as TLS Server Name Indications) or implicit ways (such as traffic analysis).

Indeed, much of the effort in combatting pervasive monitoring (as per {{RFC7258}}) has focused on minimizing metadata in existing, known protocols (such as TLS and HTTP).  {{IAB-confidentiality}} in particular points out the need to hide data previously thought of as inconsequential, to avoid attacks on privacy by correlation.

Any new path communication facility, then – whether it be introduced to an existing protocol, or as part of a new one – should be carefully scrutinized and narrowly tailored to conservatively emit metadata.

This draft attempts to identify potential impacts associated with new path communication facilities in Internet protocols, and suggest possible mitigations. Its goal is to initiate a discussion of these tradeoffs up-front, rather than waiting until after the development of such mechanisms.

Adding metadata to protocols is not an inherent harm – i.e., there are some legitimate uses of metadata, particularly if it eases the adoption of encrypted protocols or aligns well with both the interests of users and service or network operations, e.g., traffic management on mobile networks. However, the balance between the interests of stakeholders like end users, content providers and network operators needs to be carefully considered.

# Potential Impact

## Security and Privacy

In late 2014, it was found that Verizon was injecting HTTP headers into requests that identified their mobile customers using a unique identifier, allowing "third-party advertisers and websites to assemble a deep, permanent profile of visitors' web browsing habits without their consent."  {{X-UIDH}}

In doing so, Verizon was taking advantage of a relatively unconstrained extension point in the HTTP protocol -- header fields. While HTTP header fields do require registration {{RFC3864}}, the requirements are lax, and fields are often used without registration, because there is no technical enforcement of the requirements, due to HTTP's policy of ignoring unrecognized header fields {{RFC7230}}.

HTTP header fields can be made a protected end-to-end facility by using HTTPS, reducing the risk of such injection, but traffic analysis, IPv6 option addtion, or other approaches might still leak some of the protected information.

Well-intentioned metadata can also put the user at substantial risk without careful consideration. For example, if a Web browser "labels" flows based upon what they contain (e.g., "video", "image", "interactive"), an observer on the network path -- including pervasive ones -- can more effectively perform traffic analysis to determine what the user is doing. Similarly, metadata adornment might reveal sensitive information; for example the Server Name Indicator (SNI) in the TLS handshake would reveal if a web visitor intends to go to `falungong.github.com` versus `kitties.github.com`.

Standardizing an extensible transport path communication mechanisms could also trigger various jurisdictions to define and require insertion of in-band metadata, an extension of current practices {{AU-data-retention}}, although this does not appear to have happened yet for IP options, TCP options, or ICMP -- all of which are extensible in the same manner. While the IETF would not be directly responsible for such an outcome, it is notable that in the past we've explicitly said we won't serve conceptually similar use cases {{RFC1984}}.

## Network Neutrality

There is obvious potential for network neutrality impact from a mechanism that allows networks to communicate with endpoints about flows. 

For example, if a network can instruct content servers to throttle back bandwidth available to users for video based upon a commercial arrangement (or lack thereof), the network can achieve their goals without directly throttling traffic, thereby offering the potential to circulate a regulatory regime that's designed to effect network neutrality.

While the IETF has not take as firm a stance on network neutrality as it has for Pervasive Monitoring (for good reasons, since network neutrality problems are at their heart a sign of market failure, not a technical issue), new path communication facilities that enable existing regulatory regimes -- thereby upsetting "the tussle" -- must be carefully considered.

# Possible Mitigations


## Constrained Vocabulary

Much of the potential for harm above comes about because a transport-level metadata mechanism effectively becomes a side channel for arbitrary data, for use by any node on the path. The risks of questionable use might be mitigated by constraining the data that's allowed in this side channel, at the cost of decreasing the incentives to deploy a new protocol.

In other words, if the network doesn't have a means of inserting a unique identifier for customers, they won't be able to do so. If notification of constrained network conditions takes place using well-defined terms, regulatory regimes can be adjusted to achieve desired outcomes. And, information about application semantics can be carefully vetted for security considerations before being included in transport metadata.  The downside of this approach is that a complete analysis of all possible path communications must take place at the beginning of protocol design, precluding future innovation derived from implementation and deployment experience.

Technically, the vocabulary could be constrained by merely allowing beneficial path nodes to silently drop non-standard metadata, at the cost of ossifying the set of capabilities allowed through that path element to the ones known at the time the element was developed.

## Transparency

Many proposals for transport communication indend that metadata will be encrypted, to improve security. While well-intentioned, this approach may also create an opaque side channel with a third party (the first and second being the endpoints). 

The effect of of such designs should be carefully considered before standardisation; it may be that the community is better served by keeping this metadata "in the clear", albeit possibly with some form of authentication and integrity available (or required).


# Security Considerations

This document describes security and privacy aspects of metadata adornment to internet protocols that protocol designers should consider.

--- back
