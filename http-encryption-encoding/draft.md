---
title: Encryption Content-Encoding for HTTP
abbrev: HTTP encryption coding
docname: draft-nottingham-http-encryption-encoding-00
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
    organization: 
    email: mnot@mnot.net
    uri: http://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This memo introduces an "encryption" content-coding for HTTP, to allow message
payloads to be encrypted, and for that encryption to be persisted on the server.

Such a capability would allow, for example, storing content on a HTTP server
without exposing its contents to the server.


--- middle

# Introduction

It is sometimes desireable to encrypt the contents of a HTTP message (request
or response) in a persistent manner, so that when their payload is stored
(e.g., with a HTTP PUT), only someone with the appropriate key can read it.

For example, it might be necessary to store a file on a server without exposing
its contents to that server. Furthermore, that same file could be replicted to
other servers (to make it more resistant to server or network failure),
downloaded by clients (to make it available offline), etc. without exposing its
contents.

These uses are not met by the use of TLS {{RFCxxxx}}, since it encrypts the channel
between the client and server.

This memo introduces an "encryption" content-coding (along with associated
machinery) for HTTP to serve these use cases.

The most common uses for such an encoding would be in the successful response
to a GET request, or in a PUT request. 

Using this content coding in a PATCH or POST request is less likely to be
useful, since the server needs to process the reuqest body to perform the
method. Likewise, using this content-coding in an unsuccessful response to a
GET request is likely to be counterproductive.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


# The "encrypted" HTTP content-coding  {#encrypted}

The "encrypted" HTTP content-coding indicates that a payload has been encrypted
using the cipher described in the Encryption HTTP header field.

When it appears, the Encryption HTTP header field MUST be present in the message.


# The "Encryption" HTTP header field  {#encryption}

The "Encryption" HTTP header field describes the ciphers that have been applied
to a message payload.

~~~
  Encryption-val = #cipher
  cipher = token *( ";" param )
~~~


Servers processing PUT requests MUST persist the value of the Encryption header
field.


# Examples

## Successful GET response
~~~
HTTP/1.1 200 OK
Content-Type: application/octet-stream
Content-Encoding: encrypted
Connection: close
Encryption: rsa256; key="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a successful HTTP GET response has been encrypted using rsa256 and a key
identified with the HTTP URI scheme.

Note that the media type has been normalised to "application/octet-stream" to
avoid exposing information about the content.

## Encryption and Compression

~~~
HTTP/1.1 200 OK
Content-Type: text/html
Content-Encoding: encrypted, gzip
Transfer-Encoding: chunked
Encryption: rsa256; key="mailto:me@example.com"

[encrypted payload]
~~~

## Encryption with More Than One Key

~~~
PUT /thing HTTP/1.1
Host: storage.example.com
Content-Type: application/http
Content-Encoding: encrypted, encrypted
Content-Length: 1234
Encryption: rsa256; key="mailto:me@example.com",
            rsa256; key="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a PUT request has been encrypted with two keys; both will be necessary to
read the content.


# IANA Considerations

## The "encrypted" HTTP content-coding

This memo registers the "encrypted" HTTP content-coding in the HTTP Content
Codings Registry, as detailed in {{encrypted}}.

* Name: encrypted
* Description: encrypted data
* Reference [this specification]

## The "Encryption" HTTP header field

This memo registers the "Encryption" HTTP header field in the Permanent Message
Header Registry, as detailed in {{encryption}}.

* Field name: Encrypted
* Protocol: HTTP
* Status: Standard
* Reference: [this specification]
* Notes: 

## The HTTP Encryption Registry


### Initial Contents

* "rsa256" - 

# Security Considerations

## Key Exposure

As with any encryption scheme, this mechanism is only as secure as the key.
Because the key is identified by (and potentially available at) a URI, care
needs to be taken that it will not be unduly exposed.

## Leaking Information in Headers

Because "encrypted" only operates upon the message payload, any information
exposed in headers is visible to anyone who can read the message.

For example, the Content-Type header can lead information about the message
payload. 

There are a number of strategies available to mitigate this threat, depending
upon the application's threat model and the users' tolerance for leaked
information:

1. Determine that it is not an issue. For example, if it is expected that all
content stored will be HTML (a very common media type), exposing the
Content-Type header may be an acceptable risk.

2. If it is considered sensitive information and it is possible to determine it
through other means (e.g., out of band, using hints in other representations,
etc.), omit the relevant headers, and/or normalise them. In the case of
Content-Type, this could be accomplished by always sending Content-TYpe:
application/octet-stream (the most generic media type).

3. If it is considered sensitive information and it is not possible to convey
it elsewhere, encapsulate the HTTP message using the application/http media
type {{xxxx}}, encrypting that as the payload of the "outer" message.


## Poisoning Storage

This mechanism only offers encryption of content; it does not perform
authentication or authorization, which still needs to be performed (e.g., by
HTTP authentication {{xxxxx}}).

This is especially relevant when a HTTP PUT request is accepted by a server; if
the request is unauthenticated, it becomes possible for a third party to deny
service and/or poision the store.

## Sizing and Timing Attacks

Applications using this mechanism need to be aware that the size of encrypted
messages, as well as their timing, HTTP methods, URIs and so on, may leak sensitive
information.

This risk can be partially mitigated by splitting up files into segments and
storing the separately. It can also be mitigated by using HTTP/2 {{xxxx}}
combined with TLS {{xxxx}}.

## Compression and CRIME

--- back
