---
title: Binary Structured HTTP Field Values
abbrev:
docname: draft-nottingham-binary-structured-headers-latest
date: draft-nottingham-binary-structured-headers-date
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/binary-structured-headers"

github-issue-label: binary-structured-headers

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
    country: Australia
    email: mnot@mnot.net
    uri: https://mnot.net/

normative:
  RFC2119:
  RFC7541:
  STRUCTURED-FIELDS: RFC9651
  HTTP: RFC9110
  HTTP2: RFC9113
  UTF8: RFC3629
  QUIC: RFC9000
  RETROFIT: I-D.ietf-httpbis-retrofit

informative:


--- abstract

This specification defines a binary serialisation of Structured Field Values for HTTP, along with a negotiation mechanism for its use in HTTP/2.


--- middle

# Introduction

Structured Field Values for HTTP {{!STRUCTURED-FIELDS}} offers a set of data types for use by HTTP fields, along with a serialisation of them in a familiar textual syntax.

{{fields}} defines an alternative, binary serialisation of those structures, and {{negotiate}} defines a mechanism for using that serialisation in HTTP/2.

The primary goal of this specification is to reduce parsing overhead and associated costs, as compared to the textual representation of Structured Fields. A secondary goal is a more compact wire format in common situations. An additional goal is to enable future work on more granular field compression mechanisms.


## Notational Conventions

{::boilerplate bcp14-tagged}

This specification describes wire formats using the convention described in {{Section 1.3 of QUIC}}.


# Binary Structured Types {#fields}

This section defines a binary serialisation for Structured Field Values as defined in {{!STRUCTURED-FIELDS}}.

A Structured Field Value can be a singular Item (such as a String, an Integer, or a Boolean, possibly with parameters), or it can be a compound type, such as a Dictionary or List, whose members are composed of those Item types.

When a field value is serialised as a Binary Structured Field, each of these types is preceded by a header octet that indicates the relevant type, along with some type-specific flags. The type then determines how the value is serialised in the following octet(s).

~~~
Binary Structured Type {
  Type (5),
  Flags (3),
  [Payload (..)]
}
~~~

Use of each flag may not be specified by all types. When this is the case, generators MUST send 0 for them, and recipients MUST ignore them.


## Recipient Validation {#validation}

A recipient of a Binary Structured Field Value MUST check it against the constraints in this section, which carry over the restrictions that {{!STRUCTURED-FIELDS}} places on the textual form. The sections for each type state the checks on its payload. Checks that apply to the value as a whole are:

* Every Type is defined by this specification, or by an extension that the recipient supports (see {{setting}}).
* No Member Count, Parameter Count, Length or Key Length reaches past the end of the field value, and no octets remain after the top-level type and any Parameters that follow it.
* Each type appears only where {{!STRUCTURED-FIELDS}} allows that data type: the top-level type is a List, a Dictionary or an Item; the members of Lists and Dictionaries are Items or Inner Lists; the members of Inner Lists and the values of Parameters are Items.
* The Parameters Flag is never set on the value of a Parameter ({{parameter}}).

A value that fails any of these checks is malformed; see {{malformed}}.

A recipient that skipped these checks could accept values that the textual form cannot express, and then be unable to serialise them for a peer that does not support this specification (see {{setting}}).


## Literal Values {#literal}

A Literal Value is a special type that carries the string value of a field; they are used to carry field values that are not structured using the data types defined in {{Section 3 of STRUCTURED-FIELDS}}. This might be because the field is not recognised as a Structured Field, or it might be because a field that is understood to be a Structured Field cannot be parsed successfully as one.

A literal value's payload consists of an integer Length field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by that many octets of the field value. They are functionally equivalent to String Literal Representations in {{Section 5.2 of RFC7541}}.

~~~
Literal Value {
  Type (5) = 0,
  Unused Flags (3) = 0,
  Length (i),
  Payload (..)
}
~~~

A recipient MUST apply the field value validation in {{Section 8.2.1 of HTTP2}} to the payload.


## Lists

A List ({{Section 3.1 of STRUCTURED-FIELDS}}) uses its Flags to carry a Short Member Count as three bits.

If the Short Member Count is zero, it indicates that the next byte is the Member Count, represented using the variable-length encoding from {{Section 16 of QUIC}}. Otherwise, it indicates the Member Count itself. This allows a small list to be encoded without using an extra byte for its length.

