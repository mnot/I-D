---
title: Making Decisions in the IETF
abbrev:
docname: draft-nottnick-ietf-decisions-latest
date: {DATE}
category: bcp
updates: 2418

ipr: trust200902
keyword:
  - consensus
  - rough consensus
  - process
  - decision

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://projects.mnot.net/I-D/"
  repo: "https://github.com/mnot/I-D/labels/SHORT"

github-issue-label: ietf-decisions

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
 -
    ins: P. Resnick
    name: Pete Resnick
    organization:
    postal:
     - Urbana
    country: USA
    email: resnick@episteme.net
    uri: https://episteme.net/


--- abstract

This document specifies Best Current Practice for making decisions within the IETF process.

It updates {{Section 3.3 of ?RFC2418}}.

--- middle


# Introduction

The IETF guides its decisions with "rough consensus and running code." However, {{?BCP9}} does not explicitly define how consensus is achieved; it only highlights the importants of "broad" consensus.

{{Section 3.3 of ?RFC2418}} is more detailed:

    Working groups make decisions through a "rough consensus" process.
    IETF consensus does not require that all participants agree although
    this is, of course, preferred.  In general, the dominant view of the
    working group shall prevail.  (However, it must be noted that
    "dominance" is not to be determined on the basis of volume or
    persistence, but rather a more general sense of agreement.) Consensus
    can be determined by a show of hands, humming, or any other means on
    which the WG agrees (by rough consensus, of course).  Note that 51%
    of the working group does not qualify as "rough consensus" and 99% is
    better than rough.  It is up to the Chair to determine if rough
    consensus has been reached.

While this guidance has served the IETF well for more than thirty years, the IETF community has grown, and the decisions we make are more relevant than ever to society. To help both participants and those who use our standards understand our process, this document outlines the procedures we use to make decisions in more detail. It is not intended to establish new policy, only articulate existing practices more carefully.

{{principles}} outlines the principles that guide the rest of this document. {{consensus}} provides guidelines for making decisions that require consensus; {{non-consensus}} notes the kinds of decisions that do not require consensus.

## Principles {#principles}

This section establishes the principles for decision making at the IETF.

The openness of the IETF has significant influence on our decision-making process. Because we have no concept of membership and anyone can participate, decision making by voting is inappropriate -- it would make our processes vulnerable to rule by majority and vote stuffing.

Instead, we use a consensus process, described in {{consensus}}. This assures that viewpoints are heard and considered. This is not a representative process: the IETF's legitimacy rests upon its expertise and the success of its output, rather than representative input.

As a result, the number of people supporting or objecting on any given issue is not essential to the decision of whether rough consensus exists. While a significant number of people stating objections may give a consensus caller pause regarding whether a particular issue has achieved rough consensus, the objection must still be evaluated on its merits to determine whether it has been addressed by the remainder of the group. Conversely, while a very small number of people, or even a single person, objecting might point toward rough consensus being achieved, any outstanding objection still needs to be addressed.

Our work must also conclude. We use "rough consensus" because requiring unanimity would allow any single objection to stop the work. An outstanding objection is not sufficient on its own to show lack of rough consensus. If the objection has been heard, understood, and addressed (even if not accommodated), rough consensus can still be declared.

We do not recognise authorities. An objection is not accepted merely on the basis of the title or purported expertise of the person(s) making it. This is especially true of an objection put forward by the consensus caller themself. The objection must stand or fall on its own merits. Certainly a consensus caller may be inclined to exercise more diligence if someone with relevant expertise has made the objection, but that is no substitute for actually making the judgement of whether the objection has been heard, understood, and addressed.

We do not allow ballot stuffing. As a corollary to the above, even an overwhelming majority of voices simply stating an objection does not necessarily indicate a lack of consensus. If the people making those objections are not making a coherent claim, cannot explain the reasoning behind their objections, or cannot explain why the answers to their objections are valid after given answers by the rest of the group, such objections can be dismissed on the merits.

## Notational Conventions

{::boilerplate bcp14-tagged}

This document uses the term "consensus caller" to indicate the person(s) making the determination of consensus. In Working Groups, this will be the Chair(s).

# Consensus Decisions {#consensus}

Decisions that require rough consensus MUST fulfil these requirements, as expanded upon in the following subsections:

0. The decision is within the authority of the body
1. The outcome has sufficient support
2. Any objections have been handled

Only the consensus caller can determine consensus; participants cannot declare consensus, and should avoid attempting to characterise consensus before it is established.

Working Groups are required to establish rough consensus to progress a document in the process. Some groups only formally declare consensus on a document's content with a Working Group Last Call; others make calls for consensus on selected decisions to establish agreement on parts of the design earlier in the process.

Consensus callers can informally determine consensus -- i.e., characterise the consensus of a group without a formal call or determination -- but this is necessarily more open to contestation than formally determined consensus.

Once rough consensus is established and documented, it can only be reconsidered if genuinely new information becomes available. The consensus caller determines whether this bar is met; like other decisions, that determination is appealable.

