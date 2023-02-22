---
title: HTTP Availability Hints
abbrev:
docname: draft-nottingham-http-availability-hints
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/SHORT"

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


--- abstract



--- middle


# Introduction

The HTTP Vary header field ({{}}) allows an origin server to describe to clients what aspects of requests it will take into account when producing a response for a URL. This information is useful in many ways; most prominently, downstream caches can use it to select the correct stored response for a given request to that URL ({{}}).

However, the information conveyed by Vary is limited. If the request headers enumerated in it are considered as a n-dimensional space with each field representing an axis, this response header:

> Vary: Accept-Encoding, Accept-Language, ECT

indicates that there is a three-dimensional space of potential responses that could be sent. However, not much more than that is conveyed; the number and nature of the entries on each axis are not available, leaving caches and other downstream consumers none the wiser.

This design makes using Vary difficult. A cache that has a selection of stored responses doesn't have enough information available to it to decide whether or not they are the best ones to satisfy a request in all but the most simple circumstances. For example, if the request indicates that the client prefers responses in the French language, but will accept English, and the cache has a stored English response, what is the appropriate action? Should it serve the English response, or should it make a request to the server for a French response and hope that one might be available -- introducing significant latency if it is not?

This specification defines a new type of HTTP header field -- an _availability hint_ -- that augments the information on a single axis of content negotiation, by describing the selection of responses that a server has available along that axis. So, our example above might become:

> Vary: Accept-Encoding, Accept-Language, ECT
> Avail-Encoding: gzip, br
> Avail-Language: fr, en;d
> Avail-ECT: (slow-2g 2g 3g), (4g);d

This says that there are two encodings available -- gzip and brotli -- beyond the mandatory "identity" encoding; that both French and English are available, but English is the default if no preference is stated; and that there are two different representations available depending on the Effective Connection Type that the client advertises, with "4g" being the default.

Caches and other clients can use this information to intuit when a request can be satisfied by a given response, and what other options might be available. Using the example above, we can know that the response for a request with an ECT of "2g" is the same as that for "3g", even though it doesn't have the latter at hand.

Availability hints need to be specified for each individual content negotiation axis that they might apply to. An availability hint specification needs to:
* Define how to convey the


Availability hints have some limitations. While a server's preferences along a single axis of negotiation can be conveyed, its relative preferences between them are not. In the example above, it isn't possible to know whether the server prefers that downstream caches and clients use the brotli-encoded French version over the gzip-encoded English version.

Likewise, it is't possible to convey "holes" in the dimensional space described by Vary. For example, a gzip-encoded French response may not be available from the server. Since addressing this shortcoming would make these responses much more verbose, this shortcoming is not addressed by this specification.



## Notational Conventions

{::boilerplate bcp14-tagged}


# Defining Availability Hints



# Availability Hint Definitions

## Content Encoding

Avail-Encoding: gzip, br
Content-Encoding: gzip

## Content Format

Avail-Format: image/png, image/gif;d
Content-Type: image/png

## Content Language

Avail-Language: en-uk, en-us;d, fr, de
Content-Language: en-us

## Cookie

Cookie-Indices: id, sid


## Device Pixel Ratio

Avail-DPR:
DPR:

## Downlink

Avail-Downlink: (0 1), (1 50);d, (50 max)


## Width

Avail-Width: (0 640), (641 1024);d, (1025 max)
Width:

## Sec-CH-UA

## Sec-CH-UA-Platform


## Device-Memory

## RTT

## ECT

> Avail-ECT: (slow-2g 2g 3g), (4g);d

## Save-Data


# IANA Considerations

# Security Considerations


--- back

