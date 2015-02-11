---
title: Registration Procedures for Message Header Fields
abbrev: rfc3864bis
docname: draft-nottingham-rfc3864bis-00
date: 2014
category: bcp
obsoletes: 3864

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
    uri: http://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

This specification defines registration procedures for the message header fields used by Internet
mail, HTTP, Netnews and other applications.

--- middle

# Introduction

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.



# Introduction

This specification defines registration procedures for the message header field names used by
Internet mail, HTTP, newsgroup feeds and other Internet applications. It is not intended to be a
replacement for protocol-specific registries, such as the SIP registry [30].

Benefits of a central registry for message header field names include:

* providing a single point of reference for standardized and widely-used header field names;

* providing a central point of discovery for established header fields, and easy location of their
  defining documents;

* discouraging multiple definitions of a header field name for different purposes;

* helping those proposing new header fields discern established trends and conventions, and avoid
  names that might be confused with existing ones;

* encouraging convergence of header field name usage across multiple applications and protocols.

The primary specification for Internet message header fields in email is the Internet mail message
format specification, RFC 2822 [4]. HTTP/1.0 [10] and HTTP/1.1 [24] define message header fields
(respectively, the HTTP-header and message-header protocol elements) for use with HTTP. RFC 1036
[5] defines message header elements for use with Netnews feeds. These specifications also define a
number of header fields, and provide for extension through the use of new field-names.

There are many other Internet standards track documents that define additional header fields for
use within the same namespaces, notably MIME [11] and related specifications. Other Internet
applications that use MIME, such as SIP (RFC 3261 [30]) may also use many of the same header fields
(but note that IANA maintains a separate registry of header fields used with SIP).

Although in principle each application defines its own set of valid header fields, exchange of
messages between applications (e.g., mail to Netnews gateways), common use of MIME encapsulation,
and the possibility of common processing for various message types (e.g., a common message archive
and retrieval facility) makes it desirable to have a common point of reference for standardized and
proposed header fields. Listing header fields together reduces the chance of an accidental
collision, and helps implementers find relevant information. The message header field registries
defined here serve that purpose.


## Structure of this Document

Section 2 discusses the purpose of this specification, and indicates some sources of information
about defined message header fields.

Section 4 defines the message header field name repositories, and sets out requirements and
procedures for creating entries in them.


## Document Terminology and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14,
{{RFC 2119}}.


# Message Header Fields

## Permanent and Provisional Header Fields

Many message header fields are defined in standards-track documents, which means they have been
subjected to a process of community review and achieved consensus that they provide a useful and
well-founded capability, or represent a widespread use of which developers should be aware. Some
are defined for experimental use, typically indicating consensus regarding their purpose but not
necessarily concerning their technical details. Many others have been defined and adopted ad-hoc to
address a locally occurring requirement; some of these have found widespread use.

The catalogues defined here are intended to cater for all of these header fields, while maintaining
a clear distinction and status for those which have community consensus. To this end, two
repositories are defined:

* A Permanent Message Header Field Registry, intended for headers defined in IETF standards-track
  documents, those that have achieved a comparable level of community review, or are generally
  recognized to be in widespread use. The assignment policy for such registration is "Specification
  Required", as defined by RFC 2434 [3], where the specification must be published in an RFC
  (standards-track, experimental, informational or historic), or as an "Open Standard" in the sense
  of RFC 2026, section 7 [1].

* A Provisional Message Header Field Repository, intended for any header field proposed by any
  developer, without making any claim about its usefulness or the quality of its definition. The
  policy for recording these is "Private Use", per RFC 2434 [3].

Neither repository tracks the syntax, semantics or type of field- values. Only the field-names,
applicable protocols and status are registered; all other details are specified in the defining
documents referenced by repository entries. Significant updates to such references (e.g., the
replacement of a Proposed Standard RFC by a Draft Standard RFC, but not necessarily the revision of
an Internet- draft) SHOULD be accompanied by updates to the corresponding repository entries.



