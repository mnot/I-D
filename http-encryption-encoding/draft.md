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
  RFC4492:
  RFC4648:
  RFC7230:
  RFC7231:
  AES:
    title: Advanced Encryption Standard (AES)
    author:
      - org: National Institute of Standards and Technology (NIST)
    date: November 2001
    seriesinfo: FIPS PUB 197
  NIST80038D:
    title: "Recommendation for Block Cipher Modes of Operation: Galois/Counter Mode (GCM) and GMAC"
    author:
      - org: National Institute of Standards and Technology (NIST)
    date: December 2001
    seriesinfo: NIST PUB 800-38D
  FIPS186:
    title: Digital Signature Standard (DSS)
    author:
      - org: National Institute of Standards and Technology (NIST)
    date: May 1994
    seriesinfo: FIPS PUB 186
  FIPS180-2:
    title: NIST FIPS 180-2, Secure Hash Standard
    author:
      name: NIST
      ins: National Institute of Standards and Technology, U.S. Department of Commerce
    date: 2002-08

informative:
  RFC5226:
  RFC5246:
  RFC7235:
  I-D.ietf-httpbis-http2:

--- abstract

This memo introduces a content-coding for HTTP that allows message payloads to be encrypted.


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

This mechanism is likely only a small part of a larger design that uses content encryption.  In
particular, this document does not describe key management practices.  How clients and servers
acquire and identify keys will depend on the use case.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The "aesgcm-128" HTTP content-coding {#aesgcm128}

The "aesgcm-128" HTTP content-coding indicates that a payload has been encrypted using Advanced
Encryption Standard (AES) in Galois/Counter Mode (GCM) {{AES}} {{NIST80038D}}, using a 128 bit
content encryption key.

When this content-coding is in use, the Encryption header field {{encryption}} MUST be present, and
MUST include sufficient information to determine the content encryption key (see {{derivation}}).

The "aesgcm-128" content-coding uses a fixed block size for any given payload.  Each block is
followed by 128-bit authentication tag.  The block size defaults to 4096 bytes, but this value can
be changed using the "bs" parameter on the Encryption header field.

The encrypted content is therefore an sequence of blocks, each with a length equal to the value of
the "bs" parameter, and 16 bytes of authentication tag.

The final block can be any size up to the block size.  AES-GCM does not require block-level padding,
so the size of an encrypted block can be determined by subtracting the 16 bytes of authentication
tag from the remaining bytes.

Each block contains between 0 and 255 bytes of padding, inserted into a block before the enciphered
content.  The length of the padding is stored in the first byte of the payload.  All padding bytes
MUST be set to zero.  It is a fatal decryption error to have a block with more padding than the
block size.

The initialization vector for each block is a 96-bit value containing the index of the current
block.  Blocks are indexed starting at zero.

The additional data passed to the AES-GCM algorithm consists of the concatenation of:

1. the ASCII-encoded string "Content-Encoding: aesgcm-128",
2. a zero octet, and
3. the index of the current block encoded as a 64-bit unsigned integer.


# The "Encryption" HTTP header field  {#encryption}

The "Encryption" HTTP header field describes the encrypted content encoding(s) that have been
applied to a message payload, and therefore how those content encoding(s) can be removed.

~~~
  Encryption-val = #cipher_params
  cipher_params = [ param *( ";" param ) ]
~~~

If the payload is encrypted more than once (as reflected by having multiple content-codings that
imply encryption), each cipher is reflected in the Encryption header field, in the order in which
they were applied.

The Encryption header MAY be omitted if the sender does not intend for the immediate recipient to
be able to decrypt the message.  Alternatively, the Encryption header field MAY be omitted if the
sender intends for the recipient to acquire the header field by other means.

Servers processing PUT requests MUST persist the value of the Encryption header field, unless they
remove the content-coding by decrypting the payload.


## Encryption Header Field Parameters

The following parameters are used in determining the key that is used for encryption:

key:
: contains the base64 URL-encoded [RFC4648] bytes of the key.

keyid:
: contains a string that identifies a key.

p256-dh:
: contains an ephemeral elliptic curve Diffie-Hellman share over the P-256 curve {{FIPS186}}. The
share is base64 URL-encoded [RFC4648] bytes of the uncompressed curve point.

nonce:
: contains a base64 URL-encoded bytes of a nonce that is used to derive a content encryption key.

These parameters are used to determine a content encryption key.  The key derivation process is
described in {{derivation}}.

In addition to key determination parameters, the "bs" parameter includes a positive integer value
that describes the block size.


## Content Encryption Key Derivation {#derivation}

The content encryption key used by the content-coding is determined based on the information in the
Encryption header field.  Several variations are possible:

explicit key:

: The "key" parameter is decoded and used directly if present.  Other key determination parameters
can be ignored if this parameter is present.

identified key:

: The "keyid" is used to identify a key that is discovered by some out-of-band means.  A "keyid"
parameter can be omitted if a key can be identified based on other information.

p256-dh:

: The "p256-dh" parameter contains a elliptic curve Diffie-Hellman share {{RFC4492}}.  This share is
combined with a share from the intended recipient of the encrypted message.  When a "p256-dh"
parameter is present, the "keyid" parameter identifies the share from the intended recipient.


The product of each of these alternatives generates a sequence of bytes.  This is used as the secret
input to the TLS pseudorandom function (PRF) {{RFC5246}} with the SHA-256 hash function
{{FIPS180-2}} to generate the key.

The label used for the PRF is the ASCII string "encrypted Content-Encoding" and the seed is the
value of the "nonce" parameter, which is first decoded.  The "nonce" parameter therefore MUST be
provided to enable decryption.


# Examples

## Successful GET Response

~~~
HTTP/1.1 200 OK
Content-Type: application/octet-stream
Content-Encoding: aesgcm-128
Connection: close
Encryption: keyid="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a successful HTTP GET response has been encrypted using a key that is identified by a URI.

Note that the media type has been changed to "application/octet-stream" to avoid exposing
information about the content.

## Encryption and Compression

~~~
HTTP/1.1 200 OK
Content-Type: text/html
Content-Encoding: aesgcm-128, gzip
Transfer-Encoding: chunked
Encryption: keyid="mailto:me@example.com"

[encrypted payload]
~~~

## Encryption with More Than One Key

~~~
PUT /thing HTTP/1.1
Host: storage.example.com
Content-Type: application/http
Content-Encoding: aesgcm-128, aesgcm-128
Content-Length: 1234
Encryption: keyid="mailto:me@example.com",
            keyid="http://example.org/bob/keys/123"

[encrypted payload]
~~~

Here, a PUT request has been encrypted with two keys; both will be necessary to read the content.


# IANA Considerations

## The "aesgcm-128" HTTP content-coding

This memo registers the "encrypted" HTTP content-coding in the HTTP Content Codings Registry, as
detailed in {{aesgcm128}}.

* Name: aesgcm-128
* Description: AES-GCM encryption with a 128-bit key
* Reference [this specification]

## The "Encryption" HTTP header field

This memo registers the "Encryption" HTTP header field in the Permanent Message Header Registry, as
detailed in {{encryption}}.

* Field name: Encryption
* Protocol: HTTP
* Status: Standard
* Reference: [this specification]
* Notes:

## The HTTP Encryption Registry {#cipher-registry}

This memo establishes a registry for parameters used by the "Encryption" header
field under the "Hypertext Transfer Protocol (HTTP) Parameters" grouping.  The
"Hypertext Transfer Protocol (HTTP) Encryption Parameters" operates under an
"Specification Required" policy [RFC5226].

Entries in this registry are expected to include the following information:

Parameter Name:
: The name of the parameter.
Purpose:
: A brief description of the purpose of the parameter.
Reference:
: A reference to a specification that defines the semantics of the parameter.

The initial contents of this registry are:

Parameter Name:
: keyid
Purpose:
: Identify the key that is in use.

Parameter Name:
: key
Purpose:
: Provide an explicit key.

Parameter Name:
: p256-dh
Purpose:
: Carry an elliptic curve Diffie-Hellman share used to derive a key.

* nonce
* bs

# Security Considerations


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
