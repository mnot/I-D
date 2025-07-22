---
title: Requirements for Paid Web Crawling
abbrev:
docname: draft-nottingham-paid-crawl-reqs-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]


author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: Cloudflare
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

 -
   ins: S. Newton
   name: Simon Newton
   organization: Cloudflare
   postal:
     - Cambridge
   country: United Kingdom
   email: rfc@simonnewton.com


informative:
  CENTRALIZATION: RFC9518
  EXTENSIBILITY: RFC9170
  PRIVACY: RFC6973

--- abstract

This document suggests requirements (and non-requirements) for paid Web crawling protocols.



--- middle


# Introduction

Automated web clients, or "crawlers," have increasingly dominated website traffic, leading to increased operational costs and new technical and economic risks.

Historically, websites have borne these costs and risks because they believed they received value in return. For instance, crawling to build web search indices exposed sites to increased "referral" traffic when search engine users clicked links to those sites.

However, this balance has been disrupted by an increase in web traffic without any corresponding benefit to websites. Crawling to train Large Language Models ("AI") not only burdens site infrastructure but also creates value for the LLM vendor without compensation to the content owner.

An Internet protocol to facilitate payments from crawlers to websites could help address this imbalance. This document outlines the use case in {{usecase}}, specifies requirements in {{reqs}}, and identifies non-requirements in {{nonreqs}}.

## The Paid Web Crawling Use Case {#usecase}

A Web site "S" wants to be financially compensated for a Web client "C"'s access to its resources. This might be facilitated by a payment processor, "P".

For purposes of this use case, we assume:

* C is _not_ a Web browser with a human behind it; it is a machine-driven process that is collecting Web content for some other purpose (colloquially, "crawling" the Web). Note that that process might (or might not) use a "headless" browser as part of its operation.

* There are a diverse set of C in the world, but the total set of C that a site will interact with is reasonably bounded (i.e., there will not be thousands of C accessing a given site with this protocol, but there may be twenty or more).

* S has some means of cryptographically identifying C. See <https://datatracker.ietf.org/wg/webbotauth/about/>.

Note that this use case is not uniformly applied to all Web crawlers; the intent is not to preclude or require payment for all crawlers, but instead to address situations where there is an economic imbalance.


## Notational Conventions

{::boilerplate bcp14-tagged}

# Requirements {#reqs}

The following sections propose requirements for a protocol that facilitates payment by crawlers to Web sites.

## Avoid Centralization {#central}

A crawl payment protocol MUST NOT have a single or constrained number of "choke point" or "gatekeeper" roles. It MUST be possible for new payment processors to be introduced into the ecosystem with reasonable effort. In particular, attention needs to be paid to mitigating factors such as network effects.

Furthermore, a crawl payment protocol SHOULD NOT have secondary effects that encourage centralization in either clients (e.g., allowing advantages to accrue to a small number of well-known crawlers) or servers (e.g., creating significant barriers to deploying new Web sites that compete with well-known ones). Where they are unavoidable, these effects SHOULD be mitigated if at all possible.

Similarly, a crawl payment protocol MUST NOT "bundle" other capabilities unless absolutely necessary to achieve its goals. For example, it SHOULD NOT require the payment processor to be co-located with the server, or with the party providing access control to the server.

See {{CENTRALIZATION}} for further discussion.

## Lower Deployment Costs

A crawl payment protocol MUST be reasonable to deploy in a variety of systems. In particular, it SHOULD NOT incur significant processing, network, or storage overheads on the servers that wish to require payment. It SHOULD be compatible with common techniques for efficient Web sites, such as caching, serving from a filesystem, and in particular SHOULD NOT incur significant per-request overhead, unless absolutely necessary to meet the goals of the protocol.

It is acknowledged that "significant" is in the eye of the beholder, and can vary based upon the resources available to a system. Here, the intent is to allow deployment on a diversity of systems, thereby helping to avoid the centralization risks described in {{central}}. Thus, a successful crawl payment protocol SHOULD be deployable on a reasonable variety of systems that include at least one maintained by a single person on commodity hardware, but might not reach to some more specialised systems, such as a low-power embedded server.

