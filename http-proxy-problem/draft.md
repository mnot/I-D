---
title: Problems with Proxies in HTTP
abbrev: HTTP Proxy Problems
docname: draft-nottingham-http-proxy-problem-00
date: 2013
category: info

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
    uri: http://www.mnot.net/

normative:
  RFC2119:

informative:
  RFC2616:
  RFC2818:
  RFC3040:
  RFC5246:
  RFC6585:
  W3C.CR-ct-guidelines-20100617:
  I-D.mbelshe-httpbis-spdy:
  proxypac:
    target: http://en.wikipedia.org/wiki/Proxy_auto-config
    title: Proxy Auto-Config
    author:
      ins: various
      name: various
    date: 2013
  wpad:
    target: http://tools.ietf.org/html/draft-ietf-wrec-wpad-01
    title: Web Proxy Auto-Discovery Protocol
    author:
      ins: J. Cohen
      name: Josh Cohen et al
    date: 1999
  https-everywhere:
    target: https://www.eff.org/https-everywhere
    title: HTTPS Everywhere
    author:
      ins: EFF
      name: Electronic Freedom Foundation
    date: 2013

--- abstract

This document discusses the use and configuration of proxies in HTTP, pointing
out problems in the currently deployed infrastructure along the way. It then
offers a few principles to base further discussion upon, and lists some
potential avenues for further exploration.

--- middle

# Introduction

Using proxies to gain access to the Web has long been a feature of HTTP
{{RFC2616}}. While they are interposed for a variety of reasons, they are often
motivated by the needs of the network operator, rather than the end user behind
the browser or the origin server being accessed.

When combined with the visibility into message flows that proxies have
(especially when unprotected by {{RFC5246}}), this mismatch of incentives leads
to situations that many consider abusive, leading to questions about the
legitimacy of proxies in general.

This document attempts to catalogue the reasons that proxies are used, the ways
they are deployed, highlighting related problems. It then suggests some
principles to base further discussion upon, along with suggestions for areas
where further investigation may yield solutions (or at least mitigations) for
some of these problems.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.



# Why Proxy?

This section attempts to identify the different motivations networks have for
deploying proxies, characterizing whether each is seen as a legitimate use of
proxies, and under what conditions.

## Request Routing

Some networks do not have direct Internet connectivity for Web browsing. These
networks can deploy proxies that do have Internet connectivity and then
configure clients to use them.

Such request routing using HTTP is seen as legitimate, as long as the request
is still sent to the origin server that the user agent intended.

However, some proxies may divert requests to servers other than the intended
origin. For example, there is anecdotal evidence that a small number of
networks re-route requests to advertising servers to their own servers, in an
attempt to co-opt the associated revenue. This is really a form of content
modification, discussed below.

## Caching

An extremely common use of proxies is to interpose a HTTP cache, in order to
save bandwidth, improve end-user perceived latency, increase reliability, or
some combination of these purposes.

HTTP defines a detailed model for caching; when it is adhered to, caching
proxies are seen as legitimate (although some lesser-known aspects of the
caching model can cause operational issues).

However, proxy caches sometimes fail to honor the HTTP caching model, reusing
content when it should not have been. This can cause interoperability issues,
with the end user seeing "stale" content, or applications not operating
correctly.

## Network Policy Enforcement

