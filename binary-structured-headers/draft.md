---
title: Binary Structured HTTP Field Values
abbrev:
docname: draft-nottingham-binary-structured-headers-03
date: {DATE}
category: std

ipr: trust200902
area: General
workgroup:
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: Fastly
    city: Prahran
    region: VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  I-D.ietf-quic-transport:

informative:


--- abstract

This specification defines a binary serialisation of Structured Field Values for HTTP, along with a negotiation mechanism for its use in HTTP/2.

It also defines how to use Structured Fields for many existing fields -- thereby "backporting" them -- when supported by both peers.


--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/binary-structured-headers>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/binary-structured-headers/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/binary-structured-headers>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-binary-structured-headers/>.

--- middle

# Introduction

Structured Field Values for HTTP {{!RFC8941}} offers a set of data types that new fields can combine to express their semantics. This specification defines a binary serialisation of those structures in {{fields}}, and specifies its use in HTTP/2 in {{negotiate}}.

Additionally, {{backport}} defines how to convey existing fields as Structured Fields, when supported by two peers.

The primary goal of this specification are to reduce parsing overhead and associated costs, as compared to the textual representation of Structured Fields. A secondary goal is a more compact wire format in common situations. An additional goal is to enable future work on more granular field compression mechanisms.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

This specification describes formats using the convention described in {{Section 1.3 of I-D.ietf-quic-transport}}.


# Binary Structured Fields {#fields}

This section defines a binary serialisation for the Structured Field Types defined in {{!RFC8941}}.

The types permissable as the top-level of Structured Field values -- Dictionary, List, and Item -- are defined in terms of a Binary Representation ({{binlit}}), which is a replacement for the String Literal Representation in {{RFC7541}}.

Binary representations of the remaining structured field types are defined in {{types}}.


## Binary Representations {#binlit}

Binary Representations are a replacement for the String Literal Representation defined in {{!RFC7541}}, Section 5.2, and can be used to serialise a Structured Field Type.

All Binary Representations share the following header:

~~~
Binary Representation {
  Top Level Type (3),
  Length (5..),
}
~~~

Its fields are:

* Top Level Type: Three bits indicating the top-level type of the field value.
* Length: The number of octets used to represent the payload, encoded as per {{!RFC7541}}, Section 5.1, with a 5-bit prefix.

The following top-level types are defined:


### List Field Values

List values (type=0x1) have a payload consisting of a stream of Binary Item Types representing the members of the list. Members that are Items are represented as per {{types}}; members that are inner-lists are represented as per {{inner-list}}.

~~~
List Field Value {
  Top Level Type (3) = 1,
  Length (5..),
  Item (..) ...
}
~~~

A List Field Value's fields are:

* Length: The number of octets used to represent the entire List, encoded as per {{!RFC7541}}, Section 5.1, with a 5-bit prefix
* Item: One or more Item(s) ({{types}})


### Dictionary Field Values

Dictionary values (type=0x2) have a payload consisting of a stream of Dictionary Members.

Each member is represented by a length, followed by that many bytes of the member-name, followed by the Binary Item Type(s) representing the member-value.

~~~
Dictionary Field Value {
  Top Level Type (3) = 2,
  Length (5..),
  Dictionary Member (..) ...
}
~~~

A Dictionary Field Value's fields are:

* Length: The number of octets used to represent the entire Dictionary, encoded as per {{!RFC7541}}, Section 5.1, with a 5-bit prefix
* Dictionary Member: one or more Dictionary Member(s)

~~~
Dictionary Member {
  Name Length (8..),
  Member Name (..),
  Item (..),
  [Parameters (..)]
}

~~~

A Dictionary Member's fields are:

* Name Length: The number of octets used to represent the Member Name, encoded as per {{!RFC7541}}, Section 5.1, with a 8-bit prefix
* Member Name: Name Length octets of the member-name, ASCII-encoded
* Item: An Item ({{types}})
* Parameters: Optional Parameters ({{parameter}})

The Item in a Dictionary Member MUST NOT be a Parameters (0x2).


### Item Field Values

Item values (type=0x3) have a payload consisting of Binary Item Types, as described in {{types}}.

~~~
Item Field Value {
  Top Level Type (3) = 3,
  Length (5..),
  Item (..)
  [Parameters (..)]
}
~~~

An Item Field Value's fields are:

* Length: The number of octets used to represent the Item (including Parameters, if present), encoded as per {{!RFC7541}}, Section 5.1, with a 5-bit prefix
* Item: An Item ({{types}})
* Parameters: Optional Parameters ({{parameter}})

The Item in an Item Field Value MUST NOT be an Inner List (0x1) or Parameters (0x2).


### Binary Literal Field Values {#literal}

Binary Literal values (type=0x4) are the string value of a field; they are used to carry field values that are not Binary Structured Fields, and may not be Structured Fields at all. As such, their semantics are that of String Literal Representations in {{!RFC7541}}, Section 5.2.

~~~
Binary Literal Field Value {
  Top Level Type (3) = 4,
  Length (5..),
  Payload (..)
}
~~~

A Binary Literal Field Value's fields are:

* Length: The number of octets used to represent the string literal, encoded as per {{!RFC7541}}, Section 5.1, with a 5-bit prefix
* Payload: The raw octets of the field value



## Binary Data Types {#types}

Every data type starts with a 5-bit type field that identifies the format of its payload.

~~~
Binary Data Type {
  Type (5)
}
~~~

Some data types contain padding bits; senders MUST set padding bits to 0; recipients MUST ignore their values.


### Inner Lists {#inner-list}

The Inner List data type (type=0x1) has a payload in the format:

~~~
Inner List {
  Type (5) = 1,
  Length (3..),
  Item (..) ...
}
~~~

Its fields are:

* Length: The number of octets used to represent the members, encoded as per {{!RFC7541}}, Section 5.1, with a 3-bit prefix
* Item(s): Length octets containing the Item(s) in the List

An Item in an Inner List MUST NOT be an Inner List (0x1).

Parameters on the Inner List itself, if present, are serialised in a following Parameter type ({{parameter}}); they do not form part of the payload of the Inner List (and therefore are not counted in Length).


### Parameters {#parameter}

The Parameters data type (type=0x2) has a payload in the format:

~~~
Parameters {
  Type (5) = 2,
  Length (3..),
  Parameter (..) ...
}
~~~

Its fields are:

* Length: The number of octets used to represent the payload, encoded as per {{!RFC7541}}, Section 5.1, with a 3-bit prefix
* Parameter(s): Length octets

Each Parameter conveys a key and a value:

~~~
Parameter {
  Parameter Name Length (8..),
  Parameter Name (..),
  Binary Data Type (..)
}
~~~

A parameter's fields are:

* Parameter Name Length: The number of octets used to represent the parameter-name, encoded as per {{!RFC7541}}, Section 5.1, with a 8-bit prefix
* Parameter Name: Parameter Name Length octets of the parameter-name
* Binary Data Type: The parameter value, a Binary Data Type

The Binary Data Type in a Parameter MUST NOT be an Inner List (0x1) or Parameters (0x2).

Parameters are always associated with the Binary Data Type that immediately preceded them. Therefore, Parameters MUST NOT be the first Binary Data Type in a container, and MUST NOT follow another Parameters.


### Integers

The Integer data type (type=0x3) has a payload in the format:

~~~
Integer {
  Type (5) = 3,
  Sign (1),
  Payload (2..)
}
~~~

Its fields are:

* Sign: sign bit; 0 is negative, 1 is positive
* Payload: The integer, encoded as per {{!RFC7541}}, Section 5.1, with a 2-bit prefix


### Floats

The Float data type (type=0x4) have a payload in the format:

~~~
Float {
  Type (5) = 4,
  Sign (1),
  Integer (2..),
  Fractional (8..)
}
~~~

Its fields are:

* Sign: sign bit; 0 is negative, 1 is positive
* Integer: The integer component, encoded as per {{!RFC7541}}, Section 5.1, with a 2-bit prefix.
* Fractional: The fractional component, encoded as per {{!RFC7541}}, Section 5.1, with a 8-bit prefix.


### Strings

The String data type (type=0x5) has a payload in the format:

~~~
String {
  Type (5) = 5,
  Length (3..),
  Payload (..)
}
~~~

Its fields are:

* Length: The number of octets used to represent the string, encoded as per {{!RFC7541}}, Section 5.1, with a 3-bit prefix.
* Payload: Length octets, ASCII-encoded.


### Tokens {#token}

The Token data type (type=0x6) has a payload in the format:

~~~
Token {
  Type (5) = 6,
  Length (3..),
  Payload (..)
}
~~~

