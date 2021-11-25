---
title: Binary Structured HTTP Field Values
abbrev:
docname: draft-nottingham-binary-structured-headers-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/binary-structured-headers"

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
      - VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  RFC7541:
  STRUCTURED-FIELDS: RFC8941
  QUIC: RFC9001
  RETROFIT: I-D.nottingham-http-structure-retrofit

informative:


--- abstract

This specification defines a binary serialisation of Structured Field Values for HTTP, along with a negotiation mechanism for its use in HTTP/2.


--- middle

# Introduction

Structured Field Values for HTTP {{!STRUCTURED-FIELDS}} offers a set of data types that new fields can use to express their semantics in a familiar textual syntax. This specification defines an alternative, binary serialisation of those structures in {{fields}}, and specifies its use in HTTP/2 in {{negotiate}}.

The primary goal is to reduce parsing overhead and associated costs, as compared to the textual representation of Structured Fields. A secondary goal is a more compact wire format in common situations. An additional goal is to enable future work on more granular field compression mechanisms.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

This specification describes formats using the convention described in {{Section 1.3 of QUIC}}.


# Binary Structured Fields {#fields}

This section defines a binary serialisation for the Structured Field Types defined in {{!STRUCTURED-FIELDS}}.

The types permissable as the top-level of Structured Field values -- Dictionary, List, and Item -- are defined in terms of a Binary Representation ({{binlit}}), which is a replacement for the String Literal Representation in {{RFC7541}}.

Binary representations of the remaining structured field types are defined in {{types}}.


## Binary Representations {#binlit}

Binary Representations are a replacement for the String Literal Representation defined in {{Section 5.2 of RFC7541}}, and can be used to serialise any field, including but not limited to those defined as Structured Fields.

All Binary Representations share the following header:

~~~
Binary Representation {
  Top Level Type (3),
  Length (5..),
}
~~~

Its fields are:

* Top Level Type: Three bits indicating the top-level type of the field value.
* Length: The number of octets used to represent the entire field value (including the header), encoded as per {{Section 5.1 of RFC7541}}, with a 5-bit prefix.

The following top-level types are defined:


### Binary Literal Field Values {#literal}

Binary Literal field values (type=0x0) carry the string value of a field; they are used to carry field values that are not structured using the data types defined in {{Section 3 of STRUCTURED-FIELDS}}. This might be because the field is not recognised as a Structured Field, or it might be because a field that is understood to be a Structured Field cannot be parsed successfully as one.

A binary literal field value's payload is the raw octets of the field value. As such, they are functionally equivalent to String Literal Representations in {{Section 5.2 of RFC7541}}.

~~~
Binary Literal Field Value {
  Top Level Type (3) = 0,
  Length (5..),
  Payload (..)
}
~~~


### List Field Values

Structured fields whose values are known to be a List as per {{Section 3.1 of STRUCTURED-FIELDS}} can be conveyed as a binary representation with a top level type of 0x1. They have a payload consisting of one or more Binary Data Types ({{types}}) representing the members of the list.

~~~
List Field Value {
  Top Level Type (3) = 1,
  Length (5..),
  Binary Data Type (..) ...
}
~~~


### Dictionary Field Values

Structured fields whose values are known to be a Dictionary as per {{Section 3.2 of STRUCTURED-FIELDS}} can be conveyed in a binary representation with a top level type of 0x2. They have a payload consisting of one or more Dictionary Members.

~~~
Dictionary Field Value {
  Top Level Type (3) = 2,
  Length (5..),
  Dictionary Member (..) ...
}
~~~

Each Dictionary member is represented by a length, followed by that many bytes of the member-name, followed by the Binary Data Type(s) representing the member-value.

~~~
Dictionary Member {
  Name Length (8..),
  Member Name (..),
  Binary Data Type (..),
  [Parameters (..)]
}

~~~

The Binary Data Type in a Dictionary Member MUST NOT be a Parameters (0x2).


### Item Field Values

Structured field values that are known to be an Item as per {{Section 3.3 of STRUCTURED-FIELDS}} can be conveyed in a binary representation with a top level type of 0x3. They have a payload consisting of a single Binary Data Type ({{types}}), with optional parameters ({{parameter}}).

~~~
Item Field Value {
  Top Level Type (3) = 3,
  Length (5..),
  Binary Data Type (..),
  [Parameters (..)]
}
~~~

The Binary Data Type in an Item Field Value MUST NOT be an Inner List (0x1) or Parameters (0x2).


## Binary Data Types {#types}

Binary data types are discrete values that are composed into binary representations ({{binlit}}) to represent the structured field values.

Every binary data type starts with a 4-bit type field that identifies the format of its payload.

~~~
Binary Data Type {
  Type (4)
}
~~~

Some data types contain padding bits; senders MUST set padding bits to 0; recipients MUST ignore their values.


### Inner Lists {#inner-list}

The Inner List data type (type=0x1) has a payload in the format:

~~~
Inner List {
  Type (4) = 1,
  Length (4..),
  Binary Data Type (..) ...
}
~~~

Length conveys the number of octets used to represent the inner list, encoded as per {{Section 5.1 of RFC7541}}, with a 4-bit prefix.

A Binary Data Type in an Inner List MUST NOT be an Inner List (0x1).

Parameters on the Inner List itself, if present, are serialised in a following Parameter type ({{parameter}}); they do not form part of the payload of the Inner List (and therefore are not counted in Length).


### Parameters {#parameter}

The Parameters data type (type=0x2) has a payload in the format:

~~~
Parameters {
  Type (4) = 2,
  Length (4..),
  Parameter (..) ...
}
~~~

Length conveys the number of octets used to represent the parameters, encoded as per {{Section 5.1 of RFC7541}}, with a 4-bit prefix.

