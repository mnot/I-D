---
title: Structured HTTP Header Values
abbrev: Structured HTTP Headers
docname: draft-nottingham-structured-headers-00
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
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/structured-headers>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/structured-headers/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/structured-headers>.


--- middle

# Introduction

Specifying the syntax of new HTTP header fields is an onerous task; even with the guidance in {{?RFC7231}}, Section 8.3.1, there are many decisions -- and pitfalls -- for a prospective HTTP header field author.

Likewise, parsers often need to be written for specific HTTP headers, because each has slightly different handling of what looks like common syntax. 

This document introduces structured HTTP header field values (hereafter, Structured Headers) to address these problems. Structured Headers define a generic, abstract model for data, along with a concrete serialisation for expressing that model in textual HTTP headers, as used by HTTP/1 {{?RFC7230}} and HTTP/2 {{?RFC7540}}.

In doing so, it allows new headers to be defined much more easily and reliably, using the guidance in {{defining}}. Likewise, it offers a single parsing model for the headers that use the syntax.

Additionally, future versions of HTTP can define alternative serialisations of the abstract model, allowing headers that use it to be transmitted more efficiently without being redefined.

Note that it is not a goal of this document to redefine the syntax of existing HTTP headers; the mechanisms described herein are only intended to be used with headers that explicitly opt into them.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

# Structured Headers

A Structured Header is a HTTP header field-value {{RFC7230}} that uses the conventions defined in this document.

{{types}} defines a number of data types that can be used in Structured Headers, but only three are allowed at the "top" level; lists, dictionaries, or items.



## Serialising Structured Headers as Text

In HTTP/2 and previous versions of the protocol, HTTP headers are strongly encouraged to be serialised as ASCII characters, to aid interoperability. Therefore, Structured Headers that contain non-ASCII content are encoded to be safe to use over these protocol versions.

To aid parsers in automatically identifying a Structured Header in the textual serialisation, its value's first non-whitespace character MUST be a "|" sigil character.

Other serialisations of Structured Headers might use a different means of indicating their presence and type.

The payload after the sigil is expected to be either a list, dictionary, or item, as defined below.


## Specifying Structured Headers


versioning

Note that empty headers are not allowed by the syntax, and must be considered errors.


# Structured Header Data Types {#types}

This section defines the abstract value types that can be composed into Structured Headers, along with the textual HTTP serialisations of them. 


## Numbers {#number}

Abstractly, numbers are integers within the range -(2**53)+1 to (2**53)-1, with an optional fractional part. They MUST NOT include numbers that express greater magnitude or precision than an IEEE 754 double precision number ({{IEEE754}}) provides.

The textual HTTP serialisation of numbers is compatible with JSON numbers ({{?RFC7159}}), although it does not include exponents.

~~~
number        = [ "-" ] int [ frac ]
int           = zero / ( digit1-9 *14DIGIT )
frac          = "." 1*10DIGIT
zero          = %x30      ; 0
digit1-9      = %x31-39   ; 1-9
~~~


## Strings {#string}

Abstractly, strings are Unicode strings {{UNICODE}} that MUST NOT include code points that identify Surrogates or Noncharacters as defined by {{UNICODE}}.

The textual HTTP serialisation of strings uses percent-encoding {{RFC3986}} over UTF-8 for all non-ASCII characters, as well as double quotes.

~~~
string = DQUOT *char DQUOT
char = unescaped /
  escape (
      %x22 /          ; "    quotation mark  U+0022
      %x5C /          ; \    reverse solidus U+005C
      %x2F /          ; /    solidus         U+002F
      %x62 /          ; b    backspace       U+0008
      %x66 /          ; f    form feed       U+000C
      %x6E /          ; n    line feed       U+000A
      %x72 /          ; r    carriage return U+000D
      %x74 /          ; t    tab             U+0009
      %x75 4HEXDIG )  ; uXXXX                U+XXXX
escape = %x5C              ; \
unescaped = %x20-21 / %x23-5B / %x5D-10FFFF
~~~


## Labels {#label}

Labels are short (up to 256 characters), textual identifiers; their abstract model is identical to their expression in the textual HTTP serialisation.

~~~
label = ALPHA *255( ALPHA / DIGIT / _ / - )
~~~


## Binary Content {#binary}

Arbitrary binary content up to 16K in size can be conveyed in Structured Headers.

The textual HTTP serialisation indicates their presence by a leading "*", with the data encoded using BASE64 (without newlines or "=" padding).

~~~
binary = '*' 1*21846(base64)
base64 = ALPHA / DIGIT / "+" / "/"
~~~

For example, a header whose value is defined as binary content could look like:

~~~
ExampleBinaryHeader: |*cHJldGVuZCB0aGlzIGlzIGJpbmFyeSBjb250ZW50Lg
~~~


## Items {#item}

An item is can be a number ({{number}}), string ({{string}}), label ({{label}}) or binary content ({{binary}}).

~~~
item = number / string / label / binary
~~~


## Dictionaries {#dictionary}

Dictionaries are unordered maps of key-value pairs, where the keys are labels ({{label}}) and the values are items ({{item}}). There can be between 1 and 1024 members, and keys are required to be unique.

In the textual HTTP serialisation, keys and values are separated by "=" (without whitespace), and key/value pairs are separated by a comma with optional whitespace.

~~~
dictionary = label "=" item *1023( OWS "," OWS label "=" item )
~~~

For example, a header field whose value is defined as a dictionary could look like:

~~~
ExampleDictHeader: |foo=1.232, bar="We hold these truths...", baz=testing1
    *baz=cHJldGVuZCB0aGlzIGlzIGJpbmFyeSBjb250ZW50Lg
~~~


## Lists {#list}

Lists are arrays of items ({{item}}), with one to 1024 members. 

In the textual HTTP serialisation, each item is separated by a comma and optional whitespace.

~~~
list = item 1*1024( OWS "," OWS item )
~~~


# Security Considerations


--- back
