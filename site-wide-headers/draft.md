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

This document specifies a mechanism for Web sites to send HTTP header fields that apply to the entire origin via a different, more efficient mechanism, rather than including them in every response.

--- middle

# Introduction

A variety of metadata about Web sites is being conveyed in new HTTP response headers. In particular, it is becoming more common for metadata that applies to an entire Web site to be conveyed in a header field that is included on every response for that site.

For example, `Strict-Transport-Security` {{?RFC6797}} and `Public-Key-Pins` {{?RFC7469}} both define headers that are explicitly scoped to an entire origin {{!RFC6454}}, and number of similar headers are under consideration.

Likewise, some HTTP header fields only sensibly have a single value per origin; for example, `Server`.

Furthermore, some headers are resource-specific, but in some deployments, are uniform across an origin. For example, some sites will have a `CSP` {{?W3C.CR-CSP2-20150721}} header that doesn't vary across the site.

This is inefficient. Besides the obvious bandwidth waste due to redundancy in HTTP/1, it also impacts HTTP/2's HPACK {{?RFC7541}} header compression; since the amount of space of available for state is limited (by default, 4K), verbose, repeating headers can greatly reduce the effectiveness of HPACK.

However, when the metadata affects processing of the response, and the application is latency-sensitive (as uses of HTTP so often are), it's not pratical to separate the metadata from the response; it needs to be sent on every response so that it is available.

One way to mitigate this problem is to remove these site-wide header fields from responses, and keep them in a separate resource. When clients have fetched that resource and guarantee that they will consider its contents to be included in all responses for that domain, they can indicate this to the server with a small request header; when servers see it, they can safely omit those headers in responses.

In this manner, such headers are sent on responses until they are loaded from a separate resource; once the client indicates it has done so, they can be omitted from responses, reducing network and compression context usage.

This document specifies how to do this by using a well-known URI {{!RFC5785}} to store these headers in a format specified in {{type}}. In typical use, a server can use HTTP/2 Server Push ({{!RFC7540}}, Section 8.2) to proactively send this content upon the first request from the client. Then, it can add the headers therein to responses when the corresponding requests do not contain the `SM` header field, or when the `SM` header field value does not contain the well-known resource's ETag.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.



# Site-Wide HTTP Headers {#site-wide}

When a server wishes to use site-wide HTTP headers, it places a file in the `text/http-headers` format ({{type}}) at the `site-headers` well-known URI ({{well-known}}).

Then, when requests have a `SM` request header field {{sm}}, the header field values within are omitted from the corresponding responses. Typically, this can be implemented by appending the headers contained therein when the request doesn't contain the SM header field.

Servers SHOULD include `SM` in the field-value of the Vary response header field when the response is cacheable (as per {{!RFC7234}}).

For example, if a request to the well-known URI returns:

~~~
HTTP/1.1 200 OK
Content-Type: text/http-headers
Cache-Control: max-age=3600
ETag: "abc123"
Content-Length: 334

Strict-Transport-Security: max-age=15768000 ; includeSubDomains
Server: Apache/2.4.7 (Ubuntu)
Public-Key-Pins: max-age=604800; 
  pin-sha256="ZitlqPmA9wodcxkwOW/c7ehlNFk8qJ9FsocodG6GzdjNM=";
  pin-sha256="XRXP987nz4rd1/gS2fJSNVfyrZbqa00T7PeRXUPd15w="; 
  report-uri="/lib/key-pin.cgi"
Cache-Control: max-age=3600
Vary: Accept-Encoding
~~~

and a client that has loaded that resource makes the request:

~~~~
GET /images/foo.jpg HTTP/1.1
Host: www.example.com
SM: "abc123"
~~~~

this indicates that the client has processed the site-metatadata resource, and therefore that the server can omit the response header fields contained within it on the wire:

~~~~
HTTP/1.1 200 OK
Content-Type: image/jpeg
Vary: SM
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


## The "text/http-headers" Media Type {#type}

The text/http-headers media type is used to indicate that a file contains a set of HTTP header fields, as defined in {{!RFC7230}}, Section 3; i.e.,

~~~
OWS *( header-field CRLF ) OWS
~~~

Whitespace at the beginning and end of the file MUST be stripped. As in HTTP itself, implementations need to be forgiving about line endings; specifically, bare CR MUST be considered to be a line ending.

For example:

~~~~
Strict-Transport-Security: max-age=15768000 ; includeSubDomains
Server: Apache/2.4.7 (Ubuntu)
Public-Key-Pins: max-age=604800;
  pin-sha256="ZitlqPmA9wodcxkwOW/c7ehlNFk8qJ9FsocodG6GzdjNM=";
  pin-sha256="XRXP987nz4rd1/gS2fJSNVfyrZbqa00T7PeRXUPd15w="; 
  report-uri="/lib/key-pin.cgi"
Cache-Control: max-age=3600
Vary: Accept-Encoding
~~~~


## The "site-metadata" well-known URI {#well-known}

The well-known URI {{!RFC5785}} "site-metadata" is a resource that, when fetched, returns a file in the "text/http-headers" {{type}} format.

Its media type SHOULD be generated as `text/http-headers`, although clients SHOULD NOT reject responses with other types (particularly, `application/octet-stream` and `text/plain`).

Its representation MUST contain an `ETag` response header {{!RFC7232}}.

Clients SHOULD consider it to be valid for its freshness lifetime (as per {{!RFC7234}}). If it does not have an explicit freshness lifetime, they SHOULD consider it to have a heuristic freshness lifetime of 60 seconds.


## The "SM" HTTP Request Header Field {#sm}

The "SM" HTTP request header field indicates that the client has a fresh (as per {{!RFC7234}}) copy of the "site-metadata" URI {{well-known}} for the request's origin ({{!RFC6454}}), and will consider the corresponding response to contain the header field(s) contained within.

Clients MUST generate its field value as a strong `entity-tag` {{!RFC7232}}.

For example:

~~~
SM: "abc123"
~~~



# IANA Considerations

TBD

# Security Considerations


## Combining Headers


--- back
