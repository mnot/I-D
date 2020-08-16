---
title: De-Chartering the IETF Discussion List
abbrev:
docname: draft-nottingham-shut-it-down-00
date: {DATE}
category: info
updates: 3005

ipr: trust200902
area: General
workgroup: GENDISPATCH
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    street: made in
    city: Prahran
    region: VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This draft contends that the IETF discussion list is not fit its chartered purposes, and makes recommendations that follow from that conclusion.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/shut-it-down>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/shut-it-down/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/shut-it-down>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-shut-it-down/>.

--- middle

# Introduction

The IETF discussion list was chartered {{!RFC3005}} to '[further] the development and specification of Internet technology through discussion of technical issues, and [host] discussions of IETF direction, policy, meetings and procedures.' It is thus considered the primary venue where the operation of the IETF is discussed.

This draft contends that the IETF discussion list is not fit for these purposes, and makes recommendations that follow from that conclusion.

In particular, it argues that the IETF discussion list is not representative of the IETF community as a whole ({{representative}}), and that the IETF discussion list is toxic {{toxic}}. In combination, these factors make it a poor venue for the matters it is chartered to host. {{recommendations}} therefore makes recommendations for changes that address these issues.

Note that this document does not advocate closing the IETF discussion list.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.


# The IETF discussion list is not representative {#representative}

The IETF discussion list is often said to be the place where the IETF community as a whole comes together. Discussion there often influences decisions made about the direction of the organisation as a whole, and occasionally about specific technology choices.

It is difficult to measure how representative the IETF discussion list is. One way to approximate it is to compare its membership with other IETF lists. Although this has many limitations (e.g., some may use different addresses; some may have subscribed and then disabled delivery rather than unsubscribing; generally, subscription to a mailing list is only a weak proxy for participation in the IETF), it is nevertheless illuminating.

As of writing, the IETF discussion list has 1,751 members who have made their e-mail address public; 29 members have not made their addresses public.

Comparing its membership to that on other various IETF mailing lists, we find that there are typically a large number of members that are not participating on the IETF discussion list:

| List        | Members | Overlap | % on IETF list |
|-------------+---------+---------+----------------|
| 6MAN        |   1,698 |     246 | 14.5%          |
| DISPATCH    |     436 |     111 | 25.5%          |
| DNSOP       |   1,041 |     204 | 19.6%          |
| GENDISPATCH |      54 |      37 | 68.5%          |
| OPSAWG      |     423 |     100 | 23.6%          |
| QUIC        |     853 |     121 | 14.2%          |
| RTGWG       |     610 |     119 | 19.5%          |
| SECDISPATCH |     153 |      50 | 32.7%          |
| TLS         |   1,257 |     134 | 10.7%          |
| WEBTRANS    |     110 |      39 | 35.5%          |
| WPACK       |      98 |      24 | 24.5%          |

When combined, the lists above have a total of 5,355 unique addresses subscribed; only 628 (11.7%) of them are on the IETF discussion list.

Another lens to examine the IETF discussion list with is in the proportion of RFC authors who are subscribed to it. Again, this has many shortcomings, but can nevertheless help to inform as to how representative the IETF discussion list is.

As of 11 August 2020, the RFC Editor queue contained 167 drafts, which had a total of 352 unique author addresses. Of that group, 83 (23.6%) are also members of the IETF discussion list.


# The IETF discussion list is toxic {#toxic}

{{!RFC3005}} also specifies that 'considerable latitude is allowed' in what is considered acceptable on this mailing list.

This latitude has helped to make it difficult for the community to come to agreement about the boundaries of discussion. {{!RFC3005}} empowers the IETF Chair, the IETF Executive Director or a sergeant-at-arms (SAA) appointed by the Chair to 'restrict posting by a person, or of a thread, when the content is inappropriate and represents a pattern of abuse.'

Subsequently, the SAA developed a Standard Operating Procedure (SoP) in consultation with the community, in an effort to assure that the community understood how this power would be used, that it was used in a fair and non-discriminatory fashion, and so that participants had more confidence about what was appropriate for the list.

When that power was recently exercised, there was considerable pushback within the community about its use, and the IETF Chair directed the SAA to rescind the restriction.

Without examining the issue as to whether it was appropriate for the SAA to use their power to restrict posting in that instance, this incident has made it clear that the tools available to the SAA to guide the nature of the discussion -- even once it's declared to be off-topic -- are blunt. The mechanisms in {{!RFC3005}} are not adequate to reasonably guide discussion on this list to be productive, and as a result anecdotal evidence suggests that several participants are choosing to leave it.


# Recommendations {#recommendations}

This document updates {{!RFC3005}} by recommending that:

1. The IESG should not consider the IETF discussion list as an appropriate venue for notifying IETF participants of its actions or items under consideration. More suitable channels include the IETF Announcements list and the GENDISPATCH Working Group, depending on the nature of the notification.

2. The IESG should not consider discussion on the IETF discussion list as representative of the broader IETF community. As noted above, many participants are not active there, and some of those who are are able to amplify their positions in a way that may distort the 'reading of the room' as a result.

3. IETF participants who wish to make proposals about or discuss the IETF's direction, policy, meetings and procedures should do so in GENDISPATCH or other Working Group, if one more specific to that topic should exist. Note that Working Groups can define policies for participation in their work.

4. IETF participants who wish to discuss technical issues should do so in the most appropriate Working Group or Area mailing list to the topic -- ideally publishing an Internet-Draft to further that discussion as appropriate. Note that topics without an obvious home, as well as cross-area topics, have been proven to be well-handled by the DISPATCH-style Working Groups.

5. Cross-area review should continue using a combination of review directorates, cross-participation, AD oversight and the Last Call discussion list.

6. There should be no explicit or implicit requirement for IETF leadership or any other person to be subscribed to the IETF discussion list. Requiring participation in a toxic forum with no clear connection to the operation of the organisation is problematic.

7. Operational documents (such as <https://www.ietf.org/about/participate/tao/>, <https://www.ietf.org/how/lists/> and <https://www.ietf.org/how/lists/discussion/>) should be rewritten to reflect this understanding of the role of the IETF discussion list. In particular, newcomers to the IETF should not be steered towards subscribing to the IETF discussion list. Likewise, presentations to new IETF participants should be updated.

8. Operational documents should be updated to indicate the role of the DISPATCH groups more clearly to newcomers.


# Security Considerations

The security of the Internet had better not depend upon the IETF discussion list.


--- back
