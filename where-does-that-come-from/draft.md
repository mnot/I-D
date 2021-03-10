---
title: Clarifying IETF Document Status
abbrev:
docname: draft-nottingham-where-does-that-come-from-00
date: 2021
category: info

ipr: trust200902
area: General
workgroup:
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    city: Prahran
    region: VIC
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:

informative:


--- abstract

There is widespread confusion about the status of Internet-Drafts and RFCs, especially regarding their association with the IETF and other streams. This document recommends several interventions to more closely align reader perceptions with actual document status.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/where-does-that-come-from>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/where-does-that-come-from/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/where-does-that-come-from>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-where-does-that-come-from/>.

--- middle


# Introduction

There is widespread confusion about the status of Internet-Drafts and RFCs -- specifically, regarding their association with the IETF and other streams. It is commonly perceived that all RFCs and all Internet-Drafts are associated with and approved by the IETF.

This is likely due to the conflation of the IETF and RFC brands; most people think of them in close association, and do not appreciate the concept of streams, because it is not surfaced obviously in the documents. These impressions are reinforced by our reuse of IETF infrastructure for publishing and managing drafts on other streams, as well as drafts on no stream.

These observations are not new. In the past, changes to boilerplate have been proposed and implemented to distinguish document status. However, the current boilerplate is obscure; it requires a knowledge of the Internet Standards Process to interpret, and furthermore, many readers gloss over boilerplate language.

This problem is also important to solve. Beyond confusion in the press and by implementers, standards-based interoperability is increasingly being considered by competition regulators as a remedy to abuse of power in Internet-related markets. Consensus status and stream association is critical to their interpretation of a given specification.

Additionally, the still in-progress change to the v3 format for Internet-Drafts and RFCs affords an opportunity to adjust how these documents are rendered in a manner that leads to more appropriate perceptions about their status.

Therefore, {{recs}} contains several recommendations for strong, clear interventions along these lines.

## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.


# Recommendations {#recs}

## RFCs

The following recommendations apply to the publication of RFCs.

### Proposal 1: logo usage

The purpose of this proposal is to create a strong, clear link between document status and logo usage.

The IETF, IRTF and IAB stream managers MUST ask the RFC Editor to place their respective logos on HTML, HTMLized and PDF renderings of RFCs on the applicable stream, and only on those documents. The logo should be displayed prominently at the top of the document.

The Independent Submissions Editor MAY designate a logo for equivalent use.

The tools team is directed to honour these requests in any renderings of these RFCs on sites under their control. This includes the negative condition; i.e., IETF, IRTF, and IAB logos should not appear on or in association with RFCs on other streams.

### Proposal 2: visual distinction

The purpose of this proposal is to create a strong, clear link between document status and document presentation.

The RFC Editor is directed to propose stream-specific presentation of RFCs that vary in visually significant ways; e.g., use of typeface, decoration, formatting such as alignment and spacing, and other typographic controls.


### Proposal 3: domain usage

The purpose of this proposal is to create a strong, clear link between document status and the domain name(s) where the document is found.

The IETF, IRTF and IAB stream managers SHOULD designate what hostname(s) RFCs from their streams are to be available upon. Initially, this is likely to be datatracker.ietf.org, although stream managers might designate a more specific place (such as specs.irtf.org) instead of or in addition to that location.

The Independent Submission Editor SHOULD designate what hostname(s) RFCs from their stream are to be available upon, if any. Independent Submissions MUST NOT be designated to appear on ietf.org, irtf.org or iab.org hostnames.

The tools team is directed to assure that these instructions are carried out - in particular, that each stream's RFCs appear only on the designated hostnames (within the scope of hostnames that the tools team has access to), and RFCs from other streams do not appear on the designated hostnames.

Note that placeholder documents MAY be used to indicate where a document on another stream can be found, while clearly stating that the target document is not associated with the stream in question; however, automatic redirects MUST NOT be used.

