---
title: Privacy Considerations for Web Feed Readers
abbrev: Web Feed Privacy
docname: draft-nottingham-feed-privacy-latest
date: {DATE}
category: bcp

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/feed-privacy"

github-issue-label: feed-privacy

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Prahran
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  TLS13: RFC8446
  TRANS: RFC9162
  HSTS: RFC6797

informative:
  HTTP: RFC9110
  COOKIES: I-D.ietf-httpbis-rfc6265bis
  ATOM: RFC4287
  MASQUE: I-D.ietf-masque-connect-udp
  RSS:
    target: https://www.rssboard.org/rss-specification
    title: RSS 2.0 Specification
    date: 30 March 2009
    author:
     -
        org: RSS Advisory Board
  FINGERPRINTING: W3C.NOTE-fingerprinting-guidance-20190328
  NEL: W3C.WD-network-error-logging-1-20180925
  CSP: W3C.REC-CSP2-20161215

--- abstract

This specification collects privacy-enhancing guidelines for Web feed readers.

--- note_Note_to_Readers

This draft is a quick straw-man; it is intended to assess implementer and community interest in the topic, not to state concrete requirements (yet). Feedback much appreciated.


--- middle

# Introduction

Many web sites offer a feed of updates to their content, using {{ATOM}} or {{RSS}}. While they are consumed in a variety of ways and for a variety of purposes, web feeds are often presented to users by dedicated software, colloquially known as a "feed reader."

Feed readers use HTML and HTTP, and can be considered as part of the web, but one that is distinct from web browsers. Unlike browsers, feed readers do not easily facilitiate cross-site tracking or behavioural advertising, because their capabilities are more limited, thereby establishing an alternative, more privacy-respecting web platform.

At the same time, browsers are protecting privacy in increasingly sophisticated ways; for example, by taking steps to prevent  active fingerprinting {{FINGERPRINTING}}.

This specification seeks to codify these privacy-enhancing distinctions while incorporating browser's privacy advances by offering a definition for "feed reader" in {{reader}}, providing guidelines for how they make requests in {{requests}}, and providing guidelines for their handling of content in {{content}}.


## Notational Conventions

{::boilerplate bcp14-tagged}


# Feed Readers {#reader}

A feed reader acts as a user agent (per {{HTTP}}) that consumes and presents information from documents in {{ATOM}}, {{RSS}}, and/or similar formats to users.

A feed reader might be local software program on a host that the user controls, or a remote service that they access over the Internet, such as through a web browser. Typically, a feed reader will allow the user to subscribe to URIs that identify feeds, and regularly poll those URIs for new content. When a feed entry has already been seen, a reader might keep this state.

Feed readers make HTTP requests and parse, render and display HTML content (including some embedded content). Users can also follow links from content in a feed reader.



# Making Feed Requests {#requests}

When a feed reader makes a request for a feed document, privacy can be impacted in several ways. This section contains guidelines for such requests; note that they do not apply to requests for embedded content and user-initiated navigation to links in content (see {{content}}).

## Encryption

In HTTP, encryption protects communication from observation and modification, and is used to establish the identity of the server. Feed readers, therefore, are expected to follow best current practice for encryption, as captured in the relevant RFCs and industry practice.

This includes implementation of the most recent version of TLS (as of this writing, {{TLS13}}), the Strict-Transport-Security mechanism {{HSTS}}, and Certificate Transparency checking {{TRANS}}.

## Cookies

The HTTP Cookie mechanism has aspects that are problematic for privacy; see, eg., {{Section xx of COOKIES}}. Therefore, when making feed requests feed readers MUST NOT send the Cookie header field, and when receiving feed responses, they MUST NOT process the Set-Cookie header field.

## ETags

HTTP ETags (see {{Section x.x of HTTP}}) are especially useful to feed readers, as they enable more efficient transfers when there have been no changes to a feed. However, they can also be used to track user activity. Therefore, feed readers SHOULD periodically send requests without If-None-Match header fields, to asure that ETags are changed.

## User-Agent

Feed readers SHOULD NOT include more significant detail than an identifier for the software being used and its version. In particular, detail about libraries used and other aspects of the environment can contribute to the formation of an identifier for the user.

## Client IP Address

Feed readers SHOULD take steps to prevent servers hosting feeds from using the client's IP address to identify them or track their activity. For example, {{MASQUE}} might be used to this end.


# Handling Feed Content {#content}

When a feed reader displays a feed content (including an individual feed entry) to its user, interaction with the feed's server is limited in several ways to reduce privacy impact. This section outlines those limits.

## Requesting Remote Resources

Feed readers MAY make requests for remote resources that are explicitly part of the feed or feed entry's metadata. For example, a feed reader might fetch the URL in the atom:logo element (defined in {{Section 4.2.7 of ATOM}}) in order to present it to the user.

Feed readers MAY make requests for remote resources that are embedded in feed content. However, the user MUST be able to control this behaviour.


## Executing Scripts

When handling feed content, feed readers MUST NOT execute embedded or linked scripts.


## Reporting

Feed readers MUST NOT trigger reporting mechanisms designed for Web browsers when handing feed content. For example, {{NEL}}, {{CSP}}.


## Following Links

When a user explicitly follows a link in a feed reader, their expectation will be that it either opens in their preferred Web browser, or that the resulting functionality is equivalent (e.g., a browser embedded in the feed reader). Once a link is followed, the feed reader is no longer handling feed content; the user's activity is now either in a separate Web browser, or in an embedded web browser that is considered a distinct context.

Therefore, the context used to follow a link MUST be separate from that used to make requests for feed documents. In particular, separate underlying connections are to be used, and no state such as cookies is to be shared.





# IANA Considerations

This document has no actions for IANA.

# Security Considerations

_TBD_


--- back
