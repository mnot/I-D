---
title: Encrypted Content-Encoding for HTTP
abbrev: HTTP encryption coding
docname: draft-nottingham-http-encryption-encoding-01
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
    uri: http://www.mnot.net/
-
    ins: M. Thomson
	name: Martin Thomson
	organization: Mozilla
	email: martin.thomson@gmail.com

normative:
  RFC2119:
  RFC3986:
  RFC7230:
  RFC7231:

informative:
  RFC5246:
  RFC7235:
  I-D.ietf-httpbis-http2:

--- abstract

This memo introduces a content-codings for HTTP that allows message payloads to be encrypted.


--- middle

# Introduction

It is sometimes desirable to encrypt the contents of a HTTP message (request or response) in a
persistent manner, so that when their payload is stored (e.g., with a HTTP PUT), only someone with
the appropriate key can read it.

For example, it might be necessary to store a file on a server without exposing its contents to
that server. Furthermore, that same file could be replicated to other servers (to make it more
resistant to server or network failure), downloaded by clients (to make it available offline), etc.
without exposing its contents.

These uses are not met by the use of TLS {{RFC5246}}, since it only encrypts the channel between
the client and server.

This document specifies a content-coding ({RFC7231}}) for HTTP to serve these and other use
cases. 


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The "aesgcm-128" HTTP content-coding

The "aesgcm-128" HTTP content-coding indicates that a payload has been encrypted using Advanced
Encryption Standard (AES) in Galois/Counter Mode (GCM) {AES}} {{NIST.800-38D}}, using a 128 bit key.

When this content-coding is in use, the Encryption header field {#encryption} MUST be present, and
MUST have a corresponding value with the following parameters:

- block size - fixed for message scope; default 4k, change via parameter
- padding - 1 byte
- IV - per-block prefix
- auth tags - end of block




# The "Encryption" HTTP header field  {#encryption}

The "Encryption" HTTP header field describes the parameters that are necessary for encrypted
content encoding(s) that have been applied to a message payload.

~~~
  Encryption-val = #cipher_params
  cipher_params = *( ";" param )
~~~

The following parameters are defined for all ciphers' potential use:

* "key" - contains the base64 URL-encoded bytes of the key.

* "keyid" - contains 

* "" -

One parameter, "key", is defined for all ciphers; it carries a URI {{RFC3986}} that identifies the
key used to encrypt the payload. Individual tokens MAY define the parameters that are appropriate
for them.

If the payload is encrypted more than once (as reflected by having multiple content-codings that
imply encryption), each cipher MUST be reflected in "Encryption", in the order in which they were
applied.

Servers processing PUT requests MUST persist the value of the Encryption header field.


# Examples

## Successful GET response

~~~
HTTP/1.1 200 OK
Content-Type: application/octet-stream
Content-Encoding: aesgcm-128
Connection: close
Encryption: key="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a successful HTTP GET response has been encrypted using rsa256 and a key identified with the
HTTP URI scheme.

Note that the media type has been normalized to "application/octet-stream" to avoid exposing
information about the content.

## Encryption and Compression

~~~
HTTP/1.1 200 OK
Content-Type: text/html
Content-Encoding: aesgcm-128, gzip
Transfer-Encoding: chunked
Encryption: key="mailto:me@example.com"

[encrypted payload]
~~~

## Encryption with More Than One Key

~~~
PUT /thing HTTP/1.1
Host: storage.example.com
Content-Type: application/http
Content-Encoding: aesgcm-128, aesgcm-128
Content-Length: 1234
Encryption: key="mailto:me@example.com",
            key="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a PUT request has been encrypted with two keys; both will be necessary to read the content.


# IANA Considerations

## The "aesgcm-128" HTTP content-coding

This memo registers the "encrypted" HTTP content-coding in the HTTP Content Codings Registry, as
detailed in {{encrypted}}.

* Name: aesgcm-128
* Description: AES-GCM encryption with a 128-bit key
* Reference [this specification]

## The "Encryption" HTTP header field

This memo registers the "Encryption" HTTP header field in the Permanent Message Header Registry, as
detailed in {{encryption}}.

* Field name: Encrypted
* Protocol: HTTP
* Status: Standard
* Reference: [this specification]
* Notes: 


# Security Considerations

## Key Exposure

As with any encryption scheme, this mechanism is only as secure as the key. Because the key is
identified by (and potentially available at) a URI, care needs to be taken that it will not be
unduly exposed.


## Leaking Information in Headers

Because "encrypted" only operates upon the message payload, any information exposed in headers is
visible to anyone who can read the message.

For example, the Content-Type header can lead information about the message payload.

There are a number of strategies available to mitigate this threat, depending upon the
application's threat model and the users' tolerance for leaked information:

1. Determine that it is not an issue. For example, if it is expected that all content stored will
be HTML (a very common media type), exposing the Content-Type header may be an acceptable risk.

2. If it is considered sensitive information and it is possible to determine it through other means
(e.g., out of band, using hints in other representations, etc.), omit the relevant headers, and/or
normalize them. In the case of Content-Type, this could be accomplished by always sending
Content-Type: application/octet-stream (the most generic media type).

3. If it is considered sensitive information and it is not possible to convey it elsewhere,
encapsulate the HTTP message using the application/http media type {{RFC7230}}, encrypting that as
the payload of the "outer" message.


## Poisoning Storage

This mechanism only offers encryption of content; it does not perform authentication or
authorization, which still needs to be performed (e.g., by HTTP authentication {{RFC7235}}).

This is especially relevant when a HTTP PUT request is accepted by a server; if the request is
unauthenticated, it becomes possible for a third party to deny service and/or poison the store.


## Sizing and Timing Attacks

Applications using this mechanism need to be aware that the size of encrypted messages, as well as
their timing, HTTP methods, URIs and so on, may leak sensitive information.

This risk can be partially mitigated by splitting up files into segments and storing the
separately. It can also be mitigated by using HTTP/2 {{I-D.ietf-httpbis-http2}} combined with 
TLS {{RFC5246}}.


--- back
