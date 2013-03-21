---
title: The "safe" HTTP Client Hint
abbrev: The safe Hint
docname: draft-nottingham-safe-hint-00
date: 2013
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline, rfcedstyle]

author:
 -  ins: M. Nottingham
    name: Mark Nottingham
    organization: 
    email: mnot@mnot.net
    uri: http://www.mnot.net/

normative:
  RFC2119:
  grigorik-http-client-hints:
    title: HTTP Client Hints
    author:
      - ins: I. Grigorik
  
informative:
  RFC6265:
  yahoo: 
    target: http://search.yahoo.com/preferences/preferences
    title: Yahoo! Search Preferences
    author: 
      - organization: Yahoo! Inc.
  bing:
    target: http://onlinehelp.microsoft.com/en-AU/bing/ff808441.aspx
    title: "Bing Help: Block Explicit Web Sites"
    author:
      - organization: Microsoft
  google:
    target: "http://support.google.com/websearch/bin/answer.py?p=settings_safesearch&amp;answer=510"
    title: "SafeSearch: turn on or off"
    author:
     - organization: Google
  youtube:
    target: "http://support.google.com/youtube/bin/answer.py?answer=174084"
    title: How to access and turn on Safety Mode?
    author:
     - organization: Google


--- abstract

This specification defines a "safe" HTTP Client Hint, expressing a user
preference to avoid "objectionable" content.


--- middle

Introduction
============

Many Web sites have a "safe" mode, to assist those who don't want to be
exposed to "objectionable" content, or who don't want their children to be
exposed to such content. YouTube {{youtube}}, Yahoo! Search {{yahoo}}, Google
Search {{google}}, Bing Search {{bing}}, and many other services have such a
setting.

However, a user that wishes to have this preference honoured would need to go
to each Web site in turn, navigate to the appropriate page, (possibly creating
an account along the way) to get a cookie {{RFC6265}} set in the browser. They
would need to do this for each browser on every device they use.

This can be onerous to nearly impossible to achieve effectively, because there
are too many permutations of sites, user agents and devices.

If instead this preference is proactively advertised by the user agent, things
become much simpler. A user agent that supports this (whether it be an
individual browser, or through an Operating System HTTP library) need only be
configured once to assure that the preference is honoured by all sites that
understand and choose to act upon it. It's no longer necessary to go to each
site that has potentially "unsafe" content and configure a "safe" mode.

Furthermore, a proxy (for example, at a school) can be used to ensure that the
preference is associated with all (unencrypted) requests flowing through it,
helping to assure that clients behind it are not exposed to "objectionable"
content.

This specification defines how to associate this preference with a request,
as a HTTP Client Hint {{grigorik-http-client-hints}}.

Note that this approach does not define what "safe" is; rather, it is
interpreted within the scope of each Web site that chooses to act upon this
information (or not). As such, it does not require agreement upon what "safe"
is, nor does it require application of policy in the user agent or an 
intermediary (which can be problematic for many reasons).


Notational Conventions
----------------------

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


The "safe" HTTP Client Hint
===========================

When present in a request, the "safe" HTTP Client Hint indicates that the
user prefers content which is not objectionable, according to the server's
definition of the concept. 

For example:

~~~
GET /foo.html HTTP/1.1
Host: www.example.org
User-Agent: ExampleBrowser/1.0
CH: safe
~~~

When configured to do so, user agents SHOULD send "safe" on every request,
to ensure that the preference is applied (where possible) to all resources.

Servers that utilise the "safe" hint SHOULD document that they do so, along
with the criteria that they use to denote objectionable content. If a site
has more fine-grained degrees of "safety", it SHOULD select a reasonable
default to use, and document that; it MAY use additional mechanisms (e.g.,
cookies) to fine-tune.


Security Considerations
=======================

The "safe" client hint is not a secure mechanism; it can be inserted or
removed by intermediaries with access to the data stream. Its presence reveals
information about the user, which may be of small assistance in
"fingerprinting" the user (1 bit of information, to be precise).

Due to its nature, including it in requests does not assure that all content
will actually be safe; it is only when servers elect to honour it that it 
might change content. 

Even then, a malicious server might adapt content so that it is even less
"safe" (by some definition of the word). As such, this mechanism on its own is
not enough to assure that only "safe" content is seen; users who wish to
ensure that will need to combine its use with other techniques (e.g., content
filtering).

Furthermore, the server and user may have differing ideas regarding the
semantics of "safe." As such, the "safety" of the user's experience when 
browsing from site to site might (and probably will) change. 


IANA Considerations
===================

This specification registers the "safe" HTTP Client Hint
{{grigorik-http-client-hints}}:

* Hint Name: safe
* Hint Value: boolean
* Description: Indicates that the user (or one responsible for them) prefers
  "safe" / "unobjectionable" content.
* Contact: mnot@mnot.net
* Specification: (this document)
* Notes: 


--- back

Acknowledgements
================

Thanks to Alissa Cooper, Ilya Grigorik and Emma Llanso for their comments.