Its fields are:

* Length: The number of octets used to represent the token, encoded as per {{!RFC7541}}, Section 5.1, with a 3-bit prefix.
* Payload: Length octets, ASCII-encoded.


### Byte Sequences

The Byte Sequence data type (type=0x7) has a payload in the format:

~~~
Byte Sequence {
  Type (5) = 7,
  Length (3..),
  Payload (..)
}
~~~

Its fields are:

* Length: The number of octets used to represent the byte sequence, encoded as per {{!RFC7541}}, Section 5.1, with a 3-bit prefix.
* Payload: Length octets.


### Booleans

The Boolean data type (type=0x8) has a payload of two bits:

~~~
Boolean {
  Type (5) = 8,
  Payload (1),
  Padding (2) = 0
}
~~~

If Payload is 0, the value is False; if Payload is 1, the value is True.




# Using Binary Structured Fields in HTTP/2 {#negotiate}

When both peers on a connection support this specification, they can take advantage of that knowledge to serialise fields that they know to be Structured Fields (or compatible with them; see {{backport}}) as binary data, rather than strings.

Peers advertise and discover this support using a HTTP/2 setting defined in {{setting}}, and convey Binary Structured Fields in streams whose HEADERS frame uses the flag defined in {{flag}}.


## The SETTINGS_BINARY_STRUCTURED_FIELDS Setting {#setting}

Advertising support for Binary Structured Fields is accomplished using a HTTP/2 setting, SETTINGS_BINARY_STRUCTURED_FIELDS (0xTODO).

Receiving SETTINGS_BINARY_STRUCTURED_FIELDS with a non-zero value from a peer indicates that:

1. The peer supports the Binary Item Types defined in {{fields}}.
2. The peer will process the BINHEADERS frames as defined in {{frame}}.
3. When a downstream consumer does not likewise support that encoding, the peer will transform them into HEADERS frames (if the peer is HTTP/2) or a form it will understand (e.g., the textual representation of Structured Fields data types defined in {{!RFC8941}}).
4. The peer will likewise transform all fields defined as Aliased Fields ({{aliased}}) into their non-aliased forms as necessary.

The default value of SETTINGS_BINARY_STRUCTURED_FIELDS is 0, whereas a value of 1 indicates that this specification is supported with no further extensions. Future specifications might use values greater than one to indicate support for extensions.


## The BINARY_STRUCTRED HEADERS Flag {#flag}

When a peer has indicated that it supports this specification as per {{setting}}, a sender can send the BINARY_STRUCTURED flag (0xTODO) on the HEADERS frame.

This flag indicates that the HEADERS frame containing it and subsequent CONTINUATION frames on the same stream use the Binary Representation defined in {{binlit}} instead of the String Literal Representation defined in {{!RFC7541, Section 5.2}} for all field values. Field names are still serialised as String Literal Representations.

In such frames, field values that are known to be Structured Fields and those that can be converted to Structured Fields (as per {{backport}}) MAY be sent using the applicable Binary Representation. However, any field value (including those defined as Structured Fields) can also be serialised as a Binary Literal ({{literal}}) to accommodate fields that are not defined as Structured Fields, not valid Structured Fields, or that the sending implementation does not wish to send as a Structured Field for some other reason.

Binary Representations are stored in the HPACK {{!RFC7541}} dynamic table, and their lengths are used for the purposes of maintaining dynamic table size ({{RFC7541, Section 4}}).

Note that HEADERS frames with and without the BINARY_STRUCTURED flag MAY be mixed on the same connection, depending on the requirements of the sender.


# Using Binary Structured Fields with Existing Fields {#backport}

Any field can potentially be parsed as a Structured Field according to the algorithms in {{!RFC8941}} and serialised as a Binary Structured Field. However, many cannot, so optimistically parsing them can be expensive.

This section identifies fields that will usually succeed in {{direct}}, and those that can be mapped into Structured Fields by using an alias field name in {{aliased}}.


## Directly Represented Fields {#direct}

The following HTTP field names can have their values parsed as Structured Fields according to the algorithms in {{!RFC8941}}, and thus can usually be serialised using the corresponding Binary Item Types.

