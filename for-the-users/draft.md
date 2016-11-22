---
title: The Internet is for End Users
docname: draft-nottingham-for-the-users-04
date: 2016
category: bcp

ipr: trust200902
area: General
workgroup:
keyword: constituent
keyword: constituency
keyword: relevant parties
keyword: end users
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

normative:
  RFC2119:

informative:
  RFC2460:
  RFC3935:
  RFC4941:
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

This document requires that Internet Standards consider end users as their highest priority concern.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-the-users>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-the-users/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-the-users>.

--- middle

# Introduction

As the Internet increasingly mediates key functions in societies, it has unavoidably become
profoundly political; it has helped people overthrow throw governments and revolutionize social
orders, control populations and reveal secrets. It has created wealth for some individuals and
companies, while destroying others'.

The IETF, while focused on technical matters, is not neutral about the purpose of its work in
developing the Internet {{RFC3935}}:

> The IETF community wants the Internet to succeed because we believe that the existence of the Internet, and its influence on economics, communication, and education, will help us to build a better human society.

However, the IETF is most comfortable making what we believe to be purely technical decisions; our
process is defined to favor technical merit, through our well-known bias towards "rough consensus
and running code".

Nevertheless, the running code that results from our process (when things work well) inevitably has
an impact beyond technical considerations, because the underlying decisions afford some uses, while
discouraging others; while we believe we are making purely technical decisions, in reality that may
not be possible. Or, in the words of Lawrence Lessig {{CODELAW}}:

> Ours is the age of cyberspace. It, too, has a regulator... This regulator is code — the software and hardware that make cyberspace as it is. This code, or architecture, sets the terms on which life in cyberspace is experienced. It determines how easy it is to protect privacy, or how easy it is to censor speech. It determines whether access to information is general or whether information is zoned. It affects who sees what, or what is monitored. In a host of ways that one cannot begin to see unless one begins to understand the nature of this code, the code of cyberspace regulates.

All of this raises the question: Who do we go through the pain of rough consensus and write that
running code for?

There are a variety of identifiable parties in the larger Internet community that standards can
provide benefit to, such as (but not limited to) end users, network operators, schools, equipment
vendors, specification authors, specification implementers, content owners, governments,
non-governmental organisations, social movements, employers, and parents.

Successful specifications will provide some benefit to all of the relevant parties, because
standards do not represent a zero-sum game. However, there are often situations where we need to
balance the benefits of a decision between two (or more) parties.

To help clarify such decisions, {{users}} mandates that end users have the highest priority.



## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Internet is for End Users {#users}

Internet standards MUST NOT consider any other party to have priority over end users.

While networks need to be managed, employers and equipment vendors need to meet business goals, and
so on, the IETF's mission is to "build a better human society" {{RFC3935}} and -- on the Internet
-- society is composed of what we call "end users."

By "end users", we mean non-technical users whose activities our protocols are designed to support.
Thus, the end user of a protocol to manage routers is not a router administrator; it is the people
using the network that the router operates within.

This does not mean that the IETF community has any specific insight into what is "good for end
users"; as always, we will need to interact with the greater Internet community and apply our
process to help us make decisions, deploy our protocols, and ultimately determine their success or
failure.

It does mean that when a proposed solution to a problem has a benefit to some other party at the
expense of end users, we will find a different solution, or find another way to frame the problem.

There may be cases where genuine technical need requires compromise. However, such tradeoffs need
to be carefully examined, and avoided when there are alternate means of achieving the desired
goals. If they cannot be, these choices and reasoning SHOULD be carefully documented.

For example, IPv6 {{RFC2460}} identifies each client with a unique address -- even though this
provides a way to track end user activity and helps identify them -- because it is technically
necessary to provide networking (and despite this, there are mechanisms like {{RFC4941}} to
mitigate this effect, for those users who desire it).

Finally, this requirement only comes into force when an explicit conflict between the interests of
end users and other relevant parties is explicitly encountered (e.g., by being brought up in the
Working Group). It does not imply that a standards effort needs to be audited for user impact, or
every decision weighed against end user interests.



# IANA Considerations

This document does not require action by IANA.

# Security Considerations

This document does not have direct security impact; however, failing to apply it might affect
security negatively in the long term.


--- back

# Acknowledgements

Thanks to Edward Snowden for his comments regarding the priority of end users at IETF93.

Thanks to Harald Alvestrand for his substantial feedback and Stephen Farrell, Joe Hildebrand, Russ
Housley, Niels ten Oever, and Martin Thomson for their suggestions.
