---
title: Considering the Users of Internet Standards
abbrev: IETF Constituencies
docname: draft-nottingham-for-the-users-00
date: 2015
category: bcp

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft
keyword: constituent
keyword: constituency

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
  RFC1958:
  RFC2460:
  RFC3935:
  RFC4941:
  RFC6265:
  CODELAW:
    target: http://harvardmagazine.com/2000/01/code-is-law-html
    title: "Code Is Law: On Liberty in Cyberspace"
    author:
      -
        ins: L. Lessig
        name: Lawrence Lessig
        organization: Harvard Magazine
    date: 2000
  TUSSLE:
    target: "http://groups.csail.mit.edu/ana/Publications/PubPDFs/Tussle2002.pdf"
    title: "Tussle in Cyberspace: Defining Tomorrow’s Internet"
    author:
      -
        ins: D. Clark
        name: David D. Clark
        organization: MIT Lab for Computer Science
      -
        ins: K. Sollins
        name: Karen R. Sollins
        organization: MIT Lab for Computer Science
      -
        ins: J. Wroclawski
        name: John Wroclawski
        organization: MIT Lab for Computer Science
      -
        ins: R. Braden
        name: Robert Braden
        organization: USC Information Sciences Institute  
    date: 2002
  PRIORITY:
    target: http://www.w3.org/TR/html-design-principles/#priority-of-constituencies
    title: HTML Design Principles
    author: 
      - 
        ins: A. van Kesteren
        name: Anne van Kesteren
        organization: Opera Software ASA
      -
        ins: M. Stachowiak
        name: Maciej Stachowiak
        organization: Apple Inc
    date: 26-11-2007
  RFC6962:
  RFC7230:


--- abstract

Internet standards serve and are used by a variety of constituencies. This document contains
guidelines for identifying them, serving them, and determining how to resolve conflicts between
their interests, when necessary.

It also mandates end users as the highest priority constituency for Internet standards.

--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-the-users>.


--- middle

# Introduction

The IETF is most comfortable making technical decisions; our process is defined to favor technical
merit, and our known bias towards "rough consensus and running code" is well suited to this area of
work.

However, the running code that results (when things work well) inevitably has an impact beyond
technical considerations. As much as engineers would like to be removed from "political"
considerations, as the Internet has become prevalent in many societies, it has a profound
societal impact. The Internet has played a role in political organizing, revolutionizing access to information and improving accountability, it has also contributed to surveillance and harassment. It has created wealth for some individuals and companies, while destroying others'.

These effects are in no small part attributable to how the Internet works; its design affords some
uses, while discouraging others. Or, in the words of Lawrence Lessig {{CODELAW}}:

> Ours is the age of cyberspace. It, too, has a regulator... This regulator is code—the software and hardware that make cyberspace as it is. This code, or architecture, sets the terms on which life in cyberspace is experienced. It determines how easy it is to protect privacy, or how easy it is to censor speech. It determines whether access to information is general or whether information is zoned. It affects who sees what, or what is monitored. In a host of ways that one cannot begin to see unless one begins to understand the nature of this code, the code of cyberspace regulates.

All of this begs the question: Who do we go through the pain of rough consensus and write the
running code for?

There are a variety of identifiable constituents that Internet standards can provide benefit to,
such as (but not limited to) end users, network operators, social movements, NGOs, schools, equipment vendors,
specification implementers, content owners, governments, and employers.

Good specifications will provide benefit to all of the relevant constituencies, because standards
do not represent a zero-sum game. However, on occasion we do need to balance the benefits of a
protocol design decision between two (or more) constituents.

Likewise, sometimes efforts are brought to the IETF that represent the technical needs of a
specific constituency that does not take the needs of others into account. On its own, such a
specification meets a technical need for its community, but at the expense of others. When
presented with such a proposal, we need to decide how to handle it.

Currently, such decisions occur in an ad hoc fashion, often without explicitly being discussed.
This approach works reasonably well in many cases; even if a constituency is not directly
represented in the process, there are often advocates for their interests, and ultimately protocols
that disadvantage a particular constituency tend to be either rejected by it or eventually replaced.

However, we do sometimes expend a considerable amount of energy mitigating potential harm to
under-represented constituencies, and often harm to a constituency is not so onerous or obvious as
to dissuade them from using something (e.g., {{RFC6265}}). 

Furthermore, the Internet is not a value-neutral space, as per the IETF's mission {{RFC3935}}:

> The IETF community wants the Internet to succeed because we believe that the existence of the Internet, and its influence on economics, communication, and education, will help us to build a better human society.

To better define the criteria that we use to make such decisions when necessary, document these decisions, minimize potential harm, and to help fulfill the mission of the IETF, this document outlines a set of guidelines about
how the constituents of Internet standards should be identified, and when necessary, balanced.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Internet is for End Users

Internet standards MUST prioritize end users higher than any other constituents. While networks
need to be managed, employers and equipment vendors need to meet business goals, etc., our mission
is to "build a better human society" {{RFC3935}} and providing "global connectivity" {{RFC1958}} and -- on the Internet -- society is composed of what we call "end users."

