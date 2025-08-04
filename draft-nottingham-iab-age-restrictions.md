---
title: Architectural Considerations of Age Restriction
abbrev:
docname: draft-nottingham-iab-age-restrictions-latest
date: {DATE}
category: info

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/age"

github-issue-label: age

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

informative:
  CENTRALIZATION: RFC9518
  PRIVACY: RFC6973
  TRACKING:
    target: https://www.w3.org/2001/tag/doc/unsanctioned-tracking/
    title: Unsanctioned Web Tracking
    date: 17 July 2015
    author:
      - organization: W3C TAG

--- abstract

Around the world, policymakers are considering (and in some cases implementing) age restriction systems for Internet content. This document explores the unwanted impacts on the Internet that these systems are likely to have and makes recommendations about the properties they should have, if they are to be a successful part of the Internet infrastructure.

--- middle


# Introduction

Increasingly, policymakers are proposing and implementing regulation that restricts what content young people can access online. A recurring theme in these efforts is that it is no longer considered sufficient to rely on self-assertions of age, and so stronger guarantees are deemed necessary.

Age restrictions are already deployed on the Internet: for example, some Web sites already require proof of age to create an account. However, when such deployments become more prevalent, they tend to have greater impact upon the Internet architecture, thereby endangering other properties that we depend upon for a healthy online ecosystem. Systems that are designed for deployment in a single, homogenous domain rarely are suitable for the diversity of requirements and considerations that apply to Internet-scale systems.


# Risks of Age Restriction {#risks}

This section catalogues risks that age restriction systems might encounter, expressed in terms of the Internet's architectural principles.

## Centralization

Inherently, any age restriction system involves controlling access to content and services on the Internet. That control -- along with the potential for access to information about people's activities online that comes with it -- is immensely valuable to various parties, often for purposes other than those that policymakers have in mind.

How and where that control is exercised thus becomes an important consideration.

For example, if an age restriction system requires verification by a single party, that party will have access to a significant amount of sensitive information about people's activities on the Internet. Such systems can be leveraged for a variety of purposes beyond those intended by policymakers -- both by that party itself, and by individuals, organized criminals, and nation-state actors who are able to perform successful cyber attacks against it.

It also means that any party operating the system has extraordinary access, and thus risk of abuse, especially if their incentives are not aligned with other participants in the system.

In both cases, having only one entity operating the system increases the associated risks dramatically, as this effectively centralizes control in their hands while simultaneously presenting a single target to attackers.

Even when multiple parties provide verification services, centralization can emerge if there is too much friction against user switching between them. For example, if Web sites rather than end users select the verification service used, this does not create a market that respects end user preferences; it only respects the self-interest of sites.

Age restriction systems can also have secondary effects that lead to centralization. For example, if an age restriction system requires use of a particular Web browser (or a small number of them), that effectively distorts the market for Web browsers.

Thus, centralisation is a primary consideration for age restriction systems. Internet infrastructure is designed in a way to avoid centralization where it is technically possible, or to mitigate centralization risks where it is not. Since there is nothing inherently centralized about determining a person's age -- i.e., there are many ways to come to that conclusion -- centralization should be avoided, not merely mitigated, in these systems.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:

* Avoid reliance on a single party to provide age verification services
* Provide some mechanism for easy switching between verification services by end users
* Avoid requiring use of an arbitrarily limited set of operating systems, Web browsers, client programs, or other software or hardware

{{CENTRALIZATION}} explores these issues greater detail.


## Privacy and Security

It is technically challenging to design an age restriction system that exhibits the security and privacy properties expected of Internet standards. Exposing information about Internet users to third parties -- whether verifiers, services, or others -- creates powerful incentives. In particular, commercial interests desire access to it to be able to track activity across the Internet so that this can be sold (to advertisers, insurers and others), and so they will use (and abuse) any facility that offers such information to learn about what people are doing.

Critically, even small amounts of information can aid these purposes, because they can be aggregated with other information (like IP addresses, browser characteristics, and so on) to create a unique identifier for each Internet user.

In this context, age restriction systems can introduce several new risks to the Internet.

Most immediately, a system that reveals the age (or birthdate) of Internet users to services on it is a privacy risk. A person's age is an attribute that can be used to discriminate against them without justification, and is legally protected by privacy law in many jurisdictions.

Beyond that immediate risk, verifying services' potential access to personal information creates a powerful incentive for misuse -- whether as part of the business model of the verifying service, or by third parties (such as nation-state attackers).

