---
title: The Key HTTP Response Header Field
abbrev: 
docname: draft-fielding-http-key-00
date: 2012
category: info

ipr: trust200902
area: General
workgroup: 
keyword: Internet-Draft

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: R. Fielding
    name: Roy T. Fielding
    organization: Adobe Systems Incorporated
    email: fielding@gbiv.com
    uri: http://roy.gbiv.com/

 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: 
    email: mnot@mnot.net
    uri: http://www.mnot.net/
    
normative:
  RFC2119:
  RFC5234:
  I-D.ietf-httpbis-p1-messaging:
  I-D.ietf-httpbis-p2-semantics:
  I-D.ietf-httpbis-p6-cache:
  
informative:


--- abstract

The 'Key' header field for HTTP responses allows an origin server
to describe the cache key for a negotiated response: a short algorithm
that can be used upon later requests to determine if the same response
is reusable. Key has the advantage of avoiding an additional round trip
for validation whenever a new request differs slightly, but not
significantly, from prior requests. Key also informs user agents of the
request characteristics that might result in different content, which
can be useful if the user agent is not sending Accept* fields in order
to reduce the risk of fingerprinting.

--- middle

Introduction
============

In HTTP caching {{I-D.ietf-httpbis-p6-cache}}, the Vary response header field
effectively modifies the key used to store and access a response to include
information from the request's headers. This allows proactive content
negotiation {{I-D.ietf-httpbis-p2-semantics}} to work with caches.

However, Vary's operation is coarse-grained; although
caches are allowed to normalise the values of headers based upon their
semantics, this requires the cache to understand those semantics, and is still
quite limited.

For example, if a response is cached with the response header field:

~~~
  Vary: Accept-Encoding
~~~
  
and and its associated request is:

~~~
  Accept-Encoding: gzip
~~~
  
then a subsequent request with the following header is (in a strict reading of
HTTP) not a match, resulting in a cache miss:

~~~
  Accept-Encoding: identity, gzip
~~~

This document defines a new response header field, "Key", that allows servers
to describe the cache key in a much more fine-grained manner, leading to
improved cache efficiency.

Notational Conventions
----------------------

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.

This document uses the Augmented Backus-Naur Form (ABNF) notation of
{{RFC5234}} with the list rule extension defined in
{{I-D.ietf-httpbis-p1-messaging}}, Appendix B. It includes by reference the
OWS, field-name and quoted-string rules from that document, and the
parameter rule from {{I-D.ietf-httpbis-p2-semantics}}.

The "Key" Response Header Field
===============================

The "Key" response header field describes the request attributes that the
server has used to select the current representation. 

As such, its semantics are similar to the "Vary" response header field, but it
allows more fine-grained description, using "key modifiers".

Caches can use this information as part of determining whether a stored
response can be used to satisfy a given request. When a cache fully 
implements this mechanism, it MAY ignore the Vary response header field.

User agents can use this information to discover if additional content
negotiation header fields might influence the resulting response.

The Key field-value is a comma-delimited list of selecting header fields
(similar to Vary), with zero to many modifiers to each, delimited by
semicolons. Whitespace is not allowed in the field-value between each
field-name and its parameter set.

~~~
  Key = 1#field-name *( ";" parameter )
~~~

The following header fields therefore have identical semantics:

~~~
  Vary: Accept-Encoding, Accept-Language
  Key: Accept-Encoding, Accept-Language
~~~
  
However, Key's use of modifiers allows:

~~~
  Key: Accept-Encoding;tok="gzip", Accept-Language;beg="fr"
~~~
  
to indicate that the response it occurs in is allowed to be reused for
requests that contain the token "gzip" (in any case) in the Accept-Encoding
header field and an Accept-Language header field value that starts with "fr".

Note that both the field-name and parameter name are case insensitive.
  
Header Matching
--------------- 

When used by a cache to determine whether a stored response can be used to
satisfy a presented request, each field-name identifies a potential request
header, just as with the Vary response header field.

