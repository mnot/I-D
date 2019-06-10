---
title: The Internet is for End Users
docname: draft-nottingham-for-the-users-08
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

This document explains why the IETF should consider end-users as its highest priority concern, and how.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-the-users>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-the-users/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-the-users>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-for-the-users/>.

--- middle

# Introduction

Many who participate in the IETF are most comfortable making what we believe to be purely technical decisions; our process is defined to favor technical merit, through our well-known bias towards "rough consensus and running code".

Nevertheless, the running code that results from our process (when things work well) inevitably has an impact beyond technical considerations, because the underlying decisions afford some uses while discouraging others; while we believe we are making purely technical decisions, in reality, we are defining what is possible on the Internet itself. Or, in the words of Lawrence Lessig {{CODELAW}}:

> Ours is the age of cyberspace. It, too, has a regulator... This regulator is code — the software and hardware that make cyberspace as it is. This code, or architecture, sets the terms on which life in cyberspace is experienced. It determines how easy it is to protect privacy, or how easy it is to censor speech. It determines whether access to information is general or whether information is zoned. It affects who sees what, or what is monitored. In a host of ways that one cannot begin to see unless one begins to understand the nature of this code, the code of cyberspace regulates.

This impact has become significant. As the Internet increasingly mediates essential functions in societies, it has unavoidably become profoundly political; it has helped people overthrow governments and revolutionize social orders, control populations and reveal secrets. It has created wealth for some individuals and companies while destroying others'.

All of this raises the question: Who do we go through the pain of gathering rough consensus and writing running code for?

After all, there are a variety of identifiable parties in the broader Internet community that standards can provide benefit to, such as (but not limited to) end users, network operators, schools, equipment vendors, specification authors, specification implementers, content owners, governments, non-governmental organisations, social movements, employers, and parents.

Successful specifications will provide some benefit to all of the relevant parties because standards do not represent a zero-sum game. However, there are sometimes situations where there is a need to balance the benefits of a decision between two (or more) parties.

In these situations, when one of those parties is an "end user" of the Internet -- for example, a person using a Web browser, mail client, or another agent that connects to the Internet -- this document argues that the IETF should protect their interests over those of parties such as network operators, governments, or equipment vendors.

{{who}} explains what is meant by "end users"; {{why}} outlines why they should be prioritised in IETF work, and {{how}} describes how that can be done.


# What Are "End Users"? {#who}

In this document, "end users," means non-technical users whose activities IETF protocols are designed to support, sometimes indirectly. Thus, the end user of a protocol to manage routers is not a router administrator; it is the people using the network that the router operates within.

End users are not necessarily a homogenous group; they might have different views of how the Internet should work (from their viewpoint) and might occupy several roles, such as a seller, buyer, publisher, reader, service provider and consumer. An end user might be browsing the Web, monitoring remote equipment, playing a game, video conferencing with colleagues, sending messages to friends, or performing an operation in a remote surgery theatre.

Likewise, an individual end user might have many interests (e.g., privacy, security, flexibility, reachability) that are sometimes in tension.

A person whose interests we need to consider might not directly be an end-user of a specific system connected to the Internet. For example, if a child is using a browser, the interests of that child's parents or guardians may be relevant; if a person is pictured in a photograph, that person may have an interest in systems that process that photograph, or if a person entering a room triggers sensors that send data to the Internet than that person's interests may be involved in our deliberations about how those sensor readings are handled.

While such less-direct interactions between people and the Internet may be harder to evaluate, such people are nonetheless included in this document's concept of end-user.


# Why End Users Should Be Prioritised {#why}

While focused on technical matters, the IETF is not neutral about the purpose of its work in developing the Internet; in "A Mission Statement for the IETF" {{?RFC3935}}, the definitions include:

> The IETF community wants the Internet to succeed because we believe that the existence of the Internet, and its influence on economics, communication, and education, will help us to build a better human society.

and later in Section 2.1, "The Scope of the Internet" it says:

> The Internet isn't value-neutral, and neither is the IETF. We want the Internet to be useful for communities that share our commitment to openness and fairness. We embrace technical concepts such as decentralized control, edge-user empowerment and sharing of resources, because those concepts resonate with the core values of the IETF community. These concepts have little to do with the technology that's possible, and much to do with the technology that we choose to create.

