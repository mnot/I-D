---
title: "IESG Document Review Expectations: Impact on AD Workload"
abbrev: Document Review and AD Workload
docname: draft-nottingham-iesg-review-workload-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/ad-workload"

github-issue-label: ad-workload

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

Arguably, IETF Area Directors are overloaded with document review duties. This document surveys the relevant background, discusses the implications, and makes a proposal for improvements.

--- middle


# Introduction

The job of an IETF Area Director is notoriously difficult. Beyond the impact on the individual, this reputation is widely thought to reduce the pool of potential candidates for the position, resulting in a lack of diversity, vulnerability to failure to find a candidate, or the possibility of having to accept a poor candidate. See {{Section 2.6.2 of ?RFC3774}} for further discussion.

One of the key responsibilities of an Area Director is reviewing each document that comes to the IESG for publication. Although Area Directors do much more than simply review documents, the sheer volume of pages that the IETF publishes makes this a significant component of the job, in terms of both their time and attention.

{{background}} surveys relevant background materials. {{discussion}} discusses the requirements for document review in the IETF process, and {{proposal}} makes a proposal to modify the Area Director's role in it, in order to make it possible for more people to consider putting their hands up to fill the position.


# Background {#background}

The responsibility of an Area Director to review all documents being considered for publication originates in {{Section 6.1.2 of ?RFC2026}}, which describes the responsibilities of the IESG when reviewing a specification for approval:

> The IESG shall determine whether or not a specification submitted to
   it according to section 6.1.1 satisfies the applicable criteria for
   the recommended action (see sections 4.1 and 4.2), and shall in
   addition determine whether or not the technical quality and clarity
   of the specification is consistent with that expected for the
   maturity level to which the specification is recommended.

The criteria referred to regard the maturity of the document as indicated by its stability, its resolution of design choices, level of community review, implementation and operational experience.

{{Section 5 of ?RFC3710}} states that:

> The IESG is expected to ensure that the documents are of a sufficient
   quality for release as RFCs, that they describe their subject matter
   well, and that there are no outstanding engineering issues that
   should be addressed before publication.  The degree of review will
   vary with the intended status and perceived importance of the
   documents.

However, that document notes that "\[i]t does not claim to represent consensus of the IETF" but rather "was written as a 'documentation of existing practice'".

