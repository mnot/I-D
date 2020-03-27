---
title: Unreliable HTTP Payloads
abbrev:
docname: draft-nottingham-unreliable-http-00
date: 2020
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

informative:


--- abstract

This document might eventually specify a way to mark messages (or parts of them) for unreliable delivery in HTTP. For now, it just enumerates some design assumptions in {{assumptions}} to seed discussion.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/unreliable-http>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/unreliable-http/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/unreliable-http>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-unreliable-http/>.

--- middle

# Introduction

Some HTTP applications might benefit from being able to tell the protocol that delivery of data need not be reliable; that is, rather than offering guaranteed end-to-end transmission of the entire message payload, it is preferable to forgo this, because the retransmission of lost data is harmful (or just not useful).

For example, in some cases retransmission of audio or video data might be counterproductive, because use of the data is time-sensitive, and retransmission of loss only competes with more current data "on the wire."

This document might eventually specify a way to do this in HTTP. For now, it just enumerates some design assumptions in {{assumptions}} to seed discussion.

## Design Assumptions {#assumptions}

This document asserts that the following assumptions are necessary for a successful unreliable HTTP mechanism. If you disagree, please discuss on the HTTP WG mailing list, or the issues list above.

An unreliable HTTP delivery mechanism should:

1. Allow unreliable delivery both on requests and responses. While the response side is the most obvious target, requests such as POST can support interesting use cases too.

1. Focus on unreliable delivery of the message body. Header and trailers need to be reliable.

1. Be triggered by an in-protocol mechanism, like a header field or request method. Requiring implementations to have out-of-band knowledge hurts deployment.

1. Be able to fall back to "normal" reliable HTTP on hops that don't support unreliable delivery. This implies that unreliable delivery is an optimisation, not an application semantic.

1. Give _some_ level of feedback to both ends about whether unreliable delivery is in use, end-to-end. Probably also optional loss stats, hop-by-hop. This might be through a header like {{?I-D.ietf-httpbis-proxy-status}}.

1. Provide some way to guarantee that application data is delimited at certain boundaries, to add application loss handling. This might be just a convention that DATAGRAM frames are never combined or split, or it might be something in-protocol.

1. Still provide in-order delivery.



## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

## Some Protocol Mechanism

TBD.


# Security Considerations

Eventually.


--- back
