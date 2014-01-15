---
title: Web Linking
abbrev: Web Linking
docname: draft-nottingham-rfc598bis-00
date: 2013
category: std
updates: 5988

ipr: pre5378Trust200902
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
    uri: http://www.mnot.net/

normative:	
  RFC2026:
  RFC2119:
  RFC2616:
  RFC3864:
  RFC3986:
  RFC3987:
  RFC4288:
  RFC5226:
  RFC5646:
  RFC5987:
  
informative:
  RFC2068:
  RFC2817:
  RFC2818:
  RFC4287:
  W3C.CR-css3-mediaqueries-20090915:
  W3C.CR-curie-20090116:
  W3C.REC-html401-19991224:
  W3C.REC-rdfa-syntax-20081014:
  W3C.REC-xhtml-basic-20080729:


--- abstract

This document specifies relation types for Web links, and defines a registry
for them. It also defines the use of such links in HTTP headers with the Link
header field.

--- middle


# Introduction

A means of indicating the relationships between resources on the Web, as well
as indicating the type of those relationships, has been available for some time
in HTML {{W3C.REC-html401-19991224}}, and more recently in Atom {{RFC4287}}.
These mechanisms, although conceptually similar, are separately specified.
However, links between resources need not be format specific; it can be useful
to have typed links that are independent of their serialisation, especially
when a resource has representations in multiple formats.

To this end, this document defines a framework for typed links that isn't
specific to a particular serialisation or application. It does so by redefining
the link relation registry established by Atom to have a broader domain, and
adding to it the relations that are defined by HTML.

Furthermore, an HTTP header field for conveying typed links was defined in
Section 19.6.2.4 of {{RFC2068}}, but removed from {{RFC2616}}, due to a lack of
implementation experience. Since then, it has been implemented in some User
Agents (e.g., for stylesheets), and several additional use cases have surfaced.

Because it was removed, the status of the Link header is unclear, leading some
to consider minting new application-specific HTTP headers instead of reusing
it. This document addresses this by re-specifying the Link header as one such
serialisation, with updated but backwards-compatible syntax.

# Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in BCP 14, {{RFC2119}}, as scoped to those conformance
targets.

This document uses the Augmented Backus-Naur Form (ABNF) notation of
{{RFC2616}}, and explicitly includes the following rules from it:
quoted-string, token, SP (space), LOALPHA, DIGIT.

Additionally, the following rules are included from {{RFC3986}}: URI and
URI-Reference; from {{RFC4288}}: type-name and subtype-name; from
{{W3C.REC-html401-19991224}}: MediaDesc; from {{RFC5646}}: Language-Tag; and
from {{RFC5987}}, ext-value and parmname.


# Links


In this specification, a link is a typed connection between two resources that
are identified by Internationalised Resource Identifiers (IRIs) {{RFC3987}},
and is comprised of:

* A context IRI,
* a link relation type ({{link-relation-types}}),
* a target IRI, and
* optionally, target attributes.
      

A link can be viewed as a statement of the form "{context IRI} has a {relation
type} resource at {target IRI}, which has {target attributes}".

Note that in the common case, the context IRI will also be a URI {{RFC3986}},
because many protocols (such as HTTP) do not support dereferencing IRIs.
Likewise, the target IRI will be converted to a URI (see {{RFC3987}}, Section
3.1) in serialisations that do not support IRIs (e.g., the Link header).

This specification does not place restrictions on the cardinality of links;
there can be multiple links to and from a particular IRI, and multiple links of
different types between two given IRIs. Likewise, the relative ordering of
links in any particular serialisation, or between serialisations (e.g., the
Link header and in-content links) is not specified or significant in this
specification; applications that wish to consider ordering significant can do
so.

Target attributes are a set of key/value pairs that describe the link or its
target; for example, a media type hint. This specification does not attempt to
coordinate their names or use, but does provide common target attributes for
use in the Link HTTP header.

Finally, this specification does not define a general syntax for expressing
links, nor does it mandate a specific context for any given link; it is
expected that serialisations of links will specify both aspects. One such
serialisation is communication of links through HTTP headers, specified in
{{the-link-header-field}}.


# Link Relation Types

In the simplest case, a link relation type identifies the semantics of a link.
For example, a link with the relation type "copyright" indicates that the
resource identified by the target IRI is a statement of the copyright terms
applying to the current context IRI.

