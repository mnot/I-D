---
title: Specification Required Sub-Policies
abbrev:
docname: draft-nottingham-ianabis-spec-reqd-latest
date: {DATE}
category: bcp

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

## Notational Conventions

{::boilerplate bcp14-tagged}


# Common Requirements {#common}

This section applies to registrations under any of the sub-policies in {{subpolicies}}. The Expert(s) determine whether the registration itself is appropriate for the registry, using any guidance available in the document(s) establishing it.

The Expert(s) determine whether the use case addressed by the specification uses the registry's extension point as it was intended to be used.

Unless the document(s) establishing the registry provide otherwise, a registration request MUST come from the change controller of the cited specification, or from a party acting on its behalf.

{{Section 4.6 of I-D.ietf-ianabis-rfc8126bis}} requires a specification to be "permanent and readily available." To qualify, a specification MUST be freely available to the public, except as provided in {{sp-standards}}, and SHOULD NOT be able to be made or kept unavailable by the action or inaction of a single person. This precludes, for example, personal Web sites and personal GitHub repositories as suitable specification references, but MAY permit those operated by groups of people. Note that this requirement only applies to provision of the specification, not authorship.

{{Section 4.6 of I-D.ietf-ianabis-rfc8126bis}} also requires a specification to be "in sufficient detail so that interoperability between independent implementations is possible." The Expert(s) determine this on a case-by-case basis, using any guidance available in the document(s) establishing the registry.

The Expert(s) MAY define additional guidance and criteria for managing the name space of the registry. Where a registry's values are human-readable, that guidance SHOULD address whether a requested value is appropriate to the use case it describes; a value more generic than its specification warrants can mislead users, and can consume a term that later efforts will need.

The Expert(s) can refuse a registration on any of these grounds, even where the cited specification qualifies under the applicable sub-policy.


# Specification Required Sub-Policies {#subpolicies}

For a sub-policy to take effect, a given registry needs to opt into its use; note that there is no default, as existing registries may have already established relevant practices.

Documents that define new registries and redefine existing ones can explicitly nominate a sub-policy. However, such action is not necessary; in consultation with the relevant Expert(s), the IESG may deem a registry to be covered by a sub-policy.

## Specification Required (Standards) {#sp-standards}

The "Standards" sub-policy of Specification Required adds a requirement that the cited specification(s) MUST be under the control of and published by an organization listed in the "IESG-Recognized Standards-Related Organizations" registry described in {{Section 3.2 of !I-D.ietf-ianabis-rfc7120bis}}.

This sub-policy explicitly precludes registrations using Internet-Drafts as the basis of a registration. However, IETF efforts are still eligible for early allocation, per {{I-D.ietf-ianabis-rfc7120bis}}.

Likewise, specifications from recognized organizations do not qualify for registration until they have completed the relevant approval processes in those organizations. However, preliminary and in-progress specifications might qualify for early allocation, per {{I-D.ietf-ianabis-rfc7120bis}}.

Organizations that appear in the "IESG-Recognized Standards-Related Organizations" registry are assumed to have met the "permanent and readily available" requirement for the purposes of this sub-policy, even if they charge for access to the specification. However, such organizations MUST provide a free copy to the Expert(s) for review.

Registrations under this sub-policy are also subject to {{common}}.

## Specification Required (Community) {#sp-community}

The "Community" sub-policy of Specification Required adds a requirement that the cited specification(s) MUST either qualify under the Standards sub-policy ({{sp-standards}}), or in the opinion of the Expert(s) be the product of a community effort (a "community specification"), as evidenced by the indicators below.

The Expert(s) SHOULD consider the following indicators when determining whether a specification is the product of a community effort:

   *  The specification is developed in a process that is open to participation, with a public record of its discussion
   *  Change control over the specification is held by a group or organization, rather than by an individual
   *  The specification is versioned, and changes to it are published rather than made silently
   *  The specification is not tied to or heavily associated with one implementation
   *  There is evidence of broad adoption or implementer interest beyond the specification's authors
   *  There are multiple interoperable implementations of the specification or such implementations are likely to emerge
   *  Other specifications or projects normatively reference the specification

Taken together, these indicators are evidence that a community effort stands behind the specification. No single one is required, and the list is not exhaustive.

A specification need not already be deployed to qualify. In many registries implementation does not begin until a value has been assigned, so the absence of adoption is not by itself grounds for refusal. Equally, the Expert(s) can refuse a registration where the specification has not had enough review for its quality or its fit to the registry to be judged, even when every indicator above is present.

Community specifications are not eligible for early allocation. Early allocation presumes a process that will conclude and a body accountable for the request, so that an allocation can later be confirmed or reclaimed. A community effort supplies neither, so an allocation granted on that basis would be permanent from the moment it was made.

Registrations under this sub-policy are also subject to {{common}}.

## Specification Required (Permissive) {#sp-permissive}

The "Permissive" sub-policy of Specification Required explicitly allows registration of a specification, regardless of who publishes it, provided that it meets the requirements of {{Section 4.6 of I-D.ietf-ianabis-rfc8126bis}} and {{common}}. Specifications published in the following ways can qualify, among others:

* Archived Internet-Drafts
* GitHub repositories and similar data stores
* Publicly available archive services

When this sub-policy is in effect, only registrations that qualify under the Standards sub-policy ({{sp-standards}}) are eligible for early allocation.

Registrations under this sub-policy are also subject to {{common}}.

# IANA Considerations

When a registry has a defined sub-policy, IANA should record it in the registry's "Registration Procedure(s)" field, along with a reference to the document or IESG determination that established it.

# Security Considerations

The security considerations of {{I-D.ietf-ianabis-rfc8126bis}} apply.

--- back

