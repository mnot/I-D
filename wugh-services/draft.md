---
title: Using Third Party Services for IETF Work
abbrev: 3rd Party Services to the IETF
docname: draft-nottingham-wugh-services-00
date: 2017
category: bcp

ipr: trust200902
area: General
workgroup: WUGH
keyword: Internet-Draft

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


--- abstract

Some IETF Working Groups use third-party tools to manage their work, in addition to or instead of
those that the Secretariat and Tools team provide. This document specifies requirements regarding
their use.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/wugh-services>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/wugh-services/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/wugh-services>.


--- middle

# Introduction

Some IETF Working Groups use third-party tools to manage their work, in addition to or instead of
those that the Secretariat and Tools team provide.

For example, GitHub <https://github.com/> is currently used by a number of active Working Groups to
manage their drafts; as a distributed version control system, it has several attractive features,
including broad understanding and use among developers, a refined user experience, and issue
tracking facilities.

Working Groups are encouraged to use the best tools that work for them, in a manner that best suits
the work; the IETF does not benefit from locking its work practices into a one-size-fits-all set of
tools.

However, use of tools controlled by third parties can cause issues if not carefully considered. To
preserve the integrity of the IETF process when they are used, {{reqs}} outlines requirements for
such uses.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Requirements for Third-Party Tools {#reqs}

Working Groups using third-party tools to manage an aspect of their work -- for example, but not
limited to, hosting and change control for adopted drafts, issue tracking, and discussion
management -- are expected to conform to the following requirements when doing so:


## Rough Consensus To Use {#consensus}

The appropriate tools to use depends in large part on the community that will be using them; what
works for some will be problematic for others.

As a result, Working Groups using third-party tools MUST establish consensus to do so. This
consensus MAY be "rough", as any other decision in the IETF might be. The Working Group's decision
SHOULD be informed by the needs of those who will use the tools the most, such as document editors.

The Working Group SHOULD establish alternative means of access to critical resources when there are
participants "in the rough" on this decision. For example, if a few participants object to using
Github, issue activity can be mirrored to a mailing list, and they can subscribe to it.


## Equal Access {#access}

One of the important properties of IETF work is that it is accessible to any who want to
participate.

Use of third-party tools MUST NOT require payment of a fee by participants. However, if use of a
tool requires payment and some party (e.g., the Working Group chair) is willing to cover all fees,
such a tool MAY be used. Note that this requirement does not preclude the use of services where
"premium" features are available for a payment, as long as those features are not required to fully
participate in the work.

Use of third-party tools MUST NOT require legal agreements, beyond acceptance of reasonable "terms
of service" and similar measures. In particular, third-party services MUST NOT require assignment
of intellectual property.

When choosing a tool, a Working Group MUST consider the breadth of platform(s) it is available
upon; tools that are platform-specific SHOULD NOT be chosen unless there is consensus in the
Working Group that the benefits of using that tool outweigh this limitation, and no suitable
alternative is available. Tools that are specific to individual users (e.g., the Editors) MAY be
exempted from this requirement, although the Working Group Chair(s) MUST approve of such choices.

It is not a requirement that every third-party tool be accessible using every possible combination
of technology.


## Clear Procedure {#procedure}

IETF Working Groups using third-party tools MAY use them to host substantial technical discussions,
in addition to or even instead of the traditional mailing list.

When doing so, Working Groups MUST establish and document clear procedures about what the
appropriate venue(s) for discussion are, and how consensus is established.

In particular, even when consensus is allowed to be established in another medium, the Working
Group mailing list MUST remain an acceptable form of input and participation; this assures that use
of a third-party tool is not required for participation.

Furthermore, when the Working Group does establish consensus in another medium, the mailing list
MUST still be informed, and objections from those on the mailing list not using the third-party
tool MUST be considered as new information by the Chairs, although the Chairs MAY determine that it
is not sufficient to reopen an issue.

For example, if a draft incorporates the resolutions of a number of issues discussed in Github, it
is appropriate to notify the mailing list that those issues are believed to have consensus, giving
people an opportunity to raise objections at that point.


## Notification {#notification}

When IETF work is hosted on a third-party tool, new participants might engage directly with the
tool, rather than being first introduced to IETF processes. In some cases, drawing such new,
non-traditional participants into the work is an explicit goal of using a third-party service.

Many of these participants will not be familiar with IETF processes -- in particular, the NOTE WELL
terms. As a result, Working Groups using third-party tools:

* MUST prominently display the NOTE WELL terms and MUST state their applicability to that tool.
* SHOULD display links to introductory resources about the IETF; e.g., <https://ietf.org/> and {{!RFC4677}}.

The IESG MAY establish specific text to include in certain situations.


## Neutrality {#neutral}

Because a tool often serves as a "source of truth" for Working Group activity, it is important that
it be trustworthy. Preferably, tools SHOULD be operated by a party that is not involved in the
Working Group's activities directly; exceptions include cases where a tool has a very limited
function (e.g., a script to post the results of one process to another service).


## Recoverability {#recovery}

Third-party tools can and do go out of business, have disasters befall them, or change their terms
of service in a way that is no longer acceptable for our purposes. Additionally, after the work has
completed, it is important that there is a stable archive of the work available, even when the
relationship with the third party has terminated.

Using a third-party tool is effectively taking a dependency against it, and so Working Groups that
use them MUST take reasonable steps to assure that any state necessary to recover the work is
available.

This requirement could be met in a number of ways. For example, some Working Groups using GitHub
will check their issue lists into the repository, so that the issue state is recoverable; since
there are multiple copies of the repository replicated (a minimum of one per editor), this state is
recoverable.

Ideally, such recovery mechanisms will enable a seamless transition to a different toolset in the
event of an unforeseen (and hopefully rare) transition. However, it is not a requirement that there
be a "ready to go" fallback. That said, backups SHOULD be in open formats (e.g., XML, JSON).

The Secretariat and/or Tools team SHOULD provide backup mechanisms for commonly used third-party
tools, as nominated by the IESG. When available, such facilities MUST be used by Working Groups.


## Administrative Access {#admin}

Because Working Group personnel can change over time, both the Chair(s) and responsible Area
Director SHOULD have administrative access to third-party tools, unless this is impractical.


# IANA Considerations

This document does not require any action from IANA.


# Security Considerations

This document does not introduce security considerations for protocols, but its application helps
assure that the process that the IETF uses maintains its integrity.


--- back
