---
title: The Internet is for End Users
docname: draft-nottingham-for-the-users-07
date: 2019
category: info

ipr: trust200902
area: General
workgroup:
keyword: constituent
keyword: constituency
keyword: relevant parties
keyword: end users
keyword: endpoint
keyword: stakeholder

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    email: mnot@mnot.net
    uri: https://www.mnot.net/

informative:
  CODELAW:
    target: http://harvardmagazine.com/2000/01/code-is-law-html
    title: "Code Is Law: On Liberty in Cyberspace"
    author:
      -
        ins: L. Lessig
        name: Lawrence Lessig
        organization: Harvard Magazine
    date: 2000


--- abstract

This document explains why, when a conflict cannot be avoided, the IETF considers end users as
its highest priority concern.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-the-users>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-the-users/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-the-users>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-for-the-users/>.

--- middle

# Introduction

The IETF, while focused on technical matters, is not neutral about the purpose of its work in
developing the Internet {{?RFC3935}}:

> The IETF community wants the Internet to succeed because we believe that the existence of the Internet, and its influence on economics, communication, and education, will help us to build a better human society.

and:

> The Internet isn't value-neutral, and neither is the IETF. We want the Internet to be useful for communities that share our commitment to openness and fairness. We embrace technical concepts such as decentralized control, edge-user empowerment and sharing of resources, because those concepts resonate with the core values of the IETF community. These concepts have little to do with the technology that's possible, and much to do with the technology that we choose to create.

However, the IETF is most comfortable making what we believe to be purely technical decisions; our
process is defined to favor technical merit, through our well-known bias towards "rough consensus
and running code".

Nevertheless, the running code that results from our process (when things work well) inevitably has
an impact beyond technical considerations, because the underlying decisions afford some uses while
discouraging others; while we believe we are making purely technical decisions, in reality that may
not be possible. Or, in the words of Lawrence Lessig {{CODELAW}}:

> Ours is the age of cyberspace. It, too, has a regulator... This regulator is code — the software and hardware that make cyberspace as it is. This code, or architecture, sets the terms on which life in cyberspace is experienced. It determines how easy it is to protect privacy, or how easy it is to censor speech. It determines whether access to information is general or whether information is zoned. It affects who sees what, or what is monitored. In a host of ways that one cannot begin to see unless one begins to understand the nature of this code, the code of cyberspace regulates.

This impact has become significant. As the Internet increasingly mediates key functions in
societies, it has unavoidably become profoundly political; it has helped people overthrow
governments and revolutionize social orders, control populations and reveal secrets. It has created
wealth for some individuals and companies, while destroying others'.

All of this raises the question: For whom do we go through the pain of gathering rough consensus
and writing running code?

There are a variety of identifiable parties in the larger Internet community that standards can
provide benefit to, such as (but not limited to) end users, network operators, schools, equipment
vendors, specification authors, specification implementers, content owners, governments,
non-governmental organisations, social movements, employers, and parents.

Successful specifications will provide some benefit to all of the relevant parties, because
standards do not represent a zero-sum game. However, there are sometimes situations where there is
a need to balance the benefits of a decision between two (or more) parties.

In these situations, when one of those parties is the "end user" of the Internet -- for example, a
person using a Web browser, mail client, or other agent that connects to the Internet -- the IETF
tends to protect their interests over those of parties such as network operators or equipement
vendors.

This document explains what is meant by "end users" in {{who}}, why they tend to be prioritised in
IETF work in {{why}}, and how that is done in {{how}}.


# What Are "End Users"? {#who}

In this document, "end users," means non-technical users whose activities IETF protocols are
designed to support, sometimes indirectly. Thus, the end user of a protocol to manage routers is
not a router administrator; it is the people using the network that the router operates within.

That said, end users are not necessarily a homogenous group; often, but not always, interactions on
the Internet are characterised by a seller/buyer, publisher/reader, or service provider/consumer
relationship. Conflicts in these interests are out of scope in this document; from the point of
view of the Internet, all of these parties are end users.

Likewise, even though we use the term "user" here, this does not necessarily denote a passive
relationship with the Internet; someone producing content, selling goods or providing a service is
equally a user of the Internet. The emphasis here is on "end" -- as in endpoint {{?RFC3724}}.


# Why End Users are Prioritised {#why}

While networks need to be managed, employers and equipment vendors need to meet business goals, and
so on, the IETF's mission is to "build a better human society" {{?RFC3935}} and -- on the Internet
-- society is composed of end users, along with groups of them forming business, governments,
clubs, civil society organizations, and other institutions that influence it.

Doing so helps the IETF achieve its mission, and also helps to assure the long-term health of the
Internet. By prioritising the concerns of end users, we assure that it reaches the greatest number
of people, thereby delivering greater utility by maximising its network effect.

Prioritising end users' needs also helps to assure that the Internet itself retains end users'
trust, preserving the benefit its network effect brings.


# How End Users are Prioritised {#how}

The IETF community does not have any specific insight into what is "good for end users"; to help
make decisions involving them, it interacts with the greater Internet community. Because end users
are typically not technical experts, the IETF has a responsibility to consider their interests, and
engages with those who understand how IETF work will affect end users, such as civil society
organisations, as well as governments, businesses and other groups representing some aspect of end
user interests.

When we've identified a conflict between the interests of end users and another stakeholder (e.g.,
a network operator), and need a "tiebreaker", we should err on the side of finding a solution that
doesn't harm end users.

Note that "harm" is not defined in this document; that is something that the relevant body (e.g.,
Working Group) needs to discuss.

The IETF has already established a body of guidance for situations where this sort of conflict is
common, including (but not limited to) {{?RFC7754}} on filtering, {{?RFC7258}} and {{?RFC7624}} on
pervasive surveillance, {{?RFC7288}} on host firewalls, and {{?RFC6973}} regarding privacy
considerations.

When such advice is not yet available, we try to find a different solution, or another way to frame
the problem, distilling the underlying principles into more general advice where appropriate.

There may be cases where genuine technical need requires compromise. However, such tradeoffs are
carefully examined, and avoided when there are alternate means of achieving the desired goals. If
they cannot be, these choices and reasoning ought to be carefully documented.


## Examples

* IPv6 {{?RFC8200}} can be used to assign a client with a unique address prefix -- even though this provides a way to track end user activity and helps identify them -- because it is technically necessary to provide networking (and despite this, there are mechanisms like {{?RFC4941}} to mitigate this effect, for those users who desire it).

* Different network operator communities have, from time to time, asked for a mechanism that would allow them to insert themselves into HTTPS {{?RFC7231}} connections to interpose caching and other performance optimisations. This was rejected for a number of reasons, including that end users' conception of HTTPS as an encrypted end-to-end protocol had already formed, so that changing it would harm user security.


# IANA Considerations

This document does not require action by IANA.

# Security Considerations

This document does not have direct security impact; however, failing to prioritise end users might
well affect their security negatively in the long term.


--- back

# Acknowledgements

Thanks to Edward Snowden for his comments regarding the priority of end users at IETF93.

Thanks to the WHATWG for blazing the trail with the Priority of Constituencies.

Thanks to Harald Alvestrand for his substantial feedback and Mohamed Boucadair, Stephen Farrell,
Joe Hildebrand, Lee Howard, Russ Housley, Niels ten Oever, Mando Rachovitsa, Martin Thomson, and
Brian Trammell for their suggestions.
