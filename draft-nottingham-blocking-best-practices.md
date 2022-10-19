---
title: Best Practices for Blocking Clients by IP Address
abbrev: Blocking by IP Address
docname: draft-nottingham-blocking-best-practices-latest
date: {DATE}
category: bcp

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/blocking"

github-issue-label: blocking

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/


--- abstract

Blocking clients by IP address creates not only local availability problems for clients, but also can foster conditions that lead to systemic issues, such as centralization of Internet protocols. This document makes recommendations to mitigate these effects.

--- middle

# Introduction

Internet services block access from specific IP addresses, ranges of addresses, and addresses associated with attributes like geography in response to (or anticipation of) what is perceived as abusive or otherwise undesirable traffic.

For example, blocking of source addresses in SMTP is a widespread practice to control unsolicited e-mail messages ("spam"). Web sites also block IP addresses from clients that make an unreasonable volume of requests, and/or those addresses that probe for vulnerabilities.

While these practices might be necessary to operate and make services available to those clients that are not perceived as abusive, blocking clients by IP address can have longer-term systemic effects on the Internet that are undesirable.

In particular, blocking IP addresses can over-capture clients that are not considered abusive, leading to legitimate clients being blocked. While some traffic from a given address might indeed be abusive, other clients that share that IP address -- for example, because it is reallocated to another entity, or shared between many clients -- are not necessarily to blame.

When widespread, blocking can have systemic effects, as it becomes difficult to deploy clients on IP addresses that have been problematic in the past.

For example, self-hosting an e-mail server has become difficult (and impractical for most) because blocking has become so prevalent in that ecosystem. The resulting pressure to use large, widely-recognised providers creates centralization risk in e-mail.

This document promotes practices that are intended to mitigate some harmful effects of blocking clients by IP address. It does not address blocking through use of other identifiers, or blocking undesirable services.

## Notational Conventions

{::boilerplate bcp14-tagged}

# Best Practices for Blocking Clients by IP Address

## Reasons for Blocking

Services that are intended to be generally available on the Internet MUST NOT block clients by default (i.e., use an "allow list"), and SHOULD NOT block clients as a matter of course.

Before blocking by IP address, consider whether other, more precise mechanisms for identifying abusive traffic are available. Because there is not a one-to-one mapping between end users and IP addresses (due to IP address reuse, NATs, application-layer proxies, multi-user systems, and other causes), IP addresses are generally a poor identifier. Even when there is a one-to-one mapping, in some cases a user might not be in full control of their system (e.g., due to malware), causing it to emit abusive traffic without their knowledge.

Likewise, before blocking it is important to consider _all_ traffic from the IP address, not only the volume of abusive traffic. What looks like a high amount of abusive traffic from one user could be in fact representing many hundred or even thousands of users. Tools that identify abusive traffic should take this into account, for example by making decisions based upon the proportion of abusive traffic, rather than just the volume.

Delegating a blocking decision to another entity -- for example, using a "block list" -- should be done with great care. When a blocking decision is delegated, that decision should be regularly reviewed, to verify that it is still appropriate and that the block list follows the guidance in this document.

Alternatives to blocking should also be considered. If traffic is suspicious, it could be separated from other traffic and handled by separate systems to contain its impact. Or, it could be subjected to extra processing to identify and weed out the abusers, such as is seen in "CAPTCHA" systems on the Web. This includes techniques that leverage protocol functionality, such as using "backscatter" in e-mail.


## Blocking Duration

IP addresses MUST NOT be blocked indefinitely. As discussed above, permanent or even long-lived address-based blocking can have serious effects on not only the availability of specific services to legitimate clients, but also create more general systemic issues in the Internet.

Instead, when blocking is believed to be necessary, its duration SHOULD be proportional to the certainty that the client is still abusive. For example, a service might initially ban a problematic client for a few minutes. If there is still significant abusive traffic from the address after that period, the block period might be lengthened to an hour or two.

Depending on the nature of the service offered, IP-based blocking SHOULD NOT exceed a period of more than one month, and typically SHOULD be for much shorter periods. This approach allows the service to discard enough abusive traffic to operate with reasonable efficiency while lowering (but not eliminating) the impact of blocking any legitimate clients.

Tools that enable blocking by IP address through operator intervention -- for example, firewall rule engines, web portals for controlling traffic, and server configuration formats -- SHOULD promote this practice. For example, allowing a block to removed after a period of time has passed and promoting that with the period recommended above as a default is good practice.


## Blocking Scope

When blocking by IP address, the scope SHOULD be as minimal as possible -- typically, limited to a single source address that has been abusive in the recent past. Anticipatory blocking by netblock is NOT RECOMMENDED, as it can have significant side effects.

Likewise, delegating blocking decisions to a third party based upon assigned attributes (e.g., "dial-up Internet") is NOT RECOMMENDED.


## Client Recourse

Services that block clients by IP address SHOULD have some well-publicised mechanism for challenging a block. For example, an e-mail service's Web site could provide a form for submitting disputes.


# IANA Considerations

This document has no actions for IANA.

# Security Considerations

Blocking is often used as a means of reducing the cost of processing traffic that is perceived to be abusive (and therefore a security risk) in order to improve availability for clients that are perceived as legitimate. It does not alleviate the need to secure systems or to make them scalable. Implementing the guidelines in this document should not impact security so long as the systems being protected are reasonably secure and scalable themselves.

--- back