Link relation types can also be used to indicate that the target resource has
particular attributes, or exhibits particular behaviours; for example, a
"service" link implies that the identified resource is part of a defined
protocol (in this case, a service description).

Relation types are not to be confused with media types {{RFC4288}}; they do not
identify the format of the representation that results when the link is
dereferenced. Rather, they only describe how the current context is related to
another resource.

Relation types SHOULD NOT infer any additional semantics based upon the
presence or absence of another link relation type, or its own cardinality of
occurrence. An exception to this is the combination of the "alternate" and
"stylesheet" registered relation types, which has special meaning in HTML4 for
historical reasons.

There are two kinds of relation types: registered and extension.


## Registered Relation Types

Well-defined relation types can be registered as tokens for convenience and/or
to promote reuse by other applications. This specification establishes an IANA
registry of such relation types; see {{link-relation-type-registry}}.

Registered relation type names MUST conform to the reg-rel-type rule, and MUST
be compared character-by-character in a case-insensitive fashion. They SHOULD
be appropriate to the specificity of the relation type; i.e., if the semantics
are highly specific to a particular application, the name should reflect that,
so that more general names are available for less specific use.
			
Registered relation types MUST NOT constrain the media type of the context IRI,
and MUST NOT constrain the available representation media types of the target
IRI. However, they can specify the behaviours and properties of the target
resource (e.g., allowable HTTP methods, request and response media types that
must be supported).
		
Additionally, specific applications of linking may require additional data to
be included in the registry. For example, Web browsers might want to know what
kinds of links should be downloaded when they archive a Web page; if this
application-specific information is in the registry, new link relation types
can control this behaviour without unnecessary coordination.

To accommodate this, per-entry application data can be added to the Link
Relation Type registry, by registering it in the Link Relation Application Data
registry ({{link-relation-application-data-registry}}).
		
## Extension Relation Types

Applications that don't wish to register a relation type can use an extension
relation type, which is a URI {{RFC3986}} that uniquely identifies the relation
type. Although the URI can point to a resource that contains a definition of
the semantics of the relation type, clients SHOULD NOT automatically access
that resource to avoid overburdening its server.

When extension relation types are compared, they MUST be compared as strings
(after converting to URIs if serialised in a different format, such as a Curie
{{W3C.CR-curie-20090116}}) in a case-insensitive fashion,
character-by-character. Because of this, all-lowercase URIs SHOULD be used for
extension relations.

Note that while extension relation types are required to be URIs, a
serialisation of links can specify that they are expressed in another form, as
long as they can be converted to URIs.


# The Link Header Field

The Link entity-header field provides a means for serialising one or more links
in HTTP headers. It is semantically equivalent to the &lt;LINK&gt; element in
HTML, as well as the atom:link feed-level element in Atom {{RFC4287}}.

	Link           = "Link" ":" #link-value  
	link-value     = "<" URI-Reference ">" *( ";" link-param )
	link-param     = ( ( "rel" "=" relation-types )
	             | ( "anchor" "=" <"> URI-Reference <"> )
	             | ( "rev" "=" relation-types )
	             | ( "hreflang" "=" Language-Tag )
	             | ( "media" "=" ( MediaDesc | ( <"> MediaDesc <"> ) ) )
	             | ( "title" "=" quoted-string )
	             | ( "title*" "=" ext-value )
	             | ( "type" "=" ( media-type | quoted-mt ) )
	             | ( link-extension ) )
	link-extension = ( parmname [ "=" ( ptoken | quoted-string ) ] )
	             | ( ext-name-star "=" ext-value )
	ext-name-star  = parmname "*" ; reserved for RFC2231-profiled
	                            ; extensions. Whitespace NOT
	                            ; allowed in between.
	ptoken         = 1*ptokenchar
	ptokenchar     = "!" | "#" | "$" | "%" | "&" | "'" | "(" 
	             | ")" | "*" | "+" | "-" | "." | "/" | DIGIT 
	             | ":" | "<" | "=" | ">" | "?" | "@" | ALPHA 
	             | "[" | "]" | "^" | "_" | "`" | "{" | "|" 
	             | "}" | "~"
	media-type     = type-name "/" subtype-name
	quoted-mt      = <"> media-type <">
	relation-types = relation-type
	             | <"> relation-type *( 1*SP relation-type ) <">
	relation-type  = reg-rel-type | ext-rel-type
	reg-rel-type   = LOALPHA *( LOALPHA | DIGIT | "." | "-" )
	ext-rel-type   = URI

## Target IRI