## Definitions of Message Header Fields

RFC 2822 [4] defines a general syntax for message headers, and also defines a number of fields for
use with Internet mail. HTTP/1.0 [10] and HTTP/1.1 [24] do likewise for HTTP.

### Application-specific Message Header Fields

Internet applications that use similar message headers include Internet mail [26] [4], NNTP
newsgroup feeds [5], HTTP web access [24] and any other that uses MIME [11] encapsulation of
message content.

In some cases (notably HTTP [24]), the header syntax and usage is redefined for the specific
application. This registration is concerned only with the allocation and specification of field
names, and not with the details of header implementation in specific protocols.

In some cases, the same field name may be specified differently (by different documents) for use
with different application protocols; e.g., The Date: header field used with HTTP has a different
syntax than the Date: used with Internet mail. In other cases, a field name may have a common
specification across multiple protocols (ignoring protocol-specific lexical and character set
conventions); e.g., this is generally the case for MIME header fields with names of the form
'Content-*'.

Thus, we need to accommodate application-specific fields, while wishing to recognize and promote
(where appropriate) commonality of other fields across multiple applications. Common repositories
are used for all applications, and each registered header field specifies the application protocol
for which the corresponding definition applies. A given field name may have multiple registry
entries for different protocols; in the Permanent Message Header Field registry, a given header
field name may be registered only once for any given protocol. (In some cases, the registration may
reference several defining documents.)


### MIME Header Fields

Some header fields with names of the form Content-* are associated with the MIME data object
encapsulation and labelling framework. These header fields can meaningfully be applied to a data
object separately from the protocol used to carry it.

MIME is used with email messages and other protocols that specify a MIME-based data object format.
MIME header fields used with such protocols are defined in the registry with the protocol "mime",
and as such are presumed to be usable in conjunction with any protocol that conveys MIME objects.

Other protocols do not convey MIME objects, but define a number of header fields with similar names
and functions to MIME. Notably, HTTP defines a number of entity header fields that serve a purpose
in HTTP similar to MIME header fields in email. Some of these header fields have the same names and
similar functions to their MIME counterparts (though there are some variations). Such header fields
must be registered separately for any non-MIME-carrying protocol with which they may be used.

It is poor practice to reuse a header field name from another protocol simply because the fields
have similar (even "very similar") meanings. Protocols should share header field names only when
their meanings are identical in all foreseeable circumstances. In particular, new header field
names of the form Content-* should not be defined for non-MIME-carrying protocols unless their
specification is exactly the same as in MIME.


# Registry Usage Requirements

RFCs defining new header fields for Internet mail, HTTP, or MIME MUST include appropriate header
registration template(s) (as given in Section 4.2) for all headers defined in the document in their
IANA considerations section. Use of the header registry MAY be mandated by other protocol
specifications, however, in the absence of such a mandate use of the registry is not required.


# Registration Procedure

The procedure for registering a message header field is:

1.  Construct a header field specification

2.  Prepare a registration template

3.  Submit the registration template


## Header Field Specification

Registration of a new message header field starts with construction of a proposal that describes
the syntax, semantics and intended use of the field. For entries in the Permanent Message Header
Field Registry, this proposal MUST be published as an RFC, or as an Open Standard in the sense
described by RFC 2026, section 7 [1].

A registered field name SHOULD conform at least to the syntax defined by RFC 2822 [4], section
3.6.8.

Further, the "." character is reserved to indicate a naming sub- structure and MUST NOT be included
in any registered field name. Currently, no specific sub-structure is defined; if used, any such
structure MUST be defined by a standards track RFC document.

Header field names may sometimes be used in URIs, URNs and/or XML. To comply with the syntactic
constraints of these forms, it is recommended that characters in a registered field name are
restricted to those that can be used without escaping in a URI [20] or URN [13], and that are also
legal in XML [32] element names.

