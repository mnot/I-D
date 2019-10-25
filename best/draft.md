---
title: Binary Encoding of Structured Types
abbrev:
docname: draft-nottingham-best-00
date: {DATE}
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
    organization: Fastly
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

HTTP messages often pass through several systems -- clients, intermediaries, servers, and subsystems of each -- that parse and process their header and trailer fields. This repeated parsing (and often re-serialisation) adds latency and consumes CPU, energy, and other resources.

Structured Headers for HTTP offers a set of data types that new headers can combine to express their semantics. This specification defines a binary serialisation of these types that is more efficient to process, along with a negotiation mechanism for its use in HTTP/2. It also defines how to use Structured Headers for many existing headers -- thereby "backporting" them -- when supported by two peers.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/hehe>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/hehe/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/hehe>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-hehe/>.

--- middle

# Introduction

HTTP messages often pass through several systems -- clients, intermediaries, servers, and subsystems of each -- that parse and process their header and trailer fields. This repeated parsing (and often re-serialisation) adds latency and consumes CPU, energy, and other resources.

Structured Headers for HTTP {{!I-D.ietf-httpbis-header-structure}} offers a set of data types that new headers can combine to express their semantics. This specification defines a binary serialisation of these types that is more efficient to process, along with a negotiation mechanism for its use in HTTP/2. It also defines how to use Structured Headers for many existing headers -- thereby "backporting" them -- when supported by two peers.

The goals of this specification are to reduce parsing overhead and associated costs. It may also result in a more efficient wire format in some cases, but that is not a primary goal. An additional goal is to enable future work on more efficient header compression mechanisms.

{{types}} defines binary serialisations of Structured Headers types. {{negotiate}} shows how to negotiate their use in a HTTP/2 connection. {{backport}} shows how to use Structured Headers types with already defined header fields.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.


# Binary Structured Types {#types}

This section defines a binary serialisation for the Structured Header Types defined in {{!I-D.ietf-httpbis-header-structure}}.

Every Binary Structured Type starts with a 6-bit type field that defines the format of its payload:

~~~
+------+--+--------
|T (6) | Payload (0...)
+------+--+--------
~~~

Some Binary Structured Types have variable lengths; in these cases, the payload MUST have padding appended to align it with the next byte boundary.

## Lists {#list}

The List data type (type=0x1) has a length field that indicates how many members are in the list, as an unsigned 10-bit integer.

~~~
--+--------+--------+---------
Length (10)|  List members...
--+--------+--------+---------
~~~

Each member of the list will be represented by one or more Binary Structured Types (depending on their types), unless it cannot be represented; in these cases, the field value will be serialised as a Textual Field Value {{TFV}}.

list-members that are Items are represented as per {{item}}; list-members that are inner-lists are represented as per {{inner-list}}.

Binary Structured Headers can represent Lists with up to 1024 members; fields containing more members will need to be serialised as Textual Field Values {{TFV}}.

### Inner Lists {#inner-list}

The Inner List data type (type=0x2) has a length field that indicates how many members are in the inner-list, as an unsigned 10-bit integer.

~~~
--+--------+--------+---------
Length (10)|  List members...
--+--------+--------+---------
~~~

Each member of the list will be represented as an Item {{item}}, unless it cannot be represented; in these cases, the field value will be serialised as a Textual Field Value {{TFV}}.

Binary Structured Headers can represent inner lists with up to 1024 members; fields containing more members will need to be serialised as Textual Field Values {{TFV}}.


### Parameters {#parameter}

The Parameters data type (type=0x3) has a length field that indicates how many (parameter-name, parameter-value) pairs are present, as an unsigned 10-bit integer.

~~~
--+--------+--------+---------
Length (10)|  Parameters...
--+--------+--------+---------
~~~

Each pair will be represented by at least two Binary Structured Types; the parameter-name, represented as a token {{token}}, and the parameter-value, which is represented as a bare item {{item}}.

If the parameters cannot be represented, the field value will be serialised as a Textual Field Value {{TFV}}.

