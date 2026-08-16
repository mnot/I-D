---
title: Making Decisions in IETF Working Groups
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
  repo: "https://github.com/mnot/I-D/labels/ietf-decisions"

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

This document specifies Best Current Practice for making decisions in IETF Working Groups.

It updates {{Section 3.3 of ?RFC2418}}.

--- middle


# Introduction

The IETF guides its decisions with "rough consensus and running code." However, {{?BCP9}} does not explicitly define how that consensus is achieved; it only highlights the importance of "broad" consensus.

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

While this guidance has served the IETF well for more than thirty years, the IETF community has grown, and our decisions increasingly affect people who do not participate in them. To help both participants and those who use our standards understand our process, this document outlines the procedures we use to make Working Group decisions in more detail. It is not intended to establish new policy, only articulate existing practices more carefully.

This document replaces {{Section 3.3 of ?RFC2418}}. Most of that text remains accurate. Three aspects of it, however, are not carried forward: practice has diverged from them, and they have proven misleading. Consensus is not determined by the "dominant view" prevailing; objections are disposed of on their merits, and the number of participants holding a view is not what settles the question. A show of hands, a hum, or a poll does not determine consensus; such mechanisms gauge support, which is one input to a determination made by the consensus caller (see {{support}}). And no proportion of the group -- neither 51% nor 99% -- establishes or fails to establish rough consensus, because it is not a vote.

{{principles}} outlines the principles that guide the rest of this document. {{consensus}} provides guidelines for making decisions that require consensus; {{non-consensus}} notes the kinds of decisions that do not require consensus.

This document describes decision making in Working Groups. It does not describe how the IESG or the IAB make decisions; those bodies have their own documented procedures (see {{?BCP39}} and {{?RFC3710}}).

## Principles {#principles}

This section establishes the principles for decision making at the IETF.

The openness of the IETF has significant influence on our decision-making process. Because we have no concept of membership and anyone can participate, decision making by voting is inappropriate -- it would make our processes vulnerable to rule by majority and vote stuffing.

Instead, we use a consensus process, described in {{consensus}}. This assures that viewpoints are heard and considered. This is not a representative process: the IETF's legitimacy rests upon its expertise and the success of its output, rather than representative input.

As a result, the number of people supporting or objecting on any given issue is not essential to the decision of whether rough consensus exists. While a significant number of people stating objections may give a consensus caller pause regarding whether a particular issue has achieved rough consensus, the objection must still be evaluated on its merits to determine whether it has been addressed by the remainder of the group. Conversely, while a very small number of people, or even a single person, objecting might point toward rough consensus being achieved, any outstanding objection still needs to be addressed.

Our work must also conclude. We use "rough consensus" because requiring unanimity would allow any single objection to stop the work. An outstanding objection is not sufficient on its own to show lack of rough consensus. If the objection has been heard, understood, and addressed (even if not accommodated), rough consensus can still be declared.

We do not recognise authorities. An objection is not accepted merely on the basis of the title or purported expertise of the person(s) making it. This is especially true of an objection put forward by the consensus caller themself. The objection must stand or fall on its own merits. Certainly a consensus caller may be inclined to exercise more diligence if someone with relevant expertise has made the objection, but that is no substitute for actually making the judgement of whether the objection has been heard, understood, and addressed.

We do not weigh the person. Participation is open and participants act as individuals, so a person's history with the group, their affiliation, and their reputation are not inputs to a determination. What is evaluated is what was said, not who said it.

We do not allow ballot stuffing. Volume does not decide in either direction: a large number of voices simply stating an objection does not establish a lack of consensus, and a large number simply stating support does not establish its presence. In both cases the consensus caller weighs what was said, not how many said it. Where the people objecting are not making a coherent claim, cannot explain the reasoning behind their objections, or cannot explain why the group's answers to them are inadequate, those objections can be dismissed on the merits.