To avoid confusion, make our process and the status of decisions legible to newcomers, and facilitate review, groups SHOULD maintain a record of decisions, including characterisation of support and any objections indicating the disposition of their handling. This might be in e-mail, a publicly available document, or an issues list.

## Assuring Authority

All decisions MUST be within the authority of the body making them. For Working Groups, this means that they are required to be within the declared scope of the group's charter.

This does not mean that a charter needs to enumerate all questions that a group makes decisions upon; assuring authority is a necessarily interpretive act. When there is a dispute about the authority to make a given decision, the consensus caller will make a determination. Like all decisions, this is appealable.

## Determining Support

All decisions MUST demonstrate substantial support within the group for the outcome.

How support is determined is contextual. For uncontroversial topics that are uninteresting to many participants, expressed support may be sparse. Conversely, controversial topics may attract both strong support and opposition.

There is no exact proportion of the group that is required to demonstrate support in order for a proposal to be successful, because determining support is not a voting process.

If a significant number participants indicate support for a proposal and there are no objections, there is clearly support for that proposal. Here "significant" is contextual -- the consensus caller needs to consider how many participants have been active in the discussion, how long they have had to consider the proposal, and how likely objections are.

If a small number of partipants indicate support for a proposal and there are no objections,
support may be present, but the consensus caller should consider its strength. Depending on the nature of the decision, more time or another call for consensus may be necessary. Again, "small" is contextual and requires interpretation by the consensus caller.

If support is indicated for a proposal but there are objections, those objections need to be handled according to {{handling}}. These two evaluations are iterative, not sequential. Addressing an objection often alters the proposal, which then needs to be re-checked for support; a revised proposal may attract fresh objections. The consensus caller repeats both assessments until the proposal has substantial support with all objections handled.

When determining support for a technical proposal, a consensus caller MAY give weight to interest by implementers or potential implementers, or lack thereof.

Authority is also bounded by decisions already settled at a broader level. The IETF reaches consensus on matters that apply across its work — architectural principles, and positions such as the treatment of pervasive monitoring as an attack {{?BCP188}}. Where such a decision applies, a group cannot set it aside by reaching its own local consensus; the broader decision is not within the group's authority to overturn. A group may apply a settled principle to its particular circumstances, and may surface genuinely new information that bears on it (which is grounds to revisit the broader decision through the appropriate body, not to depart from it locally). But local consensus does not override wider consensus.

## Handling Objections {#handling}

Objections to a proposal are first considered by the consensus caller. Trivial and off-topic objections can be discarded outright. Objections that have already been handled can be satisfied by a reference to the previously handled objection, so long as they are comparable.

Substantial and new objections need to be understood fully by the group. This puts a burden on the party making the objection to explain its nature and relevance, and on the group to appreciate and consider it. Successful objection handling is characterised by dialogue and introspection by all parties, with the goal of achieving a consensus that produces the best outcome for the Internet's users.

If an objection nevertheless persists after full consideration, the consensus caller should make a determination of its disposition.

A persistent objection has one of two dispositions. It is upheld when the consensus caller finds it coherent and on the merits, and not addressed by the group. An upheld objection means rough consensus has not been reached for the proposal as it stands; the proposal must be revised, the objection otherwise addressed, or the decision deferred.

It is discounted when, after full consideration, the consensus caller finds it does not bear on the merits — for instance, it is incoherent, cannot be explained by the person raising it, restates an already-handled objection without new grounds, or has been answered by the group without substantive reply. A discounted objection does not prevent a finding of rough consensus.
The consensus caller records the disposition and its basis. Either determination can be appealed."

As with other aspects of decision making in the IETF, objection handling can be appealed; see {{Section 6.5 of RFC2026}}.

# Non-Consensus Decisions {#non-consensus}

Some IETF decisions do not require a consensus process. In general, these can be characterised as administrative decisions that often have other established procedural requirements.

For example, a Working Group chair does not need to establish consensus to adopt a draft as a work item, because that would necessitate going through the full process in {{consensus}} for the draft's content, effectively making it ready for publication.

Likewise, establishing the time and location of an interim meeting does not require consensus, as doing so would introduce unreasonable overhead and endanger the group's work.

Many decisions are characterised as "editorial" -- that is, they are about how a design is documented, encompassing style, phrasing, organisation of the document and similar issues. Subjecting such decisions to the consensus process is not a good use of the group's time.

Not requiring consensus does not mean that these decisions can be made unilaterally or without consultation. Adopting a draft that has little chance of gaining consensus is a waste of the group's time, and a meeting scheduled at a time or place that makes it impossible for contributors to attend is unlikely to be productive. In some cases, editorial decisions do have impact on adoption and implementation (for example, naming of protocol elements). Objections to these decisions SHOULD be considered, but need not be handled according to the consensus process. Instead, we rely upon other checks and balances to assure good outcomes.

Specifically, non-consensus decisions can also be appealed (see {{Section 6.5 of RFC2026}}); however, lack of consensus is not a valid basis.

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

The consensus process is critical to Internet security overall -- it helps to assure that the protocols we build provide the properties that end users rely upon are present.

--- back

