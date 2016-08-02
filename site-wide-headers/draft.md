---
title: Site-Wide HTTP Headers
abbrev:
docname: draft-nottingham-site-wide-headers-00
date: 2016
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

informative:


--- abstract

This document specifies a mechanism for Web sites to send HTTP header fields that apply to large numbers of resources on an origin via a different, more efficient mechanism, rather than including them in every response.

--- middle

# Introduction

A variety of metadata about Web sites is being conveyed in new HTTP response headers. In particular, it is becoming more common for metadata that applies to an entire Web site to be conveyed in a header field that is included on every response for that site.

For example, `Strict-Transport-Security` {{?RFC6797}} and `Public-Key-Pins` {{?RFC7469}} both define headers that are explicitly scoped to an entire origin {{!RFC6454}}, and number of similar headers are under consideration.

Likewise, some HTTP header fields only sensibly have a single value per origin; for example, `Server`.

Furthermore, some headers are resource-specific, but in some deployments, are uniform across an origin. For example, some sites will have a `CSP` {{?W3C.CR-CSP2-20150721}} header that doesn't vary across the site, or only varies slightly from resource to resource.

This is inefficient. Besides the obvious bandwidth waste due to redundancy in HTTP/1, it also impacts HTTP/2's HPACK {{?RFC7541}} header compression; since the amount of space of available for state is limited (by default, 4K), verbose, repeating headers can greatly reduce the effectiveness of HPACK.

However, when the metadata affects processing of the response, and the application is latency-sensitive (as uses of HTTP so often are), it's not practical to separate the metadata from the response; it needs to be sent on every response so that it is available.

One way to mitigate this problem is to remove these common header fields from responses, and keep them in a separate resource. When clients have fetched that resource and guarantee that they will apply its contents to all responses for that domain, they can indicate this to the server with a small request header; when servers see it, they can safely omit those headers in responses.

This document defines how to do this by using a well-known URI (specified in {{well-known}}) to store these headers in a format specified in {{type}}.


## Example {#example}

If a request to the well-known URI (see {{well-known}}) returns:

~~~
HTTP/1.1 200 OK
Content-Type: text/site-headers
Cache-Control: max-age=3600
ETag: "abc123"
Content-Length: 1234

# a
Strict-Transport-Security: max-age=15768000 ; includeSubDomains
Server: Apache/2.4.7 (Ubuntu)
Public-Key-Pins: max-age=604800; 
  pin-sha256="ZitlqPmA9wodcxkwOW/c7ehlNFk8qJ9FsocodG6GzdjNM=";
  pin-sha256="XRXP987nz4rd1/gS2fJSNVfyrZbqa00T7PeRXUPd15w="; 
  report-uri="/lib/key-pin.cgi"
Cache-Control: max-age=3600
Vary: Accept-Encoding
# b
Server: Apache/2.7.4 (Ubuntu)
Cache-Control: max-age=0
~~~

and a client that has loaded that resource makes the request:

~~~~
GET /images/foo.jpg HTTP/1.1
Host: www.example.com
SM: "abc123"
~~~~

this indicates that the client has processed the site-metatadata resource, and therefore that the server can omit the nominated response header fields on the wire, instead referring to them with the `HS` response header field:

~~~~
HTTP/1.1 200 OK
Content-Type: image/jpeg
Vary: SM
HS: "a"
Transfer-Encoding: chunked
~~~~

Upon receipt of that response, the client will consider it equivalent to:

~~~~
HTTP/1.1 200 OK
Content-Type: image/jpeg
Vary: SM
Connection: close
Strict-Transport-Security: max-age=15768000 ; includeSubDomains
Server: Apache/2.4.7 (Ubuntu)
Public-Key-Pins: max-age=604800; 
  pin-sha256="ZitlqPmA9wodcxkwOW/c7ehlNFk8qJ9FsocodG6GzdjNM=";
  pin-sha256="XRXP987nz4rd1/gS2fJSNVfyrZbqa00T7PeRXUPd15w="; 
  report-uri="/lib/key-pin.cgi"
Cache-Control: max-age=3600
Vary: Accept-Encoding
~~~~

If a request omits the `SM` header field, or its field-value does not match the current ETag of the well-known resource, all of the header fields above will be sent by the server in the response.