Binary Structured Headers can represent up to 1024 parameters; fields containing more will need to be serialised as Textual Field Values {{TFV}}.

## Dictionaries

The Dictionary data type (type=0x4) has a length field that indicates how many members are in the dictionary, as an unsigned 10-bit integer.

~~~
--+--------+--------+---------
Length (10)|  Dictionary members...
--+--------+--------+---------
~~~

Each member of the dictionary will be represented by at least two Binary Structured Types; the member-name, represented as a token {{token}}, and the member-value, which is represented as one or more Binary Structured Types as per their definitions.

member-values that are Items are represented as per {{item}}; member-values that are inner-lists are represented as per {{inner-list}}.

If the dictionary cannot be represented, the field value will be serialised as a Textual Field Value {{TFV}}.

Binary Structured Headers can represent Dictionaries with up to 1024 members; fields containing more members will need to be serialised as Textual Field Values {{TFV}}.

## Items {#item}

Items are represented using one to many Binary Structured Types. The bare-item is serialised as the appropriate Binary Structured Type, as per below.

The item's parameters, if present, are serialised as the Parameter type {{parameter}} (which will include zero or more following types).

Bare items are never serialised with parameters.

### Integers

The Integer data type (type=0x5) has a payload of 58 bits:

~~~
--+--------+--------+--------+--------+--------+--------+--+------+
SX|  Integer                                               |  Pad |
--+--------+--------+--------+--------+--------+--------+--+------+
~~~

Its fields are:

* S - sign bit; 0 is negative, 1 is positive
* X - 1 bit; discard
* Integer - 50 bits, unsigned
* Pad - 6 bits

TODO: varint?

### Floats

The Float data type (type=0x6) have a payload of 74 bits:

~~~
-+-+--------+--------+--------+--------+--------+------+
S|   Integer                                           |
-+-+--------+--------+--------+--------+--------+------+

+--+--------+--------+--------+
|    Fractional               |
+--+--------+--------+--------+
~~~

Its fields are:

* S - sign bit; 0 is negative, 1 is positive
* Integer - 47 bits, unsigned
* Fractional - 20 bits, unsigned integer

TODO: varint?

### Strings

The String data type (type=0x7) has a payload whose length is indicated by its first ten bits (as an unsigned integer):

~~~
--+--------+--------+---------
Length (10)|  String...
--+--------+--------+---------
~~~

Binary Structured Headers can represent Strings up to 1024 characters in length; fields containing longer values will need to be serialised as Textual Field Values {{TFV}}.

TODO: Huffman coding?

### Tokens {#token}

The Token data type (type=0x8) has a payload whose length is indicated by its first ten bits (as an unsigned integer):

~~~
--+--------+--------+--------------
Length (10)|  Token...
--+--------+--------+--------------
~~~

Binary Structured Headers can represent Tokens up to 1024 characters in length; fields containing longer values will need to be serialised as Textual Field Values {{TFV}}.

TODO: Huffman coding?

### Byte Sequences

The Byte Sequence data type (type=0x9) has a payload whose length is indicated by its first 14 bits (as an unsigned integer):

~~~
--+--------+----+----+---------------------
Length (14)     |XXXX|  Byte Sequence...
--+--------+----+----+---------------------
~~~

Binary Structured Headers can represent Byte Sequences up to 16384 characters in length; fields containing longer values will need to be serialised as Textual Field Values {{TFV}}.


### Booleans

The Boolean data type (type=0xa) has a payload of two bits:

~~~
--+
BX|
--+
~~~

If B is 0, the value is False; if B is 1, the value is True. The value of X is discarded.


## Textual Field Values {#TFV}

The Textual Field Value data type (type=0xb) indicates that the contents are a textual HTTP header value, rather than a Binary Structured Header. The value may or may not be a Structured Header.

Its payload is two bytes of padding, followed by the octets of the field value:

~~~
--+--------+----
XX| Field Value...
--+--------+----
~~~

