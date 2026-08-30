---
title: Embargoing Archive Publication using robots.txt
abbrev: Archive-Embargo
docname: draft-nottingham-archive-embargo-latest
date: draft-nottingham-archive-embargo-date
category: std
updates: 9309

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://projects.mnot.net/I-D/"
  repo: "https://github.com/mnot/I-D/labels/embargo"

github-issue-label: embargo

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://mnot.net/
 -
    ins: M. Thomson
    name: Martin Thomson
    organization:
    postal:
      - Sydney
    country: Australia
    email: mt@lowentropy.net

normative:
  ABNF: RFC5234
  ROBOTS: RFC9309
  HTTP: RFC9110


--- abstract

Web sites often block archiving crawlers because they host time-sensitive information. This
specification documents a robots.txt extension, "Archive-Embargo", that can be used to request
that such crawlers delay publication of information.

This document updates RFC 9309 to add two directives that support embargoes.

--- middle


# Introduction

Many Web publishers choose not allow their content to be publicly archived, by disallowing archiving crawlers in robots.txt {{ROBOTS}}. Archiving is widely seen as a public good, enhancing the value of the Internet both for current and future users.

In some cases, publishers are amenable to archiving in the long term, but sensitive (for various reasons, including commercial considerations) to immediate republication of content in an archive.

This document proposes updates to {{ROBOTS}} to address this concern by allowing publishers to state an embargo period for content on their sites.

{{archive-embargo}} adds an "Archive-Embargo" rule that sets an embargo period. {{embargo-allow}} defines an "Embargo-Allow" rule that conditionally allows access to resources for crawlers that respect embargos.

## Notational Conventions

{::boilerplate bcp14-tagged}

# The "Archive-Embargo" Rule {#archive-embargo}

This document adds a new rule that associates an embargo period with a group.

Its value indicates the length of the embargo period, measured from the earliest of the HTTP response's Last-Modified value (when present and parseable; see {{Section 8.8.2 of HTTP}}) and the time when the content was first observed. The following values (along with their associated embargo periods) are supported:

* "w" - 7 days
* "m" - 31 days
* "q" - 90 days

Any other value is unsupported and results in the rule being ignored. Note that the embargo period uses case-insensitive matching, so that "Q" and "q" both indicate 90 days.

During an embargo period, a crawler MUST NOT allow covered content to be republished in an archive. Its existence MAY be indicated in an archive (e.g. by a "tombstone" entry that includes the URL, response header fields, and/or a cryptographic digest of the content) so long as the response body is not included.

The rule ABNF {{ABNF}} pattern from {{Section 2.2 of ROBOTS}} is extended as shown in {{f-abnf-embargo}}.

~~~ abnf
rule =/ embargo

archive-embargo = *WS "archive-embargo" *WS ":" *WS embargo-period EOL

embargo-period = "w" / "m" / "q"
~~~
{: #f-abnf-embargo title="ABNF for Archive-Embargo line"}


# The "Embargo-Allow" Rule {#embargo-allow}

Sites wishing to set archive embargoes without knowledge of whether a particular crawler supports this protocol extension need a way to predicate an 'allow' rule on support for it. The "Embargo-Allow" rule serves this function.

Its semantics are identical to the "Allow" rule in {{Section 2.2.2 of ROBOTS}}, except that it is only applicable when the crawler supports and honours the "Archive-Embargo" rule.  This includes having "Embargo-Allow" override an identical-length "Disallow".

This rule has no effect on its own.  If there is no valid value for "Archive-Embargo" in the group, the "Embargo-Allow" rule MUST be ignored.

The rule ABNF pattern from {{Section 2.2 of ROBOTS}} is extended as shown in {{f-abnf-allow}}.

~~~ abnf
rule =/ embargo-allow

embargo-allow = *WS "embargo-allow" *WS ":" *WS
                (path-pattern / empty-pattern) EOL
~~~
{: #f-abnf-allow title="ABNF for Embargo-Allow line"}


# Examples

The following illustrates use of a group that allows the specified crawler to access content under the `/news` path, so long as it embargoes publication of that content for a calendar quarter.

This depends on knowing that the specified crawler supports this specification.

~~~
User-Agent: ExampleBot
Archive-Embargo: q
Allow: /news
~~~

The example below illustrates a group that allows any crawler that supports and honours this specification to crawl resources under the `/news` path, so long as they embargo that content for one month.

~~~
User-Agent: *
Archive-Embargo: m
Embargo-Allow: /news
Disallow: /
~~~


# IANA Considerations

This document has no actions for IANA.

# Security Considerations {#security}

Embargoing is not a security mechanism; it relies upon crawlers to honour the embargo.

This mechanism cannot be used to request that the existence of resources be hidden
or that an embargo is in force; see {{archive-embargo}}.


--- back

# Implementing Embargoes in Archives

How archives provide access to their contents
will constrain how they might implement embargoes.
This section considers archives that provide
access to content from individual resources
and archives that provide bulk snapshots
that contain content from many resources.

Both types of archive need to have a way to store or reconstruct an embargo date
along with each representation that it stores.

An archive that provides access to single items of content
is simple:
access to content can be limited until its embargo date.

Managing access to archives that provide bulk access to content
is more complex.
To ensure that embargoed content is not included in archives,
a complete and inaccessible repository containing all archived content.
Periodically, content that has passed its embargo date
can be copied to accessible versions of the repository.

For large archives,
this sort of update process could be time-consuming,
so updates might only be applied periodically.
For that reason, content might not be available immediately
after the embargo date passes.
Techniques like sharding of archives
or maintaining a sorted index of embargo dates
could make the update process more efficient
or reduce the time between the embargo date passing
and the content being available.