We assume good faith. The process requires participants to state the reasons they actually hold, to consider the answers they are given, and to be open to persuasion; it works because most people do this. Someone participating strategically -- objecting to delay a decision, or restating a position without engaging with the response to it -- can stall a group indefinitely.

The remedy is not to diagnose motive. An accusation of bad faith is rarely provable, and treating a sincere objection as insincere denies the objector the consideration this process exists to provide. The mechanisms here address the conduct without requiring a judgement about what lies behind it: an objection whose basis cannot be explained, or that does not engage with the group's answers, can be dismissed on the merits regardless of why it was raised (see {{handling}}), and a failed call cannot be made into consensus by repetition (see {{consensus}}).

Where the problem is a participant's conduct rather than any particular objection, it is not a matter for the consensus process; see {{?BCP54}}.

## Notational Conventions

{::boilerplate bcp14-tagged}

This document uses the term "consensus caller" to indicate the person(s) making the determination of consensus. In Working Groups, this will be the Chair(s).

Following {{?RFC7282}}, this document distinguishes between an objection being *addressed* and being *accommodated*. An objection is accommodated when the proposal is changed to satisfy it. An objection is addressed when it has been heard, understood, and disposed of without blocking the decision, whether or not the proposal changes as a result; {{handling}} sets out the ways this can occur. Rough consensus requires that objections be addressed; it does not require that they be accommodated.

# Consensus Decisions {#consensus}

Decisions that require rough consensus MUST fulfil these requirements, as expanded upon in the following subsections:

0. The decision is within the authority of the body
1. The outcome has sufficient support
2. Any objections have been addressed

Only the consensus caller can determine consensus; participants cannot declare consensus, and should not characterise it before it is established.

Working Groups are required to establish rough consensus to progress a document in the process. Some groups only formally declare consensus on a document's content with a Working Group Last Call; others make calls for consensus on selected decisions to establish agreement on parts of the design earlier in the process.

Consensus callers can make an informal determination -- i.e., characterise the consensus of a group without a formal call -- but this is necessarily more open to contestation than a formal declaration.

To avoid confusion, make our process and the status of decisions legible to newcomers, and facilitate review, groups MUST record their consensus decisions; see {{communicating}}. A failure to record a decision does not by itself invalidate it; the remedy is to produce the record.

Once rough consensus is established and documented, it can only be reconsidered if genuinely new information becomes available. The consensus caller determines whether this bar is met; like other decisions, that determination is appealable.

A call that does not establish consensus does not settle the question, and the consensus caller may make a further call. There are good reasons to do so: the proposal may have changed, more time may be needed, or a heated discussion may benefit from a pause. What a further call cannot do is establish consensus by attrition. Where the objections are unchanged and unaddressed, repeating the call does not address them.

Deferring a decision is a legitimate outcome, and sometimes the right one -- where a revised proposal, further background work, or more time to consider the options would change the discussion.

## Assuring Authority {#authority}

All consensus decisions MUST be within the authority of the body making them. For Working Groups, this means that they are required to be within the declared scope of the group's charter.

This does not mean that a charter needs to enumerate all questions that a group makes decisions upon; assuring authority is a necessarily interpretive act. When there is a dispute about the authority to make a given decision, the consensus caller will make a determination. Like all decisions, this is appealable.

Authority is also bounded by decisions already settled at a broader level. The IETF reaches consensus on matters that apply across its work -- architectural principles, and positions such as the treatment of pervasive monitoring as an attack {{?BCP188}}. Where such a decision applies, a group cannot set it aside by reaching its own local consensus; the broader decision is not within the group's authority to overturn. A group may apply a settled principle to its particular circumstances, and may raise genuinely new information that bears on it (which is grounds to revisit the broader decision through the appropriate body, not to depart from it locally). But local consensus does not override wider consensus.

