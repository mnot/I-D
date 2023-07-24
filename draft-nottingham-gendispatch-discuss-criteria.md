---
title: DISCUSS Criteria
abbrev:
docname: draft-nottingham-gendispatch-discuss-criteria-latest
date: {DATE}
category: bcp
updates: 2026

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/discuss-criteria"

github-issue-label: discuss-criteria

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

This document describes the role of the 'DISCUSS' position in the IESG review process. It gives some guidance on when a DISCUSS should and should not be issued. It also discusses procedures for DISCUSS resolution.

--- note_Note_to_Readers

This document is currently a copy of the DISCUSS criteria published at <https://www.ietf.org/about/groups/iesg/statements/iesg-discuss-criteria/>; the only changes are to the material in the Introduction regarding the status of the document.

As such, it serves as a proposal: to put control over the criteria that the IESG uses to evaluate documents in the hands of the IETF community.

Because the balloting system is not defined by RFC, an unresolved issue is how that should be referred to. Two possible options are a) also publishing it a BCP, or b) abstracting this document to talk about the general criteria that the IESG can use to hold up publication of a document, without using the 'DISCUSS' terminology.

--- middle

# Introduction

The Internet Engineering Steering Group (IESG) is responsible for the final review of IETF documents. Members of the IESG have the option, when they review a document, of stating a 'DISCUSS' position. The DISCUSS identifies one or more issues that must be discussed in relation to the document before the document can become an RFC. As such, 'DISCUSS' is a blocking position; the document cannot proceed until any issues are resolved to the satisfaction of the Area Director who issued the DISCUSS. For cases where the reasoning for an unresolved DISCUSS does not reflect the consensus of the IESG, override procedures can be invoked to unblock documents.

The criteria set forward in this document are intended to serve two purposes: to educate and to improve consistency. When new members join the IESG, it might not be immediately clear when it is appropriate to issue a DISCUSS and when a non-blocking comment should be preferred. Even among the standing IESG (at the time this document was written), it is clear that different Area Directors use different criteria for issuing a DISCUSS. While this is not innately problematic, greater consistency in evaluating the severity of an issue would reduce unnecessary document delays and blockages.

This document approaches IESG review of Proposed Standard documents as a review of "last resort". Most such documents reviewed by the IESG are produced and reviewed in the context of IETF working groups. In those cases, the IESG cannot overrule working group consensus without good reason; informed community consensus should prevail.

These criteria are not intended to constrain the IESG from issuing DISCUSSes on documents that are genuinely problematic, but rather to set reasonable expectation among the IESG and the community about the propriety of and justification for blocking IETF documents.


# Document Classes Reviewed by the IESG

The IESG reviews several classes of document, and applies different criteria to each of these document types. The exemplary questions that follow appear on each IESG agenda to remind the Area Directors of the appropriate level of review for these classes:

Protocol Actions:
: "Is this document a reasonable basis on which to build the salient part of the Internet infrastructure? If not, what changes would make it so?"

Document Actions (WG):
: "Is this document a reasonable contribution to the area of Internet engineering which it covers? If not, what changes would make it so?"

Document Actions (Individual):
: "Is this document a reasonable contribution to the area of Internet engineering which it covers? If not, what changes would make it so?"

Document Actions (from RFC-Editor):
: "Does this document represent an end run around the IETF's working groups or its procedures? Does this document present an incompatible change to IETF technologies as if it were compatible?"

Of these document classes, the fundamental distinction between "Protocol Actions" and "Document Actions" involves the relation of these documents to the IETF Standards Track. Only Standards Track and Best Common Practice documents are considered for "Protocol Action"; Informational and Experimental documents are considered for "Document Action".

Protocol Actions are naturally subject to greater scrutiny than Document Actions; Area Directors are not even required to state a position on a Document Action (the default being "No Objection"). Accordingly, the exact criteria used to evaluate Protocol Actions would benefit from greater scrutiny. The remainder of this document focuses on the use of DISCUSS for standards-track and BCP documents.

