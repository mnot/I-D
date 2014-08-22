---
title: The Web Proxy Description Format
abbrev: Web Proxy Description
docname: draft-nottingham-web-proxy-desc-00
date: 2014
category: std

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
  RFC2818:
  RFC3986:
  RFC4632:
  RFC7159:
  RFC7230:
  RFC7234:
  I-D.ietf-httpbis-http2:
  W3C.CR-html5-20140731:

informative:
  RFC5246:
  RFC5785:
  RFC7231:


--- abstract

This specification defines a simple means of configuring Web proxies, and places additional
requirements upon them in order to promote improved interoperability, security, and error handling.

--- middle

# Introduction

Web proxies are configured in a variety of ways today, but existing approaches suffer from
security, usability and interoperability issues.

This specification defines:

* A simple format for describing a Web proxy ("WPD"; see {{wpd}}) to facilitate configuration, and
  so that it can be represented to users in a consistent way, and
* A way to discover the proxy description using a well-known URL {{discover}}, so that direct
  configuration of a proxy is as simple as entering a hostname, and
* A set of additional requirements for proxies described in this fashion, as well as requirements
  for User Agents connecting to them, designed to improve security, usability and interoperability.

It can be used in a variety of ways, but is designed to meet the following goals:

* Users should always be aware of a configured proxy and be able to confidently identify it, and
* Configuring a proxy should be a deliberate act, but simple to do for non-technical users, and
* Proxies should always respect the wishes of the end user and Web site, and
* Proxies should never reduce or compromise the security of connections, and improve it where
  possible, and
* The proxy should be able to reliably communicate with the end user regarding its policies and
  problems that are encountered.

Furthermore, it is designed to be useful in the following cases:

* An end user wants to use a proxy network that provides improved performance, by re-compressing
  responses to http:// resources.
* An end user wants to use a proxy network that provides improved privacy, by routing requests
  through any number of intermediaries.
* An end user is required to use a proxy to access Internet resources by their network (e.g., a
  school, workplace or prison).
* A network wants to offer enhanced access to selected Web sites, through interposition of a proxy.

Importantly, this specification does not address the automatic discovery of proxy configuration for
a given network.