Whether a broader decision applies at all is a separate question, and one the group can legitimately decide. For example, {{?BCP41}} gives strong guidance about congestion control, but a group might determine that the only environment its protocol can be deployed in is one where that guidance does not apply. Such a determination is itself a decision subject to this document: the reasoning for it needs to be stated explicitly and recorded, and like any other decision it is open to objection and appeal. A determination of this kind usually rests on an assumption about the environment the protocol will be deployed in, and such assumptions have often proven wrong over time. Such determinations warrant caution.

## Determining Support {#support}

All consensus decisions MUST demonstrate substantial support within the group for the outcome.

How support is determined is contextual. For uncontroversial topics that are uninteresting to many participants, expressed support may be sparse. Conversely, controversial topics may attract both strong support and opposition.

Often, the group will have two (or more) competing proposals under consideration. When this happens, relative support can be determined through mechanisms like polls.

If a significant number of participants indicate support for a proposal and there are no objections, there is clearly support for that proposal. Here "significant" is contextual -- the consensus caller needs to consider how many participants have been active in the discussion, how long they have had to consider the proposal, and how likely objections are.

If a small number of participants indicate support for a proposal and there are no objections, support may be present, but the consensus caller should consider its strength. Depending on the nature of the decision, more time or another call for consensus may be necessary. Again, "small" is contextual and requires interpretation by the consensus caller.

If a proposal is determined to have support but there are objections, those objections need to be addressed according to {{handling}}. These two evaluations are iterative, not sequential. Addressing an objection often alters the proposal, which then needs to be re-checked for support; a revised proposal may attract fresh objections. The consensus caller repeats both assessments until the proposal has substantial support with all objections addressed.

When determining support for a technical proposal, a consensus caller MAY give weight to interest by implementers or potential implementers, or lack thereof. This is evidence about whether the proposal will be deployed, not standing given to the people expressing it.


## Addressing Objections {#handling}

Most feedback on a proposal is handled by the document's editor(s). Feedback becomes an objection when it is raised against a decision and maintained after the group and the editors have responded to it; only then does it require disposition by the consensus caller.

An objection to a decision is disposed of when:

1. The consensus caller declares it to be invalid
2. The objection is removed by a negotiated resolution
3. The consensus caller upholds the objection
4. The consensus caller rejects the objection
5. The consensus caller finds it outweighed

Except where the objection is upheld, all of these mean that the objection has been addressed, and so do not prevent a finding of rough consensus.

An objection might be invalid if it is trivial, nonsensical, poorly described, off-topic, purely editorial, out of charter, or already addressed. Invalid objections do not prevent a finding of rough consensus.

Provided they are not invalid, objections need to be understood fully by the group. This puts a burden on the party making the objection to explain its nature and relevance, and on the group to appreciate and consider it. Successfully addressing an objection is characterised by dialogue and introspection by all parties, with the goal of achieving a consensus that produces the best outcome for the Internet's users.

Consensus callers manage the discussion; they can ask that a well-worn argument not be repeated, or that a call for consensus collect positions rather than restart the debate. Doing so does not dispose of any objection -- only the outcomes listed above do that.

Once an objection is understood and has been discussed by the group, the consensus caller weighs the arguments.

The best outcome is one that is, after discussion, palatable to all; often, this is determined through polls that ask if participants "can live with" that outcome. When successful, this removes the objection, but the consensus caller is still required to determine a sufficient level of support for that resolution; see {{support}}.

If such an outcome cannot be negotiated in a reasonable timeframe, the consensus caller will determine if the objection is upheld, rejected, or outweighed. This determination is made on the merits of the objection; how many people support an objection is not relevant.

Arguments that rely on already established IETF consensus (as recorded in IETF stream RFCs) will be substantiated, if necessary by consulting the IESG. Per {{authority}}, objections to decisions that are determined to contradict IETF consensus will be upheld.

An upheld objection means rough consensus has not been reached for the proposal as it stands; the proposal must be revised, the objection otherwise addressed, or the decision deferred.

An objection is rejected when, after full consideration by the group, the consensus caller finds it does not bear on the merits. A rejected objection does not prevent a finding of rough consensus.

