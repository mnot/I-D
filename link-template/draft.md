---
title: The Link-Template HTTP Header Field
abbrev: Link-Template
docname: draft-nottingham-link-template-01
date: 2017
category: std

ipr: trust200902
area: General
workgroup:
keyword: Link
keyword: Linking
keyword: Web Linking
keyword: link relation

stand_alone: yes
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline, rfcedstyle]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    email: mnot@mnot.net
    uri: https://www.mnot.net/


--- abstract

This specification defines the Link-Template HTTP header field, providing a means for describing
the structure of a link between two resources, so that new links can be generated.


--- note_Note_to_Readers

The issues list can be found at <https://github.com/mnot/I-D/labels/link-template>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/link-template/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/link-template>.


--- middle

# Introduction

{{!RFC6570}} defines a syntax for templates that, when expanded using a set of variables, results
in a URI {{!RFC3986}}.

This specification defines a HTTP header field for conveying templates for links in the headers of
a HTTP message. It is complimentary to the Link header field {{!RFC5988}}, which carries links
directly.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in {{!RFC2119}}.

This document uses the Augmented BNF defined in {{!RFC7230}} to specify valid protocol
elements. Additionally, it uses the modified "parameter" rule from {{!RFC5987}},
and the "URI-Template" rule from {{!RFC6570}}.


# The Link-Template Header Field

The Link-Template entity-header field provides a means for serialising one or more links into HTTP
headers. It is semantically equivalent to the Link header field {{!RFC5988}}, except
that it uses URI Templates {{!RFC6570}} to convey the structure of links.

~~~
  Link-Template  = "Link-Template" ":" #linkt-value
  linkt-value    = "<" URI-Template ">" *( ";" parameter )
~~~

For example:

~~~
Link-Template: </{username}>; rel="http://example.org/rel/user"
~~~

indicates that a resource with the relation type "http://example.org/rel/user" can be found by
interpolating the "username" variable into the template given.

The target for the link (as defined by {{!RFC5988}}) is the result of expanding the URI
Template {{!RFC6570}} (being converted to an absolute URI after expansion, if
necessary).

The context, relation type and target attributes for the link are determined as defined for the
Link header field in {{!RFC5988}}.

The parameters on a linkt-value have identical semantics to those of a Link header field
{{!RFC5988}}. This includes (but is not limited to) the use of the "rel" parameter to convey the
relation type, the "anchor" parameter to modify the context IRI, and so on.

Likewise, the requirements for parameters on linkt-values are the same as those for a Link header
field; in particular, the "rel" parameter MUST NOT appear more than once, and if it does, the
linkt-value MUST be ignored by parsers.

This specification defines additional semantics for the "var-base" parameter on linkt-values; see
below.


## The 'var-base' parameter

When a linkt-value has a 'var-base' parameter, its value conveys a URI-reference that is used as a
base URI for the variable names in the URI template.

This mechanism allows template variables to be globally identified, rather than specific to the
context of use. Dereferencing the URI for a particular variable might lead to more information
about the syntax or semantics of that variable; specification of particular formats for this
information is out of scope for this document.

To determine the URI for a given variable, the value given is used as a base URI in reference
resolution (as specified in {{!RFC3986}}). If the resulting URI is still relative, the
context of the link is used as the base URI in a further resolution; see {{!RFC5988}}.

For example:

~~~
Link-Template: </widgets/{widget_id}>;
               rel="http://example.org/rel/widget";
               var-base="http://example.org/vars/"
~~~

indicates that a resource with the relation type "http://example.org/rel/widget" can be found by
interpolating the "http://example.org/vars/widget_id" variable into the template given.

If the current context of the message that the header appears within is "http://example.org/", the
same information could be conveyed by this header field:

~~~
Link-Template: </widgets/{widget_id}>;
               rel="http://example.org/rel/widget";
               var-base="/vars/"
~~~


# Security Considerations

The security consideration for the Link header field in {{!RFC5988}} and those for URI Templates
{{!RFC6570}} both apply.

# IANA Considerations

This specification enters the "Link-Template" into the registry of Permanent Message Header Field
Names.

    Header Field Name: Link-Template
    Protocol: http
    Status:
    Reference: [this document]


--- back
