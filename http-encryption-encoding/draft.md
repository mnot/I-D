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
  RFC5116:
  FIPS180-2:
    title: NIST FIPS 180-2, Secure Hash Standard
    author:
      name: NIST
      ins: National Institute of Standards and Technology, U.S. Department of Commerce
    date: 2002-08

informative:
  RFC2440:
  RFC5226:
  RFC5246:
  RFC5652:
  RFC7235:
  I-D.ietf-httpbis-http2:
  FIPS186:
    title: "Digital Signature Standard (DSS)"
    author:
      - org: National Institute of Standards and Technology (NIST)
    date: July 2013
    seriesinfo: NIST PUB 186-4
  X.692:
     title: "Public Key Cryptography For The Financial Services Industry: The Elliptic Curve Digital Signature Algorithm (ECDSA)"
     author:
       - org: ANSI
     seriesinfo: ANSI X9.62, 1998.
  I-D.ietf-jose-json-web-encryption:
  XMLENC:
     title: "XML Encryption Syntax and Processing"
     author:
       - ins: D. Eastlake
       - ins: J. Reagle
       - ins: T. Imamura
       - ins: B. Dillaway
       - ins: E. Simon
     date: 2002-12
     seriesinfo: W3C REC
     target: "http://www.w3.org/TR/xmlenc-core/"

--- abstract

This memo introduces a content-coding for HTTP that allows message payloads to be encrypted.


--- middle

# Introduction

It is sometimes desirable to encrypt the contents of a HTTP message (request or response) in a
persistent manner, so that when the payload is stored (e.g., with a HTTP PUT), only someone with
the appropriate key can read it.

For example, it might be necessary to store a file on a server without exposing its contents to
that server. Furthermore, that same file could be replicated to other servers (to make it more
resistant to server or network failure), downloaded by clients (to make it available offline), etc.
without exposing its contents.

These uses are not met by the use of TLS [RFC5246], since it only encrypts the channel between the
client and server.

Message-based encryption formats - such as those that are described by [RFC2440], [RFC5652],
[I-D.ietf-jose-json-web-encryption], and [XMLENC] - are not suited to stream processing, which is
necessary for HTTP messages.  While virtually any of these alternatives could be profiled and
adapted to suit, the overhead and complexity that would introduce is sub-optimal.

This document specifies a content-coding [RFC7231]) for HTTP to serve these and other use cases.

This mechanism is likely only a small part of a larger design that uses content encryption.  In
particular, this document does not describe key management practices.  How clients and servers
acquire and identify keys will depend on the use case.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
[RFC2119].


# The "aesgcm-128" HTTP content-coding {#aesgcm128}

The "aesgcm-128" HTTP content-coding indicates that a payload has been encrypted using Advanced
Encryption Standard (AES) in Galois/Counter Mode (GCM) as identified as AEAD_AES_128_GCM in
[RFC5116], Section 5.1.  The AEAD_AES_128_GCM algorithm uses a 128 bit content encryption key.

When this content-coding is in use, the Encryption header field {{encryption}} is used to determine
the content encryption key (see {{derivation}}).

The "aesgcm-128" content-coding uses a single fixed set of encryption primitives.  Cipher suite
agility is achieved by defining a new content-coding scheme.  This ensures that only the HTTP
Accept-Encoding header field is necessary to negotiate the use of encryption.

The "aesgcm-128" content-coding uses a fixed record size.  The final encoding is a series of
fixed-size records, though the final record can be any length.

~~~
       +------+
       | data |         input of between rs-256
       +------+            and rs-1 octets
           |
           v
+-----+-----------+
| pad |   data    |     add padding to form plaintext
+-----+-----------+
         |
         v
+--------------------+
|    ciphertext      |  encrypt with AEAD_AES_128_GCM
+--------------------+     expands by 16 octets
~~~

The record size determines the length of each portion of plaintext that is enciphered.  The record
size defaults to 4096 octets, but can be changed using the "rs" parameter on the Encryption header
field.

AEAD_AES_128_GCM expands ciphertext to be 16 octets longer than its input plaintext.  Therefore, the
length of each enciphered record is equal to the value of the "rs" parameter plus 16 octets.  It is
a fatal decryption error to have a remainder of 16 octets or less in size (though AEAD_AES_128_GCM
permits input plaintext to be zero length, records always contain at least one padding byte).

Each record contains between 0 and 255 bytes of padding, inserted into a record before the enciphered
content.  The length of the padding is stored in the first byte of the payload.  All padding bytes
MUST be set to zero.  It is a fatal decryption error to have a record with more padding than the
record size.

The nonce used for each record is a 96-bit value containing the index of the current record in
network byte order.  Records are indexed starting at zero.

Note:

: The nonce used by the AEAD algorithms in [RFC5116] is different from the value of the "nonce"
parameter, which is used to ensure that two content encryption keys are not the same.

The additional data passed to the AEAD algorithm consists of the concatenation of:

1. the ASCII-encoded string "Content-Encoding: aesgcm-128" (with no trailing 0),
2. a zero octet, and
3. the index of the current record encoded as a 64-bit unsigned integer in network byte order.


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

