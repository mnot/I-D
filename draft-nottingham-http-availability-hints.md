---
title: HTTP Availability Hints
abbrev:
docname: draft-nottingham-http-availability-hints-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/availability-hints"

github-issue-label: availability-hints

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  HTTP: RFC9110
  HTTP-CACHING: RFC9111


--- abstract

This specification defines availability hints, a new class of HTTP responses headers that augment the information in the Vary header field.

--- middle


# Introduction

The HTTP Vary header field ({{Section 12.5.5 of HTTP}}) allows an origin server to describe what aspects of requests affect the content of its responses. This information is useful in many ways; most prominently, downstream caches can use it to select the correct stored response for a given request ({{Section 4.1 of HTTP-CACHING}}).

However, the information conveyed by Vary is limited. If the request headers enumerated in it are considered as a n-dimensional space with each field representing an axis, this response header:


~~~ http-headers
Vary: Accept-Encoding, Accept-Language, ECT
~~~

indicates that there is a three-dimensional space of potential responses that could be sent. However, nothing more is conveyed; the number and nature of the entries on each axis are not available, leaving caches and other downstream consumers none the wiser as to how broad this space is, or how to navigate it.

This design makes using Vary difficult. A cache doesn't have enough information available to decide whether one of its stored responses is the best to satisfy a given request in all but the most simple circumstances.

For example, if a request indicates that the client prefers responses in the French language, but will also accept English, and the cache has a stored English response, what is the appropriate action? Should it serve the English response, or should it make a request to the server for a French response and hope that one might be available -- adding significant latency if it is not?

This specification defines a new type of HTTP header field -- an _availability hint_ -- that augments the information on a single axis of content negotiation, by describing the selection of responses that a server has available along that axis. So, our example above have three availabilty hints added to it:

~~~ http-headers-new
Vary: Accept-Encoding, Accept-Language, ECT
Avail-Encoding: gzip, br
Avail-Language: fr, en;d
Avail-ECT: (slow-2g 2g 3g), (4g);d
~~~

This says that there are two encodings available -- gzip and brotli -- beyond the mandatory "identity" encoding; that both French and English are available, but English is the default; and that there are two different representations available depending on the Effective Connection Type that the client advertises, with "4g" being the default.

Caches and other clients can use this information to determine when a request can be satisfied by a stored response, and what other options might be available. Using the example above, we can know that the response to a request an ECT of "2g" can also be used for a request with "3g".

Availability hints have some limitations. While a server's preferences along a single axis of negotiation can be conveyed by the corresponding availability hint, its relative preferences between multiple axes are not. In the example above, it isn't possible to know whether the server prefers that downstream caches and clients use the brotli-encoded French version over the gzip-encoded English version.

Likewise, it is't possible to convey "holes" in the dimensional space described by Vary. For example, a gzip-encoded French response may not be available from the server. This specification does not attempt to address this shortcoming.

Finally, availability hints need to be defined for each axis of content negotiation in use, and the recipient (such as a cache) needs to understand that availability hint. If either condition is not true, that axis of negotiation will fall back to the behaviour specified by Vary.

{{define}} describes how availability hints are defined. {{process}} specifies how availability hints are processed, with respect to the Vary header field. {{definitions}} defines a number of availability hints for existing HTTP content negotiation mechanisms.


## Notational Conventions

{::boilerplate bcp14-tagged}


# Defining Availability Hints {#define}



# Processing Availability Hints {#process}



# Availability Hint Definitions {#definitions}

The following subsections define availability hints for a selection of existing content negotiation mechanisms.

## Content Encoding

> Avail-Encoding: gzip, br

## Content Format

> Avail-Format: image/png, image/gif;d

## Content Language

> Avail-Language: en-uk, en-us;d, fr, de

## Cookie

> Cookie-Indices: id, sid


## Device Pixel Ratio

TBD


> Avail-DPR:

## Downlink

TBD

> Avail-Downlink: (0 1), (1 50);d, (50 max)

## Width

TBD

> Avail-Width: (0 640), (641 1024);d, (1025 max)

## Sec-CH-UA

TBD

## Sec-CH-UA-Platform

TBD


## Device-Memory

TBD



## RTT

TBD


## ECT

> Avail-ECT: (slow-2g 2g 3g), (4g);d

TBD


## Save-Data

TBD


# IANA Considerations

TBD

# Security Considerations

TBD


--- back

