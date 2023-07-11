---
title: Allowing Community Registrations in the Standards Tree
abbrev: Community Registrations
docname: draft-nottingham-mediaman-standards-tree-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/standards-tree"

github-issue-label: standards-tree

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

Over time, it has become clear that there are media types which have the character of belonging in the standards tree (because they are not associated with any one vendor or person), but are not published by a standards body. This draft suggests an update to {{!RFC6838}} to allow their registration.

--- middle


# Introduction

{{!RFC6838}} only allows registrations in the standards tree from the IETF and other "recognized standards-related organizations."

Over time, it has become clear that there are media types which have the character of belonging in the standards tree (because they are not associated with any one vendor or person), but are not published by a standards body.

To address this shortcoming, {{tree}} suggests a drop-in replacement for {{Section 3.1 of !RFC6838}}.

## Notational Conventions

{::boilerplate bcp14-tagged}

# Standards Tree {#tree}

The standards tree is intended for types of general interest to the Internet community. Registrations in the standards tree MUST be either:

1. in the case of registrations associated with IETF specifications, approved directly by the IESG, or

2. registered by a recognized standards-related organization using the "Specification Required" IANA registration policy {{!RFC5226}} (which implies Expert Review), or

3. approved by the Designated Expert(s) as identifying a "community format", as described in {{community}}.

The first procedure is used for registrations from IETF Consensus documents, or in rare cases when registering a grandfathered (see Appendix A) and/or otherwise incomplete registration is in the interest of the Internet community. The registration proposal MUST be published as an RFC. When the registration RFC is in the IETF stream, it must have IETF Consensus, which can be attained with a status of Standards Track, BCP, Informational, or Experimental. Registrations published in non-IETF RFC streams are also allowed and require IESG approval. A registration can be either in a stand-alone "registration only" RFC or incorporated into a more general specification of some sort.

In the second case, the IESG makes a one-time decision on whether the registration submitter represents a recognized standards-related organization; after that, a Media Types Reviewer (Designated Expert or a group of Designated Experts) performs the Expert Review as specified in this document. Subsequent submissions from the same source do not involve the IESG. The format MUST be described by a formal standards specification produced by the submitting standards- related organization.

The third case is described in {{community}}.

Media types in the standards tree MUST NOT have faceted names, unless they are grandfathered in using the process described in Appendix A.

The "owner" of a media type registered in the standards tree is assumed to be the standards-related organization itself. Modification or alteration of the specification uses the same level of processing (e.g., a registration submitted on Standards Track can be revised in another Standards Track RFC, but cannot be revised in an Informational RFC) required for the initial registration.

Standards-tree registrations from recognized standards-related organizations are submitted directly to the IANA, where they will undergo Expert Review {{!RFC5226}} prior to approval. In this case, the Expert Reviewer(s) will, among other things, ensure that the required specification provides adequate documentation.

## Community Formats in the Standards Tree {#community}

Some formats are interoperable (i.e., they are supported by more than one implementation), but their specifications are not published by a recognized standards-related organization. To accommodate these cases, the Designated Expert(s) are empowered to approve registrations in the standards tree that meet the following criteria:

- There is a well-defined specification for the format
- That specification is not tied to or heavily associated with one implementation
- The specification is freely available at a stable location
- There are multiple interoperable implementations of the specification, or they are likely to emerge
- The requested name is appropriate to the use case, and not so generic that it may be considered 'squatting'
- There is no conflict with IETF work or work at other recognised SDOs (present or future)
- There is evidence of broad adoption

The Designated Expert(s) have discretion in applying these criteria; in rare cases, they might judge it best to register an entry that fails one or more.

Note that such registrations still go through preliminary community review (Section 5.1), and decisions can be appealed (Section 5.3).


# IANA Considerations

This draft introduces no new instructions for IANA.

# Security Considerations

This draft does not introduce new security issues. Seriously.


--- back