# Protocol Action Criteria

## DISCUSS Criteria {#DISCUSS}

The following are legitimate reasons that an Area Director might state a DISCUSS position on a Protocol Action. This cannot be an exhaustive list, but this set should be taken as exemplary of the common causes for DISCUSSes seen by the IESG in the past.

* The specification is impossible to implement due to technical or clarity issues.
* The protocol has technical flaws that will prevent it from working properly, or the description is unclear in such a way that the reader cannot understand it without ambiguity.
* It is unlikely that multiple implementations of the specification would interoperate, usually due to vagueness or incomplete specification.
* Widespread deployment would be damaging to the Internet or an enterprise network for reasons of congestion control, scalability, or the like.
* The specification would create serious security holes, or the described protocol has self-defeating security vulnerabilities (e.g. a protocol that cannot fulfill its purpose without security properties it does not provide).
* It would present serious operational issues in widespread deployment, by for example neglecting network management or configuration entirely.
* Failure to conform with IAB architecture (e.g., {{?RFC1958}}, or {{?RFC3424}}) in the absence of any satisfactory text explaining this architectural decision.
* The specification was not properly vetted against the I-D Checklist. Symptoms include broken ABNF or XML, missing Security Considerations, and so on.
* The draft omits a normative reference necessary for its implementation, or cites such a reference merely informatively rather than normatively.
* The document does not meet criteria for advancement in its designated standards track, for example because it is a document going to Full Standard that contains 'down references' to RFCs at a lower position in the standards track, or a Standards Track document that contains only informational guidance.
* IETF process related to document advancement was not carried out; e.g., there are unresolved and substantive Last Call comments which the document does not address, the document is outside the scope of the charter of the WG which requested its publication, and so on.
* The IETF as a whole does not have consensus on the technical approach or document. There are cases where individual working groups or areas have forged rough consensus around a technical approach which does not garner IETF consensus. An AD may DISCUSS a document where she or he believes this to be the case. While the Area Director should describe the technical area where consensus is flawed, the focus of the DISCUSS and its resolution should be on how to forge a cross-IETF consensus.

## DISCUSS Non-Criteria {#NON-DISCUSS}

* Disagreement with informed WG decisions that do not exhibit problems outlined in {{DISCUSS}}. In other words, disagreement in preferences among technically sound approaches.
* Reiteration of the issues that have been raised and discussed as part of WG or IETF Last Call, unless the AD believes they have not been properly addressed.
* Pedantic corrections to non-normative text. Oftentimes, poor phrasing or misunderstandings in descriptive text are corrected during IESG review. However, if these corrections are not essential to the implementation of the specification, these should not be blocking comments.
* Stylistic issues of any kind. The IESG are welcome to copy-edit as a non-blocking comment, but this should not obstruct document processing.
* The motivation for a particular feature of a protocol is not clear enough. At the IESG review stage, protocols should not be blocked because they provide capabilities beyond what seems necessary to acquit their responsibilities.
* There are additional, purely informational references that might be added to the document, such as pointers to academic papers or new work. Although the cross-area perspective of the IESG invites connections and comparison between disparate work in the IETF, IESG review is not the appropriate time to append external sources to the document.
* The document fails to cite a particular non-normative reference. This is an appropriate non-blocking comment, but not a blocking comment.
* Unfiltered external party reviews. While an AD is welcome to consult with external parties, the AD is expected to evaluate, to understand and to concur with issues raised by external parties. Blindly cut-and-pasting an external party review into a DISCUSS is inappropriate if the AD is unable to defend or substantiate the issues raised in the review.
* New issues with unchanged text in documents previously reviewed by the AD in question. Review is potentially an endless process; the same eyes looking at the same document several times over the course of years might uncover completely different issues every time.
* "IOU" DISCUSS. Stating "I think there's something wrong here, and I'll tell you what it is later" is not appropriate for a DISCUSS; in that case, the AD should state the position DEFER (or, if the document has already been DEFERed once, "No Objection").
* When an extension or minor update is made to an existing protocol that has unaddressed issues, it would not be appropriate to hold a DISCUSS on that document demanding that the problem in the base protocol specification be addressed; rather, the way to address problems of this sort is to update the base protocol specification. For example, a lack of consideration for pervasive monitoring in an existing specification would not justify holding a DISCUSS on the extension or minor update.

