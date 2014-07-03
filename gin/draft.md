---
title: Granular Information about Networks
abbrev: GIN
docname: draft-nottingham-gin-00
date: 2014
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
    uri: http://www.mnot.net/

normative:
  RFC2119:
  RFC1035:
  RFC7230:

informative:
  RFC0793:
  RFC5246:
  netinfo:
    target: http://www.w3.org/TR/netinfo-api/
    title: The Network Information API
    author:
      - organization: W3C
    date: 2014
  bytemobile:
    target: http://www.citrix.com/products/bytemobile-adaptive-traffic-management/overview.html
    title: ByteMobile Adaptive Traffic Management
    author:
      - organization: Citrix
    date: 2014
  verizon: 
    target: http://www.vzwdevelopers.com/aims/downloads/wapoptout/Optimized_View_for_Mobile_Website_Developers_Guide.pdf
    title: VERIZON WIRELESS OPTIMIZED VIEW FOR MOBILE WEB
    author:
      - organization: Verizon
    date: 2014
  syniverse:
    target: http://www.syniverse.com/products-services/product/Hosted-Data-Optimization
    title: Hosted Data Optimization
    author:
      - organization: Syniverse
    date: 2014
  flashnet:
    target: http://www.flashnetworks.com/Optimization-Overview
    title: Optimization Overview
    author:
      - organization: Flash Networks
    date: 2014

--- abstract

Protocol endpoints often want to adapt their behavior based upon the current
properties of the network path, but have limited information available to aid
these decisions. This document motivates and proposes a protocol that makes
this information available.


--- middle

# Introduction

Protocol endpoints often want to adapt their behavior based upon the current properties of the
network path.

For example, it has become common practice for HTTP {{RFC7230}} servers to adapt the responses they
give based upon the IP address of the client, client "fingerprinting" (e.g., using the User-Agent
request header field), and other properties.

Likewise, client using HTTP sometimes adapt their behavior in a similar fashion; for example, a
mobile client on a 3G network might download a different video file then if it were on a wifi
network. Often, the goal of these adaptations is to improve user experience by making content more
suitable for the properties of the network it is traversing, whilst utilizing the network resources
more optimally.

There are currently a number of sources of information to inform these decisions, but they share a
few limitations. For example, it is possible to measure delay to a given server using ICMP, but the
results are ephemeral, and may change if a different server has changed.

There have also been attempts to provide relevant information in APIs; for example, {{netinfo}}.
Doing so has proven to be difficult, because of the limited information available to the client.

To address these issues, network operators have been deploying infrastructure that uses the
information available to them to modify content; e.g., {{bytemobile}}, {{verizon}}, {{syniverse}},
{{flashnet}}.

However, at the same time, encryption has become more prevalent on the Internet, with many
prominent (and heavily traffic'd) Web sites going HTTPS-only. This frustrates attempts to adapt
content in the network.

This document proposes an alternative approach. By making the information that the network
operators have available to the endpoints, it allows them to make more informed choices about
content, thereby allowing the user experience to be improved and the network to be used more
optimally without requiring that the end-to-end nature of encryption (e.g., in HTTPS) to be
compromised.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Requirements

To be useful to endpoints, the information a network exposes needs to be:

* Specific to the client - General information about network properties is often an improvement over current practice, but to be truly useful, it should be able to be tailored to a specific client IP address.
* Reasonably current - Information from ten minutes ago is often useless; when necessary, an endpoint ought to be able to get information that is fresh (on the granularity of a few seconds).
* Scalable - The overhead of conveying information to clients ought to be minimal, and it needs to be usable on the scale of a large Web site.
* Private - The protocol ought not expose details of private networks, or any personally identifying information beyond that already available.

A protocol for exposing this information necessarily must choose the scope of its applicability.
Due to the nature of the Internet, it is not practical to meet the goals above for any given pair
of IP addresses; the permutations are impractical, and discovering meaningful information on this
scale is likewise unlikely.

However, it is comparatively easy for a network operator to expose what it considers to be the
"last mile" properties of an IP address. For example, an ISP providing ADSL access to its
subscribers could advertise the properties of those end links, whereas a mobile operator could use
the information available to advertise the properties of individual subscriber handset IP addresses
(whether they be globally routable, or behind NAT).

Furthermore, a protocol for such information should expose a minimum of:

* Bandwidth - an approximation of the bandwidth currently unused on the "last mile" connection, in bits per second.
* Delay - an approximation of delay seen on the "last mile" connection, in milliseconds.
* Packet Loss - the current packet loss seen on "last mile" connections from the client, expressed as a percentage.

Additional metrics (including some that are operator-specific) might also be useful, and ought to
be accommodated.

This information, in turn, could be used by Web servers, browsers and other tools to optimize both
the responses and requests made. For example, MPEG-DASH clients could use the information about
their own address to better choose an encoding; servers could re-encode images and HTML to account
for slow networks, based upon the requesting client's IP address.


# Granular Information about Networks: Straw-Men

NOTE: the technical mechanisms discussed are straw-men, and might not be the "real" approach.
Readers are encouraged to consider and discuss the overall viability of the idea expressed above
before focusing too much upon the details below.

## DNS

One approach would be to using DNS {{RFC1035}} to convey this information. This has
several advantages:

* DNS works at the granularity of an IP address
* Reverse DNS for a public IP address is often administered by the access network that provisions it
* DNS is lightweight and has a built-in caching mechanism

This would require a new RRTYPE to be defined to carry the information outlined above.


## HTTP

It might be possible to provide such information with a lightweight HTTP {{RFC7230}} service
exposed by the network operator. However, discovery of that service would still need to be
established; this might be possible through DNS.

HTTP offers built-in caching, and is familiar to many developers. However, it has a higher
overhead, as compared to DNS.


## TLS

Another approach would be to add another channel in TLS {{RFC5246}} that does not form part of teh encrypted
session, to allow the network to annotate connections directly.

However, this is likely to be both technically invasive, and seen as a layer violation / security
heresy.

## TCP

Yet another approach would be to allow simliar mechanisms in TCP {{RFC0793}}. However, it's even
less likely that this would be technically feasible or politically possible.


# Security Considerations

This proposal is only exploratory now, but there are already clearly evident security and privacy implications, including:

* Whether the information exposed can be used to identify a user
* Whether denial of service attacks are possible using this mechanism


--- back
