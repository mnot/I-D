---
title: Reserving the 418 HTTP Status Code
abbrev: 418
docname: draft-nottingham-thanks-larry-00
date: 2017
category: std

ipr: trust200902
area: General
workgroup: httpbis
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

informative:


--- abstract

{{?RFC2324}} was an April 1 RFC that lampooned the various ways HTTP was abused; one such abuse was the definition of the application-specific 418 (I'm a Teapot) status code.

In the intervening years, this status code has been widely implemented as an "easter egg", and therefore is effectively consumed by this use.

This document changes 418 to the status of "Reserved" in the IANA HTTP Status Code registry to reflect that.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/thanks-larry>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/thanks-larry/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/thanks-larry>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-thanks-larry/>.

--- middle

# Introduction

{{?RFC2324}} was an April 1 RFC that lampooned the various ways HTTP was abused; one such abuse was the definition of the application-specific 418 (I'm a Teapot) status code. 

In the intervening years, this status code has been widely implemented as an "Easter Egg", and therefore is effectively consumed by this use.

This document changes 418 to the status of "Reserved" in the IANA HTTP Status Code registry to reflect that.

This indicates that the status code cannot be assigned to other applications currently. If future circumstances require its use (e.g., exhaustion of all other 4NN status codes), it can be re-assigned to another use.

Implementations are encouraged to avoid "squatting" on status codes in this manner; while there are a number of unassigned status codes in each range currently, unofficial, uncoordinated use makes the definition of new status codes more difficult over the lifetime of HTTP, which (hopefully) is a potentially very long period of time.



# IANA Considerations

This document updates the following entry in the Hypertext Transfer Protocol (HTTP) Status Code Registry:

* Value: 418
* Description: Reserved
* Reference: [this document]

IANA should also typographically distinguish "Unassigned" and "Reserved" in the registry descriptions, to prevent confusion.


# Security Considerations

This document has no security content.


--- back
