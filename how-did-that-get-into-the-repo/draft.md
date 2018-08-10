---
title: The secret-token URI scheme
abbrev:
docname: draft-nottingham-how-did-that-get-into-the-repo-00
date: 2018
category: std

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

This document registers the "secret-token" URI scheme, to aid in the identification
of authentication tokens.

--- note_Note_to_Readers

*RFC EDITOR: please remove this section before publication*

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/how-did-that-get-into-the-repo>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/how-did-that-get-into-the-repo/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/how-did-that-get-into-the-repo>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-how-did-that-get-into-the-repo/>.

--- middle

# Introduction

It has become increasingly common to use Bearer tokens as an authentication mechanism.

Unfortunately, the number of security incidents involving accidental disclosure of these tokens has also increased. For example, we now regularly hear about a developer committing an access token to a public source code repository, either because they didn't realise it was included in the committed code, or because they didn't realise the implications of its disclosure.

This specification registers the "secret-token" URI scheme to aid prevention of such accidental disclosures. When tokens are easier to unambiguously identify, they can trigger warnings in Continuous Integration systems, or be used in source code repositories themselves. They can also be scanned for separately.

For example, if cloud.example.net issues access tokens to its clients for later use, and it does so by formatting them as secret-token URIs, this enables its clients to more easily find tokens that "leak" into places that they don't belong. If repo.example.com can be configured to refuse commits containing secret-token URIs, it helps its customers avoid accidental disclosures.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as
described in BCP 14 {{!RFC2119}} {{!RFC8174}} when, and only when, they appear in all capitals, as
shown here.

This document uses ABNF {{!RFC5234}}, including by reference the following rules: ALPHA, DIGIT.

# The secret-token URI scheme

The secret-token URI scheme identifies a token that is intended to be a secret.

~~~ abnf
secret-token-URI    = secret-token-scheme ":" token
secret-token-scheme = "secret-token"
token               = 1*tchar
tchar               = ALPHA / DIGIT / "-" / "_" / "." / "~"
~~~

Note that characters outside the range allowed by tchar MUST be percent-encoded ({{!RFC3986}}, Section 2.1.

When a token is presented for authentication, the entire URI MUST be presented, without changes.

For example, given the URI:

~~~ example
secret-token:E92FB7EB-D882-47A4-A265-A0B6135DC842%20foo
~~~

This string (character-for-character, case-sensitive) will both be issued by the token authority, and required for later access.


# IANA Considerations

This document registers the following value in the URI Scheme registry:

* Scheme name: secret-token
* Status: permanent
* Applications / protocols that use this scheme: none yet
* Contact: iesg@iesg.org
* Change Controller: IESG
* References: [this document]


# Security Considerations

The token ABNF rule allows tokens as small as one character. This is not recommended practice; applications should evaluate their requirements for entropy and issue tokens correspondingly.

This URI scheme is intended to prevent accidental disclosure; it cannot prevent intentional disclosure.

If it is difficult to correctly handle secret material, or unclear as to what the appropriate handling is, users might choose to obfuscate their secret tokens in order to evade detection. Clear guidelines and helpful tools are good mitigations here.

--- back