However, each of these can have zero to many "key modifiers" that change how
the response selection process (as defined in {{I-D.ietf-httpbis-p6-cache}},
Section 4.3)) works.

In particular, a cache that implements the Key header field MUST NOT use a
stored response unless all of the selecting header fields nominated by the 
Key header field match in both the original request (i.e., that associated
with the stored response) and the presented request.

	Does this mean the cache doesn't respond to the original request?
	Or just doesn't cache the response? Is it necessary?

Modifiers operate on a list of zero to many field-values. This list is
constructed by:

  1. Starting with the field-values of all header fields that have the given
     field-name.
  2. Splitting each field-value on commas, excluding any that occur inside of
     a quoted-string production.
  3. Flattening the list of lists into a single list that represents the
     individual header field-values.
  4. Trimming any OWS from the start and end of the field-values.

For example, given the set of headers:

~~~
 Foo: 1
 Bar: z
 Foo: 2, a="b,c"
~~~

A modifier for "Foo" would operate on the list of presented values '1', '2',
'a="b,c"'.

Once the appropriate header fields from both the original request and the
stored request are processed in this manner, the result is two (possibly
empty) lists of values for each specified header field.

The key modifiers (as specified in the Key header field) are then applied to
the lists in the order they appear in Key (left to right). If any modifier
does not return a match (as per its definition), the headers are said not to
match. If all of the modifiers return a match, the headers are said to match.

Note that some types of modifiers are said to always match; they can be used
to alter the input lists, or to alter the semantics of subsequent matches.

Unrecognised modifiers MUST result in a failure to match.
  
Key Modifiers
-------------

This document defines the following key modifiers:

	What happened to tok? How about word? I prefer those to str.
	It seems odd that we use 3 letters for everything except the
	flags (e.g., not).  We could make them all 1 (t,s,b,e,i,n).

### "str": String Match Modifier

The "str" modifier matches if the parameter value (after unquoting) matches
(character-for-character) any whole value in both lists.

### "sub": Substring Match Modifier

The "sub" modifier matches if the parameter value (after unquoting) is
contained as a sequence of characters within both lists.

### "beg": Beginning Substring Match Modifier

The "beg" modifier matches if both lists contain a value that begins with the
same sequence of characters as the parameter value (after unquoting).

### "I": Case Insensitivity Flag

The "I" modifier always matches, and has the side effect of case normalising
the list values to lowercase for purposes of subsequent matches (i.e., the
match modifiers to its right, lexically).

	I know this is from regex, but almost all header matching will be
	case-insensitive -- wouldn't it be more efficient to flag only when
	a match is case-sensitive?

### "N": Not Flag

The "N" modifier always matches, and has the side effect of modifying the
semantics of subsequent modifiers (i.e., the match modifiers to its right,
lexically) so that they will be considered to match if they do not, and 
likewise they will be considered not to match if they do.

For example, given a response with:

~~~
  Key: Foo;str="a";N;str="b"
~~~
  
then the presented header:

~~~
  Foo: a, c
~~~
  
would match, while

~~~
  Foo: a, b
~~~
  
would not (because it contains "b").


Examples
--------

For example, this response header field:

~~~
  Key: cookie;str="ID=\"Roy\"";I;str="_sess=fhd378", 
       Accept-Encoding;i;str="gzip"
~~~

would allow the cache to reuse the response it occurs in if the presented
request contains:

 * A Cookie header containing both ID="Roy" (in that case) and _sess=fhd378
   (evaluated case insensitively), and
 * An Accept-Encoding header containing the token "gzip" (evaluated case
   insensitively).
 
Less convoluted examples include matching any request with a User-Agent field
value containing "MSIE" in any combination of case:

~~~
  Key: user-agent;I;sub="MSIE"
~~~

And an Accept-Language field value for French:

~~~
  Key: accept-language;beg="fr"
~~~


IANA Considerations
===================

TBD


Security Considerations
=======================

TBD


--- back