## Be Extensible

One of the core requirements for Internet protocols is the ability to evolve -- to incorporate new use cases as well as changes in their context and use. Because the Internet is a distributed system, we cannot call a "flag day" where everyone changes at once; instead, changes are accommodated through explicit extensibility mechanisms. See {{EXTENSIBILITY}} for more discussion.

Therefore, a crawl payment protocol MUST allow a variety of payment schemes to be used with it, and MUST allow introduction of new capabilities.

Particular attention will need to be paid to the deployability of such extensions. If a small set of payment schemes is deployed, it may be difficult for sites to introduce a new one without protocol support (e.g., fallback mechanisms).

## Minimise Information Disclosure {#private}

A crawl payment protocol SHOULD NOT expose more information about either party than is necessary to complete the payment. Note that legal requirements in some jurisdictions and payment regimes may require exposure of such information, but it SHOULD be limited to that which is required.

Furthermore, a crawl payment protocol MUST NOT expose additional information about the parties publicly.

This requirement extends to the terms of the payment itself: some parties may not wish to make the amount they are paying or being paid for crawling public information.

See {{PRIVACY}} for more considerations regarding privacy in protocol design.

## Allow Granularity

A crawl payment protocol SHOULD allow sites to have separate payment agreements for different sets of content on them. This reflects the nature of content: some of it is more valuable or more expensive to produce.

Note that this is not an absolute requirement: granularity often comes at a cost of complexity and protocol "chattiness," which are in tension with other requirements.

## Facilitate Negotiation

A crawl payment protocol SHOULD allow the parties to negotiate over time, so that they can converge on a payment that is agreeable to both of them. However, because negotiation adds complexity to the protocol (and therefore implementation and deployment burden), it SHOULD be optional to use for both parties; i.e. either party could make a "take it or leave it" offer.

Likewise, a crawl payment protocol MAY consider providing some level of price transparency either directly or indirectly (e.g., through intermediarie), provided that the privacy requirements in {{private}} are met.

## Allow Enforcement

A crawl payment protocol SHOULD allow intermediaries acting on behalf of the origin server to verify payment status, so that they can impose policy.


# Non-Requirements {#nonreqs}

To clarify the scope of work, the following items are considered as NOT being requirements for a successful crawl payment protocol.

Note that in each case, this does not preclude a successful protocol from accommodating the non-requirement, or require the protocol to preclude that end: it only implies that the non-requirement is not a design goal that the effort will actively seek.

## Standalone Deployment

While we wish to avoid centralization (see {{central}}), it is not a requirement to facilitate full deployment of the protocol exclusively on a single Web server, without external dependencies.

This non-requirement reflects the nature of payment systems, which typically use intermediaries to provide useful services such as chargebacks, reputation management, and compliance with legal requirements.

The implication is that where payment intermediaries are used in the protocol, they should be as interchangeable as possible, to promote an ecosystem whereby both servers and crawlers have choices regarding which intermediaries they support.


## Real-Time Operation

It is not a requirement for the protocol to facilitate immediate payment at request time, though the protocol may allow for this. Crawlers are not like Web browsers: they are long-running processes that aren't constrained by the responsiveness requirements of human users, and can reconcile asynchronous operations.

## Controlling Content

It is not a requirement to provide a technical means of controlling the use of content once it has been crawled; this is not a Digital Rights Management scheme.

## Preventing Bad Faith

Some crawlers will attempt to crawl without using a payment protocol (e.g., by masquerading as browsers). It is not a requirement of a crawl payment protocol to prevent such misuse. Instead, we expect other interventions -- including blocking of misbehaving crawlers -- to disincent such behaviour.

Some crawlers might even use contents for purposes other than what they negotiate. Likewise, some sites might renege on their agreements and refuse access to content that a crawler has paid for. It is not a requirement to technically prevent these situations. We expect such cases to be addressed by other mechanisms, such as legal intervention.


# IANA Considerations

This document has no tasks for IANA.

# Security Considerations

Payment mechanisms for Web crawling undoubtedly have security implications and considerations, but beyond the aspects captured above, it is premature to characterise their nature.

--- back

