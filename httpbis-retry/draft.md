---
title: Retrying HTTP Requests: Current Practice
abbrev: 
docname: draft-nottingham-httpbis-retry-00
date: 2015
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


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/httpbis-retry>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/httpbis-retry/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/httpbis-retry>.


--- middle

# Introduction


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# When Clients Retry

{{RFC7230}} explicitly allows clients to retry requests under specific conditions, in section 6.3.1:

> When an inbound connection is closed prematurely, a client MAY open a new connection and automatically retransmit an aborted sequence of requests if all of those requests have idempotent methods (Section 4.2.2 of [RFC7231]). A proxy MUST NOT automatically retry non-idempotent requests.

> A user agent MUST NOT automatically retry a request with a non-idempotent method unless it has some means to know that the request semantics are actually idempotent, regardless of the method, or some means to detect that the original request was never applied. For example, a user agent that knows (through design or configuration) that a POST request to a given resource is safe can repeat that request automatically. Likewise, a user agent designed specifically to operate on a version control repository might be able to recover from partial failure conditions by checking the target resource revision(s) after a failed connection, reverting or fixing any changes that were partially applied, and then automatically retrying the requests that failed.

> A client SHOULD NOT automatically retry a failed automatic retry.


# Current Implementation Behaviours

In implementations, clients have been observed to retry requests in a number of circumstances.

## Squid

The Squid caching proxy server

[squid](http://bazaar.launchpad.net/~squid/squid/trunk/view/head:/src/FwdState.cc#L594)


## Traffic Server

Apache Traffic Server, a caching proxy server, 

[Traffic Server](https://git-wip-us.apache.org/repos/asf?p=trafficserver.git;a=blob;f=proxy/http/HttpTransact.cc;h=8a1f5364d47654b118296a07a2a95284f119d84b;hb=HEAD#l6408)

## Firefox

http://mxr.mozilla.org/mozilla-release/source/netwerk/protocol/http/nsHttpTransaction.cpp#886
http://mxr.mozilla.org/mozilla-release/source/netwerk/protocol/http/nsHttpTransaction.cpp#1600

## Chrome




# TCP Fast Open





# Security Considerations


--- back