Some proxies are deployed to aid in network policy enforcement; for example, to
control access to the network, requiring a login (as allowed explicitly by
HTTP's proxy authentication mechanism), bandwidth shaping of HTTP access,
quotas, etc.

These use cases are generally seen as legitimate; that is, a network operator
can choose to disallow access to their network and place reasonable limits or
conditions upon its use.

## Content Filtering (a.k.a. Content Policy Enforcement)

Some networks attempt to filter HTTP messages (both request and response) based
upon a number of criteria. For example, they might wish to stop users from
downloading content that contains malware, or that violates site policies on
appropriate content, or that violates local law.

Intermediary proxies are a notoriously poor mechanism for enforcing content
policy, because they are often easy to circumvent. For example, a device might
become infected by using a different network. Nevertheless, proxies are a
common tool for content policy enforcement.

Some content policy enforcement is also done locally to the user agent; for
example, several Operating Systems have machine-local proxies built in that
scan content. 

The legitimacy of content filtering is controversial, often depending on the
context it is used within and how it is performed.


## Content Modification

Some networks modify HTTP messages (both request and response) as they pass
through proxies. This might include the message body, headers, request-target,
method or status code.

Motivation for content modification varies. For example, some mobile networks
interpose proxies that modify content in an attempt to save bandwidth, or
transcode content to formats that limited-resource devices can more easily
consume.

In other cases, content modification is performed to make more substantial
modifications. This could include inserting advertisements, or changing the
layout of content in an attempt to make it easier to use.

The legitimacy of content modification is controversial, often depending on the
context it is used within and how it is performed. Many feel that, without the
explicit consent of either the end user or the origin server, a proxy that
modifies content violates their relationship, thereby degrading trust in the
Web overall.

It should be noted that {{RFC2616}} explicitly allows "non-transparent" proxies
that modify content in certain ways. Such proxies are required to honor the
"no-transform" directive, giving both user agents and origin servers a
mechanism to "opt out" of modifications; however, it is not technically
enforced.

{{W3C.CR-ct-guidelines-20100617}} is a product of the W3C Mobile Web Best
Practices Working Group that attempts to set guidelines for content
modification proxies. Again, it is a policy document, without technical
enforcement measures.



# How Proxies are Interposed

How a proxy is interposed into a network flow often has great affect on
perceptions of its legitimacy. This section catalogues the ways that this
happens, and potential problems with each.


## Manual Configuration

The original way to interpose a proxy was to manually configure it into the
user agent. For example, most browsers still have the ability to have a proxy
hostname and port configured for HTTP; many Operating Systems have system-wide
proxy settings.

Unfortunately, manual configuration suffers from several problems:

* Users often lack the expertise to manually configure proxies.

* When the user changes networks, they must manually change proxy settings, a
  laborious task. This makes manual configuration impractical in a modern,
  mobile-driven world.

* Not all HTTP stacks support manual proxy configuration. Therefore, a proxy
  administrator cannot rely upon this method.


## proxy.pac and WPAD

The limitations of manual configuration were recognized long ago. The solution
that evolved was a format called "proxy.pac" {{proxypac}} that allowed the
proxy configuration to be automated, once the user agent had loaded it.

Proxy.pac is a JavaScript format; before each request is made, it is dispatched
to a function in the file that returns a string that denotes whether a proxy is
to be used, and if so, which one to use.

Discovery of the appropriate proxy.pac file for a given network can be made
using a DHCP extension, {{wpad}}. WPAD is simple; it conveys a URL
that locates the proxy.pac file for the network.

Unfortunately, the proxy.pac/WPAD combination has several operational issues
that limit its deployment:

* The proxy.pac format does not define timeouts or failover behaviour
  precisely, leading to wide divergence between implementations. This makes
  supporting multiple user agents reliably difficult for the network.

* WPAD is not widely implemented by user agents. 

* In those user agents where it is implemented, WPAD is often not the default,
  meaning that users need to configure its use.


## Interception

The problems with manual configuration and proxy.pac/WPAD have led to the wide
deployment of a third style of interposition; interception proxies.

Interception occurs when lower-layer protocols are configured to route HTTP
traffic to a host other than the origin server for the URI in question. It
requires no client configuration (hence its advantages over other methods). See
{{RFC3040}} for an example of an interception-related protocol.

Interception is problematic, however, because it is often done without the
consent of either the end user or the origin server. This means that a response
that appears to be coming from the origin server is actually coming from the
intercepting proxy.


## Configuration As Side Effect

More recently, it's become more common for a proxy to be interposed as a side
effect of another choice by the user.

For example, the user might decide to add virus scanning -- either as installed
software, or a service that they configure from their provider -- that is
interposed as a proxy.

This approach has the merits of both being easy and obtaining explicit user
consent. However, in some cases, the end user might not understand the
consequences of use of the proxy, especially upon security and interoperability.


# Proxies and HTTP

Deployment of proxies has an effect on the HTTP protocol itself. Because a
proxy implements both a server and a client, any limitations or bugs in their
implementation impact the protocol's use.

For example, HTTP has a defined mechanism for upgrading the protocol of a
connection, to aid in the deployment of new versions of HTTP (such as HTTP/2.0)
or completely different protocol. 

However, operational experience has shown that a significant number of proxy
implementations do not correctly implement it, leading to dangerous situations
where two ends of a HTTP connection think different protocols are being spoken.


# Proxies and TLS

It has become more common for Web sites to use TLS {{RFC5246}} in an attempt to
avoid many of the problems above. More recently, many have advocated use of TLS
more broadly; for example, see the EFF's HTTPS Everywhere {{https-everywhere}}
program, and SPDY's default use of TLS {{I-D.mbelshe-httpbis-spdy}}.

However, doing so engenders a few problems.

Firstly, TLS as used on the Web is not a perfectly secure protocol, and using
it to protect all traffic gives proxies a strong incentive to work around it,
e.g., by deploying a certificate authority directly into browsers, or buying a
sub-root certificate. Considering the current state of TLS on the Web,
escalating the battle between intermediaries and endpoints may not end well for
the latter parties.

Secondly, it removes the opportunity for the proxy to inform the user agent of
relevant information; for example, conditions of access, access denials, login
interfaces, and so on. 

Finally, it removes the opportunity for services provided by a proxy that the
end user may wish to opt into. 

One example of many is when a remote village shares a proxy server to cache
content, thereby helping to overcome the limitations of their Internet
connection. TLS-protected HTTP traffic cannot be cached by intermediaries,
removing much of the benefit of the Web to what is arguably one of its most
important target audiences.


# Principles for Consideration

Every HTTP connection has three major stakeholders; the user (through their
agent), the origin server (possibly using gateways such as a CDN) and the
network that the user uses to access the origin.

Currently, the rights of these stakeholders are defined by how the Web is
deployed. Most notably, networks sometimes change content because they're able
to. On the other hand, if they change it too much, origin servers will start
using encryption. 

Changing the way that HTTP operates therefore has the potential to re-balance
the capabilities and rights of the various stakeholders.


## Proxies Have a Legitimate Place

As illustrated above, there are many legitimate uses for proxies, and they are
a necessary part of the architecture of the Web. While all uses of proxies are
not legitimate -- especially when they're interposed without the knowledge or
consent of the end user and the origin -- this does not mean that ALL proxies
are undesirable.


## Users Need to be Informed of Proxies

When a proxy is interposed, the user needs to be informed about it, so they
have the opportunity to change their configuration (e.g., introduce
encryption), or not use the network at all.


## Users Need to be able to Tunnel through Proxies

When a proxy is interposed, the user needs to be able to tunnel any request
through it without its content (or that of the response) being exposed to the
proxy. 

This includes both "https://" and "http://" URIs. 


## Proxies Can say "No"

A proxy can refuse to forward any request. This includes a request to a
specific URI, or from a specific user, and includes refusing to allow tunnels
as described above.

The "no", however, needs to be explicit, and explicitly from the proxy.


## Changes Need to be Detectable

Any changes to the message body, request URI, method, status code, or
representation header fields of an HTTP message needs to be detectable by the
origin server or user agent, as appropriate, if they desire it.

This allows a proxy to be trusted, but its integrity to be verified.


## Proxies Need to be Easy

It must be possible to configure a proxy extremely easily; the adoption of
interception over proxy.pac/WPAD illustrates this very clearly.


## Proxies Need to Communicate to Users

There are many situations where a proxy needs to communicate with the end user
through the user agent; for example, to gather network authentication
credentials, communicate network policy, report that access to content has been
denied, and so on.

Currently, HTTP has poor facilities for doing so. The proxy authentication
mechanism is extremely limited, and while there are a few status codes that are
define as being from a proxy rather than the origin, they do not cover all
necessary situations.

Importantly, proxies also need a limited communication channel when TLS is in
use, for similar purposes.

Equally as important, the communication needs to clearly come from the proxy,
rather than the origin.


## HTTPS URI Semantics Can't Change

"https://" URIs are widely deployed and currently have the semantics of
end-to-end encryption, albeit with known issues. While educating users about
security is notoriously difficult, the "https://" URI in combination with the
"lock symbol" has gained some amount of broad understanding as indicating
security.

This MUST NOT change; in particular, the HTTP specifications ought not be
rewritten to allow proxies visibility into HTTPS flows.

## Choices are Context-Specific

Getting consent from users, as well as informing them, can take a variety of
forms. For example, if we require that users consent to using a proxy, that
consent could be obtained through a modal dialog in the browser, or through a
written agreement between an employer and their employee.

Likewise, a browser vendor may choose not to implement some optional portions
of the specification, based upon how they want to position their product with
their audience.


## RFC2119 Doesn't Define Reality

It's very tempting for a committee to proclaim that proxies MUST do this and
SHOULD NOT do that, but the reality is that the proxies, like any other actor
in a networked system, will do what they can, not what they're told to do, if
they have an incentive to do it.

Therefore, it's not enough to say that (for example), "proxies have to honor
no-transform" as HTTP/1.1 does. Instead, the protocol needs to be designed in
a way so that either transformations aren't possible, or if they are, they 
can be detected (with appropriate handling by User Agents defined).


## It Needs to be Deployable

Any improvements to the proxy ecosystem MUST be incrementally deployable, so
that existing clients can continue to function.


# Areas to Investigate

Finally, this section lists some areas of potential future investigation,
bearing the principles suggested above in mind.

## Living with Interception

The IETF has long fought against interception proxies, as they are
indistinguishable from Man-In-The-Middle attacks. Nevertheless, it persists as
the preferred method for interposing proxies in many networks.

Unless another mechanism can be found or defined that offers equally attractive
properties to network operators, we ought to consider that they'll continue to
be deployed, and work to find ways to make their operation both more verifiable
and legitimate.


## TLS Errors for Proxies

HTTP's use of TLS {{RFC2818}} currently offers no way for an interception proxy
to communicate with the user agent on its own behalf. This might be necessary
for network authentication, notification of filtering by hostname, etc.

The challenge in defining such a mechanism is avoiding the opening of new
attack vectors; if unauthenticated content can be served as if it were from the
origin server, or the user can be encouraged to "click through" a dialog, it
has severe security implications. As such, the user experience would need to be
carefully considered.


## HTTP Errors for Proxies

HTTP currently defines two status codes that are explicitly generated by a
proxy:

* 504 Gateway Timeout {{RFC2616}} - when a proxy (or gateway) times out going
  forward

* 511 Network Authentication Required {{RFC6585}} - when authentication
  information is necessary to access the network

It might be interesting to discuss whether a separate user experience can be
formed around proxy-specific status codes, along with the definition of new
ones as necessary.


## TLS for Proxy Connections

While TLS can be used end-to-end for "https://" URIs, support for connecting to
a proxy itself using TLS (e.g., for "http://" URIs) is spotty. Using a proxy
without strong proof of its identity introduces security issues, and if a proxy
can legitimately insert itself into communication, its identity needs to be
verifiable.


## TLS for HTTP URIs

To allow users to tunnel any request through proxies without revealing its
contents, it must be possible to use TLS for HTTP URIs.

Proxies can then choose whether to allow such tunneled traffic, and if not, the
user can choose whether to trust the proxy.


## Improving Trust

Currently, it is possible to exploit the mismatched incentives and other flaws
in the CA system to cause a browser to trust a proxy as authoritative for a
"https://" URI without full user knowledge. This needs to be remedied.


## HTTP Signatures

Signatures for HTTP content -- both requests and responses -- has been
discussed on and off for some time.

Of particular interest here, signed responses would allow a user-agent to
verify that the origin's content has not been modified in transit, whilst still
allowing it to be cached by intermediaries.

Likewise, if header values can be signed, the caching policy (as expressed by
Cache-Control, Date, Last-Modified, Age, etc.) can be signed, meaning it can be
verified as being adhered to.

Note that properly designed, a signature mechanism could work over TLS,
separating the trust relationship between the UA and the origin server and that
of the UA and its proxy (with appropriate consent).

There are significant challenges in designing a robust, widely-deployable HTTP
signature mechanism. One of the largest is an issue of user interface - what
ought the UA do when encountering a bad signature?



# Security Considerations

Plenty of them, I suspect.


--- back


# Target Usage Scenarios for Proxies

This section contains a number of target usage scenarios that attempt to
illustrate possible outcomes of the principles and investigations, as an aid in
understanding and discussing them.

As such, these are intended to serve as discussion aids, not formal proposals.


## Virus-Scanning Corporate Proxy

The network administrators for FooCorp believe that an effective component of
their anti-malware strategy is at the border. Therefore, they need to
interpose a proxy that scans incoming response bodies for viruses, etc.

FooCorp users agree, as part of their employment, to grant FooCorp access to
their communications from work.

Therefore, for "http://" URLs, FooCorp decides to block encrypted connections,
and scan the remainder. If a user tries to configure their browser to
optimistically encrypt "http://" URLs, they'll be presented with an error page
that's clearly from FooCorp, describing their policy. Likewise, if they browse
to a URL that returns a virus, they will see a page clearly stating that
FooCorp is blocking access, and why.

FooCorp can make a separate decision as to whether they allow "https://" URLs;
they can block all of them, whitelist some origins, blacklist some origins, or
allow all of them. However, they cannot gain access to either the request
stream (i.e., anything from the request other than the origin), nor any
responses.

When FooCorp employees use the network, they don't have to log in or otherwise
accept the presence of the proxy; however information about the proxy is
available in their browser (e.g., an "about this network" menu item, or an
indicator in the user interface).


## Coffee Shop Capture Proxy

Hobba Cafe serves coffee that would make grown men weep, had they only been
exposed to chain coffee stores before. While they are weeping, these men need
emotional support resources, so the coffee shop offers free WiFi to browser the
Internet.

However, Hobba needs to have users agree to Terms of Use for the network before
surfing. So, they interpose an interception proxy that "captures" users that
aren't logged in, presenting them with a login screen that is clearly from
Hobba.

From the users' standpoint, there are many requirements here. They need to be
sure that the proxy they log into is actually Hobba's, and that no other proxy
can masquerade as them. Furthermore, they'd like to make sure that their
communications aren't sniffed by other users in the coffee shop, so they are
likely to want to optimistically encrypt "http://" URLs.



## Content Filtering School Proxy

The network administrators at the Academy of Basket Weaving want to make sure
that their students aren't accessing inappropriate content. Since they teach
basket weaving to a range of age groups, they need to ascertain who the user is
before applying this policy.

When a student access the ABW network, they're presented with a login page
that's clearly from the Academy. Once their credentials are accepted, students
can browse the Web freely.

However, upon accessing a "http://" URL that the Academy determines the student
shouldn't be exposed to, an error page that is clearly identified as from the
Academy is shown.

Just as in the FooCorp example, the Academy can choose to block or limit
origins of optimistically encrypted "http://" URLs, but cannot "see" anything
other than the origin. Likewise for "https://" URLs.


## Content Transforming Mobile Proxy

The Stationary Mobile Telephone Company wants to improve their customers'
experience by reformatting HTML to look better on their low-cost handsets. Some
users, however, are upset by this, because the well-intentioned rewriting
doesn't always work. Furthermore, some origin servers are unhappy about a third
party rewriting their content.

There are a few possible paths for those unhappy users and content providers to
take. If they encrypt communication (using either a "https://" URL or a
"http://" URL with optimistic encryption), the proxy cannot rewrite the
content, of course. 

However, for unencrypted content, HTTP signatures can be used to verify that
the content has not changed. Presumably, this would be combined with
"Cache-Control: no-transform" to give the proxy warning that modifications are
not desired.


## Shared Community Caching Proxy

The primitive village of Wollongong has a very limited, shared Internet
connection that is often overcome by the traffic of the children using the
popular Club Quoll Web site.

It needs to be as easy as possible to use to be efficient, so they interpose an
interception proxy. 

Since the purpose of the proxy is caching, the village would like to see as
many "http://" URLs unencrypted as possible; as a result, they block
optimistically encrypted "http://" URLs at the proxy, and explain why in a page
that's explicitly from the proxy.

However, users should be assured that the "http://" content they see isn't
modified by the proxy. Likewise, some want to verify that the caching policy of
the Web sites they access is honored by the proxy. Both of these goals can be
achieved using HTTP signatures.


## Evil Attacking Proxy

Finally, some proxies are used to attack end users and origin servers. There
are a variety of possible attacks, but the main goals that need focus are:

* Preventing an attacker from interposing a proxy without user knowledge
* Preventing an attacker from masquerading as a legitimate proxy
* Preventing an attacker from observing communications to and from the proxy
* Preventing an attacker from modifying communications to and from the proxy