---
title: "HTTP/2: Operational Considerations for Servers"
abbrev: HTTP/2 Server Ops
docname: draft-nottingham-http2-ops-00
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
    organization: Akamai Technologies
    email: mnot@mnot.net
    uri: http://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This document gives advice regarding performance and operability to servers deploying HTTP/2.

--- middle

# Introduction

HTTP/2 {{I-D.httbis-http2}} does not change the semantics of HTTP {{}}, but it does substantially
change how they are mapped to the underlying protocols.

While some of these changes can enhance performance and/or operability on their own, getting the full benefit of the new protocol requires changes beyond the scope of just the Web server.

Likewise, HTTP/2 offers new in-protocol mechanisms like header compression, flow control,
prioritisation and server push. Used effectively, they can improve the performance characteristics
of the protocol, but they can also cause operability issues if used incorrectly.

This document gives advice about both cases; how to configure lower-layer protocols, as well as how
to use HTTP/2's in-built mechanisms effectively. 

It is primarily focused on the needs of origin servers, since there are generally many more
instances of origin servers than there are unique client deployments. It is also primarily focused
on the Web browsing use case; however, much of the advice here is applicable to non-browsing uses
as well.

Note that the advice here is specific to when it was written; changes in underlying protocols, deployment practices, and HTTP itself may obsolete it at any time. As such, it is not intended to be
long-lived, but instead to aid initial deployment of the new protocol.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# TCP Configuration

HTTP/2 has been designed to use a single TCP connection, whereas current practice for HTTP/1 is to
use multiple connections to acheive parallelism (generally, between four and eight).

The change has a number of benefits. Using fewer TCP connections to load a Web page consumes less
server-side resources, and it also reduces the chance of a congestion event caused by a large
number of connections simulataneously starting (overcoming TCP Slow Start), and returns HTTP to
being a "fair" protocol. Using a single connection also enables better efficiency with header
compression.

However, using a single connection can also lead to unfavourable performance, as compared with
HTTP/1's use of multiple connections, primarily due to side effects of TCP congestion control.

In particular, a single HTTP/2 connection with an initcwnd of 3 can only have three unacknowledged
packets during the startup phase of the connection, whereas (for example) six HTTP/1 connections
would have as many as 18 packets outstanding. This places HTTP/2 at a significant disadvantage
compared to HTTP/1, but can be mitigated by adopting an initcwnd of 10 for HTTP/2 connections, as
outlined in {{RFC6928}}.

Similarly, a congestion event on a HTTP/2 connection can cause disproprortionate havoc, as compared
to HTTP/1, in those cases where the event only affects a subset of open connections (such as random
packet loss). TBD: mitigation

Key recommendations:
 * HTTP/2 servers SHOULD adopt an initcwnd of 10, as per {{RFC6928}}.


# TLS Configuration

Beyond the typical performance and operational considerations of deploying TLS {{RFC5246}}, a
concern specific to HTTP/2 is the TLS record size; because HTTP/2 is a multiplexed protocol, a
large record size can cause packet loss to affect a disproportionate number of streams, due to an
individual record not being available until it is complete.

Therefore, small record sizes are preferred for HTTP/2; if a record is sent within a single packet,
the chances of blocking are minimised. That said, records ought not be much smaller, since this
will increase processing overhead, and in some circumstances (e.g., non-interactive applications,
downloads), it may be reasonable to have larger record sizes.

Key recommendations:
 * HTTP/2 servers SHOULD use a small TLS record size; ideally, small enough that a record fits completely in a single packet.


# Load Balancing and Failover 

It's common to use multiple servers to server a single HTTP origin, in order to provide a scalable
and reliable service. DNS is also commonly used to direct clients to the best (by some metric)
server available.

In HTTP/1, the transition from one server to another in these scenarios is often done between
connections; because HTTP/1 connections are generally short-lived, it's possible to load balance
clients as they re-connect.

HTTP/2, however, is designed to have fewer, longer-lived connections, and it's anticipated that
clients will be keeping them open much more aggressively. This provides fewer opportunities for
servers to shift traffic. If a server breaks connections pre-emtively in order to load balance or
failover, it can also have a greater negative effect, since more than one request can be "in
flight" simultaneously.

The new protocol accommodates these situations in a few ways, improving operability along the way.

Firstly, the GOAWAY frame allows servers to announce that they will not serve additional requests on
a connection, while still completing those that preceed the GOAWAY. This allows a connection to be
shut down in an orderly fashion, and its use is required in HTTP/2.

Additionally, the ALTSVC frame allows a server to redirect traffic to another location, without
changing the resource's URL. This can be used for load balancing (both local and global), as well
as controlled failover of services.


# Use of HPACK

TBD

# Use of Flow Control

TBD

# Use of Prioritisation

TBD

# Use of Server Push

TBD


# Security Considerations

This document introduces no unique security considerations beyond those discussed in HTTP/2 itself.


# Acknowledgements

TBD

--- back
