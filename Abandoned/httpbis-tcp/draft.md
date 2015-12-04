---
title: TCP Performance Tuning for HTTP
abbrev: TCP for HTTP
docname: draft-stenberg-httpbis-tcp-00
date: 2015
category: bcp

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: D. Stenberg
    name: Daniel Stenberg
    organization: 
    email: daniel@haxx.se
    uri: http://daniel.haxx.se

normative:
  RFC2119:
  RFC7230:
  RFC0793:

informative:
  RFC7430:
  RFC6928:
  

--- abstract

This document records current best practice for using all versions of HTTP over TCP.

--- middle

# Introduction

HTTP {{RFC7230}} is currently defined to use TCP {{RFC0793}}, and its performance can depend greatly upon
how TCP is configured. This document records best current practice for using HTTP over TCP, with a
focus on improving end-user perceived performance.

These practices are generally applicable to HTTP/1 as well as HTTP/2, although some may note
particular impact or nuance regarding a particular protocol version.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# TCP Fast Open

TCP Fast Open (a.k.a. TFO, {{RFC7430}}) allows data to be sent on the TCP handshake, thereby
allowing a request to be sent without any delay if a connection is not open.

TFO requires both client and server support, and additionally requires application knowledge,
because the data sent on the SYN cannot be idempotent. Therefore, TFO can only be used on
non-idempotent, safe methods (e.g., GET and HEAD), or with intervening negotiation (e.g, using TLS).

Support for TFO is growing in client platforms, especially mobile, due to the significant
performance advantage it gives.


# Initial Congestion Window

{{RFC6928}} specifies an initial congestion window of 10, and is now fairly widely deployed
server-side. There has been experimentation with larger initial windows, in combination with packet
pacing.


# Packet Pacing

TBD


# Explicit Congestion Control

Apple [deploying in iOS and OSX](https://developer.apple.com/videos/wwdc/2015/?id=719).


# Tail Loss Probes

[draft](http://tools.ietf.org/html/draft-dukkipati-tcpm-tcp-loss-probe-01)

# Slow Start after Idle

    net.ipv4.tcp_slow_start_after_idle = 0

# Nagle's Algorithm

Most implementations disable

# Half-close

Client or server is free to half-close after a request or response has been completed; or when there is no pending stream in HTTP/2.


# Abort

No client abort for HTTP/1.1 after the request body has been sent. Delayed full close is expected following an error response to avoid RST on the client.


# Keep-alive

TCP keep-alive likely disabled. App-level keep-alive is required for long-lived requests to detect failed peers.
  


# IANA Considerations

This document does not require action from IANA.

# Security Considerations


--- back