The IESG has created internal policies to ensure that this goal of sufficient review is achieved. The [IESG Ballot Procedures](https://www.ietf.org/standards/process/iesg-ballots/) document describes the system used. Notably, the description of the "No Objection" position includes this statement:

> This ballot position may be interpreted as "This is outside my area of expertise or have no cycles", in that you exercise the ability to move a document forward on the basis of trust towards the other ADs.

This language implies that Area Directors need not read every page of every document; it is an "escape clause" for an overloaded AD.

Expectations for document review are also set by the job descriptions used by the NOMCOM. The [General IESG Member Expertise](https://datatracker.ietf.org/nomcom/2022/expertise/) desired by the 2023 NOMCOM includes:

> An AD should be able to personally review every Internet-Draft that they sponsor. For other Internet-Drafts an AD needs to be satisfied that adequate review has taken place, though many ADs personally review these documents as well.

However, it later sets a more onerous expectation:

> Basic IESG activities can consume significant time during a typical non-meeting week. Enough time must be allocated to \[...] read on the order of 500 pages of internet-drafts every two weeks \[...]

... which implies that they should be reading every draft.


# Discussion {#discussion}

IESG document review undeniably serves an important function: maintaining the output quality of IETF specifications, by making Area Directors both responsible for document review and accountable to the community (through transparency mechanisms like the Open Mic session at plenaries, and ultimately through the risk of appeal and recall). This accountability and quality enhances the legitimacy of the IETF's work, and ultimately, its success.

However, the expectations for review are not clearly stated: while there are clear affordances in the IESG-internal policies and in the NOMCOM job description for an AD to skip a detailed review of the document, many IETF participants and Area Directors alike seem to believe that ADs have a fundamental responsibility to review every document published for any concerns they may have -- to "read on the order of 500 pages \[...] every two weeks."

These conflicting and ill-stated expectations arguably have the effect of discouraging many qualified candidates from applying for Area Director positions.

A solution should:

* align RFC-specified requirements, IESG policy, and community expectations
* maintain (or improve) the output quality of the IETF stream
* reduce the required workload for Area Directors in a meaningful way
* maintain the accountability relationships that enhance our output's legitimacy

These requirements rule out many potential solutions. For example, allowing Area Directors to delegate their reviews to Directorates would be seen to harm the accountability relationship, since the person reviewing the document would no longer be directly accountable to the community.

On the other hand, it is clear that Area Directors are not expected to be expert in every technology that crosses their doorstep; per the 2023 NOMCOM guidelines:

> An AD need not be the ultimate expert and authority in any technical area. The abilities to manage, to guide and judge consensus, to know who the subject-matter experts are and to seek their advice, and to mentor other IETF participants to take the technical lead is at least as important as their own technical abilities.

This implies that an Area Director might rely on others in their review responsibilities, but cannot avoid responsibility for them.

But what _is_ that responsibility, exactly? Clearly, they are not exercising only their own judgement; an Area Director who refused documents based only upon their personal beliefs would effectively be a tyrant.

This is supported by the materials. At their core, the desired criteria listed in {{Sections 4.1 and 4.2 of RFC2026}} are all fairly objective; for example:

> A Proposed Standard specification is generally stable, has resolved
   known design choices, is believed to be well-understood, has received
   significant community review, and appears to enjoy enough community
   interest to be considered valuable.

Any proposal, then, should also be focused on assuring these properties.

This document makes one proposal below, as a starting point for discussion; others might also meet these requirements.

# Proposal {#proposal}

To clarify the nature and role of Area Director reviews and thereby partially address workload issues as described in {{RFC3774}}, this document recommends that the policy described below be adopted, either as an IESG Statement or through IETF Consensus. Once that takes place, supporting material (such as the NOMCOM job descriptions) should be clarified and aligned with it.

## Policy

This policy sets the expectation that Area Directors are responsible for assuring that, from the perspective of their Area, documents being considered for publication on the IETF stream meet the requirements in {{Section 4 of RFC2026}}. This implies that an Area Director can ballot "No Objection" for a document that they judge to have no implications for their Area without further review. Furthermore, they need only review those portions of other documents that do have implications for their Area.

When reviewing a document, Area Directors may rely on expertise of others to judge the desired properties; they need not be expert in every technology in their Area. However, in doing so, they do not avoid responsibility for meeting the requirements stated in {{RFC2026}}, and they may be held accountable if those requirements are not met, from the perspective of their Area.

This policy does not prevent an Area Director from exceeding these expectations. However, Area Director reviews should be based in the requirements of {{RFC2026}}, as elaborated upon by the [DISCUSS Criteria](https://www.ietf.org/about/groups/iesg/statements/iesg-discuss-criteria/).


## Policy Discussion

This policy is not a very large change from current practice of at least some ADs, based upon discussions I've had. As such, its most important function is to level-set expectations between the community and the IESG.

Practically, this allows an AD to delegate their review (or partially do so) to someone that they judge as appropriate, based upon their expertise. However, they cannot avoid responsibility -- which means that delegating to a review directorate of volunteers may be unwise.

Overall, the expectation is that ADs should rely on other experts in their area more than they do the reviewing themselves. They are responsible to understand and manage any objections that come from experts they rely on, and are expected to decide the relative importance of actually requiring that any issue raised by such an expert be addressed, but they are expected to farm out their reviews more than they do it themselves.


# IANA Considerations

This document has no actions for IANA.

# Security Considerations

Undoubtedly changing how the IESG reviews documents has potential security implications. Caveat emptor.


--- back


# Acknowledgements

Thanks to Pete Resnick for his thoughts and a snippet of text.

