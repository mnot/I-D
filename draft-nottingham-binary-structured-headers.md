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

github-issue-label: binary-structured-headers

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

Structured Field Values for HTTP {{!STRUCTURED-FIELDS}} offers a set of data types that new fields can use to express their semantics in a familiar textual syntax. {{fields}} defines an alternative, binary serialisation of those structures, and {{negotiate}} defines a mechanism for using that serialisation in HTTP/2.

The primary goal is to reduce parsing overhead and associated costs, as compared to the textual representation of Structured Fields. A secondary goal is a more compact wire format in common situations. An additional goal is to enable future work on more granular field compression mechanisms.


## Notational Conventions

{::boilerplate bcp14-tagged}

This specification describes formats using the convention described in {{Section 1.3 of QUIC}}.


# Binary Structured Types {#fields}

This section defines a binary serialisation for Structured Field Values as defined in {{!STRUCTURED-FIELDS}}.

A Structured Field value can be a singular Item (such as a String, an Integer, or a Boolean, possibly with parameters), or it can be a compound type, such as a Dictionary or List, whose members are composed of those Item types.

When a field value is serialised as a Binary Structured Field, each of these types is preceded by an header octet that indicates the relevant type, along with some type-specific flags. The type then determines how the value is serialised in the following octet(s).

~~~
Binary Structured Type {
  Type (5),
  Parameters (1),
  Flag1 (1),
  Flag2 (1),
  [Payload (..)]
}
~~~

The Parameters Flag indicates whether the value is followed by Parameters (see {{parameter}}). Flag1 and Flag2 are available for use by the indicated Type.

Parameters, Flag1, and/or Flag2 may not be specified for use by all Types. When this is the case, generators of values MUST send 0 for them, and recipients MUST ignore them.



## Literal Values {#literal}

A Literal Value is a special type that carries the string value of a field; they are used to carry field values that are not structured using the data types defined in {{Section 3 of STRUCTURED-FIELDS}}. This might be because the field is not recognised as a Structured Field, or it might be because a field that is understood to be a Structured Field cannot be parsed successfully as one.

A literal value's payload consists of a Length field, followed by that many octets of the field value. As such, they are functionally equivalent to String Literal Representations in {{Section 5.2 of RFC7541}}.

~~~
Literal Value {
  Type (5) = 0,
  Parameters (1) = 0,
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Length (i),
  Payload (..)
}
~~~


## Lists

A List ({{Section 3.1 of STRUCTURED-FIELDS}}) has a payload consisting a Member Count field, followed by one or more fields representing the members of the list.

~~~
List {
  Type (5) = 1,
  Parameters (1) = 0,
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Member Count (i),
  Binary Structured Type (..) ...
}
~~~


## Dictionaries

A Dictionary ({{Section 3.3 of STRUCTURED-FIELDS}}) has a payload consisting a Member Count field, followed by one or more Dictionary Members.

~~~
Dictionary {
  Type (5) = 2,
  Parameters (1) = 0,
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Member Count (i),
  Dictionary Member (..) ...
}
~~~

Each Dictionary member is represented by a length, followed by that many bytes of the member-name, followed by the Binary Data Type(s) representing the member-value.

~~~
Dictionary Member {
  Name Length (i),
  Member Name (..),
  Binary Structured Type (..),
}

~~~

A Dictionary Member MUST NOT be a Parameters (0x2).


## Inner Lists {#inner-list}

An Inner List () has a payload consisting a Member Count field, followed by one or more fields representing the members of the list.

~~~
Inner List {
  Type (5) = 3,
  Parameters (1),
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Member Count (i),
  Binary Structured Type (..) ...
  [Parameters (..)]
}
~~~

Parameters on the Inner List itself, if present, are serialised in a following Parameter type ({{parameter}}); they do not form part of the payload of the Inner List (and therefore are not counted in Member Count).


### Parameters {#parameter}

Parameters ({{Section x.x of STRUCTURED-FIELDS}}) have a payload consisting a Parameter Count field, followed by one or more Parameter.

~~~
Parameters {
  Type (5) = 4,
  Parameters (1) = 0,
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Parameter Count (i),
  Parameter (..) ...
}
~~~

Each Parameter conveys a key and a value:

