---
title: The Problem-Details HTTP Header Field
abbrev: Problem-Details Header
docname: draft-nottingham-problem-header-latest
date: draft-nottingham-problem-header-date
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://projects.mnot.net/I-D/"
  repo: "https://github.com/mnot/I-D/labels/problem-header"

github-issue-label: problem-header

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: Cloudflare
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://mnot.net/

normative:
  HTTP: RFC9110
  STRUCTURED-FIELDS: RFC9651
  PROBLEM: RFC9457
  JSON: RFC8259


--- abstract

This specification defines the Problem-Details HTTP header field, which carries a problem details object (RFC 9457) as a Structured Field. Because the Structured Fields data model is more constrained than JSON's, it also defines a profile that problem types can opt into so that they can be serialised as a header.


--- middle


# Introduction

Problem details {{PROBLEM}} give HTTP APIs a common way to describe an error, but only in a message's content, as JSON {{JSON}} or XML. That is not always available. A response to a HEAD request has no content; a response whose content is a representation of the resource cannot also carry problem details; and an intermediary that generates or annotates an error might not be able to alter the content it forwards.

This specification defines the "Problem-Details" response header field ({{field}}) to carry problem details as a Structured Field {{STRUCTURED-FIELDS}}.

Structured Fields cannot represent the entire JSON data model, so not every problem details object can be carried in the field. {{profile}} defines a profile of problem details -- *header-compatible problem types* -- to enable problem types to opt into being carried as HTTP header fields. Problem types that do not opt in to that profile can still be conveyed using the field, but the header field will only carry the members defined in {{PROBLEM}}.

## Notational Conventions

{::boilerplate bcp14-tagged}

This document uses the following terminology from {{Section 3 of STRUCTURED-FIELDS}} to specify syntax and parsing: Dictionary, Inner List, Integer, Decimal, String, Token, Boolean, Parameters, Byte Sequence, Date, and Display String.

It uses "problem details object", "problem type" and "extension member" as defined in {{PROBLEM}}.


# The Problem-Details Header Field {#field}

The "Problem-Details" response header field conveys a problem details object {{PROBLEM}}. Its value is a Dictionary.

Each member of the Dictionary corresponds to the member of the problem details object with the same name, and has the Structured Type shown in {{table-members}}.

| Member   | Structured Type | JSON type                       |
|----------|-----------------|---------------------------------|
| type     | String          | string (a URI reference)        |
| status   | Integer         | number                          |
| title    | Display String  | string                          |
| detail   | Display String  | string                          |
| instance | String          | string (a URI reference)        |
{: #table-members title="Problem Details Members in the Problem-Details Field"}

The semantics of the members are as defined in {{Section 3.1 of PROBLEM}}. A member whose value is not of the type shown in {{table-members}} is ignored, as in {{Section 3.1 of PROBLEM}}.

A sender MAY omit any member, including `type`, which then has its default value of "about:blank". However, a sender MUST NOT include extension members unless it includes `type`.

HTTP responses already carry a status code, so `status` is redundant in the field; senders SHOULD omit it.

Any problem type can be conveyed with the field, using the members in {{table-members}}. Extension members are carried only if the problem type is header-compatible ({{profile}}) and identifies them as carried in the field; a sender MUST NOT include any others.

Recipients MUST ignore members they do not recognise, and any Parameters on members.

For example, this response carries the out-of-credit problem from {{Section 3 of PROBLEM}}, which we assume is header-compatible, with `balance` an Integer and `accounts` an Inner List of Strings:

~~~ http-message
HTTP/1.1 403 Forbidden
Problem-Details: type="https://example.com/probs/out-of-credit",
   title=%"You do not have enough credit.",
   detail=%"Your current balance is 30, but that costs 50.",
   instance="/account/12345/msgs/abc", balance=30,
   accounts=("/account/12345" "/account/67890")

~~~

It is equivalent to this problem details object:

~~~ json
{
  "type": "https://example.com/probs/out-of-credit",
  "title": "You do not have enough credit.",
  "detail": "Your current balance is 30, but that costs 50.",
  "instance": "/account/12345/msgs/abc",
  "balance": 30,
  "accounts": ["/account/12345", "/account/67890"]
}
~~~

A response can carry the field with or without problem details content. When it carries both, the field is a subset of the content. A recipient that finds a member with different values uses the content's value.


# Header-Compatible Problem Types {#profile}

A problem type is header-compatible if its definition says so and identifies which of its extension members are carried in the field. Only the party that defines a problem type can make it header-compatible; a recipient does not infer it from the members a response carries.

Each of those members conforms to the following:

* Its name begins with a lower-case letter, followed by lower-case letters, digits, "\_", "-" or ".". This is a subset of the keys that {{Section 4.1.1.3 of STRUCTURED-FIELDS}} allows for a Dictionary member, chosen so that the name is also valid in the XML format ({{Section 3.2 of PROBLEM}}).
* Its value is a boolean, number or string, or an array of them. It is not null or an object, and an array does not contain arrays.
* The definition specifies the Structured Type of the member, as in {{table-types}}. Where the value is an array, it specifies the type of the array's items.

| Structured Type | JSON type | Constraints                                            |
|-----------------|-----------|--------------------------------------------------------|
| Integer         | number    | an integer; see {{Section 3.3.1 of STRUCTURED-FIELDS}} |
| Decimal         | number    | at most 12 integer digits and 3 fractional digits      |
| String          | string    | ASCII characters only                                  |
| Token           | string    | conforms to the syntax of a Token                      |
| Display String  | string    | any Unicode scalar value                               |
| Boolean         | boolean   |                                                        |
| Inner List      | array     | items are of the types above                           |
{: #table-types title="Mapping Between Structured Types and JSON"}

Members of other Structured Types (Byte Sequence and Date) are ignored.

A sender MUST use the Structured Type that the problem type specifies for each member. A recipient converts a String, Token or Display String to a JSON string, and an Integer or Decimal to a JSON number, without checking which the problem type specifies. A member of any other type, such as a Byte Sequence or Date, is ignored.

The language of Display Strings is indicated by the Content-Language header field ({{Section 8.5 of HTTP}}), when present.


# IANA Considerations

IANA is asked to update the "Hypertext Transfer Protocol (HTTP) Field Name Registry" as follows:

|-----------------|-----------|-----------------|-------------|
| Field Name      | Status    | Structured Type | Reference   |
|-----------------|-----------|-----------------|-------------|
| Problem-Details | permanent | Dictionary      | {{field}}   |
|-----------------|-----------|-----------------|-------------|


# Security Considerations

The considerations in {{Section 5 of PROBLEM}} apply to problem details using the field in the same way that they do to problem details in content: it is easy to leak implementation details through error messages. Because a header field is visible to, and often logged by, every intermediary on the path, senders should consider not only the impact of individual disclosures, but also what information might be gathered over time by observing many responses.

Display Strings can contain any Unicode scalar value, including control characters. Recipients that display `title`, `detail` or a Display String extension member need to treat it as untrusted text, and filter or escape it first ({{Section 6 of STRUCTURED-FIELDS}}).

Recipients SHOULD NOT automatically dereference the `type` or `instance` URIs ({{Section 3.1 of PROBLEM}}).

Header fields are subject to size limits that content generally is not, and some implementations impose them on the whole header section. Senders that need to convey more than a small amount of information should use content or selectively omit members from the field.

--- back