In either case, the payload indicates the number of List members that follow.

~~~
List {
  Type (5) = 1,
  Short Member Count (3),
  [ Member Count (i) ],
  Binary Structured Type (..) ...
}
~~~




## Dictionaries {#dictionary}

A Dictionary ({{Section 3.2 of STRUCTURED-FIELDS}}) uses its Flags to indicate its number of members, in a fashion similar to Lists.

~~~
Dictionary {
  Type (5) = 2,
  Short Member Count (3),
  [ Member Count (i) ],
  Dictionary Member (..) ...
}
~~~

Each Dictionary member is represented by a length, followed by that many bytes of the member-key, followed by the Binary Structured Type(s) representing the member-value.

~~~
Dictionary Member {
  Key Length (i),
  Member Key (..),
  Binary Structured Type (..),
}

~~~

A Member Key is at least one octet long. Its first octet MUST be a lowercase letter (0x61 to 0x7A) or "\*", and each following octet MUST be a lowercase letter, a digit, or one of "\_", "-", "." and "\*" (see {{Section 4.2.3.3 of STRUCTURED-FIELDS}}). If a Member Key occurs more than once in a Dictionary, the last value overwrites the earlier ones, and the key keeps the position of its first occurrence (see {{Section 4.2.2 of STRUCTURED-FIELDS}}).


## Inner Lists {#inner-list}

An Inner List ({{Section 3.1.1 of STRUCTURED-FIELDS}}) has a payload consisting of a Member Count field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by one or more fields representing the members of the list.