Thus, for maximum flexibility, header field names SHOULD further be restricted to just letters,
digits, hyphen ('-') and underscore ('_') characters, with the first character being a letter or
underscore.

## Registration Templates

The registration template for a message header field may be contained in the defining document, or
prepared separately.

### Permanent Message Header Field Registration Template

A header registered in the Permanent Message Header Field Registry MUST be published as an RFC or
as an "Open Standard" in the sense described by RFC 2026, section 7 [1], and MUST have a name which
is unique among all the registered permanent field names that may be used with the same application
protocol.

The registration template has the following form.

PERMANENT MESSAGE HEADER FIELD REGISTRATION TEMPLATE:

Header field name:
  The name requested for the new header field. This MUST conform to the header field specification
  details noted in Section 4.1.


Applicable protocol:
  Specify "mail" (RFC 2822), "mime" (RFC 2045), "http" (RFC 2616), "netnews" (RFC 1036), or cite
  any other standards-track RFC defining the protocol with which the header is intended to be used.

Status:
  Specify "standard", "experimental", "informational", "historic", "obsoleted", or some other
  appropriate value according to the type and status of the primary document in which it is
  defined. For non-IETF specifications, those formally approved by other standards bodies should be
  labelled as "standard"; others may be "informational" or "deprecated" depending on the reason for
  registration.

Author/Change controller:
  For Internet standards-track, state "IETF". For other open standards, give the name of the
  publishing body (e.g., ANSI, ISO, ITU, W3C, etc.). For other specifications, give the name, email
  address, and organization name of the primary specification author. A postal address, home page
  URI, telephone and fax numbers may also be included.

Specification document(s):
  Reference to document that specifies the header for use with the indicated protocol, preferably
  including a URI that can be used to retrieve a copy of the document. An indication of the
  relevant sections MAY also be included, but is not required.

Related information:
  Optionally, citations to additional documents containing further relevant information. (This part
  of the registry may also be used for IESG comments.) Where a primary specification refers to
  another document for substantial technical detail, the referenced document is usefully mentioned
  here.

### Provisional Message Header Field Submission Template

Registration as a Provisional Message Header Field does not imply any kind of endorsement by the
IETF, IANA or any other body.

The main requirements for a header field to be included in the provisional repository are that it
MUST have a citable specification, and there MUST NOT be a corresponding entry (with same field
name and protocol) in the permanent header field registry.

The specification SHOULD indicate an email address for sending technical comments and discussion of
the proposed message header.

The submission template has the following form.

PROVISIONAL MESSAGE HEADER FIELD SUBMISSION TEMPLATE:

Header field name:
  The name proposed for the new header field. This SHOULD conform to the field name specification
  details noted in Section 4.1.

Applicable protocol:
  Specify "mail" (RFC 2822), "mime" (RFC 2045), "http" (RFC 2616), "netnews" (RFC 1036), or cite
  any other standards-track RFC defining the protocol with which the header is intended to be used.

Status:
  Specify: "provisional". This will be updated if and when the header registration is subsequently
  moved to the permanent registry.

Author/Change controller:
  The name, email address, and organization name of the submission author, who may authorize
  changes to or retraction of the repository entry. A postal address, home page URI, telephone and
  fax numbers may also be included.
  If the proposal comes from a standards body working group, give the name and home page URI of the
  working group, and an email address for discussion of or comments on the specification.

Specification document(s):
  Reference to document that specifies the header for use with the indicated protocol. The document
  MUST be an RFC, a current Internet-draft or the URL of a publicly accessible document (so IANA
  can verify availability of the specification). An indication of the relevant sections MAY also be
  included, but is not required.

     NOTE: if the specification is available in printed form only, then an Internet draft
     containing full reference to the paper document should be published and cited in the
     registration template. The paper specification MAY be cited under related information.

