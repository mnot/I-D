---
title: Internet Standards and Policy
docname: draft-nottingham-standards-policy-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/standards-policy"

github-issue-label: standards-policy

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

This document identifies a number of distinct types of policy engagements that an Internet SDO might encounter, explores the implications of each, and suggests best practices for consideration.

--- middle


# Introduction

Discussing the interaction between *policy* -- a catch-all term that encompasses anything to do with governments, civil society, or the effects of technical decisions on society -- and Internet standards has always been difficult.

While it is now widely agreed that technical decisions (including those reflected in standards) do have impact on policy issues, there has been little agreement or clarity on what this implies for Internet Standards Developing Organisations (SDOs) like the IETF and W3C.

In particular, there isn't yet any guidance or common understanding about the different ways that policy concerns might intersect with an SDO's interest and activities. This document identifies a number of distinct types of policy engagements that an Internet SDO might encounter, explores the implications of each, and suggests best practices for consideration.

It is written for consideration and application by the Internet standards community, and for comment by the Internet policy community.


# Making Policy-Sensitive Decisions

First, while most technical decisions in SDOs don't have significant policy impact, some undeniably do. For example, {{?RFC8484}} clearly ruffled some policy feathers. Likewise, efforts to deprecate third-party HTTP cookies (reflected in work at both the W3C and IETF) have the acute interest of national regulators for privacy and competition.

When these implications are found by an SDO (or brought to their attention), communication about the considerations leading to the decision and its potential impact can smooth adoption of the standard and help guide the policy response to it. This doesn't necessarily mean that there will be alignment between the standard and policy relating to it -- merely that good communication through transparency and outreach is better than surprising those with policy concerns. {{?RFC8890}} covers this in more detail.

A deeper question concerns how SDOs should relate to state power when making such decisions -- should they defer to it? Ignore it? Coordinate with it?  Standards participants occasionally even argue that because a government has set a particular policy, a standard must conform to it, threatening the notion of an 'illegal standard.'

Such claims that standards decisions _must_ comply with law are ill-founded. Most law applies to implementations and their use within a jurisdiction, not the standards that specify how they interoperate -- reflecting the reality that power resides in the former much more than it does in the latter.

It's also doubtful that SDOs _could_ conform to laws consistently, should they apply to standards themselves. The Internet is a global phenomenon, and assuring that standards reflected all local laws globally -- if even possible -- would bring the possibility of fragmentation, significant limits on functionality, and general chaos. Consider, for example, what complying with an authoritarian regime's wishes would mean for a security-oriented protocol like TLS.

While an SDO could be selective in the laws it recognises -- for example, trying to comply with the laws of the countries represented by participants -- that would still likely lead to fragmentation, as the SDOs would effectively be abandoning other countries, and conflicts between participants' countries would not necessarily be avoided.

Furthermore, while discussions in SDOs often paint the law as static and immovable -- leading to the notion that being inevitable, it should be deferred to -- in fact it is better considered as an ongoing dialogue. Legislation is refined over time; albeit, long periods of time, but this should not deter those who are used to working on the timescales of RFCs and W3C Recommendations. Likewise, regulators often move more quickly as they consult with their stakeholders and take into account changes in their regulatory domain. Standards need not only react to the law; the law can react to the affordances provided by standards.

All of this suggests that while SDOs should be aware of the policy impacts of their decisions, the primary considerations they should take into account is their own architectural principals and the impact of policy on implementation, deployment, and adoption -- in other words, whether the goals of the standard are achievable within the policy environment.

For example, if a country passes a law that makes a standard unworkable, or a regulator focuses on a single implementor's behaviour, it does not necessarily follow that the standard has to change; it is still a useful standard elsewhere. On the other hand, if the regulatory environment in multiple jurisdictions is judged to be persistently hostile to a particular feature, that feature's design might be reconsidered so as to make it more deployable, if doing so is compatible with the feature's goals and the SDO's architectural principles.

When SDO decisions encroach upon policy matters, legitimacy is sometimes also called into question. Why should an undemocratic, unrepresentative body be allowed to decide how critical infrastructure like the Internet works?

While Internet SDOs may lack democratic legitimacy, they do have other forms of legitimacy: input legitimacy through incorporation of perspectives from civil society and other stakeholders, throughput legitimacy thanks to their transparent and accountable processes, and most significantly they have considerable output legitimacy because of their deep subject matter expertise and proven track record.

These sources of legitimacy indicate that SDOs are on the firmest ground when they focus on their areas of expertise: delivering standards that make the Internet work well. It is why decisions like the {{?RFC7258}} was stated in technical, architectural terms, even though it has deep policy impact.

Overall, the relationship of Internet SDOs to state power is not one of simple subservience or (at the other extreme) separate operation. A more helpful approach might be to think about SDOs as _transnational private regulators_ in a _polycentric regulatory regime_.

The concept of [transnational private regulation]() (TPR) is now well-established. In the last twenty to thirty years, it has become apparent that regulation of matters across state borders was not solely the domain of states -- especially when pertaining to things that required expertise that states typically lack, and even more so when those activities have a distinctly private nature. States now routinely work with, defer to, and sometimes codify the output TPRs on specific matters.

But it is important to place that role within a bigger context. Saying that SDOs operate as part of a polycentric regulatory regime recognises that the Internet has many regulators that take various forms, with different sources of legitimacy, different expertise, and a variety of roles. Importantly, there is no hierarchy: each regulator operates independently but meshes with others, sometimes cooperating, sometimes negotiating, sometimes clashing.