~~~
Inner List {
  Type (5) = 3,
  Parameters (1),
  Unused Flags (2),
  Member Count (i),
  Binary Structured Type (..) ...
  [Parameters (..)]
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

Parameters on the Inner List itself, if present, follow its last member ({{parameter}}); they do not form part of the payload of the Inner List (and therefore are not counted in Member Count).


### Parameters {#parameter}

Parameters ({{Section 3.1.2 of STRUCTURED-FIELDS}}) are not a Binary Structured Type of their own. An Item or Inner List whose Parameters Flag is set is followed by Parameters, in this form:

~~~
Parameters {
  Parameter Count (i),
  Parameter (..) ...
}
~~~

A recipient MUST treat a Parameter Count of zero as malformed, because the textual form cannot express a set of Parameters with no members.

Each Parameter conveys a key and a value:

~~~
Parameter {
  Parameter Key Length (i),
  Parameter Key (..),
  Binary Structured Type (..)
}
~~~

A parameter's fields are:

* Parameter Key Length: The number of octets used for the parameter-key (using the variable-length encoding from {{Section 16 of QUIC}})
* Parameter Key: Parameter Key Length octets of the parameter-key
* Binary Structured Type: The parameter value

The Binary Structured Type in a Parameter is an Item; it MUST NOT be an Inner List, and its Parameters Flag MUST NOT be set.

A Parameter Key is validated in the same way as a Member Key (see {{dictionary}}). Duplicates are handled as for Member Keys (see {{Section 4.2.3.2 of STRUCTURED-FIELDS}}).

### Integers

An Integer ({{Section 3.3.1 of STRUCTURED-FIELDS}}) has a payload consisting of a single integer (using the variable-length encoding from {{Section 16 of QUIC}}). The Sign flag conveys whether the value is positive (1) or negative (0).

~~~
Integer {
  Type (5) = 5,
  Parameters (1),
  Sign (1),
  Unused Flag (1) = 0,
  Payload (i)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

A recipient MUST treat an Integer whose payload exceeds 999,999,999,999,999 (the range limit in {{Section 3.3.1 of STRUCTURED-FIELDS}}) as malformed, even though the variable-length encoding can carry larger values.


### Decimals {#decimal}

A Decimal ({{Section 3.3.2 of STRUCTURED-FIELDS}}) has a payload consisting of two integers (using the variable-length encoding from {{Section 16 of QUIC}}) that are divided to convey the decimal value. The Sign flag conveys whether the value is positive (1) or negative (0).

~~~
Decimal {
  Type (5) = 6,
  Parameters (1),
  Sign (1),
  Unused Flag (1) = 0,
  Payload (i)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

The two low-order bits of the payload are the Scale, which is the number of digits after the decimal point (0 to 3). The remaining bits are the Mantissa, so the value is the Mantissa divided by 10 to the power of the Scale. For example, 4.5 has a Mantissa of 45 and a Scale of 1, so its payload is 181 (45 \* 4 + 1); -0.25 has a Mantissa of 25, a Scale of 2, a payload of 102, and the Sign flag set to negative. A Scale of 0 is a Decimal whose fractional part is zero; it is still a Decimal, not an Integer, and the textual form serialises it with a ".0".

Generators MUST use the smallest Scale that represents the value exactly, so that each value has one encoding. A recipient MUST treat a Decimal whose Mantissa is 10 to the power of (12 + Scale) or greater as malformed, because its integer component would have more than twelve digits ({{Section 3.3.2 of STRUCTURED-FIELDS}}).


### Strings

A String ({{Section 3.3.3 of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by that many octets of payload.

~~~
String {
  Type (5) = 7,
  Parameters (1),
  Unused Flags (2) = 0,
  Length (i),
  Payload (..)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

Its payload is Length octets long, and each octet MUST be in the range 0x20 to 0x7E (inclusive), as in {{Section 3.3.3 of STRUCTURED-FIELDS}}. A recipient MUST treat a String that contains any other octet as malformed.


### Tokens {#token}

A Token ({{Section 3.3.4 of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by that many octets of payload.

~~~
Token {
  Type (5) = 8,
  Parameters (1),
  Unused Flags (2) = 0,
  Length (i),
  Payload (..)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

Its payload is Length octets long. The first octet MUST be a letter (0x41 to 0x5A or 0x61 to 0x7A) or "\*", and each following octet MUST be a "tchar" ({{Section 5.6.2 of HTTP}}), ":" or "/" (see {{Section 3.3.4 of STRUCTURED-FIELDS}}). A recipient MUST treat a Token that is empty, or that contains any other octet, as malformed.


### Byte Sequences

A Byte Sequence ({{Section 3.3.5 of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by that many octets of payload.

~~~
Byte Sequence {
  Type (5) = 9,
  Parameters (1),
  Unused Flags (2) = 0,
  Length (i),
  Payload (..)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

The payload is Length octets long, containing the raw octets of the byte sequence.


### Booleans

A Boolean ({{Section 3.3.6 of STRUCTURED-FIELDS}}) uses the Payload flag to indicate its value; if Payload is 0, the value is False; if Payload is 1, the value is True.

The Boolean data type carries its payload in the Payload Flag:

~~~
Boolean {
  Type (5) = 10,
  Parameters (1),
  Payload (1),
  Unused Flag (1) = 0,
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).


### Dates

A Date ({{Section 3.3.7 of STRUCTURED-FIELDS}}) has a payload consisting of a single integer (using the variable-length encoding from {{Section 16 of QUIC}}), conveying the number of seconds since 1970-01-01T00:00:00Z, excluding leap seconds. The Sign flag conveys whether the value is positive (1) or negative (0).

~~~
Date {
  Type (5) = 11,
  Parameters (1),
  Sign (1),
  Unused Flag (1) = 0,
  Payload (i)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

A recipient MUST treat a Date whose payload exceeds 999,999,999,999,999 as malformed, as for an Integer.


### Display Strings

A Display String ({{Section 3.3.8 of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field (using the variable-length encoding from {{Section 16 of QUIC}}), followed by that many octets of payload.

~~~
Display String {
  Type (5) = 12,
  Parameters (1),
  Unused Flags (2) = 0,
  Length (i),
  Payload (..)
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}).

Its payload is Length octets long and UTF-8 encoded ({{UTF8}}). Unlike the textual form, it is not percent-encoded. A recipient MUST treat a payload that is not valid UTF-8 as malformed.


# Using Binary Structured Fields in HTTP/2 {#negotiate}

When both peers on a connection support this specification, they can negotiate to serialise fields that they know to be Structured Fields as binary data, rather than strings.

Peers advertise and discover this support using a HTTP/2 setting defined in {{setting}}, and convey Binary Structured Fields in streams whose HEADERS frame uses the flag defined in {{flag}}.


## The SETTINGS_BINARY_STRUCTURED_FIELDS Setting {#setting}

Advertising support for Binary Structured Fields is accomplished using a HTTP/2 setting, SETTINGS_BINARY_STRUCTURED_FIELDS (0xTODO).

Receiving SETTINGS_BINARY_STRUCTURED_FIELDS with a non-zero value from a peer indicates that:

1. The peer supports all of the Binary Structured Types defined in {{fields}}.
2. The peer will process the BINARY_STRUCTURED HEADERS flag as defined in {{flag}}.
3. When passing the message to a downstream consumer (whether on the network or not) who does not support this extension or otherwise explicitly negotiate an equivalent mechanism, the peer will:
   1. Transform all fields defined as Mapped Fields in Section 1.3 of {{RETROFIT}} into their unmapped forms, removing the mapped fields.
   2. Serialize all fields into the appropriate form for that peer (e.g., the textual representation of Structured Fields data types defined in {{!STRUCTURED-FIELDS}}).

The default value of SETTINGS_BINARY_STRUCTURED_FIELDS is 0, whereas a value of 1 indicates that this specification is supported with no further extensions. Future specifications might use values greater than one to indicate support for extensions.


## The BINARY_STRUCTURED HEADERS Flag {#flag}

When a peer has indicated that it supports this specification as per {{setting}}, a sender can send the BINARY_STRUCTURED flag (0xTODO) on the HEADERS frame.

This flag indicates that the HEADERS frame containing it and subsequent CONTINUATION frames on the same stream use the Binary Structured Types defined in {{fields}} instead of the String Literal Representation defined in {{Section 5.2 of RFC7541}} to represent all field values. Field names are still serialised as String Literal Representations.

In such frames, all field values MUST be sent as Binary Structured Field Values. Note that this includes Binary Literals ({{literal}}) for those field values that are not recognised as Structured Fields, as well as textual values that cannot be successfully parsed as Structured Fields. Implementations MAY also send a field value as a Binary Literal even when it is possible to represent it as a Structured Field (e.g., for efficiency purposes).

Binary Structured Field Values are stored in the HPACK {{RFC7541}} dynamic table, and their lengths are used for the purposes of maintaining dynamic table size (see {{RFC7541, Section 4}}).

Note that HEADERS frames with and without the BINARY_STRUCTURED flag MAY be mixed on the same connection, depending on the requirements of the sender.


## Malformed Binary Structured Field Values {#malformed}

A Binary Structured Field Value that fails a check in {{validation}} makes the message that contains it malformed ({{Section 8.1.1 of HTTP2}}). {{Section 4.2 of STRUCTURED-FIELDS}} allows a failed parse to either ignore the field or make the message malformed; this specification requires the latter. A sender that cannot produce a valid Structured Field can send a Binary Literal ({{literal}}) instead, so an invalid value indicates a faulty sender.

The recipient MUST NOT stop decoding the field block at the malformed value, because HPACK decoder state would then diverge from the sender's. It completes decoding, and then handles the malformed message as {{Section 8.1.1 of HTTP2}} requires: as a stream error of type PROTOCOL_ERROR, without forwarding it.

If a value is malformed in a way that prevents the recipient from determining where it ends, the field block cannot be decoded. That is a decoding error, and the recipient MUST treat it as a connection error of type COMPRESSION_ERROR ({{Section 4.3 of HTTP2}}).


# IANA Considerations

* ISSUE: todo

# Security Considerations

As is so often the case, having alternative representations of data brings the potential for security weaknesses, when attackers exploit the differences between those representations and their handling.

One mitigation to this risk is the strictness of parsing for both non-binary and binary Structured Fields data types ({{validation}}), along with the "escape valve" of Binary Literals ({{literal}}). Therefore, implementation divergence from this strictness can have security impact.


--- back

# Changes from Previous Drafts
{:removeInRFC="true"}

Each new draft adds a section here, above the existing ones, as part of the change that makes the difference.

## Since draft-nottingham-binary-structured-headers-03

* Moved the Structured Fields reference to RFC 9651, and added Date (type 11) and Display String (type 12).
* Added recipient validation for each type ({{validation}}).
* Defined malformed Binary Structured Field Values, and how a recipient handles them ({{malformed}}).
* Made duplicate Dictionary and Parameter keys last-wins, as in the textual form.
* Parameters are no longer a Binary Structured Type; they follow their Item or Inner List as a Parameter Count and the Parameters ({{parameter}}). Type 4 is unassigned.
* Decimals are a Mantissa and a Scale in a single integer, rather than a dividend and a divisor ({{decimal}}).
* Fixed typos, and type numbers that were wrong in the text.

