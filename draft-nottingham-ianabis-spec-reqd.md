---
title: Specification Required Sub-Policies
abbrev:
docname: draft-nottingham-ianabis-spec-reqd-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/spec-reqd"

github-issue-label: spec-reqd

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://mnot.net/


--- abstract

This document defines sub-policies that refine the Specification Required registry policy in RFC 8126.

--- middle


# Introduction

{{Section 4.6 of !I-D.ietf-ianabis-rfc8126bis}} currently defines Specification Required as:

> For the Specification Required policy, review and approval by a designated expert (see Section 5) is required, and the values and their meanings must be documented in a permanent and readily available public specification, in sufficient detail so that interoperability between independent implementations is possible. This policy is the same as Expert Review, with the additional requirement of a formal public specification. In addition to the normal review of such a request, the designated expert will review the public specification and evaluate whether it is sufficiently stable and permanent, and sufficiently clear and technically sound to allow interoperable implementations.
>
> The intention behind "permanent and readily available" is that a document can reasonably be expected to be findable and retrievable long after IANA assignment of the requested value. Publication of an RFC is an ideal means of achieving this requirement, but Specification Required is intended to also cover the case of a document published outside of the RFC path, including informal documentation.

{{Section 4.6.1 of I-D.ietf-ianabis-rfc8126bis}} goes on to enumerate common issues encountered in use of Specification Required, including use of Internet-Drafts as the citation, purchase-only specifications, and citing non-IETF standards.

While this text offers improved clarity over the currently in-force guidance, it does not address specifications that are defined outside formal standards processes. In some registries, it is increasingly common for registration requests to come from Open Source projects, community groups and non-profits, and motivated individuals.

At the same time, "permanent and readily available" is now arguably achievable for even the most ephemeral resource, thanks to cheap perpetual Web hosting (e.g., on GitHub) and archiving services (such as archive.org).

{{subpolicies}} suggests sub-policies of the Specification Required policy, with the aim of clarifying these situations.

For a sub-policy to take effect, a given registry would need to opt into its use; note that there is no default, as existing registries may have already established relevant practices. Future revisions of this document might explore the mechanics of how a registry adopts a sub-policy (e.g., whether a revision of the registry specification is necessary, vs. an IESG or Expert declaration).


## Notational Conventions

{::boilerplate bcp14-tagged}


# Specification Required Sub-Policies {#subpolicies}

## Specification Required (Standards) {#sp-standards}

The "Standards" sub-policy of Specification Required adds a requirement that the cited specification(s) MUST be under the control of and published by an organization listed in the "IESG-Recognized Standards-Related Organizations" registry described in {{Section 3 of !I-D.ietf-ianabis-rfc7120bis}}.

This sub-policy explicitly precludes registrations using Internet-Drafts as the basis of a registration. However, IETF efforts are still eligible for early allocation, per {{I-D.ietf-ianabis-rfc7120bis}}.

Likewise, specifications from recognized organizations do not qualify for registration until they have completed the relevant processes there. However, preliminary and in-progress specifications might qualify for early allocation, per {{I-D.ietf-ianabis-rfc7120bis}}.

Organizations that appear in the "IESG-Recognized Standards-Related Organizations" registry are assumed to have met the "permanent and readily available" requirement for the purposes of this sub-policy, even if they charge for access to the specification. However, such organizations MUST provide a free copy to the Expert(s) for review.


## Specification Required (Community) {#sp-community}

The "Community" sub-policy of Specification Required adds a requirement that the cited specification(s) MUST either qualify under the Standards sub-policy ({{sp-standards}}), or in the opinion of the Expert(s) be the product of a significant community effort.

The Expert(s) SHOULD take the following factors into consideration when determining whether a specification is the product of a significant community effort:

   *  The specification is well-defined and complete
   *  The specification is freely available at a stable location
   *  The specification is not tied to or heavily associated with one implementation
   *  The use case addressed by the specification is using the registry's extension point appropriately
   *  The requested value is appropriate to the use case, and not so generic that it may be considered 'squatting'
   *  There are multiple interoperable implementations of the specification, or such implementations are likely to emerge
   *  There is evidence of broad adoption
   *  There is no likely conflict with IETF work or known work at other recognized SDOs (present or future)

The Expert(s) have discretion in applying these criteria; in some cases, they might judge it best to register an entry that fails one or more.  The intent is to assure that successfully deployed community efforts have registered code points.  As such, the criteria above are designed to preclude anticipatory registrations.

In addition, the Expert(s) MAY define additional guidance and criteria for managing the name space of the registry (e.g., to avoid "squatting" on code points that are likely to be standardized).

Specifications whose registration is deemed to be the product of a significant community effort are not eligible for early allocation.

## Specification Required (Permissive) {#sp-permissive}

The "Permissive" sub-policy of Specification Required explicitly allows registration of
any specification, regardless of who publishes it, that meets the "permanent and readily available" requirement set by {{Section 4.6 of I-D.ietf-ianabis-rfc8126bis}}. This includes but is not limited to:

* Archived Internet-Drafts
* GitHub repositories and similar data stores
* Publicly available archive services

To qualify as "permanent and readily available", a specification SHOULD NOT be able to be made unavailable by the arbitrary decision or action of a single person. This precludes, for example, personal Web sites and personal GitHub repositories as suitable specification references, but MAY permit those operated by groups of people. Note that this requirement only applies to provision of the specification, not authorship.

The Expert(s) MAY define additional guidance and criteria for managing the name space of the registry (e.g., to avoid "squatting" on code points that are likely to be standardized).

When this sub-policy is in effect, only registrations that qualify under the Standards sub-policy ({{sp-standards}}) are eligible for early allocation.


# IANA Considerations

This document has no direct tasks for IANA, but will need to be operationalised by them.

# Security Considerations

The security considerations of {{I-D.ietf-ianabis-rfc8126bis}} apply.

--- back