When one of these fields' values cannot be represented using Structured Types in a Binary Representation, its value can instead be represented as a Binary Literal ({{literal}}).

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
* Alt-Svc - Dictionary
* Alt-Used - Item
* Cache-Control - Dictionary
* Connection - List
* Content-Encoding - List
* Content-Language - List
* Content-Length - Item
* Content-Type - Item
* Expect - Item
* Expect-CT - Dictionary
* Forwarded - Dictionary
* Host - Item
* Keep-Alive - Dictionary
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
* X-XSS-Protection - List

Note that only the delta-seconds form of Retry-After is supported; a Retry-After value containing a http-date will need to be either converted into delta-seconds or serialised as a Binary Literal ({{literal}}).


## Aliased Fields {#aliased}

The following HTTP field names can have their values represented in Structured Fields by mapping them into its data types and then serialising the resulting Structured Field using an alternative field name.

For example, the Date HTTP header field carries a http-date, which is a string representing a date:

~~~
Date: Sun, 06 Nov 1994 08:49:37 GMT
~~~

Its value is more efficiently represented as an integer number of delta seconds from the Unix epoch (00:00:00 UTC on 1 January 1970, minus leap seconds). Thus, the example above would be represented in (non-binary) Structured Fields as:

~~~
SF-Date: 784072177
~~~

As with directly represented fields, if the intended value of an aliased field cannot be represented using Structured Types successfully, its value can instead be represented as a Binary Literal ({{literal}}).

Note that senders MUST know that the next-hop recipient understands these fields (typically, using the negotiation mechanism defined in {{negotiate}}) before using them. Likewise, recipients MUST transform them back to their unaliased form before forwarding the message to a peer or other consuming components that do not have this capability.

Each field name listed below indicates a replacement field name and a way to map its value to Structured Fields.

* ISSUE: using separate names assures that the different syntax doesn't "leak" into normal fields, but it isn't strictly necessary if implementations always convert back to the correct form when giving it to peers or consuming software that doesn't understand this. <https://github.com/mnot/I-D/issues/307>

### URLs

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Fields by considering their payload a string.

* Content-Location - SF-Content-Location
* Location - SF-Location
* Referer - SF-Referer

For example, a (non-binary) Location:

~~~
SF-Location: "https://example.com/foo"
~~~

TOOD: list of strings, one for each path segment, to allow better compression in the future?

### Dates

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Fields by parsing their payload according to {{!RFC7230}}, Section 7.1.1.1, and representing the result as an integer number of seconds delta from the Unix Epoch (00:00:00 UTC on 1 January 1970, minus leap seconds).

* Date - SF-Date
* Expires - SF-Expires
* If-Modified-Since - SF-IMS
* If-Unmodified-Since - SF-IUS
* Last-Modified - SF-LM

For example, a (non-binary) Expires:

~~~
SF-Expires: 1571965240
~~~

### ETags

The following field names (paired with their replacement field names) have values that can be represented in Binary Structured Fields by representing the entity-tag as a string, and the weakness flag as a boolean "w" parameter on it, where true indicates that the entity-tag is weak; if 0 or unset, the entity-tag is strong.

* ETag - SF-ETag

For example, a (non-Binary) ETag:

~~~
SF-ETag: "abcdef"; w=?1
~~~

If-None-Match is a list of the structure described above.

* If-None-Match - SF-INM

For example, a (non-binary) If-None-Match:

~~~
SF-INM: "abcdef"; w=?1, "ghijkl"
~~~


### Links

The field-value of the Link header field {{!RFC8288}} can be represented in Binary Structured Fields by representing the URI-Reference as a string, and link-param as parameters.

* Link: SF-Link

For example, a (non-binary) Link:

~~~
SF-Link: "/terms"; rel="copyright"; anchor="#foo"
~~~

### Cookies

The field-value of the Cookie and Set-Cookie fields {{!RFC6265}} can be represented in Binary Structured Fields as a List with parameters and a Dictionary, respectively. The serialisation is almost identical, except that the Expires parameter is always a string (as it can contain a comma), multiple cookie-strings can appear in Set-Cookie, and cookie-pairs are delimited in Cookie by a comma, rather than a semicolon.

Set-Cookie: SF-Set-Cookie
Cookie: SF-Cookie

~~~
SF-Set-Cookie: lang=en-US, Expires="Wed, 09 Jun 2021 10:18:14 GMT"
SF-Cookie: SID=31d4d96e407aad42, lang=en-US
~~~

