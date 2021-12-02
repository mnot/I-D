---
title: Scheduling Online Meetings
abbrev:
docname: draft-nottingham-scheduling-online-meetings-latest
date: {DATE}
category: bcp

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/scheduling-online-meetings"

github-issue-label: scheduling-online-meetings

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
      - VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:


informative:


--- abstract

This document recommends best practices when scheduling online meetings.


--- middle

# Introduction

The Internet has made it possible for many people to meet synchronously online, no matter where they are, so long as they have suitable connectivity. Online meetings thus enable collaboration without travel, empowering those who cannot attend an in-person meeting, either because they do not have the means, or because external circumstances (like a global pandemic) prevents it.

However, the ease with which a meeting can be scheduled belies the difficulties that can be encountered when attempting to include a broad selection of people with different commitments, timezones, and expectations. Successfully scheduling an online meeting often requires a delicate balance between accommodating a large set of constraints with the need to make progress.

This document recommends best practices when scheduling online meetings. It does not address the many other issues encountered in planning online and hybrid meetings.


# Considerations When Scheduling Online Meetings {#considerations}

When scheduling an online meeting, an organizer must consider a number of different factors that can constrain their choices and influence the outcome.


## Reasons for Meeting {#reasons}

There are many reasons to hold an online meeting, and often the type of meeting has an impact on scheduling considerations.

For example, a meeting might be scheduled to make a specific decision, and thus it's important that all stakeholders have equal opportunity to participate in the discussion leading to it. Another meeting (even of the same group) might be held to gather feedback or update participants about the status of an effort, in which case scheduling conflicts might be resolved by a combination of holding multiple meetings and coordinated communication about the outcomes of each.

Successful meeting scheduling will consider the nature of the meeting. In particular, if the reasons for meeting do not require everyone to attend and there are potential conflicts, multiple meetings and/or alternative means of achieving the meeting's goals should be considered.


## Meeting Participants {#participants}

Participants often have different motivations for attending a meeting. Often, people attend a meeting to witness what occurs without contributing, because they want to track the discussion and any outcomes. Others may attend and only contribute if a proposal that they object to is made. It is often only a fraction of the participants who will make substantial contributions to the discussion.

Scheduling is also influenced by the number of people who want to participate. Finding a time that is acceptable to five or six participants is noticeably easier than doing so for fifty or sixty, both because of the larger number of permutations in the latter case, and because a small number of participants is more likely to develop a working ethic that allows cooperation.

Another factor to consider is whether the set of potential participants is known during scheduling. If a meeting purports to be 'open' -- that is, to allow broad participation from anyone -- participation from those not represented in scheduling discussions needs to be considered, so that they are not systematically disadvantaged.

Successful meeting scheduling will assure that those who are reasonably considered to be necessary to the proceedings are able to avoid conflicts. For example, those facilitating the meeting and those presenting critical information are reasonably considered to be necessary to a meeting. Likewise, presence of key stakeholders are only slightly less necessary to a meeting's success.

However, those necessary parties should not have any elevated privilege in terms of having their preferences accommodated. If a meeting time is merely inconvenient to them, rather than a serious conflict (see {{conflicts}}), that should not overcome others' need to avoid serious conflicts.


## Scheduling Conflicts {#conflicts}

Finally, there are different kinds of scheduling conflicts. One person might consider having to commute to an office or shift another meeting or meal as inconvenient, whereas another might have a commitment to collect a child from school or provide care to a family member that is difficult (if not impossible) to change. Likewise, there is a significant difference between the mild annoyance of joining a meeting outside of business hours and disrupting someone's circadian rhythm -- potentially affecting more than one day of their life as they readjust -- to join one at 3am.

Successful meeting scheduling will take the nature of conflicts into account, heavily discounting participants' mere inconvenience and prioritising those whose commitments or location make their need to avoid conflicts greater and more legitimate.

In general, a one-time conflict is not a reason to change the time of a regular meeting or a series of meetings.