Each Parameter conveys a key and a value:

~~~
Parameter {
  Parameter Name Length (8..),
  Parameter Name (..),
  Binary Data Type (..)
}
~~~

A parameter's fields are:

* Parameter Name Length: The number of octets used to represent the parameter-name, encoded as per {{Section 5.1 of RFC7541}}, with a 8-bit prefix
* Parameter Name: Parameter Name Length octets of the parameter-name
* Binary Data Type: The parameter value, a Binary Data Type

The Binary Data Type in a Parameter MUST NOT be an Inner List (0x1) or Parameters (0x2).

Parameters are always associated with the Binary Data Type that immediately preceded them. Therefore, Parameters MUST NOT be the first Binary Data Type in a Binary Representation, and MUST NOT follow another Parameters.


### Integers

The Integer data type (type=0x3) has a payload in the format:

~~~
Integer {
  Type (4) = 3,
  Sign (1),
  Payload (3..)
}
~~~

Its fields are:

* Sign: sign bit; 0 is negative, 1 is positive
* Payload: The integer, encoded as per {{Section 5.1 of RFC7541}}, with a 2-bit prefix


### Floats

The Float data type (type=0x4) have a payload in the format:

~~~
Float {
  Type (4) = 4,
  Sign (1),
  Integer (3..),
  Fractional (8..)
}
~~~

Its fields are:

* Sign: sign bit; 0 is negative, 1 is positive
* Integer: The integer component, encoded as per {{Section 5.1 of RFC7541}}, with a 2-bit prefix.
* Fractional: The fractional component, encoded as per {{Section 5.1 of RFC7541}}, with a 8-bit prefix.


### Strings

The String data type (type=0x5) has a payload in the format:

~~~
String {
  Type (4) = 5,
  Length (4..),
  Payload (..)
}
~~~

Its payload is Length octets long and ASCII-encoded.


### Tokens {#token}

The Token data type (type=0x6) has a payload in the format:

~~~
Token {
  Type (4) = 6,
  Length (4..),
  Payload (..)
}
~~~

Its payload is Length octets long and ASCII-encoded.


### Byte Sequences

The Byte Sequence data type (type=0x7) has a payload in the format:

~~~
Byte Sequence {
  Type (4) = 7,
  Length (4..),
  Payload (..)
}
~~~

The payload is is Length octets long, containing the raw octets of the byte sequence.


### Booleans

The Boolean data type (type=0x8) has a payload of two bits:

~~~
Boolean {
  Type (4) = 8,
  Payload (1),
  Padding (3) = 0
}
~~~

If Payload is 0, the value is False; if Payload is 1, the value is True.




# Using Binary Structured Fields in HTTP/2 {#negotiate}

When both peers on a connection support this specification, they can take advantage of that knowledge to serialise fields that they know to be Structured Fields as binary data, rather than strings.

Peers advertise and discover this support using a HTTP/2 setting defined in {{setting}}, and convey Binary Structured Fields in streams whose HEADERS frame uses the flag defined in {{flag}}.


## The SETTINGS_BINARY_STRUCTURED_FIELDS Setting {#setting}

Advertising support for Binary Structured Fields is accomplished using a HTTP/2 setting, SETTINGS_BINARY_STRUCTURED_FIELDS (0xTODO).

Receiving SETTINGS_BINARY_STRUCTURED_FIELDS with a non-zero value from a peer indicates that:

1. The peer supports all of the Binary Data Types defined in {{fields}}.
2. The peer will process the BINARY_STRUCTRED HEADERS flag as defined in {{flag}}.
3. When passing the message to a downstream consumer (whether on the network or not), the peer will:
   1. Transform all fields defined as Mapped Fields in Section 1.3 of {{RETROFIT}} into their unmapped forms, removing the mapped fields.
   2. Transform the message fields into the appropriate form for that peer (e.g., the textual representation of Structured Fields data types defined in {{!STRUCTURED-FIELDS}}).

The default value of SETTINGS_BINARY_STRUCTURED_FIELDS is 0, whereas a value of 1 indicates that this specification is supported with no further extensions. Future specifications might use values greater than one to indicate support for extensions.


## The BINARY_STRUCTRED HEADERS Flag {#flag}

When a peer has indicated that it supports this specification as per {{setting}}, a sender can send the BINARY_STRUCTURED flag (0xTODO) on the HEADERS frame.

This flag indicates that the HEADERS frame containing it and subsequent CONTINUATION frames on the same stream use the Binary Representation defined in {{binlit}} instead of the String Literal Representation defined in {{Section 5.2 of RFC7541}} for all field values. Field names are still serialised as String Literal Representations.

In such frames, field values that are known to be Structured Fields and those that can be converted to Structured Fields (as per {{RETROFIT}}) MAY be sent using the applicable Binary Representation. However, any field value (including those defined as Structured Fields) can also be serialised as a Binary Literal ({{literal}}) to accommodate fields that are not defined as Structured Fields, not valid Structured Fields, or that the sending implementation does not wish to send as a Structured Field for some other reason.

Binary Representations are stored in the HPACK {{RFC7541}} dynamic table, and their lengths are used for the purposes of maintaining dynamic table size (see {{RFC7541, Section 4}}).

Note that HEADERS frames with and without the BINARY_STRUCTURED flag MAY be mixed on the same connection, depending on the requirements of the sender.


# IANA Considerations

* ISSUE: todo

# Security Considerations

As is so often the case, having alternative representations of data brings the potential for security weaknesses, when attackers exploit the differences between those representations and their handling.

One mitigation to this risk is the strictness of parsing for both non-binary and binary Structured Fields data types, along with the "escape valve" of Binary Literals ({{literal}}). Therefore, implementation divergence from this strictness can have security impact.


--- back