Each link-value conveys one target IRI as a URI-Reference (after conversion to
one, if necessary; see {{RFC3987}}, Section 3.1) inside angle
brackets ("&lt;&gt;"). If the URI-Reference is relative, parsers MUST resolve
it as per {{RFC3986}}, Section 5. Note that any base IRI from the
message's content is not applied.
		
## Context IRI

By default, the context of a link conveyed in the Link header field is the IRI
of the requested resource.
				
When present, the anchor parameter overrides this with another URI, such as a
fragment of this resource, or a third resource (i.e., when the anchor value is
an absolute URI). If the anchor parameter's value is a relative URI, parsers
MUST resolve it as per {{RFC3986}}, Section 5. Note that any base
URI from the body's content is not applied.
				
Consuming implementations can choose to ignore links with an anchor parameter.
For example, the application in use may not allow the context IRI to be
assigned to a different resource. In such cases, the entire link is to be
ignored; consuming implementations MUST NOT process the link without applying
the anchor.
				
<!-- probably need to revisit security considerations -->

Note that depending on HTTP status code and response headers, the context IRI
might be "anonymous" (i.e., no context IRI is available). For instance, this is
the case on a 404 response to a GET request.

## Relation Type

The relation type of a link is conveyed in the "rel" parameter's value. The
"rel" parameter MUST NOT appear more than once in a given link-value;
occurrences after the first MUST be ignored by parsers.
	
The "rev" parameter has been used in the past to indicate that the semantics of
the relationship are in the reverse direction. That is, a link from A to B with
REL="X" expresses the same relationship as a link from B to A with REV="X".
"rev" is deprecated by this specification because it often confuses authors and
readers; in most cases, using a separate relation type is preferable.
		
Note that extension relation types are REQUIRED to be absolute URIs in Link
headers, and MUST be quoted if they contain a semicolon (";") or comma (",")
(as these characters are used as delimiters in the header itself).
	

## Target Attributes

The "hreflang", "media", "title", "title\*", "type", and any link-extension
link-params are considered to be target attributes for the link.

The "hreflang" parameter, when present, is a hint indicating what the language
of the result of dereferencing the link should be. Note that this is only a
hint; for example, it does not override the Content-Language header of a HTTP
response obtained by actually following the link. Multiple "hreflang"
parameters on a single link-value indicate that multiple languages are
available from the indicated resource.

The "media" parameter, when present, is used to indicate intended destination
medium or media for style information (see {{W3C.REC-html401-19991224}},
Section 6.13). Note that this may be updated by
{{W3C.CR-css3-mediaqueries-20090915}}). Its value MUST be quoted if it contains
a semicolon (";") or comma (","), and there MUST NOT be more than one "media"
parameter in a link-value.

The "title" parameter, when present, is used to label the destination of a link
such that it can be used as a human-readable identifier (e.g., a menu entry) in
the language indicated by the Content-Language header (if present). The "title"
parameter MUST NOT appear more than once in a given link-value; occurrences
after the first MUST be ignored by parsers.

The "title\*" parameter can be used to encode this label in a different
character set, and/or contain language information as per {{RFC5987}}. The
"title\*" parameter MUST NOT appear more than once in a given link-value;
occurrences after the first MUST be ignored by parsers. If the parameter does
not contain language information, its language is indicated by the
Content-Language header (when present).
			
If both the "title" and "title\*" parameters appear in a link-value, processors
SHOULD use the "title\*" parameter's value.

The "type" parameter, when present, is a hint indicating what the media type of
the result of dereferencing the link should be. Note that this is only a hint;
for example, it does not override the Content-Type header of a HTTP response
obtained by actually following the link. There MUST NOT be more than one type
parameter in a link-value.


## Examples

For example:

	Link: <http://example.com/TheBook/chapter2>; rel="previous";
	      title="previous chapter"

indicates that "chapter2" is previous to this resource in a logical navigation
path.
		
Similarly,

	Link: </>; rel="http://example.net/foo"

indicates that the root resource ("/") is related to this resource with the
extension relation type "http://example.net/foo".

The example below shows an instance of the Link header encoding multiple links,
and also the use of RFC 2231 encoding to encode both non-ASCII characters and
language information.

	Link: </TheBook/chapter2>;
	      rel="previous"; title*=UTF-8'de'letztes%20Kapitel,
	      </TheBook/chapter4>;
	      rel="next"; title*=UTF-8'de'n%c3%a4chstes%20Kapitel