* ISSUE: explicitly convert Expires to an integer? <https://github.com/mnot/I-D/issues/308>
* ISSUE: dictionary keys cannot contain UC alpha. <https://github.com/mnot/I-D/issues/312>
* ISSUE: explicitly allow non-string content. <https://github.com/mnot/I-D/issues/313>


# IANA Considerations

* ISSUE: todo

# Security Considerations

As is so often the case, having alternative representations of data brings the potential for security weaknesses, when attackers exploit the differences between those representations and their handling.

One mitigation to this risk is the strictness of parsing for both non-binary and binary Structured Fields data types, along with the "escape valve" of Binary Literals ({{literal}}). Therefore, implementation divergence from this strictness can have security impact.


--- back


# Data Supporting Directly Represented Field Mappings

*RFC EDITOR: please remove this section before publication*

To help guide decisions about Directly Represented Fields, the HTTP response headers captured by the HTTP Archive <https://httparchive.org> in February 2020, representing more than 350,000,000 HTTP exchanges, were parsed as Structured Fields using the types listed in {{direct}}, with the indicated number of successful header instances, failures, and the resulting failure rate:

- accept: 9,198 / 10 = 0.109%
- accept-encoding: 34,157 / 74 = 0.216%
- accept-language: 381,034 / 512 = 0.134%
- accept-patch: 5 / 0 = 0.000%
- accept-ranges: 197,746,643 / 3,960 = 0.002%
- access-control-allow-credentials: 16,684,916 / 7,438 = 0.045%
- access-control-allow-headers: 12,976,838 / 15,074 = 0.116%
- access-control-allow-methods: 15,466,748 / 28,203 = 0.182%
- access-control-allow-origin: 105,307,402 / 271,359 = 0.257%
- access-control-max-age: 5,284,663 / 7,754 = 0.147%
- access-control-request-headers: 39,328 / 624 = 1.562%
- access-control-request-method: 146,259 / 13,821 = 8.634%
- age: 71,281,684 / 172,398 = 0.241%
- allow: 351,704 / 1,886 = 0.533%
- alt-svc: 19,775,126 / 15,680,528 = 44.226%
- cache-control: 264,805,256 / 782,896 = 0.295%
- connection: 105,876,072 / 2,915 = 0.003%
- content-encoding: 139,799,523 / 379 = 0.000%
- content-language: 2,367,162 / 728 = 0.031%
- content-length: 296,624,718 / 787,843 = 0.265%
- content-type: 341,918,716 / 795,676 = 0.232%
- expect: 0 / 47 = 100.000%
- expect-ct: 26,569,605 / 29,114 = 0.109%
- forwarded: 119 / 35 = 22.727%
- host: 25,333 / 1,441 = 5.382%
- keep-alive: 43,061,546 / 796 = 0.002%
- origin: 24,335 / 1,539 = 5.948%
- pragma: 46,820,588 / 81,700 = 0.174%
- preference-applied: 57 / 0 = 0.000%
- retry-after: 605,844 / 6,195 = 1.012%
- strict-transport-security: 26,825,957 / 35,258,808 = 56.791%
- surrogate-control: 121,118 / 861 = 0.706%
- te: 1 / 0 = 0.000%
- trailer: 282 / 0 = 0.000%
- transfer-encoding: 13,952,661 / 0 = 0.000%
- vary: 150,787,199 / 41,313 = 0.027%
- x-content-type-options: 99,968,016 / 208,885 = 0.209%
- x-xss-protection: 79,871,948 / 362,979 = 0.452%

This data set focuses on response headers, although some request headers are present (because, the Web).

`alt-svc` has a high failure rate because some currently-used ALPN tokens (e.g., `h3-Q43`) do not conform to key's syntax. Since the final version of HTTP/3 will use the `h3` token, this shouldn't be a long-term issue, although future tokens may again violate this assumption.

`forwarded` has a high failure rate because many senders use the unquoted form for IP addresses, which makes integer parsing fail; e.g., `for=192.168.1.1`.

`strict-transport-security` has a high failure rate because the `includeSubDomains` flag does not conform to the key syntax.

The top ten header fields in that data set that were not parsed as Directly Represented Fields are:

- date: 354,652,447
- server: 311,275,961
- last-modified: 263,832,615
- expires: 199,967,042
- status: 192,423,509
- etag: 172,058,269
- timing-allow-origin: 64,407,586
- x-cache: 41,740,804
- p3p: 39,490,058
- x-frame-options: 34,037,985