Furthermore, the success of the Internet to date is arguably due largely to its bias towards
end user concerns; without a firm preference for their benefit, trust in the Internet will
erode, and its value -- for all constituents -- will be greatly diminished.

This does not mean that end users have ultimate priority; there may be cases where genuine
technical need of another constituent requires that end user requirements compromise. However, such
tradeoffs need to be carefully examined, and avoided when there are alternate means of achieving
the desired goals. If not, these choices and reasoning should be carefully documented.

For example, IPv6 {{RFC2460}} identifies each client with a unique address -- even though this
provides a way to track end user activity and helps identify them -- because it is technically
necessary to provide networking (and despite this, there are mechanisms like {{RFC4941}} to
mitigate this effect, for those users who desire it).

In contrast, proposed standards to allow middleboxes to inspect encrypted traffic for purposes
such as data loss prevention or virus scanning fail to meet this requirement, because there are
alternative mechanisms available (such as endpoint-based solutions). The convenience gained by the
employers who deploy such devices is not a reasonable exchange for the reduction in overall
end-user security caused by the erosion of end-to-end encryption, especially when the same
mechanisms could be legitimately deployed by ISPs and governments once they were standardized.


# Identifying the Constituents of Internet Standards

Internet standards MUST document relevant primary constituents and their interrelationships.

For example, HTML does so using the priority of constituencies in the HTML Design Principles
{{PRIORITY}}:

> In case of conflict, consider users over authors over implementors over specifiers over theoretical purity. In other words costs or difficulties to the user should be given more weight than costs to authors; which in turn should be given more weight than costs to implementors; which should be given more weight than costs to authors of the spec itself, which should be given more weight than those proposing changes for theoretical reasons alone. Of course, it is preferred to make things better for multiple constituencies at once.

Note how the relative priority of constituents is explicit; this is intentional and encouraged. However, it need not be a strict ranking in all cases; in some areas, it can be more useful to give equal weight to constituencies, so as to encourage the tussle {{TUSSLE}}.

Likewise, the responsibilities of, or expectations upon, constituents can vary greatly. For
example, end users of Web browsers cannot be reasonably expected to make informed decisions about
security, and therefore design decisions there are biased towards default security. When
applicable, the expectations upon a constituency SHOULD be documented.

Extensions to existing standards MUST document how they interact with the extended standard's
constituents. If the extended standard's constituents are not yet documented, the extension MAY
estimate its impact, in coordination with that standard's community and the IESG.

The burden of this documentation need not be high; if HTML can do it in a paragraph, so can most
standards. While it might be appropriate in a separate document (e.g., a requirements or use cases
draft) or the specification itself, documenting constituents in the WG charter has considerable
benefits, since it clarifies their relationships up-front.

Inevitably, documenting and interpreting the constituent roles will become controversial; this is
to be expected, and is still preferable to avoiding the discussion. The point is to make it
explicit, so that the effected constituencies can be made aware of the discussion, and judge the
outcome.

## Handling Change in Constituencies

Changes in the use, deployment patterns, legal context, or other factors of a standard can bring
pressure to re-balance the priorities of existing constituents, or insert new ones (usually, when a
standard is either extended or evolved).

Such changes MUST NOT violate the priority of existing constituents, or those reasonably assumed by
existing constituents, without informed consent. Note that this may preclude the change completely,
as it is often impossible to gain the informed consent of a large or diffuse group of constituents
(e.g., end users).

For example, there has been increasing pressure to change HTTP {{RFC7230}} to make it more amenable
to optimization, filtering, and interposition of other value-added services, especially in the face
of more pervasive encryption (denoted by HTTPS URIs). However, since HTTPS is already defined as a
two-party protocol with end-to-end encryption, inserting a third party in any fashion would violate
the expectations of two existing constituents; end users and content publishers. Therefore, the
HTTP Working Group has refused to consider such changes.


## Avoiding Unnecessary Constituents

In protocol design, intermediation is often thought of as "those parties on the direct path between
two people attempting to communicate"; e.g., middleboxes, proxies and so on.

When discussing constituencies, this definition can be expanded to include those parties that have
the ability to prevent or control communication between two parties. This naturally includes
middleboxes, but can also include third parties not directly on-path.

For example, HTTP has on-path intermediaries (proxies, gateways, etc.), but also off-path
intermediaries, in the form of the DNS registrar, the DNS server, and also the Certificate
Authority if TLS is in use. Certificate Transparency {{RFC6962}} potentially adds yet another
intermediary to this protocol suite.

While there might be a good technical reason to interpose such an intermediary, it also introduces
a new constituent, and thus needs to be done with due consideration of the impact on other
constituents. 

Therefore, unnecessary constituents SHOULD be avoided when possible in Internet standards. 



# IANA Considerations

This document does not require action by IANA.

# Security Considerations

This document does not have direct security impact; however, applying its guidelines (or failing
to) might affect security positively or negatively for various constituents.


--- back

# Acknowledgements

Thanks to Jacob Appelbaum for making the suggestion that led to this document.

Thanks also to the WHATWG for blazing the trail.

Thanks to Edward Snowden for his comments regarding the priority of end users.

Thanks to Harald Alvestrand for his substantial feedback, Joe Hildebrand and Martin Thomson for
their suggestions, and Niels ten Oever for encouragement.
