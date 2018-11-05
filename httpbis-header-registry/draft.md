---
title: A Registry for HTTP Header Fields
abbrev: HTTP Header Registry
docname: draft-nottingham-httpbis-header-registry-01
date: 2018
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
header fields (as per {{RFC7230}}, Section 3.2).


## Requesting Registration

Any party can request registration of a HTTP header field. See {{?RFC7231}} Section 8.3.1 for
considerations to take into account when creating a new HTTP header field.

The "HTTP Header Field Name" registry is located at "https://www.iana.org/assignments/http-headers/".
Registration requests can be made by following the instructions located there or by sending an
email to the "ietf-http-wg@ietf.org" mailing list.

Header field names are registered on the advice of a Designated Expert (appointed by the IESG or
their delegate). Header fields with the status 'permanent' are Specification Required (using
terminology from {{!RFC8126}}).

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
  the relevant section(s) can also be included, but is not required.

The Expert(s) can define additional fields to be collected in the registry, in consultation with
the community.

Standards-defined names have a status of "permanent". Other names can also be registered as permanent, if the Expert(s) find that they are in use, in consultation with the community. Other names should be registered as "provisional".

Provisional entries can be removed by the Expert(s) if -- in consultation with the community -- the Expert(s) find that they are not in use. The Experts can change a provisional entry's status to permanent at any time.

Note that names can be registered by third parties (including the Expert(s)), if the Expert(s)
determines that an unregistered name is widely deployed and not likely to be registered in a timely
manner otherwise.



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
5. Permanent entries without a status (after confirmation that the registration document did not define one) will have a status of 'provisional'. The Expert(s) can choose to update their status if there is evidence that another is more appropriate.

The Permanent and Provisional Message Header registries will be annotated to indicate that HTTP
header field registrations have moved, with an appropriate link.



# Security Considerations

No security considerations are introduced by this specification beyond those already inherent in
the use of HTTP header fields.

--- back