An objection is outweighed when the consensus caller finds that it identifies a genuine problem, but that accommodating it would cause greater harm than leaving it unaccommodated -- because the alternatives have worse weaknesses of their own, or because no alternative has been identified. This arises where a decision involves a trade-off and every available option attracts well-founded objections; see {{tradeoffs}}. An outweighed objection does not prevent a finding of rough consensus, but the consensus caller needs to be satisfied that the group weighed it against the alternatives.

As with other aspects of decision making in the IETF, how an objection is addressed can be appealed; see {{Section 6.5 of RFC2026}}.

## Deciding Trade-offs {#tradeoffs}

Some consensus decisions have no option that is free of well-founded objections. Upholding every such objection would prevent the group from deciding anything. Here the consensus caller needs to weigh the options against each other.

Evaluating a trade-off requires being concrete about who is affected and how. Use cases are the usual vehicle for this: they make the consequences of each option explicit, and an objection that cannot be tied to any use case is difficult to weigh. An objection is not weakened by raising a use case that the group had not previously considered; the group should determine whether that use case is within its scope, and if it is, weigh it alongside the others.

The alternatives to be weighed always include leaving the disputed element out and deferring the decision.

Options are not compared by counting use cases, because use cases do not carry equal weight. {{?RFC8890}} counsels that where interests conflict, those of end users be given priority. In general, a group should prefer an option under which every use case in scope can achieve a useful -- even if not optimal -- result, over one that serves some optimally while leaving others severely harmed.

The resulting document SHOULD describe the trade-off that was made and the reasoning behind it.

## Communicating Decisions {#communicating}

When declaring the outcome of a consensus call, the consensus caller SHOULD explain how the determination was reached. In simple cases this can be very brief. Where the decision was contested or involved a trade-off, a useful declaration includes:

* what was decided, stated precisely enough to act upon;
* the significant objections raised and their disposition;
* the options considered and the trade-offs between them, including the use cases weighed against each other;
* what would constitute grounds to revisit the decision, if that is not obvious.

The more contested a decision, the more its declaration needs to explain itself. A good explanation allows those who disagree to see that their objections were weighed rather than counted.

Consensus decisions can be recorded in e-mail, a publicly available document, or an issues list. Such a record need not be formal, but the consensus caller remains responsible for being able to cite their determinations.


# Non-Consensus Decisions {#non-consensus}

Some IETF decisions do not require a consensus process. In general, these can be characterised as administrative decisions that often have other established procedural requirements.

For example, a Working Group chair does not need to establish consensus to adopt a draft as a work item, because that would require the full process in {{consensus}} for the draft's content, effectively making it ready for publication.

Likewise, establishing the time and location of an interim meeting does not require consensus, as doing so would introduce unreasonable overhead and endanger the group's work.

Many decisions are characterised as "editorial" -- that is, they are about how a design is documented, encompassing style, phrasing, organisation of the document and similar issues. Subjecting such decisions to the consensus process is not a good use of the group's time.

Deciding the names of protocol elements can become contentious, but making them consensus decisions is rarely a good use of a group's time. Usually, they are best treated as editorial decisions taken with consultation.

Decisions that do not require consensus still cannot be made unilaterally or without consultation. Adopting a draft that has little chance of gaining consensus is a waste of the group's time, and a meeting scheduled at a time or place that makes it impossible for contributors to attend is unlikely to be productive.

In some cases, editorial decisions do have impact on adoption and implementation. Objections to these decisions SHOULD be considered, but need not be addressed according to the consensus process.

Specifically, non-consensus decisions can also be appealed (see {{Section 6.5 of RFC2026}}); however, lack of consensus is not a valid basis.

# IANA Considerations

This document has no considerations for IANA.

# Security Considerations

The consensus process is critical to Internet security overall -- it helps assure that the protocols we build have the properties end users rely upon.

--- back