# Recommendations for Scheduling Online Meetings {#recommendations}

Most online meetings have the potential for scheduling conflicts. The steps below help implement the guidelines above, and are intended to help schedule both single and recurring meetings.

## 1. Gather Information

Ask group participants for:

1. The timezone that they are usually participating from.
2. If they have any genuine conflicts. For example, "I need to collect my children from school at 4pm and no one else can do it".
3. If they have preferences. For example, getting up early, staying up late, avoiding family mealtimes.

"I have another meeting at 4pm on Tuesdays" is not a conflict, it is a preference. This explicitly assumes that those who participate in the meeting for work purposes should prioritise it; otherwise, successfully scheduling the meeting is much less likely.

Conflicts and preferences should be gathered privately; e.g., in an e-mail to the convener.


## 2. Find an Equitable Solution (if possible)

Based upon the information gathered, identify one or more candidate times for the meeting that conform to these rules:

1. No participant is expected to attend any part of the meeting between 11pm and 8am in their stated timezone, unless they explicitly state a preference for doing so, and
2. No participant has a genuine conflict in any part of the candidate time.

If no candidate times are available, proceed to one of the next steps below.

Otherwise, choose a candidate while conforming as much as possible to any participants' stated preferences, announcing it to the list for confirmation.


## 3a. Poll from the Least Privileged Perspective

If the previous step fails to find a candidate time, a poll can be used to select a time for the meeting. In doing so, it is important to consider the dynamics of group behaviour, because a large number of people who have similar needs are likely to overwhelm the needs of a minority in a disproportionate fashion.

For example, if ten participants are all in the US/Pacific timezone, three are in UK/London, and one is in Japan/Tokyo, a poll that has many US-friendly options is likely to result in the meeting taking place during business hours in the US, in the evening in London, and at an extremely unfriendly hour in Tokyo, because the US participants will not take others' inconvenience fully into account.

To counteract this tendency, such polls should only include options that accommodate the needs of the least-represented participant. In our example above, that might include options early in the morning for the US, late in the evening for Tokyo, and in the afternoon for London.

This option works best when participants are in somewhat compatible timezones; if it is not possible to prevent a participant from being inconvenienced by a truly unreasonable meeting time, the following options may be more appropriate.


## 3b. Equalize the Pain

Alternatively, the information gathered can be used to calculate the 'least painful' time to hold the meeting, by assigning a 'pain value' to each hour of the day. For example, a meeting during local business hours has 0 pain, whereas a meeting at 3am has a very high value (e.g., 5000). By calculating the cumulative pain for attendees in each possible time slot, the time with the least collective pain can be found.

See [the online tool](https://bit.ly/meeting-pain-calculator) that facilitates this. Note that it counts each timezone only once, no matter how many participants are in that timezone, to counteract the unfair weight that a large number of participants in one area can have.

This option works best for meetings that are one-off, or in a short series, and at least one participant will be truly inconvenienced by an unreasonable time. If it is an ongoing series of meetings, it might be combined with the next option.


## 3c. Rotate the Pain

When avoiding conflicts is impossible -- for example, because a truly global pool of participants is needed -- it is more appropriate to rotate through different meeting times that distribute the pain, so that at least some meetings will be convenient for all participants, and any inconvenience is shared.

For example, if a series of three successive meetings needed to include participants from many parts of the world, the first might be scheduled during business hours in North and South America, the second during those hours in Europe and Africa, and the third during business hours in Asia and Oceania.

Note that the relative number of participants from each region does not affect the distribution of meetings. This is because the resulting pain is not a shared experience -- it is an individual one, and should not be proportional to participant distribution. Furthermore, if a meeting needs to be perceived as globally representative, it is important that the opportunity to participate is equal.



## 4. Regularly Confirm

If a meeting is regularly scheduled or part of an ongoing series, it is important to regularly confirm the information of participants and the selected time, because new participants may join (or wish to), their information might change, and daylight savings time might change the best choice (especially when participants come from the Southern hemisphere).


--- back