This is the case when verifying services over-collect such information (for example, age estimation services that use photos and biometrics), and it is also the case when users' activity is exposed to the verifying service when age restriction takes place. The latter risk is similar to the risk of tracking and profiling seen on the Web, which the Internet standards community has expended considerable effort to mitigate (see e.g., {{?RFC7258}}).

Furthermore, exposing information beyond age to services creates additional privacy and security risks. For example, an age verification system that also exposes the country a person is a citizen of allows sites to discriminate against that attribute, which is beyond the purpose of age restriction.

Finally, even on its own a simple attribute like 'age in years' or 'birthdate' can be used to add entropy to an identifier for the end user, creating a new tracking vector when exposed to services that collect such information. See {{TRACKING}}.

In all cases, the privacy and security of an age restriction system needs to be proven: considerable experience has shown that merely trusting assertions of these properties is ill-founded.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:

* Avoid over-collection of information by age verifiers
* Avoid sharing information about service usage with age verifiers
* Avoid sharing information other than age information with services
* Minimise the amount of age information shared with services (e.g., using age brackets)
* Be based upon publicly available specifications that have had adequate security and privacy review to the level that Internet standards are held to

See also {{PRIVACY}}.


## Barriers to Access

Many existant proposals for age restriction systems require its users to have certain capabilities -- for example, a personal smartphone, a government credential, or a camera with certain resolution.

Imposing these requirements means that some number of people will be disenfranchised from full use of the Internet – especially if age restriction becomes pervasive across many services. At the scale of the entire Internet (or even in a single country), this can be a large number of disenfranchised people.

For example, many people only have Internet access from public computers (such as those in libraries), and do not have exclusive or reliable access to a smartphone. Others lack government-issued identity documents that some schemes rely upon.

While such restrictions may be palatable in a closed system (such as on a single platform or in a single jurisdiction), they are not suitable for Internet-wide deployment.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:

* Avoid requiring hardware capabilities not widely available in desktop and mobile computers globally, both in terms of overall performance and specific features
* Avoid relying on a single mechanism for proving age


## Fragmentation

The likelihood of incompatible age restriction systems being deployed in different jurisdictions around the world introduces a risk of fragmentation -- i.e., that the Internet will not work the same way in different places.

Fragmentation is a growing concern for the Internet: various local requirements are creating friction against global deployment of new applications, protocols, and capabilities. As the Internet fragments, the benefits of having a single, globe-spanning networking technology are correspondingly lessened. Although a single factor (such as diverging approaches to age restriction) is unlikely to fragment the Internet on its own, the sum of such divergences increases the risk of fragmentation greatly, risking the viability of the Internet itself.

In the context of age restriction, fragmentation is most concerning if someone were to need to understand and interact with (possibly after some onboarding procedure) a new system for each jurisdiction they visit. This would represent a significant barrier for users who travel, and would also present increased complexity and regulatory burden for businesses, potentially leading to further lack of competitiveness in some industries by increasing costs.

Fragmentation is best addressed by adoption of common technical standards across jurisdictions.

However, it is important to recognise that the mere existence of an international standard does not imply that it is suitable for deployment: experience has shown that voluntary adoption by implementers is important to prove their viability.

Furthermore, standards do not necessarily enforce interoperability and the architectural goals that they espouse: if they allow too much interpretation of their application (for example, through optional-to-implement features, or too-generous extensibility mechanisms), they can fall short of these goals and only provide "air cover" for those who wish to claim standards compliance, without actually serving public interest goals -- thereby leading to fragmentation.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:

* Be based upon internationally recognised, open technical standards
* Be based upon technical standards that are voluntarily adopted by implementers
* Be specified in a manner that provides interoperability and ensures architectural alignment
* Be coordinated across jurisdictions wherever feasible


## An Age-Gated Internet

The Internet is designed to be used without permission, both be servers and clients. Easy-to-use age restriction mechanisms risk creating a ‘papers please’ Internet, where a credential is required to access large portions of the Internet's services. Such an outcome would amplify the other harms listed.

This risk is heightened if there are incentives for sites to deploy it, such as increased access to non-age data.

Access to more granular age information also heightens many risks, because it makes a restriction system simultaneously useful in a broader variety of cases, and more attractive for misuse, because it offers more information about users.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:

* Make the use of age restrictions visible to end users
* Have a structural disincentive for deployment of age-gated services online


# IANA Considerations

This document has no instructions for IANA.

# Security Considerations

Age restriction systems undoubtedly have numerous security considerations, should they be deployed.

--- back

