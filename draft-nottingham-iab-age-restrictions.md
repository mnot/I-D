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

Around the world, authorities are considering (and in some cases implementing) age restriction
systems for Internet content. This document explores the potential for unwanted impacts upon the
Internet by these systems and makes recommendations about the properties they should have, if they
are to be a successful part of the Internet infrastructure.

--- middle


# Introduction

Increasingly, policymakers are proposing regulation that restricts what content young people can access online. A recurring theme in these efforts is that it is no longer considered sufficient to rely on self-assertions of age. A number of jurisdictions have enacted - or are in the process of enacting – laws that take steps to provide stronger guarantees that children are not exposed to certain content.

Age restrictions are already deployed on the Internet; for example, some Web sites already require some proof of age to create an account. However, when deployments become more widespread, they tend to have greater impact upon the Internet architecture. Systems that are designed for deployment in a single, homogenous domain rarely are suitable for the diversity of requirements and considerations that apply to Internet-scale systems.

{{risks}} catalogues the risks that such systems might incur, expressed in terms of the Internet's
architectural principles. {{recommendations}} suggests the properties that an age restriction
system should have to be a healthy part of the Internet infrastructure.


# Risks of Age Restriction {#risks}

This section catalogues risks that age restriction systems might encounter, expressed in terms of the Internet's architectural principles.

## Centralization

Inherently, any age restriction system involves controlling access to content and services on the Internet. That control -- along with the potential for access to information about people's activities online that comes with it -- is immensely valuable to various parties, often for purposes other than those that policymakers have in mind.

How and where that control is exercised thus becomes an important consideration.

For example, if an age restriction system requires verification by a single party, that party will have access to a significant amount of sensitive information about people's activities on the Internet. Such systems can be leveraged for a variety of purposes beyond those intended by policymakers -- both by that party itself, and by individuals, organized criminals, and nation-state actors who are able to perform successful cyber attacks against it.

It also means that any party operating the system has extraordinary access, and thus risk of abuse, especially if their incentives are not aligned with other participants in the system.

In both cases, having only one entity operating the system increases the associated risks dramatically, as this effectively centralizes control in their hands while simultaneously presenting a single target to attackers.

Thus, centralisation is a primary consideration for age restriction systems. Internet infrastructure is designed in a way to avoid centralization where it is technically possible, or to mitigate centralization risks where it is not. Since there is nothing inherently centralized about determining a person's age -- i.e., there are many ways to come to that conclusion -- centralization should be avoided, not accommodated, in these systems.

{{CENTRALIZATION}} explores these issues greater detail.


## Privacy and Security

It is technically challenging to design an age restriction system that exhibits the security and privacy properties expected of Internet standards. Exposing information about Internet users to third parties -- whether verifiers, services, or others -- creates powerful incentives. In particular, commercial interests desire access to it to be able to track activity across the Internet so that this can be sold (to advertisers, insurers and others), and so they will use (and abuse) any facility that offers such information to learn about what people are doing.

Critically, even small amounts of information can aid these purposes, because they can be aggregated with other information (like IP addresses, browser characteristics, and so on) to create a unique identifier for each Internet user.

In this context, age restriction systems can introduce several new risks to the Internet.

Most immediately, a system that reveals the age (or birthdate) of Internet users to services on it is a privacy risk. A person's age is an attribute that can be used to discriminate against them without justification, and is legally protected by privacy law in many jurisdictions.

Beyond that immediate risk, a system that exposes the Internet services that a person uses to a verifying entity introduces a new way to track and profile Internet users. The risks here are similar to those seen on the Web, which the Internet standards community has expended considerable effort to mitigate (see e.g., {{?RFC7258}}).

Exposing information regarding attributes other than age to services creates additional privacy and security risks. For example, an age verification system that also exposes the country a person is a citizen of allows sites to discriminate against that attribute, which is beyond the purpose of age restriction.

Finally, even on its own a simple attribute like 'age in years' or 'birthdate' can be used to add entropy to an identifier for the end user, creating a new tracking vector. See {{TRACKING}}.

Therefore, age restriction systems that are intended to become part of Internet infrastructure MUST:
* Avoid sharing information about usage with age verifiers
* Avoid sharing information other than age information with services
* Minimise the amount of age information shared with services (e.g., using age brackets)

See also {{PRIVACY}}.


## Barriers to Access

Many existant proposals for age restriction systems require its users to have certain capabilities -- for example, a personal smartphone, a government credential, or a camera with certain resolution.

Imposing these requirements means that some number of people will be disenfranchised from full use of the Internet – especially if age restriction becomes pervasive across many services. At the scale of the entire Internet (or even in a single country), this can be a large number of disenfranchised people.

For example, many people only have Internet access from public computers (such as those in libraries), and do not have exclusive or reliable access to a smartphone. Others lack government-issued identity documents that some schemes rely upon.

While such restrictions may be palatable in a closed system (such as on a single platform or in a single jurisdiction), they are not suitable for Internet-wide deployment.


## Fragmentation

If an age restriction system relies too much on legal controls rather than technical capabilities, those controls are likely to be inconsistently applied in different jurisdictions, leading to different experiences for Internet users around the globe.

Likewise, a solution that requires special access to computers (such as in “trusted platform modules” or otherwise mandates conformance on people’s computers introduces a risk of limiting the kinds of computers that can be used on the Internet – for example, Open Source Operating Systems and Web browsers are generally unable to provide such assurances.

While these tradeoffs may be reasonable in a single jurisdiction, too many differences will create barriers to Internet-wide deployment of services, creating not only centralization risks, but also fragmentation risks -- that the Internet will work in different ways depending on where you are.


## An Age-Gated Internet

The Internet is designed to be used without permission, both be servers and clients. Easy-to-use age restriction mechanisms risk creating a ‘papers please’ Internet, where a credential is required to access large portions of the Internet. Such an outcome would amplify the other harms listed.

This risk is heightened if there are incentives for sites to deploy it, such as access to non-age data.

Access to more granular age information also heightens many risks, because it makes a restriction system simultaneously useful in a broader variety of cases, and more attractive for misuse, because it offers more information about users.


# Recommendations for Age Restriction Systems {#recommendations}



## Content Marking


## Distributed Implementation




# IANA Considerations

This document has no instructions for IANA.

# Security Considerations

Age restriction systems undoubtedly have numerous security considerations, should they be deployed.

--- back