: The "key" parameter contains the URL-safe base64 [RFC4648] bytes of the key.

keyid:

: The "keyid" parameter contains a string that identifies a key.

ecdh:

: The "ecdh" parameter contains an ephemeral elliptic curve Diffie-Hellman (ECDH) share.  The point
is encoding using the URL-safe base64 encoding [RFC4648].

nonce:

: The "nonce" parameter contains a base64 URL-encoded bytes of a nonce that is used to derive a
content encryption key.  The nonce value MUST be present, and MUST be exactly 16 octets long.  A
nonce MUST NOT be reused for two different messages that have the same content encryption key;
generating a random nonce for each message ensures that nonce reuse is highly unlikely.

These parameters are used to determine a content encryption key.  The key derivation process is
described in {{derivation}}.

In addition to key determination parameters, the "rs" parameter includes a positive integer value
that describes the record size.


## Content Encryption Key Derivation {#derivation}

The content encryption key used by the content-coding is determined based on the information in the
Encryption header field.  Several variations are possible:

explicit key:

: The "key" parameter is decoded and used directly if present.  Other key determination parameters
can be ignored if this parameter is present.

identified key:

: The "keyid" is used to identify a key that is established by some out-of-band means.  A "keyid"
parameter can be omitted if a key can be identified based on other information.

ecdh:

: The ECDH share included in the "ecdh" parameter is combined with a share from the intended
recipient of the encrypted message using elliptic curve Diffie-Hellman (ECDH) [RFC4492] to determine
a shared secret.  This is explained in more detail in {{ecdh}}.

The output of each of these alternative methods is a sequence of octets which is used as the secret
input to the TLS pseudorandom function (PRF) (as defined in Section 5 of [RFC5246]) with the SHA-256
hash function [FIPS180-2] to generate the key.

The label used for the PRF is the ASCII string "encrypted Content-Encoding" and the seed is the
value of the "nonce" parameter, which is first decoded.  The "nonce" parameter therefore MUST be
provided to enable decryption.


### ECDH Key Derivation {#ecdh}

When an "ecdh" parameter is present, key derivation relies on several pieces of
information that the sender and receiver have agreed upon out of band:

* The elliptic curve that will be used for the ECDH process

* The format of the ephemeral public share that is included in the "ecdh"
  parameter.  For instance, both parties might need to agree whether this is an
  uncompressed or compressed point.

The "keyid" parameter contains an identifier for these agreed parameters as well as the keying
material used by the receiver.  This means that the actual content of the "ecdh" parameter does not
need to explicitly include all this information.

The intended recipient recovers this information and their shared secret and are then able to
generate a shared secret using the ECDH process on the selected curve.

Specifications that rely on an ECDH exchange for this content-coding MUST either specify what curve
and point format to use, or how a curve and point format is negotiated between sender and receiver.


# Examples

## Successful GET Response

~~~
HTTP/1.1 200 OK
Content-Type: application/octet-stream
Content-Encoding: aesgcm-128
Connection: close
Encryption: keyid="http://example.org/bob/keys/123";
            nonce="XZwpw6o37R-6qoZjw6KwAw"

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
Encryption: keyid="mailto:me@example.com";
            nonce="m2hJ_NttRtFyUiMRPwfpHA"

[encrypted payload]
~~~

## Encryption with More Than One Key

~~~
PUT /thing HTTP/1.1
Host: storage.example.com
Content-Type: application/http
Content-Encoding: aesgcm-128, aesgcm-128
Content-Length: 1234
Encryption: keyid="mailto:me@example.com";
            ecdh="BLiZzhckgp88pANskUpCkGV7-IFLHC-aF8MMPW7i8P...";
            nonce="NfzOeuV5USPRA-n_9s1Lag",
            keyid="http://example.org/bob/keys/123";
            nonce="bDMSGoc2uobK_IhavSHsHA"

[encrypted payload]
~~~

Here, a PUT request has been encrypted with two keys; both will be necessary to read the content.
The inner layer of encryption uses elliptic curve Diffie-Hellman (the actual value is truncated).


## Encryption with Explicit Key

~~~
HTTP/1.1 200 OK
Content-Length: 31
Content-Encoding: aesgcm-128
Encryption: key="T9jtNY-vTvq7mSVlNFJbyw";
            nonce="nJJ-xXkP5sM_8Zp00Gp-ig"

zIZwlquLit2UEsKh1eBATJadBieZUEOI9sfiJtT6DwU
~~~

This example shows the string "I am the walrus" being encrypted.  The content body contains a single
record only and is shown here encoded in URL-safe base64 for presentation reasons only.


## Diffie-Hellman Encryption

~~~
HTTP/1.1 200 OK
Content-Length: 31
Content-Encoding: aesgcm-128
Encryption: keyid="the key";
            nonce="6hCMStcuoSdfvDjpm0qhdQ";
            ecdh="BOsUGWuTKnbckPjtsU-vCi1BQaQu5B9iEoP8No2B34rS
                  RvaA_er_d2tpRy-3e-a6n5W7MIPBcacIJ7eDWkvnDxI"