Note that if a stream manager does not indicate any domains for such use, it implies that those RFCs will only appear on rfc-editor.org, not any tools team-controlled sites.


## Internet-Drafts

The following recommendations apply to the publication of Internet-Drafts.

### Proposal 4: logo usage

The purpose of this proposal is to create a strong, clear link between document status and logo usage.

The tools team is directed to display the logos of the IETF, IRTF and IAB prominently at the top of HTML, HTMLized, and PDF renderings of Internet-Drafts on those streams (using the appropriate logo), and only drafts on those streams. These logos should not appear anywhere on documents that are not on these streams, nor should the appear on pages associated with them (e.g., datatracker metadata).

### Proposal 5: visual distinction

The purpose of this proposal is to create a strong, clear link between document status and document presentation.

The tools team is directed to propose stream-specific presentation of Internet-Drafts that vary in visually significant ways; e.g., use of typeface, decoration, formatting such as alignment and spacing, and other typographic controls.


### Proposal 6: domain usage

The purpose of this proposal is to create a strong, clear link between document status and the domain name(s) where the document (and metadata about it) is found.

The tools team is directed to request control of the 'internet-drafts.org' domain name from ISOC (with assistance from the LLC), and to use this domain for publishing drafts not associated with a stream, along with any other material generic to Internet-Drafts (such as the master index of drafts). Drafts on a given stream MAY be published there with consent from that stream's manager.

The IETF, IRTF and IAB stream managers MAY designate what hostname(s) Internet-Drafts on their streams are to be available upon. Initially, this is likely to be datatracker.ietf.org, although stream managers might designate a more specific place (such as drafts.irtf.org) instead of or in addition to that location.

The Independent Submission Editor MAY designate a hostname that Internet-Drafts from their stream are to be available upon. Independent Submissions MUST NOT be designated to appear on ietf.org, irtf.org or iab.org hostnames.

The tools team is directed to assure that these instructions are carried out - in particular, that each stream's drafts appear only on the designated hostnames (within the scope of hostnames that the tools team has access to), and drafts from other streams do not appear on the designated hostnames.

Note that placeholder documents MAY be used to indicate where a document on another stream can be found (including on internet-drafts.org), while clearly stating that the target document is not associated with the stream in question; however, automatic redirects MUST NOT be used.


### Proposal 7: boilerplate

The purpose of this proposal is to create a strong, clear statement of the document's actual
association (or lack thereof) with a stream in its boilerplate.

The tools team is directed to modify this text in the Internet-Draft boilerplate:

~~~
Internet-Drafts are working documents of the Internet Engineering
Task Force (IETF).  Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at https://datatracker.ietf.org/drafts/current/.
~~~

to, in the case of IETF stream documents:

~~~
This Internet-Draft is a working document of the Internet Engineering
Task Force (IETF). Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at https://internet-drafts.org/drafts/current/.
~~~

in the case of IRTF stream documents:

~~~
This Internet-Draft is a working document of the Internet Research
Task Force (IRTF). Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at https://internet-drafts.org/drafts/current/.
~~~

in the case of IAB stream documents:

~~~
This Internet-Draft is a working document of the Internet Architecture
Board (IAB). Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at https://internet-drafts.org/drafts/current/.
~~~

in the case of Independent stream documents:

~~~
This Internet-Draft is an Independent Submission for publication in the
RFC Series. Note that other groups may also distribute
working documents as Internet-Drafts.  The list of current Internet-
Drafts is at https://internet-drafts.org/drafts/current/.
~~~

in the case of documents not associated with a stream:

~~~
This Internet-Draft is a working document that has not been adopted
by any stream that would lead to RFC publication. Note that other
groups may also distribute working documents as Internet-Drafts.
The list of current Internet- Drafts is at
https://internet-drafts.org/drafts/current/.
~~~


# Security Considerations

This document has no direct security impact.



--- back
