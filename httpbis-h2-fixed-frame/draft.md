---
title: HTTP/2 Fixed-Size Frames
docname: draft-nottingham-httpbis-h2-fixed-frame-00
date: 2016
category: info

ipr: trust200902
area: General
workgroup: 
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
  RFC7540:

informative:


--- abstract

This specification defines a HTTP/2 setting, SETTINGS_FIXED_FRAME_SIZE, that asks the peer to use padding and chunking to achieve a desired, static frame size for HEADERS and DATA frames.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/httpbis-h2-fixed-frame>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/httpbis-h2-fixed-frame/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/httpbis-h2-fixed-frame>.


--- middle

# Introduction

Traffic analysis depends, in part, on using the difference between sizes of messages to characterise a particular flow. 

HTTP/2 {{RFC7540}} allows its two major data-bearing frame types (HEADERS and DATA) to be split into multiple frames as well as padded with extra data. However, implementations to date do not use these capabilities in any regular way to combat traffic analysis.

This specification defines a new HTTP/2 setting that informs a peer when it is desirable to use frame splitting and padding to achieve this effect.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.



## SETTINGS_FIXED_FRAME_SIZE (0xn)

This setting requests that the peer assure that HTTP/2 frame payloads (as per {{RFC7540}}, Section 4.1) it sends are split into multiple frames and/or padded to the number of bytes indicated in its value, when the frame type allows.

A value of 0 indicates no fixed frame size is requested.

For example, if the setting value is 8192, a 10000 byte DATA frame payload would be sent as two 8192 byte frames, with 1808 bytes of padding in total (occurring in either frame, or both).

HEADERS frames would likewise be split into one HEADERS frame and an arbitrary number of CONTINUATION frames, with padding as necessary.


# IANA Considerations

This specification registers an entry in the HTTP/2 Settings registry.

* Name: SETTINGS_FIXED_FRAME_SIZE
* Code: TBD
* Initial Value: 0
* Specification: [this document]

# Security Considerations

Uniform frame sizes are not sufficient to combat traffic analysis on their own, since flows still carry metadata, timing, and other information. 


--- back

# Acknowledgements

Well, Chaum for one.
