---
title: A Registry for HTTP Header Fields
abbrev: HTTP Header Registry
docname: draft-nottingham-httpbis-header-registry-00
date: 2016
category: std
updates: 3864, 7231

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

This document defines a separate IANA registry for HTTP header fields, and establishes the procedures for its operation.

--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/httpbis-header-registry>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/httpbis-header-registry/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/httpbis-header-registry>.


--- middle

# Introduction

{{?RFC3864}} established common IANA registries for header fields from a variety of protocols.
Experience has shown that having a combined registry has few benefits, and creates a number of
issues, including:

* Difficulty in evolving the registration process (without coordination with other protocols),

* Registry user confusion, due to the large number of header fields registered,

* Using one expert to review all header field registrations is onerous to that individual,

* Lack of HTTP community involvement / oversight in reviews.

While these issues could be mitigated by a RFC3864bis, it is more straightforward to separate the
HTTP registrations out into a separate registry; since there is only slight syntactic similarity
between header fields between protocols (and often, the mismatches create confusion), and little
semantic overlap, this seems like the best path forward.

Therefore, this document establishes a new HTTP Header Field Registry, defines its procedures, and
guides the transition of existing values to it. Doing so effectively removes HTTP header fields
from the scope of {{?RFC3864}} and the registries it defines, and updates {{?RFC7231}} Section 8.3
with a new process for managing them.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{!RFC2119}}.


# The HTTP Header Field Registry {#registry}

The "Hypertext Transfer Protocol (HTTP) Header Field Registry" defines the namespace for HTTP
header fields (as per {{RFC7230}}, Section 3.2). It is maintained at
<http://www.iana.org/assignments/http-headers>.


## Requesting Registration

Any party can request registration of a HTTP header field. See {{?RFC7231}} Section 8.3.1 for
considerations to take into account when creating a new HTTP header field.

Registration requests can be sent to the "http-registrations@ietf.org" mailing list. The Expert(s)
MAY establish alternate means of requesting registrations, which SHOULD be linked to from the
registry page.

Registration requests consist of at least the following information:

* **Header field name**: The requested field name. It MUST conform to the field-name syntax defined
  in {{!RFC7230}}, Section 3.2, and SHOULD be restricted to just letters, digits, hyphen ('-') and
  underscore ('_') characters, with the first character being a letter.

* **Status**: "permanent" or "provisional"

* **Author/Change controller**: For a standards-track RFC, state "IETF". For other open standards,
  give the name of the publishing body (e.g., "W3C"). For other specifications, give the name
  and/or organisation name and e-mail address of the primary specification author.

* **Specification document(s)**: Reference to the document that specifies the header field,
  preferably including a URI that can be used to retrieve a copy of the document. An indication of
  the relevant section(s) MAY also be included, but is not required.

The Expert(s) MAY define additional fields to be collected in the registry, in consultation with
the community.

Header fields that are defined in an IETF standards-track document, have a comparable amount of
review (typically, as an Open Standard in the sense of {{!RFC2026}}, section 7), or are generally
recognised to be in widespread use (in the judgment of the Expert(s)) MAY be registered with the
status "permanent". Such registrations MUST have a defining specification that is publicly
available.

Other header fields MUST be registered with the status "provisional".


## Registration Request Processing {#processing}

Header fields are registered on the advice of a Designated Expert (appointed by the IESG or their
delegate). Header fields with the status 'permanent' are Specification Required (using terminology
from {{!RFC5226}}).

The goal of the registry is to reflect common use of HTTP on the Internet. Therefore, the Expert(s)
SHOULD be strongly biased towards approving registrations, unless they are abusive, frivolous, not
likely to be used on the Internet, or actively harmful to the Internet and/or the Web (not merely
aesthetically displeasing, or architecturally dubious).

The Expert(s) MUST clearly identify any issues which cause a registration to be refused. Advice
about the syntax or semantics of a proposed header can be given, but if it does not block
registration, this SHOULD be explicitly stated.

When a request is approved, the Expert(s) will inform IANA, and the registration will be processed.
The IESG is the final arbiter of any objection.


## Updating Registrations {#update}

After registration, the change controller MAY request that the status of a registration be changed
to "obsoleted", request that the change controller be updated, and/or request that the
specification document(s) be updated.

Likewise, the IESG MAY request changes to the registry at any time. The Expert(s) MAY act on the
IESG's behalf to update incorrect or out-of-date permanent entries.

All such requests are subject to the same conditions and processes described in {{processing}}.

If the Expert(s) make reasonable attempts to contact a change controller but cannot contact them,
they MAY update a registration.



# IANA Considerations

## Registry Creation

IANA will create a new registry as outlined in {{registry}}. 

After creating the registry, all entries in the Permanent and Provisional Message Header Registries
with the protocol 'http' are to be moved to it, with the following changes applied:

1. The 'Applicable Protocol' field is to be omitted.
2. Entries with a status of 'standard', 'experimental', or 'informational' are to have a status of
   'permanent'.
3. Entries with a status of 'deprecated' are to have a status of 'obsoleted'.
4. Provisional entries without a status are to have a status of 'provisional'.
5. Permanent entries without a status (after confirmation that the registration document did not define one) will have a status of 'provisional'. The Expert(s) MAY choose to update their status if there is evidence that another is more appropriate.

The Permanent and Provisional Message Header registries will be annotated to indicate that HTTP
header field registrations have moved, with an appropriate link.


## Registry Operation

IANA will direct any incoming requests regarding the registry to this document and, if defined, the
processes established by the Expert(s); typically, this will mean referring them to the registry
Web page.

The Expert(s) will provide registry data to IANA in an agreed form (e.g. a specific XML format).
IANA will publish:

  * The raw registry data
  * The registry data, transformed into HTML
  * The registry data in any alternative formats provided by the Expert(s)

Each published document will be at a URL agreed to by IANA and the Expert(s), and IANA will
set HTTP response headers on them as (reasonably) requested by the Expert(s).

Additionally, the HTML generated by IANA will:

 * Take directions from the Expert(s) as to the content of the HTML page's introductory text

 * Include a stable HTML fragment identifier for each registered header field

All registry data documents MUST include Simplified BSD License text as described in Section 4.e of
the Trust Legal Provisions (<eref target="http://trustee.ietf.org/license-info"/>).


# Security Considerations

No security considerations are introduced by this specification beyond those already inherent in
the use of HTTP header fields.

--- back