Here, both links have titles encoded in UTF-8, use the German language ("de"),
and the second link contains the Unicode code point U+00E4 ("LATIN SMALL LETTER
A WITH DIAERESIS").

Note that link-values can convey multiple links between the same target and
context IRIs; for example:

	Link: <http://example.org/>; 
	      rel="start http://example.net/relation/other"

Here, the link to "http://example.org/" has the registered relation type
"start" and the extension relation type "http://example.net/relation/other".

# IANA Considerations

## Link HTTP Header Registration

This specification updates the Message Header registry entry for "Link" in HTTP
{{RFC3864}} to refer to this document.

	Header field: Link
	Applicable protocol: http
	Status: standard
	Author/change controller:
	    IETF  (iesg@ietf.org)
	    Internet Engineering Task Force
	Specification document(s):
	    [RFC&rfc.number;]

## Link Relation Type Registry

This specification establishes the Link Relation Type registry, and updates
Atom {{RFC4287}} to refer to it in place of the "Registry of Link
Relations".
		
The underlying registry data (e.g., the XML file) must include Simplified BSD
License text as described in Section 4.e of the Trust Legal Provisions (<eref
target="http://trustee.ietf.org/license-info"/>).

### Registering New Link Relation Types

Relation types are registered on the advice of a Designated Expert (appointed
by the IESG or their delegate), with a Specification Required (using
terminology from {{RFC5226}}).

The requirements for registered relation types are described in
{{registered-relation-types}}.

Registration requests consist of the completed registration template below,
typically published in an RFC or Open Standard (in the sense described by
{{RFC2026}}, Section 7). However, to allow for the allocation of values prior
to publication, the Designated Expert may approve registration once they are
satisfied that a specification will be published.

Note that relation types can be registered by third parties, if the Designated
Expert determines that an unregistered relation type is widely deployed and not
likely to be registered in a timely manner.

The registration template is:

* Relation Name: 
* Description:
* Reference: 
* Notes: [optional]
* Application Data: [optional]

Registration requests should be sent to the link-relations@ietf.org mailing
list, marked clearly in the subject line (e.g., "NEW RELATION - example" to
register an "example" relation type).

Within at most 14 days of the request, the Designated Expert(s) will either
approve or deny the registration request, communicating this decision to the
review list and IANA. Denials should include an explanation and, if applicable,
suggestions as to how to make the request successful.

Decisions (or lack thereof) made by the Designated Expert can be first appealed
to Application Area Directors (contactable using app-ads@tools.ietf.org email
address or directly by looking up their email addresses on http://www.iesg.org/
website) and, if the appellant is not satisfied with the response, to the full
IESG (using the iesg@iesg.org mailing list).

IANA should only accept registry updates from the Designated Expert(s), and
should direct all requests for registration to the review mailing list.


## Link Relation Application Data Registry
		
This specification also establishes the Link Relation Application Field
registry, to allow entries in the Link Relation Type registry to be extended
with application-specific data (hereafter, "app data") specific to all
instances of a given link relation type.

Application data is registered on the advice of a Designated Expert (appointed
by the IESG or their delegate), with a Specification Required (using
terminology from {{RFC5226}}).

Registration requests consist of the completed registration template below:

* Application Name: 
* Description: 
* Default Value: 
* Notes: [optional]

The Description SHOULD identify the value space of the app data. The Default
Value MUST be appropriate to entries to which the app data does not apply.

Entries that pre-date the addition of app data will automatically be considered
to have the default value for that app data; if there are exceptions, the
modification of such entries should be coordinated by the Designated Expert(s),
in consultation with the author of the proposed app data as well as the
registrant of the existing entry (if possible).

Registration requests should be sent to the link-relations@ietf.org mailing
list, marked clearly in the subject line (e.g., "NEW APP DATA - example" to
register "example" app data).

Within at most 14 days of the request, the Designated Expert will either
approve or deny the registration request, communicating this decision to the
review list. Denials should include an explanation and, if applicable,
suggestions as to how to make the request successful. Registration requests
that are undetermined for a period longer than 21 days can be brought to the
IESG's attention (using the iesg@iesg.org mailing list) for resolution.

When a registration request is successful, the Designated Expert will forward
it to IANA for publication. IANA should only accept registry updates from the
Designated Expert(s), and should direct all requests for registration to the
review mailing list.

# Security Considerations

The content of the Link header field is not secure, private or
integrity-guaranteed, and due caution should be exercised when using it. Use of
Transport Layer Security (TLS) with HTTP ({{RFC2818}} and {{RFC2817}}) is
currently the only end-to-end way to provide such protection.

Applications that take advantage of typed links should consider the attack
vectors opened by automatically following, trusting, or otherwise using links
gathered from HTTP headers. In particular, Link headers that use the "anchor"
parameter to associate a link's context with another resource should be treated
with due caution.

The Link entity-header field makes extensive use of IRIs and URIs. See 
{{RFC3987}} for security considerations relating to IRIs. See 
{{RFC3986}} for security considerations relating to URIs. See 
{{RFC2616}} for security considerations relating to HTTP headers.

# Internationalisation Considerations

Target IRIs may need to be converted to URIs in order to express them in
serialisations that do not support IRIs. This includes the Link HTTP header.

Similarly, the anchor parameter of the Link header does not support IRIs, and
therefore IRIs must be converted to URIs before inclusion there. 

Relation types are defined as URIs, not IRIs, to aid in their comparison. It is
not expected that they will be displayed to end users.


--- back

# Notes on Using the Link Header with the HTML4 Format

HTML motivated the original syntax of the Link header, and many of the design
decisions in this document are driven by a desire to stay compatible with these
uses.

In HTML4, the link element can be mapped to links as specified here by using
the "href" attribute for the target URI, and "rel" to convey the relation type,
as in the Link header. The context of the link is the URI associated with the
entire HTML document.

All of the link relation types defined by HTML4 have been included in the Link
Relation Type registry, so they can be used without modification. However,
there are several potential ways to serialise extension relation types into
HTML4, including
		
* As absolute URIs,
* using the document-wide "profile" attribute's URI as a prefix for relation
  types, or
* using the RDFa {{W3C.REC-rdfa-syntax-20081014}} convention of mapping token
  prefixes to URIs (in a manner similar to XML name spaces) (note that RDFa is
  only defined to work in XHTML {{W3C.REC-xhtml-basic-20080729}}, but is
  sometimes used in HTML4).


Individual applications of linking will therefore need to define how their
extension links should be serialised into HTML4.

Surveys of existing HTML content have shown that unregistered link relation
types that are not URIs are (perhaps inevitably) common. Consuming HTML
implementations should not consider such unregistered short links to be errors,
but rather relation types with a local scope (i.e., their meaning is specific
and perhaps private to that document).

HTML4 also defines several attributes on links that are not explicitly defined
by the Link header. These attributes can be serialised as link-extensions to
maintain fidelity.

Finally, the HTML4 specification gives a special meaning when the "alternate"
and "stylesheet" relation types coincide in the same link. Such links should be
serialised in the Link header using a single list of relation-types (e.g.,
rel="alternate stylesheet") to preserve this relationship.

# Notes on Using the Link Header with the Atom Format

Atom conveys links in the atom:link element, with the "href" attribute
indicating the target IRI and the "rel" attribute containing the relation type.
The context of the link is either a feed IRI or an entry ID, depending on where
it appears; generally, feed-level links are obvious candidates for transmission
as a Link header.

When serialising an atom:link into a Link header, it is necessary to convert
target IRIs (if used) to URIs.

Atom defines extension relation types in terms of IRIs. This specification
re-defines them as URIs, to simplify and reduce errors in their comparison.

Atom allows registered link relation types to be serialised as absolute URIs.
Such relation types SHOULD be converted to the appropriate registered form
(e.g., "http://www.iana.org/assignments/relation/self" to "self") so that they
are not mistaken for extension relation types.

Furthermore, Atom link relation types are always compared in a case-sensitive
fashion; therefore, registered link relation types SHOULD be converted to their
registered form (usually, lowercase) when serialised in an Atom document.

Note also that while the Link header allows multiple relations to be serialised
in a single link, atom:link does not. In this case, a single link-value may map
to several atom:link elements.

As with HTML, atom:link defines some attributes that are not explicitly
mirrored in the Link header syntax, but they can also be used as
link-extensions to maintain fidelity.

# Acknowledgements

This specification lifts the idea and definition for the Link header from RFC
2068; credit for it belongs entirely to the authors of and contributors to that
document. The link relation type registrations themselves are sourced from
several documents; see the applicable references.

The author would like to thank the many people who commented upon, encouraged
and gave feedback to this specification, especially including Frank Ellermann,
Roy Fielding, Eran Hammer-Lahav, and Julian Reschke.