Note that in these examples, the `Vary` header field has two values. Because the field values in the well-known resource are appended to the header set occurring on the wire, clients will combine them as per the rules in {{!RFC7230}}, Section 3.2.2.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Server Operation {#server}

When a server wishes to use site-wide HTTP headers, it places a file in the format specified in {{type}} at the well-known URI specified in {{well-known}}.

Then, when requests have a `SM` request header field (as per {{sm}}) that matches the current ETag of the well-known resource, the set of response header fields in that nominated by the `HS` response header field (see {{hs}}) for that resource are omitted from the corresponding responses.

Servers SHOULD include `SM` in the field-value of the `Vary` response header field for all cacheable (as per {{!RFC7234}}) responses of resources that behave in this manner, whether or not headers have been actually appended. This assures correct cache operation, and also advertises support for this specification.

Servers MAY use HTTP/2 Server Push ({{?RFC7540}}, Section 8.2) to proactively send the well-known resource to clients (e.g., if they emit `SM: *`, indicating that they do not have a fresh copy of the well-known resource).


## The "HS" HTTP Response Header Field {#hs}

The `HS` HTTP response header field indicates the header set in the well-known location file (see {{type}}) that should be applied to the response it occurs in.

~~~
HS = DQUOTE 1*ALPHA DQUOTE
~~~


# Client Operation {#client}

Clients that support this specification SHOULD always emit a `SM` header field in requests, carrying either the `ETag` of the well-known resource currently held for the origin, or `*` to indicate that they support this specification, but do not have a fresh (as per {{RFC7234}}) copy of it.

Clients might discover that an origin supports this specification when it returns a response containing the `HS` response header field, or they might learn of it when the well-known location's current contents are sent via a HTTP/2 Server Push.

In either case, clients SHOULD send a `SM` request header field on all requests to such an origin.

Upon receiving a response to such a request containing the `HS` response header field, clients MUST locate the header-set referred to by its field-value in the stored well-known response, remove any surrounding white space, and append it to the response headers, stripping the `HS` response header field.

If the corresponding header-set cannot be found in the well-known location, the response MUST be considered invalid and MUST NOT be used; the client MAY retry the request without the `SM` request header field if its method was safe, or may take alternative recovery strategies.


## The "SM" HTTP Request Header Field {#sm}

The `SM` HTTP request header field indicates that the client has a fresh (as per {{!RFC7234}}) copy of the "site-metadata" URI {{well-known}} for the request's origin ({{!RFC6454}}).

~~~
SM = "*" / entity-tag
~~~

Its value is the `entity-tag` {{!RFC7232}} of the freshest valid well-known location response held by the client. If none is held, it should be `*` (without quotes).

For example:

~~~
SM: "abc123"
SM: *
~~~


# The "site-metadata" well-known URI {#well-known}

The well-known URI {{!RFC5785}} "site-metadata" is a resource that, when fetched, returns a file in the "text/site-headers" {{type}} format.

Its media type SHOULD be generated as `text/site-headers`, although clients SHOULD NOT reject responses with other types (particularly, `application/octet-stream` and `text/plain`).

Its representation MUST contain an `ETag` response header {{!RFC7232}}.

Clients SHOULD consider it to be valid for its freshness lifetime (as per {{!RFC7234}}). If it does not have an explicit freshness lifetime, they SHOULD consider it to have a heuristic freshness lifetime of 60 seconds.


## The "text/site-headers" Media Type {#type}

The `text/site-headers` media type is used to indicate that a file contains one or more sets of HTTP header fields, as defined in {{!RFC7230}}, Section 3.

~~~
site-headers = 1*( header-header header-set )
header-header = "#" 1*RWS set-name OWS CRLF
set-name = 1*ALPHA
header-set = OWS *( header-field CRLF ) OWS
~~~

Each set of HTTP header fields is started by a header-header, which is indicated by an octothorp ("#") followed by the name of the header set. The following lines, up until the next line beginning with an octothorp or the end of the file are considered to be the header-set's contents.

As in HTTP itself, implementations need to be forgiving about line endings; specifically, bare CR MUST be considered to be a line ending.

For example:

~~~~
# a
Strict-Transport-Security: max-age=15768000 ; includeSubDomains
Server: Apache/2.4.7 (Ubuntu)
Public-Key-Pins: max-age=604800;
  pin-sha256="ZitlqPmA9wodcxkwOW/c7ehlNFk8qJ9FsocodG6GzdjNM=";
  pin-sha256="XRXP987nz4rd1/gS2fJSNVfyrZbqa00T7PeRXUPd15w="; 
  report-uri="/lib/key-pin.cgi"
Cache-Control: max-age=3600
Vary: Accept-Encoding
# b
Server: Apache/2.7.4 (Ubuntu)
Cache-Control: max-age=0
~~~~

This file specifies two sets of HTTP headers, "a" and "b". Note that the `Public-Key-Pins` header field in "a" is line-folded; as in HTTP, this form of header is deprecated in this format, and SHOULD NOT be used (except in documentation, as we see here).

# IANA Considerations

TBD

# Security Considerations


## Combining Headers


--- back
