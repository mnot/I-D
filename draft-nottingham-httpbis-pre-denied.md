---
title: The Preliminary Request Denied HTTP Status Code
docname: draft-nottingham-httpbis-pre-denied-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/pre-denied"

github-issue-label: pre-denied

entity:
  SELF: "RFC nnnn"

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: Cloudflare
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  HTTP: RFC9110
  FETCH:
    target: https://fetch.spec.whatwg.org/
    title: Fetch
    author:
      -
        organization: WHAT Working Group
    date: 2026


--- abstract

This specification defines a HTTP status code to indicate that the server
is denying a prefetch or preload request.

--- middle


# Introduction

{{FETCH}} introduces a mechanism whereby HTTP {{HTTP}} user agents can speculatively request a representation of a resource, in order to improve perceived performance.

In some circumstances, a server might have information that leads it to believe that sending a full
response will not improve performance, and could have negative impacts.

When this happens, it is common practice to use a 503 (Service Unavailable) status code. However, this has been shown to cause confusion: a server operator who sees a spike in that status code being sent tends to draw the conclusion that there is a server-side operational issue.

While other status codes (e.g., 403 (Forbidden)) could be used, they can also suffer (to varying degrees) from the same problem: being confused with an error, operational problem, or other condition.

This specification defines a new status code to specifically address this situation.

## Notational Conventions

{::boilerplate bcp14-tagged}

# The 4xx (Preliminary Request Denied) Status Code

The 4xx (Preliminary Request Denied) status code indicates that the server is refusing a preliminary request.

A preliminary request is one that contains a Sec-Purpose header field {{FETCH}} with the value "prefetch".

This indication is only applicable to the associated request; future preliminary requests might or might not succeed.

# IANA Considerations

The following entry should be registered in the "HTTP Status Codes" registry:

Code: 4xx
Description: Preliminary Request Denied
Specification: {{&SELF}} (this document)

# Security Considerations

The security considerations of {{HTTP}} and {{FETCH}} apply. Conceivably, the use of this status code could leak information about the internal state of the server; caution should be exercised to assure that it does not.

--- back