## Saying No to A Document

In some cases an AD may believe that a document has fundamental flaws that cannot be fixed. Normally in such cases the AD will write up a description of these flaws and enter an "Abstain" position on the ballot. Such a position does not support publication of the document but also does not block the rest of the IESG from approving the document. Normally, entering an Abstain position is a sufficient mechanism for an AD to voice his or her objections.

However, there may be cases where an AD believes that the mechanisms described in a document may cause significant damage to the Internet and/or that the mechanisms described in a document are sufficiently incompatible with the Internet architecture that a document must not be published, despite the fact that the document is within scope for the WG and represents WG consensus. This situation should be extremely rare, and an AD should not take this position lightly, but this does represent an important cross-area "back-stop" function of the IESG.

In this situation, the AD will enter a "DISCUSS" position on the ballot and explain his or her position as clearly as possible in the tracker. The AD should also be willing to explain his or her position to the other ADs and to the WG.

It is possible in such a situation that the WG will understand the AD's objections and choose to withdraw the document, perhaps to consider alternatives, and the situation will be resolved.

Another possibility is that the WG will disagree with the AD, and will continue to request publication of the document. In those cases the responsible AD should work with both the WG and the AD holding the DISCUSS to see of a mutually agreeable path can be found.

# DISCUSS Resolution

The traditional method of DISCUSS resolution is the initiation of a discussion about the issues in question. This discussion may include only the IESG, particularly if the DISCUSS is resolved quickly during or following the IESG agenda when the document is presented. Usually the discussion extends to document editors and working group chairs, and entire working groups, as necessary. Increasingly, one of the working group chairs may coordinate the resolution of the DISCUSS (see {{?RFC4858}}).

As the conclusion of this discussion, revisions to the document may or may not be required. If revisions are required, it is customary for the Area Director to clear their DISCUSS only when the revision containing the necessary emendations has been published in the Internet-Drafts repository.

While in many cases, DISCUSSes are resolved expeditiously, there are common cases where a DISCUSS can take weeks or months to resolve, given that revisions are frequently required, and such revisions need to be checked by the AD that issued the DISCUSS. Accordingly, DISCUSSes should be used sparingly.

If a DISCUSS cannot be resolved by the working group, and the AD continues to hold his or her DISCUSS, the IESG has an alternative balloting procedure that can be used to override a single discuss position. In the alternative procedure, all ADs are required to enter a "yes" or "no" position on the document. A document will be published if two-thirds of the IESG state a position of "yes", and no more than two ADs state a "no" position. Two-thirds of the IESG is formally defined as two-thirds of the sitting ADs (current 9), except for those who are recused from voting on the document in question, rounded up to the next whole number. If three or more ADs hold a "no" position on a document using the alternative balloting procedure, or if a document fails to gather the required number of "yes" positions, the document will be returned to the WG with a "no" answer, which is one of the options described in RFC 2026.

When an AD is replaced for any reason, the successor should promptly evaluate DISCUSS ballots left by his or her predecessor, and either re-assert them, if they still meet the criteria of Section 3.1, or register "No Objection" if they do not. The successor AD is responsible for handling such DISCUSS ballots just as if they were his or her own.

The criteria provided in this document are intended to help the IESG to restrict the usage of a DISCUSS to cases where it is necessary.

# IANA Considerations

This document contains no considerations for the IANA.

# Security Considerations

This is a procedural document without security implications. However, the ability of the IESG to review the security properties of the submitted protocol specifications, point out and help resolve security flaws in them is vital for Internet security.

--- back