Note that unlike other binary data types, Textual Field Values rely upon their context to convey their length. As a result, they cannot be used anywhere but as a top-level field value; their presence elsewhere MUST be considered an error.

TODO: huffman coding?


# Negotiating and Using Binary Structured Headers in HTTP/2 {#negotiate}

When both peers on a connection support this specification, they can advertise this and then take advantage of that knowledge to serialise headers that they know to be compatible with

## Binary Structured Headers Setting {#setting}

Advertising support is accomplished using a HTTP/2 setting, SETTINGS_BINARY_STRUCTURED_HEADERS (0xTODO).

Receiving SETTINGS_BINARY_STRUCTURED_HEADERS from a peer indicates that:

1. The peer supports the encoding of Binary Structured Headers defined in {{types}}.
2. The peer will process HEADERS frames containing the HEADERS indicator as defined in {{indicator}}.
3. When a downstream consumer does not likewise support that encoding, the peer will transform them into an encoding it does understand (typically, the textual Structured Headers defined in {{!I-D.ietf-httpbis-header-structure}}) where necessary.
4. The peer will likewise transform all fields defined as Aliased Fields {{aliased}} into their non-aliased forms as necessary.

The default value of SETTINGS_BINARY_STRUCTURED_HEADERS is 0. Future extensions to Structured Headers might use it to indicate support for new types.

## HEADERS Indicator {#indicator}