It is expected that the mechanisms described could be implemented by a single program (e.g., a Web
browser), or through an Operating System facility.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Web Proxy Description (WPD) Format {#wpd}

WPD is a JSON {{RFC7159}} format that describes a Web proxy to its clients. Its root is an object
containing WPD-specific object members. For example:

    {
        "name": "ExampleCorp Web Proxy",
        "desc": "ExampleCorp's Proxy Gateway for Web access. Note that
                 all traffic through this proxy is logged, and may be
                 filtered for content."
        "moreInfo": "https://inside.example.com/proxy/",
        "proxies": [
            {
                "host": "proxy.example.com",
                "port": 8080,
                "validNetworks": ["192.0.2.0/24"]
                },
            {
                "host": "proxy1.example.com",
                "port": 8080,
                "validNetworks": ["192.0.2.0/24"]
            }
        ],
        "omitDomains": ["example.com", "192.0.2.0/24"],
		"allowDirect": True,
		"failPage": "https://www.example.com/proxy-fail"
    }


When configuring a proxy through WPD, the User agent SHOULD present the relevant information
contained within (i.e., the 'name', 'desc' and 'moreInfo' members, the latter as a link) to the end
user. User agents SHOULD also make this information available to the end user whenever the WPD is
in use.

The remainder of this section defines the content of these members. Unrecognized members SHOULD
be ignored.

## name

A string containing a short, memorable name for the proxy; typically 64 characters or less. This
member MUST be present.

## desc

A string containing a textual description of the proxy's function(s); typically 256 characters or
less. This member MUST be present.

## moreInfo

A string containing a URI {{RFC3986}} that leads to more information about the proxy, its
operation, who operates it, etc. The URI MUST have a scheme of "https" {{RFC7230}}, and MUST be
able to respond with an HTML {{W3C.CR-html5-20140731}} representation. This member MUST be present.

## proxies

An array containing one or more proxy objects; each proxy object represents a proxy endpoint that
can be used when this proxy is configured.

Proxy objects' members are defined by the following subsections; unrecognized members SHOULD be
ignored.

The ordering of proxy objects within the proxies array is not significant; clients MAY choose any
proxy they wish (keeping in mind the requirements of validNetworks), and MAY use more than one at a
time.

When connecting to a WPD proxy, clients MUST use TLS and MUST validate the hostname as per
{{RFC2818}} Section 3.1. If the proxy presents an invalid certificate, that proxy MUST be
considered "failed" and not used (until a valid certificate is presented).

WPD Proxies MUST support HTTP/2 {{I-D.ietf-httpbis-http2}} connections from clients. Clients
that cannot establish a HTTP/2 connection to a WPD proxy MUST consider that proxy "failed."

WPD Proxies MUST support forwarding requests with the "http" scheme {{RFC7230}}, and SHOULD support
the CONNECT method, as specified in {{I-D.ietf-httpbis-http2}} Section 8.3.

When user agents encounter 5xx responses to a CONNECT request from a WPD proxy, they MUST present
the response to the end user, but MUST NOT present or process it as a response to the eventual
request to be made through the tunnel (i.e., it has an identified payload, as per {{RFC7231}}
Section 3.1.4.1).

If a proxy becomes unresponsive, clients SHOULD consider it failed and attempt to use another proxy
(if available) or inform the end user (if not available). Clients SHOULD regularly attempt to
re-establish contact with failed proxies (e.g., every minute).

NOTE: the array of proxy objects is functionally similar to, but not as expressive as, the
commonly-used "proxy.pac" format. While it would be expedient for WPD to just reference a
proxy.pac, feedback so far is that proxy.pac has a number of deficiencies, and interoperability
over it is poor. Therefore, this document specifies the proxy object instead, in order to gather
feedback on an alternative approach.

### host

A string containing the host (as per {{RFC3986}}, section 3.2.2) of the proxy. This member MUST be
present.

### port

A number representing the port that the proxy is listening on. This member MUST be present, and
MUST be an integer.


### validNetworks

An array containing strings; each string contains a classless prefix {{RFC4632}} which the proxy
can be used within. Clients MUST NOT attempt to use the proxy if their IP address is within one
of the stated ranges.

This member is optional.

For example, if the value of validNetworks is

   [ "192.168.1.0/32", "192.168.2.0/24" ]

then the only clients that could use the proxy would have IP addresses in the ranges 192.168.1.0 to
192.168.1.3 and 192.168.2.0 to 192.168.2.255.


## forReferers

An array containing strings; each string is a host (as per {{RFC3986}} Section 3.2.2). Clients
MUST use the WPD's proxies to access these domains, as well as for traffic generated by that
content.

This member is optional.

For example, if the value of forReferers is 

    [ "friendface.example.com" ]

then requests to "friendface.example.com", "www.friendface.example.com",
"app.friendface.example.com" etc. would use the associated proxy; likewise, if processing a
response from one of these hosts generated further requests to "images.example.net" and
"scripts.example.org", they would also use the proxy.

TODO: tighten up what "processing" means here; the intent is to omit a href


## omitDomains

An array containing strings; each string is either a host (as per {{RFC3986}} Section 3.2.2) or a
classless prefix {{RFC4632}}. Clients MUST NOT use the WPD's proxies to access those nominated
host, nor hostnames that have the host as a root. Likewise, clients MUST NOT use the WPD's proxies
to access bare IP addresses that fall within the classless prefix.

Note that when a "bare" IP address or classless prefix is used in omitDomains, clients are not
required to perform a reverse lookup on hostnames; these forms are only intended for accessing URLs
that use the IP-literal or IPv4address forms.

This member is optional.

For example, if the value of omitDomains is:

    [ "example.com", "192.168.5/24" ]
	
then requests to "example.com", "www.example.com", "foo.example.com" etc would not use the proxy.
Likewise, requests whose URL authority were bare IP addresses in the range 192.168.5.0 to
192.168.5.255 would not use the proxy.


## allowDirect

A boolean indicating whether the client should attempt to directly access the origin server if
all applicable proxies are unavailable. 

When False, clients MUST NOT attempt to directly access the origin server when no proxy is
available, but instead SHOULD inform the user that the proxy is unavailable. if failPage is available, user agents SHOULD render it to users instead.

When True, clients MAY do so.

Here, "unavailable" means when the proxy is refusing connections, or not answering HTTP/2 pings. A
stalled connection or HTTP 5xx error SHOULD NOT cause it to be considered unavailable on their own,
since these conditions could be caused by upstream servers or networks.

Clients SHOULD regularly (e.g., every 30 seconds) probe "down" proxies for availability.


## failPage

A string containing a URL {{RFC3986}} for a Web page (most likely in HTML) that SHOULD be presented
to users when no suitable proxy is available.

By its nature, the failPage is not fetched through a proxy.



# Discovering WPD Files {#discover}

To facilitate easy configuration of Web proxies, this specification defines a well-known URI
{{RFC5785}}. Doing so allows a proxy's description to be found with a simple hostname; e.g.,
"proxy.example.net" or even just "example.net".

## The web-proxy-desc well-known URI {#well-known}

The "web-proxy-desc" well-known URI allows discovery of a Web Proxy Description ({{wpd}}).

This well-known URI is only valid when used with the "https" URI Scheme {{RFC7230}}; it MUST NOT be
used with "http" URIs. In other words, WPD discovery is always protected by TLS {{RFC5246}}.

The description found at this location is considered valid for its freshness lifetime, as defined
in {{RFC7234}} Section 4.2. Once stale, clients SHOULD refresh it and apply any changes.

If the WPD is not retrievable (e.g., a 404 response status), invalid (as per JSON {{RFC7159}} or
the requirements in {{wpd}}), or its certificate is not valid for the host (as per {{RFC2818}}
Section 3.1), the client MUST NOT use the WPD, and if a user agent, SHOULD inform the end user.

The well-known URI MAY use proactive content negotiation ({{RFC7231}} Section 3.4.1) to select an
appropriate language for the response representation. Therefore, clients SHOULD send an
Accept-Language request header field ({{RFC7231}} Section 5.3.5) when they wish to advertise their
configured language.

The registration template is:

* URI suffix: web-proxy-desc
* Change controller: IETF
* Specification document(s): [this document]
* Related information: only to be used with 'https' scheme



# IANA Considerations

This specification registers a new well-known URI, as per {{RFC5785}}. See {{well-known}} for the
template.

# Security Considerations

If a user can be convinced to configure a WPD hostname as their proxy, that host can observe all
unencrypted traffic by the client. As such, WPD configuration interfaces ought only allow
configuration of proxies once their identity is validate (as required), and the user ought to be
given access to all relevant information about the WPD proxy (i.e., 'name', 'desc' and 'moreInfo',
the latter as a link). Furthermore, WPD proxies ought only be configured as the result of an
intentional act, not as a side effect of normal Web browsing.

# Acknowledgements

Thanks to Patrick McManus for his feedback and suggestions.

--- back