~~~
Parameter {
  Parameter Name Length (i),
  Parameter Name (..),
  Binary Structured Type (..)
}
~~~

A parameter's fields are:

* Parameter Name Length: The number of octets used to represent the parameter-name, encoded as per {{Section 5.1 of RFC7541}}, with a 8-bit prefix
* Parameter Name: Parameter Name Length octets of the parameter-name
* Binary Data Type: The parameter value, a Binary Data Type

The Binary Data Type in a Parameter MUST NOT be an Inner List (0x1) or Parameters (0x2).

Parameters are always associated with the Binary Data Type that immediately preceded them. Therefore, Parameters MUST NOT be the first Binary Data Type in a Binary Representation, and MUST NOT follow another Parameters.


### Integers

An Integer ({{Section x.x of STRUCTURED-FIELDS}}) has a payload consisting of a single integer. The Sign flag conveys whether the value is positive (1) or negative (0).

~~~
Integer {
  Type (5) = 5,
  Parameters (1),
  Sign (1),
  Flag2 (1) = 0,
  Payload (i)
}
~~~



### Decimals

A Decimal ({{Section x.x of STRUCTURED-FIELDS}}) has a payload consisting of two integers that are divided to convey the decimal value. The Sign flag conveys whether the value is positive (1) or negative (0).

~~~
Decimal {
  Type (5) = 6,
  Parameters (1),
  Sign (1),
  Flag2 (1) = 0,
  Dividend (i),
  Divisory (i)
}
~~~



### Strings

A String ({{Section x.x of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field, followed by that many octets of payload.

~~~
String {
  Type (5) = 7,
  Parameters (1),
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Length (i),
  Payload (..)
}
~~~

Its payload is Length octets long and ASCII-encoded.


### Tokens {#token}

A Token ({{Section x.x of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field, followed by that many octets of payload.

~~~
Token {
  Type (5) = 8,
  Parameters (1),
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Length (i),
  Payload (..)
}
~~~

Its payload is Length octets long and ASCII-encoded.


### Byte Sequences

A Byte Sequence ({{Section x.x of STRUCTURED-FIELDS}}) has a payload consisting of an integer Length field, followed by that many octets of payload.

~~~
Byte Sequence {
  Type (5) = 9,
  Parameters (1),
  Flag1 (1) = 0,
  Flag2 (1) = 0,
  Length (i),
  Payload (..)
}
~~~

The payload is is Length octets long, containing the raw octets of the byte sequence.


### Booleans

A String ({{Section x.x of STRUCTURED-FIELDS}}) uses the Payload flag to indicate its value; if Payload is 0, the value is False; if Payload is 1, the value is True.

The Boolean data type (type=0x8) has a payload of two bits:

~~~
Boolean {
  Type (5) = 10,
  Parameters (1),
  Payload (1),
  Flag2 (1) = 0
}
~~~



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

This flag indicates that the HEADERS frame containing it and subsequent CONTINUATION frames on the same stream use the Binary Structured Types defined in {{fields}} instead of the String Literal Representation defined in {{Section 5.2 of RFC7541}} to represent all field values. Field names are still serialised as String Literal Representations.

In such frames, field values that are known to be Structured Fields and those that can be converted to Structured Fields (per {{RETROFIT}}) MAY be sent using the applicable Binary Representation. However, any field value (including those defined as Structured Fields) can also be serialised as a Binary Literal ({{literal}}) to accommodate fields that are not defined as Structured Fields, not valid Structured Fields, or that the sending implementation does not wish to send as a Structured Field for some other reason.

Binary Representations are stored in the HPACK {{RFC7541}} dynamic table, and their lengths are used for the purposes of maintaining dynamic table size (see {{RFC7541, Section 4}}).

Note that HEADERS frames with and without the BINARY_STRUCTURED flag MAY be mixed on the same connection, depending on the requirements of the sender.


# IANA Considerations

* ISSUE: todo

# Security Considerations

As is so often the case, having alternative representations of data brings the potential for security weaknesses, when attackers exploit the differences between those representations and their handling.

One mitigation to this risk is the strictness of parsing for both non-binary and binary Structured Fields data types, along with the "escape valve" of Binary Literals ({{literal}}). Therefore, implementation divergence from this strictness can have security impact.


--- back

