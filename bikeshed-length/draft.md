---
title: Advisory Content-Length for HTTP
abbrev:
docname: draft-nottingham-bikeshed-length-00
date: {DATE}
category: info

ipr: trust200902
area: General
workgroup: HTTP
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

The HTTP Content-Length header field is overloaded with (at least) two duties: message delimitation in HTTP/1, and metadata about the length of an incoming request body to the software handling it.

This causes confusion, and sometimes problems. This document proposes a new header to untangle these semantics (at least partially).


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/bikeshed-length>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/bikeshed-length/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/bikeshed-length>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-bikeshed-length/>.

--- middle

# Introduction

The HTTP Content-Length header field ({{!RFC7230}}) is overloaded with (at least) two duties: message delimitation in HTTP/1, and metadata about the length of an incoming request body to the software handling it.

Message delimitation is a critical feature of the protocol; it allows more than one message to be sent in a given direction on a connection. It is also security-critical; if it is under attacker control, it's possible to confuse a recipient about how requests and responses are associated in HTTP/1.1 (as "smuggling" attacks).

As such, it has been treated progressively more strictly in HTTP specifications. HTTP/1.1 introduced chunked transfer encoding, and forbade sending Content-Length when it is in use. From {{?RFC2616}}:

> Messages MUST NOT include both a Content-Length header field and a
   non-identity transfer-coding. If the message does include a non-
   identity transfer-coding, the Content-Length MUST be ignored.
>
> If a message is received with both a
  Transfer-Encoding header field and a Content-Length header field,
  the latter MUST be ignored.

{{?RFC7230}} strengthened that to:

> A sender MUST NOT send a Content-Length header field in any message that contains a Transfer-Encoding header field.
>
> If a message is received with both a Transfer-Encoding and a Content-Length header field, the Transfer-Encoding overrides the Content-Length. Such a message might indicate an attempt to perform request smuggling (Section 9.5) or response splitting (Section 9.4) and ought to be handled as an error. A sender MUST remove the received Content-Length field prior to forwarding such a message downstream.

HTTP/2 ({{?RFC7540}}) does not use Content-Length for message delimitation, but still requires it to match the number of bytes that its framing mechanism sends:

> A request or response that includes a payload body can include a content-length header field. A request or response is also malformed if the value of a content-length header field does not equal the sum of the DATA frame payload lengths that form the body.

It further requires such malformed responses to generate a "hard" error, so that a downstream recipient that implements HTTP/1 can't be attacked:

> Intermediaries that process HTTP requests or responses (i.e., any intermediary not acting as a tunnel) MUST NOT forward a malformed request or response. Malformed requests or responses that are detected MUST be treated as a stream error (Section 5.4.2) of type PROTOCOL_ERROR.
>
> For malformed requests, a server MAY send an HTTP response prior to closing or resetting the stream. Clients MUST NOT accept a malformed response. Note that these requirements are intended to protect against several types of common attacks against HTTP; they are deliberately strict because being permissive can expose implementations to these vulnerabilities.

The currently proposed HTTP/3 specification {{?I-D.ietf-quic-http}} has language similar to that in HTTP/2.

Unfortunately, this makes _other_ uses of Content-Length more difficult to implement. In particular, many servers will reject a request without an explicit Content-Length using 411 (Length Required), but depending on the protocol version(s) between the user agent and the origin server, a Content-Length header might not make it all the way, or the request might be rejected.

Likewise, some applications would like to use Content-Length to indicate progress of a large download, but its successful traversal cannot be relied upon.

While it's questionable whether all of the requirements above regarding Content-Length are honoured by implementations uniformly, there is enough diversity in implementation (particularly on the server side and in intermediaries) to make deployment of them daunting.

Therefore, this specification proposes a new HTTP header field to carry _advisory_ content length information. It is intended only for these uses, and _not_ message delimitation.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.


# The Bikeshed-Length HTTP Header Field

NOTE: The final name of this header field will be selected using a to-be-defined process. Warm up your paintbrushes...

The Bikeshed-Length HTTP header field is a HTTP Structured Field {{!I-D.ietf-httpbis-header-structure}} that conveys an advisory content length for the message body:

~~~ abnf
Bikeshed-Length = sh-item
~~~

Its value MUST be an Integer (Section x.x of {{!I-D.ietf-httpbis-header-structure}}), indicating a decimal number of octets for a potential payload body.

Note that it is specifically a header field; it is not allowed to occur in trailer sections, and SHOULD be ignored if encountered there.

## Example

A resource might allow requests with bodies up to a given size. If an incoming request omits both Content-Length and Bikeshed-Length, they can respond with 411 (Length Required). If either request header field is present, and the value given is not acceptable, they can respond with 413 (Payload Too Large). If Bikeshed-Length is used and deemed to be acceptable, the resource still ought to monitor the number of incoming bytes to assure that they do not exceed the anticipated value.


# IANA Considerations

TBD

# Security Considerations

The Value of Bikeshed-Length is advisory only; software that uses it will need to monitor the actual number of octets received to assure that it is not exceeded, and take appropriate action if it is.

--- back