fDBJbV-a2XnWwcJQTpDinRoDqOHdmH5XxJD0Gob7wEg
~~~

This example shows the same string, "I am the walrus", encrypted using ECDH over the P-256 curve
[FIPS186]. The content body is shown here encoded in URL-safe base64 for presentation reasons only.

The receiver (in this case, the HTTP client) uses the key identified by the string "the key" and the
sender (the server) uses a key pair for which the public share is included in the "ecdh" parameter
above. The keys shown below use uncompressed points [X.692] encoded using URL-safe base64. Line
wrapping is added for presentation purposes only.

~~~
Receiver:
  private key: XKtP2DkzcIe5IP-F2aQEGhLyIAsFQ0_i0oerP7KhVDs
  public key: BMsH0i3-wrEXL8cL66n42WLM0yjNnyYL6hIVyhcnHlb-
              GcruWEGr-5avwIu3oJVCQofFvuwu3y3VJFcIDA5tTyg
Sender:
  private key: iG9ObZuRssarFIh859KjDpysTMybv4HNoZoPc-1DzWo
  public key: <the value of the "ecdh" parameter>
~~~


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

* Parameter Name: The name of the parameter.
* Purpose: A brief description of the purpose of the parameter.
* Reference: A reference to a specification that defines the semantics of the parameter.

The initial contents of this registry are:

### keyid

* Parameter Name: keyid
* Purpose: Identify the key that is in use.
* Reference: [this document]

### key

* Parameter Name: key
* Purpose: Provide an explicit key.
* Reference: [this document]

### ecdh

* Parameter Name: ecdh
* Purpose: Carry an elliptic curve Diffie-Hellman share used to derive a key.
* Reference: [this document]

### nonce

* Parameter Name: nonce
* Purpose: Provide a source of entropy for derivation of the content encryption key. This value is mandatory.
* Reference: [this document]

### rs

* Parameter Name: rs
* Purpose: The size of the encrypted records.
* Reference: [this document]


# Security Considerations

This mechanism assumes the presence of a key management framework that is used to manage the
distribution of keys between valid senders and receivers.  Defining key management is part of
composing this mechanism into a larger application, protocol, or framework.

Implementation of cryptography can be difficult.  For instance, implementations need to account for
the potential for exposing keying material on side channels, such as might be exposed by the time it
takes to perform a given operation.  The requirements for a good implementation of cryptographic
algorithms can change over time.


## Key and Nonce Reuse

Encrypting different plaintext with the same content encryption key and nonce in AES-GCM is not safe
[RFC5116].  The scheme defined here relies on the uniqueness of the "nonce" parameter to ensure that
the content encryption key is different for every message.

If a key and nonce are reused, this could expose the content encryption key and it makes message
modification trivial.  If the same key is used for multiple messages, then the nonce parameter MUST
be unique for each.  An implementation SHOULD generate a random nonce parameter for every message,
though using a counter could achieve the desired result.


## Content Integrity

This mechanism only provides content origin authentication.  The authentication tag only ensures
that those with access to the content encryption key produce a message that will be accepted as
valid.

Any entity with the content encryption key can therefore produce content that will be accepted as
valid.  This includes all recipients of the same message.

Furthermore, any entity that is able to modify both the Encryption header field and the message
payload can replace messages.  Without the content encryption key however, modifications to or
replacement of parts of a message are not possible.


## Leaking Information in Headers

Because "encrypted" only operates upon the message payload, any information exposed in headers is
visible to anyone who can read the message.

For example, the Content-Type header can leak information about the message payload.

There are a number of strategies available to mitigate this threat, depending upon the
application's threat model and the users' tolerance for leaked information:

1. Determine that it is not an issue. For example, if it is expected that all content stored will be
"application/json", or another very common media type, exposing the Content-Type header could be an
acceptable risk.

2. If it is considered sensitive information and it is possible to determine it through other means
(e.g., out of band, using hints in other representations, etc.), omit the relevant headers, and/or
normalize them. In the case of Content-Type, this could be accomplished by always sending
Content-Type: application/octet-stream (the most generic media type).

3. If it is considered sensitive information and it is not possible to convey it elsewhere,
encapsulate the HTTP message using the application/http media type [RFC7230], encrypting that as the
payload of the "outer" message.


## Poisoning Storage

This mechanism only offers encryption of content; it does not perform authentication or
authorization, which still needs to be performed (e.g., by HTTP authentication [RFC7235]).

This is especially relevant when a HTTP PUT request is accepted by a server; if the request is
unauthenticated, it becomes possible for a third party to deny service and/or poison the store.


## Sizing and Timing Attacks

Applications using this mechanism need to be aware that the size of encrypted messages, as well as
their timing, HTTP methods, URIs and so on, may leak sensitive information.

This risk can be mitigated through the use of the padding that this mechanism provides.
Alternatively, splitting up content into segments and storing the separately might reduce
exposure. HTTP/2 [I-D.ietf-httpbis-http2] combined with TLS [RFC5246] might be used to hide the size
of individual messages.


--- back