Related information:
  Optionally, citations to additional documents containing further relevant information.


## Submission of Registration

The registration template is submitted for incorporation in one of the IANA message header field
repositories by one of the following methods:

* An IANA considerations section in a defining RFC, calling for registration of the message header
  and referencing information as required by the registration template within the same document.
  Registration of the header is then processed as part of the RFC publication process.

* Send a copy of the template to the designated email discussion list [33] [34]. Allow a reasonable
  period - at least 2 weeks - for discussion and comments, then send the template to IANA at the
  designated email address [35]. IANA will publish the template information if the requested name
  and the specification document meet the criteria noted in Section 4.1 and Section 4.2.2, unless
  the IESG or their designated expert have requested that it not be published (see Section 4.4).
  IESG's designated expert should confirm to IANA that the registration criteria have been
  satisfied.

When a new entry is recorded in the permanent message header field registry, IANA will remove any
corresponding entries (with the same field name and protocol) from the provisional registry.

## Objections to Registration

Listing of an entry in the provisional repository should not be lightly refused. An entry MAY be
refused if there is some credible reason to believe that such registration will be harmful. In the
absence of such objection, IANA SHOULD allow any registration that meets the criteria set out in
Section 4.1 and Section 4.2.2. Some reasonable grounds for refusal might be:

o There is IETF consensus that publication is considered likely to harm the Internet technical
  infrastructure in some way.

o Disreputable or frivolous use of the registration facilities.

o The proposal is sufficiently lacking in purpose, or misleading about its purpose, that it can
  be held to be a waste of time and effort.

o Conflict with some current IETF activity.

Note that objections or disagreements about technical detail are not, of themselves, considered
grounds to refuse listing in the provisional repository. After all, one of its purposes is to allow
developers to communicate with a view to combining their ideas, expertise and energy to the maximum
benefit of the Internet community.

Publication in an RFC or other form of Open Standard document (per RFC 2026 [1], section 7) is
sufficient grounds for publication in the permanent registry.

To assist IANA in determining whether or not there is a sustainable objection to any registration,
IESG nominates a designated expert to liaise with IANA about new registrations. For the most part,
the designated expert's role is to confirm to IANA that the registration criteria have been
satisfied.

The IESG or their designated expert MAY require any change or commentary to be attached to any
registry entry.

The IESG is the final arbiter of any objection.

## Change Control

Change control of a header field registration is subject to the same condition as the initial
registration; i.e., publication (or reclassification) of an Open Standards specification for a
Permanent Message Header Field, or on request of the indicated author/change controller for a
Provisional Message Header (like the original submission, subject to review on the designated email
discussion list [33].)

A change to a permanent message header field registration MAY be requested by the IESG.

A change to or retraction of any Provisional Message Header Field Repository entry MAY be requested
by the IESG or designated expert.

IANA MAY remove any Provisional Message Header Field Repository entry whose corresponding
specification document is no longer available (e.g., expired Internet-draft, or URL not
resolvable). Anyone may notify IANA of any such cases by sending an email to the designated email
address [35]. Before removing an entry for this reason, IANA SHOULD contact the registered
Author/Change controller to determine whether a replacement for the specification document
(consistent with the requirements of section Section 4.2.2) is available.

It is intended that entries in the Permanent Message Header Field Registry may be used in the
construction of URNs (per RFC 2141 [13]) which have particular requirements for uniqueness and
persistence (per RFC 1737 [8]). Therefore, once an entry is made in the Permanent Message Header
Registry, the combination of the header name and applicable protocol MUST NOT subsequently be
registered for any other purpose. (This is not to preclude revision of the applicable
specification(s) within the appropriate IETF Consensus rules, and corresponding updates to the
specification citation in the header registration.)

## Comments on Header Definitions

Comments on proposed registrations should be sent to the designated email discussion list [33].

## Location of Header Field Registry