In other words, the IETF is concerned with developing and maintaining the Internet to promote the social good, and the society that the IETF is attempting to improve is composed of end users, along with groups of them forming businesses, governments, clubs, civil society organizations, and other institutions.

Merely advancing the measurable success of the Internet (e.g., deployment size, bandwidth, latency, number of users) is not adequate; technology is a means, not an end.

Beyond fulfilling the IETF's mission, prioritising end users also helps to ensure the long-term health of the Internet. Many aspects of the Internet are user-focused, and it will (deservedly) lose their trust if prioritises others' interests. Because one of the primary mechanisms of the Internet is the "network effect", such trust is crucial to maintain; the Internet itself depends upon it.


# How End Users are Prioritised {#how}

The IETF community does not have any unique insight into what is "good for end users." To inform its decisions, it has a responsibility to interact with the greater Internet community, soliciting input from others and considering the issues raised.

End users are typically not technical experts; their experience of the Internet is often based upon inadequate models of its properties, operation, and administration. Therefore, the IETF should primarily engage with those who understand how changes to it will affect end users; in particular civil society organisations, as well as governments, businesses and other groups representing some aspect of end-user interests.

The onus is on us to engage with these parties on terms that suit them; it is not acceptable to require them to understand the mores and peculiarities of the IETF community -- even as we attempt to enculture them into it. This means that when appropriate, we should take the initiative to contact these communities and explain our work, solicit their feedback, and encourage their participation. In cases where it is not reasonable a stakeholder community to engage in the IETF, we should go to them -- for example, holding workshops.

At our best, we will select work that promotes the social good. At the very least, however, we must refrain from work where we've identified harm to end users. In particular, when we've identified a conflict between the interests of end users and another stakeholder, we should err on the side of finding a solution that avoids that harm.

Note that "harm" is not defined in this document; that is something that the relevant body (e.g., Working Group) needs to discuss. Furthermore, harm to end users is judged just as any other decision in the IETF, with consensus gathering and the normal appeals process; merely asserting that something is harmful is not adequate. The converse is also true, though; it's not permissible to avoid identifying harms, nor is it acceptable to ignore them when brought to us.

The IETF has already established a body of guidance for situations where this sort of conflict is common, including (but not limited to) {{?RFC7754}} on filtering, {{?RFC7258}} and {{?RFC7624}} on pervasive surveillance, {{?RFC7288}} on host firewalls, and {{?RFC6973}} regarding privacy considerations. When specific advice is not yet available, we try to find a different solution or another way to frame the problem, distilling the underlying principles into more general advice where appropriate.

Much of that advice has focused on maintaining the end-to-end security properties of a connection. This does not mean that our responsibility to users stops there; protocols decisions might affect users in other ways. For example, inappropriate concentration of power on the Internet has become a concerning phenomenon -- one that protocol design might have some influence upon.

When the needs of different end users conflict (for example, two sets of end users both have reasonable desires) we again should try to minimise harm. For example, when a decision improves the Internet for end users in one jurisdiction, but at the cost of potential harm to others elsewhere, that is not a good tradeoff. As such, we effectively design the Internet for the pessimal environment; if a user can be harmed, they probably will be.

There may be cases where genuine technical need requires compromise. However, such tradeoffs are carefully examined and avoided when there are alternate means of achieving the desired goals. If they cannot be, these choices and reasoning ought to be thoroughly documented.



# IANA Considerations

This document does not require action by IANA.

# Security Considerations

This document does not have any direct security impact; however, failing to prioritise end users might well affect their security negatively in the long term.


--- back

# Acknowledgements

Thanks to Edward Snowden for his comments regarding the priority of end users at IETF93.

Thanks to the WHATWG for blazing the trail with the Priority of Constituencies.

Thanks to Harald Alvestrand for his substantial feedback and Mohamed Boucadair, Stephen Farrell,
Joe Hildebrand, Lee Howard, Russ Housley, Niels ten Oever, Mando Rachovitsa, Martin Thomson, and
Brian Trammell for their suggestions.