As one regulator amongst many, this means that SDOs have autonomy at the same time they have a need -- but not a requirement -- to align with other regulatory forces.

Among other things, this implies that when a national regulator wishes to promote a particular viewpoint or outcome, they can participate as any other participant in these bodies do, but should not be afforded any special status or priority through virtue of their state backing.


# Managing Regulatory Impact

Second, some legislation, rulemaking, and other forms of regulation have impact on how the Internet works. Policymakers often consult widely when the formulate regulation, but those consultations may not surface all impacts upon the Internet. When an issue is identified, how -- and should -- an SDO respond?

Currently, the IAB and the Internet Society perform much of this work for the IETF ([example]()), and the Team (i.e., staff) does so for the W3C ([example]()). Additionally, individuals sometimes "fill the gaps" ([example]()), and professional policy representatives of some member companies make additional contributions.

The combination of the increasing pace of regulation worldwide with the specialised nature of policy work might make this piecemeal approach unsustainable; most participants in SDOs do not have appropriate skills, and many who persist despite this can cause more problems than they solve (including, perhaps, your author).

It has been suggested that bodies like the IAB (for the IETF) and the TAG (for the W3C) could focus more heavily on policy issues, including when regulatory impact needs to be managed. However, this risks the scarce availability of candidates leading to over-relying on a single person or a small group of them presenting a perspective that does not accurately reflect community consensus.

Some also suggest that dedicated groups could be created to respond to impactful regulation, and perhaps handle other policy issues too. Again, most participants' lack of knowledge about their lack of knowledge (a.k.a. the Dunning–Kruger effect) regarding policy issues could make doing so very risky.

As such, responding to every regulation proposed that has potential impact on the Internet in a way that represents the community may not be realistic. Instead, prioritising review efforts of "inbound" regulations so that only the most egregious and important ones are responded to is probably appropriate, both to conserve resources and assure community alignment. And, of course, such responses should continue to focus on the technical and architectural impact of regulation, since these are SDOs' areas of expertise.

Additionally, reinforcement and further explanation of the values and principles that underly the infrastructure may help to inform external policy discussions in a way that better reflects consensus and consumers fewer resources.


# Complementing Legal Regulation

There are also times when regulation needs to be implemented through technical mechanisms. Both the IETF and W3C have a rich history of designing mechanisms that mesh with legal regulation -- for example, [Web Accessibility](https://www.w3.org/WAI/policies/), [emergency telephone services](), and the [upcoming work on messaging interoperability](). There are also negative examples, like the [refusal to enable wiretapping]() by the IETF.

These relationships can form in many ways. Some are straightforward, such as when a regulator asks for a function to be developed that is well within the SDO's competence, and doing so is aligned with the SDO consensus. Or, an SDO might develop a specification that the becomes codified in regulatory instruments.

These efforts are most successful when they take into account the nature of Internet SDOs. Internet standards are _voluntary_ -- as is often said, 'there are no protocol police.' Retrofitting a legal mandate onto voluntary standards needs to be carefully considered, because Internet SDOs use market adoption (or lack thereof) as an important check for their products' suitability.

In other words, many Internet standards (whether it be an RFC published by the IETF or a W3C Recommendation) fail; they never see wide adoption, or they fail to satisfy their users. In voluntary standards, this is an acceptable risk; however, if there is a state-backed mandate, there is no opportunity for a standard to fail, even if it is not of suitable quality.

Furthermore, the potential for an legal mandate can fundamentally change the nature of discussions in an SDO's work. For example, if the status quo is preferable to the emergence of a standard to some participants, they may attempt to block progress, as seen in the [Do Not Track]() effort. Most successful Internet standards are created by groups who act in good faith and at least partially share a common goal; if these factors are not present, failure may be more likely.

Finally, the delivery timelines expected by legal regulators are often not realistic for that required for open Internet standards. Even efforts where there is a well-developed input proposal, a group  of dedicated engineers who share a common goal, and a strong work ethic take multiple years to ship a standard. For example, the recent effort to revise the HTTP protocol to version 2 took just over two years; QUIC (a new transport protocol) took over three.

All of this suggests that Internet SDOs need to manage expectations of regulators when they attempt to use open standards to complement their goals.


# Leveraging Standards

Finally, some SDO participants want to apply policy tools created elsewhere in technical standards. For example, the [HRPC group]() was formed in the IRTF to identify ways that the Universal Declaration of Human Rights can be incorporated into protocol design.

Remembering the framing of Internet SDOs as transnational private regulators in a polycentric regulatory regime, a few issues and questions arise.

First, what is the impact on Internet SDOs' legitimacy, which is largely based upon their technical expertise? In the HRPC example, application of human rights often involves balancing competing concerns, which is not a common skill in the IETF; nor is it one that the IETF is perceived as legitimate to perform.

Second, explicit and intentional application of policy by Internet SDOs is likely to be seen as usurping the role of other regulators in the regime -- especially of those who are perceived to have greater legitimacy regarding those topics. What are the likely responses to such a move?

This should not be read as discouraging thinking about issues like human rights in protocols -- Internet SDOs do engage deeply with them ([example](), [example]()). Rather, we should question whether formally incorporating instruments that are intended for application by other regulators -- ones which have the legitimacy to do so -- is appropriate. Internet SDOs are at their best when they are representing the technical, architectural principles which are unique to their role.



# IANA Considerations

This document has no actions for IANA.


# Security Considerations

Undoubtedly, policy issues have the ability to have security implications, and vice versa. A complete treatment of that topic is beyond the scope of this document.


--- back