The message header field registry is accessible from IANA's web site
http://www.iana.org/assignments/message-headers/ message-header-index.html

# IANA Considerations

This specification calls for:

o A new IANA registry for permanent message header fields per Section 4 of this document. The
  policy for inclusion in this registry is described in Section 4.1 and Section 4.2.1.

o A new IANA repository listing provisional message header fields per Section 4 of this document.
  The policy for inclusion in this registry is described in Section 4.1 and Section 4.2.2.

o IESG appoints a designated expert to advise IANA whether registration criteria for proposed
  registrations have been satisfied.

No initial registry entries are provided.

# Security Considerations

No security considerations are introduced by this specification beyond those already inherent in
the use of message headers.


# Acknowledgements

The shape of the registries described here owes much to energetic discussion of previous versions
by many denizens of the IETF-822 mailing list.

The authors also gratefully acknowledge the contribution of those who provided valuable feedback on
earlier versions of this memo: Charles Lindsey, Dave Crocker, Pete Resnick, Jacob Palme, Ned Freed,
Michelle Cotton.

# References

## Normative References

   [1]  Bradner, S., "The Internet Standards Process -- Revision 3", BCP
        9, RFC 2026, October 1996.

   [2]  Bradner, S., "Key words for use in RFCs to Indicate Requirement
        Levels", BCP 14, RFC 2119, March 1997.

   [3]  Narten, T. and H. Alvestrand, "Guidelines for Writing an IANA
        Considerations Section in RFCs", BCP 26, RFC 2434, October 1998.

   [4]  Resnick, P., Ed., "Internet Message Format", RFC 2822, April
        2001.

## Informative References

   [5]  Horton, M. and R. Adams, "Standard for interchange of USENET
        messages", RFC 1036, December 1987.

   [8]  Sollins, K. and L. Masinter, "Functional Requirements for
        Uniform Resource Names", RFC 1737, December 1994.

   [10] Berners-Lee, T., Fielding, R. and H. Frystyk, "Hypertext
        Transfer Protocol -- HTTP/1.0", RFC 1945, May 1996.

   [11] Freed, N. and N. Borenstein, "Multipurpose Internet Mail
        Extensions (MIME) Part One: Format of Internet Message Bodies",
        RFC 2045, November 1996.

   [13] Moats, R., "URN Syntax", RFC 2141, May 1997.

   [20] Berners-Lee, T., Fielding, R., and L. Masinter, "Uniform
        Resource Identifiers (URI): Generic Syntax", RFC 2396, August
        1998.

   [24] Fielding, R., Gettys, J., Mogul, J., Nielsen, H., Masinter, L.,
        Leach, P., and T. Berners-Lee, "Hypertext Transfer Protocol --
        HTTP/1.1", RFC 2616, June 1999.

   [26] Klensin, J., Ed., "Simple Mail Transfer Protocol", RFC 2821,
        April 2001.

   [30] Rosenberg, J., Schulzrinne, H., Camarillo, G., Johnston, A.,
        Peterson, J., Sparks, R., Handley, M., and E. Schooler, "SIP:
        Session Initiation Protocol", RFC 3261, June 2002.

   [32] Bray, T., Paoli, J., Sperberg-McQueen, C., and E. Maler,
        "Extensible Markup Language (XML) 1.0 (2nd ed)", W3C
        Recommendation xml, October 2000,
        <http://www.w3.org/TR/2000/REC-xml-20001006>.

   [33] "Mail address for announcement of new header field submissions",
        Mail address: ietf-message-headers@lists.ietf.org

   [34] "Mail address for subscription to ietf-message-
        headers@lists.ietf.org.  (DO NOT SEND SUBSCRIPTION REQUESTS TO
        THE MAILING LIST ITSELF)", Mail address:  ietf-message-headers-
        request@lists.ietf.org

   [35] "Mail address for submission of new header field templates",
        Mail address: iana@iana.org






--- back