When a peer has indicated that it supports this specification {#setting}, a sender indicates that a given HEADERS frame is serialising all of the fields in a header block fragment ({{!RFC7540}} Section 6.2) as Binary Structured Types by prefixing the header block fragment with the byte 0x80 (i.e., 10000000, which is an illegal indexed header field reference in HPACK {{?RFC7541}}).

Such header block fragments will serialise all field values as Binary Structured Types (possibly using Textual Field Values {{TFV}}). These field values can be indexed in the dynamic table just as "normal" field values, although they may have to be converted to textual field values upon reuse, depending upon the capabilities of the peer at that time.

Binary Structured Types do not have Huffman encoding applied to them (except as specified in their definitions).


# Using Binary Structured Headers with Existing Fields {#backport}

Any header field can potentially be parsed as a Structured Header according to the algorithms in {{!I-D.ietf-httpbis-header-structure}} and serialised as a Binary Structured Header. However, many cannot, so optimistically parsing them can be expensive.

This section identifies fields that will usually succeed in {{direct}}, and those that can be mapped into Structured Headers by using an alias field name in {{aliased}}.


## Directly Represented Fields {#direct}

The following HTTP field names can have their values parsed as Structured Headers according to the algorithms in {{!I-D.ietf-httpbis-header-structure}}, and thus can usually be serialised using the corresponding Binary Structured Types.

When one of these fields' values cannot be represented using Structured Types, its value can instead be represented as a Textual Field Value {{TFV}}.

* Accept - List
* Accept-Encoding - List
* Accept-Language - List
* Accept-Patch - List
* Accept-Ranges - List
* Access-Control-Allow-Credentials - Item
* Access-Control-Allow-Headers - List
* Access-Control-Allow-Methods - List
* Access-Control-Allow-Origin - Item
* Access-Control-Max-Age - Item
* Access-Control-Request-Headers - List
* Access-Control-Request-Method - Item
* Age - Item
* Allow - List
* ALPN - List
* Alt-Svc - List
* Alt-Used - Item
* Cache-Control - Dictionary
* Content-Encoding - Item
* Content-Language - List
* Content-Length - Item
* Content-Type - Item
* Expect - Item
* Forwarded - List
* Host - Item
* Origin - Item
* Pragma - Dictionary
* Prefer - Dictionary
* Preference-Applied - Dictionary
* Retry-After - Item  (see caveat below)
* Surrogate-Control - Dictionary
* TE - List
* Trailer - List
* Transfer-Encoding - List
* Vary - List
* X-Content-Type-Options - Item

Note that only the delta-seconds form of Retry-After is supported; a Retry-After value containing a http-date will need to be either converted into delta-seconds or serialised as a Textual Field Value {{TFV}}.

TODO: Accept and Content-Type media types use + in values.

## Aliased Fields {#aliased}

The following HTTP field names can have their values represented in Structured headers by mapping them into its data types and then serialising the resulting Structured Header using an alternative field name.

For example, the Date HTTP header field carries a http-date, which is a string representing a date:

~~~
Date: Sun, 06 Nov 1994 08:49:37 GMT
~~~

Its value is more efficiently represented as an integer number of delta seconds from the Unix epoch (00:00:00 UTC on 1 January 1970, minus leap seconds). Thus, the example above would be represented in (non-binary) Structured headers as:

~~~
SH-Date: 784072177
~~~

As with directly represented fields, if the intended value of an aliased field cannot be represented using Structured Types successfully, its value can instead be represented as a Textual Field Value {{TFV}}.

Note that senders MUST know that the next-hop recipient understands these fields (typically, using the negotiation mechanism defined in {{negotiate}}) before using them. Likewise, recipients MUST transform them back to their unaliased form before forwarding the message to a peer or other consuming components that do not have this capability.

Each field name listed below indicates a replacement field name and a way to map its value to Structured Headers.

### URLs

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Headers by considering their payload a string.

* Content-Location - SH-Content-Location
* Location - SH-Location
* Referer - SH-Referer

For example, a (non-binary) Location:

~~~
SH-Location: "https://example.com/foo"
~~~

TOOD: list of strings, one for each path segment, to allow better compression in the future?

### Dates

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Headers by parsing their payload according to {{!RFC7230}}, Section 7.1.1.1, and representing the result as an integer number of seconds delta from the Unix Epoch (00:00:00 UTC on 1 January 1970, minus leap seconds).

* Date - SH-Date
* Expires - SH-Expires
* If-Modified-Since - SH-IMS
* If-Unmodified-Since - SH-IUS
* Last-Modified - SH-LM

For example, a (non-binary) Expires:

~~~
SH-Expires: 1571965240
~~~

### ETags

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Headers by representing the entity-tag as a string, and the weakness flag as a boolean "w" parameter on it, where true indicates that the entity-tag is weak; if 0 or unset, the entity-tag is strong.

* ETag - SH-ETag

For example, a (non-Binary) ETag:

~~~
SH-ETag: "abcdef"; w=?1
~~~

If-None-Match is a list of the structure described above.

* If-None-Match - SH-INM

For example, a (non-binary) If-None-Match:

~~~
SH-INM: "abcdef"; w=?1, "ghijkl"
~~~


### Links

The field-value of the Link header field {{!RFC8288}} can be represented in Binary Structured Headers by representing the URI-Reference as a string, and link-param as parameters.

* Link: SH-Link

For example, a (non-binary) Link:

~~~
SH-Link: "/terms"; rel="copyright"; anchor="#foo"
~~~

### Cookies

The field-value of the Cookie and Set-Cookie fields {{!RFC6265}} can be represented in Binary Structured Headers as a List with parameters and a Dictionary, respectively. The serialisation is almost identical, except that the Expires parameter is always a string (as it can contain a comma), multiple cookie-strings can appear in Set-Cookie, and cookie-pairs are delimited in Cookie by a comma, rather than a semicolon.

Set-Cookie: SH-Set-Cookie
Cookie: SH-Cookie

~~~
SH-Set-Cookie: lang=en-US, Expires="Wed, 09 Jun 2021 10:18:14 GMT"
SH-Cookie: SID=31d4d96e407aad42, lang=en-US
~~~

TODO: explicitly convert Expires to an integer?

# IANA Considerations

TODO

# Security Considerations

As is so often the case, having alternative representations of data brings the potential for security weaknesses, when attackers exploit the differences between those representations and their handling.

One mitigation to this risk is the strictness of parsing for both non-binary and binary Structured Headers data types, along with the "escape valve" of Textual Field Values {{TFV}}. Therefore, implementation divergence from this strictness can have security impact.


--- back
