---
title: Feed Menus
abbrev:
docname: draft-nottingham-feed-menu-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/feed-menu"

github-issue-label: feed-menu

author:
 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization:
    postal:
      - Melbourne
    country: Australia
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  ATOM: RFC4287
  RSS:
    target: https://www.rssboard.org/rss-specification
    title: RSS 2.0 Specification
    date: 30 March 2009
    Author:
      - organization: RSS Advisory Board
  JSON: RFC8259
  WELL-KNOWN: RFC8615
  HTTP: RFC9110

informative:
  DISCOVERY:
    target: https://blog.whatwg.org/feed-autodiscovery
    title: Feed Autodiscovery
    date: 3 December 2006
    author:
      - organization: WHATWG


--- abstract

This specification defines Feed Menus, a simplified means of discovering the feeds (e.g., RSS or Atom) offered by a Web site.

--- middle

# Introduction

Autodiscovery of Web feeds (in formats such as RSS {{RSS}} and Atom {{ATOM}}) using link relations in HTML {{DISCOVERY}} is widely supported both by consuming software (e.g., feed readers) and Web sites (including in many content management systems).

Deployment of autodiscovery has uncovered significant issues with this approach.

Because feed links are specific to a page, they are only apparent to software that can take advantage of them (for example, to show a 'subscribe' button) when that page is being viewed. This means that sites need to repeat the relevant feeds in the headmatter of all pages on a site to assure that they are viewable, creating overhead both in effort (to organise the pages) and bandwidth (to serve them).

Practically, this means that it is often necessary to hunt around the pages of a site to find all of the relevant feeds, since sites are unwilling to repeat them on every page.

Furthermore, because many content management systems automatically create this metadata, in practice many feeds that are advertised using autodiscovery are not actually functional -- site owners do not realise that the feeds are being advertised and do not check the feeds for quality and relevance.

Finally, there are no existant best practices for naming or assigning metadata to feeds (for example, their format), leading to confusing user experiences. For example, because many sites make both RSS and Atom feeds available, there are often duplicate entries in the autodiscovery metadata.

This specification documents a different mechanism for discovering the feeds relevant to a Web site. By defining a single, well-known location {{WELL-KNOWN}} that describes a site's feeds, it encourages a more curated, usable directory of the site's feeds for easy discovery and consumption by clients.

{{format}} describes this format; {{publishing}} recommends practices for publishers that wish to use it, and {{processing}} provides guidance to clients for processing it.

## Notational Conventions

{::boilerplate bcp14-tagged}


# Feed Menu Documents {#format}

A feed menu document is a JSON {{JSON}} format whose root is an menu object ({{menu-object}}).

For example, a minimal feed menu document:

~~~json
{
  "feed-menu": "The Astor Theatre",
  "items": [
    {
      "feed-title": "Upcoming Shows",
      "rss": "/shows/upcoming.xml"
    }
  ]
}
~~~

## Menu Objects {#menu-object}

A menu object is a JSON object with a "feed-menu" member. Its potential members are:

* "feed-menu": A short human readable title for the menu (REQUIRED)
* "items": An array of menu objects and feed objects.

Menu objects MAY contain other members, to be defined by updates to this specification. Likewise, the items array MAY contain other types of objects, to be defined by updates to this specification.

Menu objects can contain other menu objects to represent a nested structure. For example:

~~~json
{
  "feed-menu": "Analog:Shift",
  "items": [
    {
      "feed-title": "Analog:Shift News",
      "rss": "/news.xml"
    },
    {
      "feed-menu": "Watches for Sale",
      "items": [
        {
          "feed-title": "All Watches",
          "rss": "/collections/watches/all.xml"
        },
        {
          "feed-title": "Vintage Watches",
          "rss": "/collections/watches/vintage.xml"
        },
        {
          "feed-title": "Neo-Vintage Watches",
          "rss": "/collections/watches/neovintage.xml"
        },
        {
          "feed-title": "Contemporary Watches",
          "rss": "/collections/watches/contemporary.xml"
        }
      ]
    }
  ]
}
~~~


## Feed Objects {#feed-object}

A feed object is a JSON object with a "feed-title" member. Its potential members are:

* "feed-title": A short human readable title for the feed (REQUIRED)
* "description": A potentially longer human readable description of the feed's purpose or content; can further explain or augment the title (OPTIONAL)
* "rss": A URL to retrieve a RSS representation of the feed (see below)
* "atom": A URL to retrieve an Atom representation of the feed (see below)

One of "rss" or "atom" is REQUIRED; both MAY be present.

URLs in "rss" and "atom" values MAY be relative, and MUST be resolved relative to the feed document's URL without a path. For example, if a feed document is located at "https://example.net/.well-known/feed-menu.json" and the "rss" member contains "feed.xml", the resulting RSS feed URL would be "https://example.net/feed.xml".

Feed objects MAY contain other members, to be defined by updates to this specification.

For example, a feed menu document with a more elaborate feed object:

~~~json
{
  "feed-menu": "Australian Senate",
  "items": [
    {
      "feed-title": "Upcoming Senate Committee Inquiries",
      "description": "Newly announced inquiries; includes calls for submissions",
      "rss": "/inquiries/upcoming.rss",
      "atom": "/inquiries/upcoming.atom"
    }
  ]
}
~~~

# Publishing Feed Menus {#publishing}

Feed menu documents are published at the "feed-menu.json" well-known URI {{WELL-KNOWN}} for a given Web site. For example:

~~~
https://www.example.com/.well-known/feed-menu.json
~~~

If the Web site supports multiple languages, publishers can use HTTP proactive negotiation to make different languages available to processors. Publishers generally SHOULD NOT mix languages in the same feed menu document, although there may be cases where this is done intentionally.

It is RECOMMENDED that feed-titles be no longer than 50 characters, and that descriptions be no longer than 140 characters. However, processors SHOULD NOT strictly enforce these limits, although they may take measures to deal with long values.

Publishing software (for example, content management systems) SHOULD NOT automatically create feed menu documents, unless they have a high degree of certainty that the publisher is aware and that doing so is intentional.


# Processing Feed Menus {#processing}

Processors MUST only request feed menu documents from the "feed-menu.json" well-known URI.

When requesting feed menu documents, processors SHOULD negotiate for content language using proactive negotiation; see {{Section 12.5.4 of HTTP}}.

Processors SHOULD follow redirects when requesting feed menu documents, subject to limits on loop, abuse, and similar error handling.

Processors MUST ignore unrecognised members of menu and feed objects. Likewise, they MUST ignore unrecognised objects in the menu object's items array.

Processors SHOULD make menu object items available to users in the order they appear in the array. For example, a visual interface might make them available as a list. In some cases, however, they may be made available in another ordering (for example, a search interface).

Processors SHOULD NOT display feed objects that do not have a link that they are able to follow -- for example, those using unsupported URI schemes. In some cases, this may be difficult for implementations to conform to; for example, if feed links are dispatched to separate software.


# IANA Considerations {#iana}

IANA should register the following Well-Known URI:

* URI Suffix: feed-menu.json
* Change Controller: IETF
* Specification document(s): [this document]


# Security Considerations

A malicious actor who gains write access to the well-known location can effectively hijack the subscription list for an entire site's audience.

Clients that automatically fetch the feed menu document leak the fact that the user is interested in subscribing to feeds. In some views this might be a feature; it creates evidence that providing feeds would be beneficial to a publisher's audience. However, it is also a privacy risk.

--- back

# JSON Schema {#schema}

~~~json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Feed Menu Document",
  "description": "Strict validation schema for draft-nottingham-feed-menu.md",
  "type": "object",
  "$ref": "#/$defs/menuObject",
  "$defs": {
    "menuObject": {
      "type": "object",
      "required": [
        "feed-menu",
        "items"
      ],
      "properties": {
        "feed-menu": {
          "type": "string"
        },
        "items": {
          "type": "array",
          "items": {
            "anyOf": [
              {
                "$ref": "#/$defs/menuObject"
              },
              {
                "$ref": "#/$defs/feedObject"
              }
            ]
          }
        }
      },
      "additionalProperties": false
    },
    "feedObject": {
      "type": "object",
      "required": [
        "feed-title"
      ],
      "anyOf": [
        {
          "required": [
            "rss"
          ]
        },
        {
          "required": [
            "atom"
          ]
        }
      ],
      "properties": {
        "feed-title": {
          "type": "string"
        },
        "description": {
          "type": "string"
        },
        "rss": {
          "type": "string",
          "format": "uri-reference"
        },
        "atom": {
          "type": "string",
          "format": "uri-reference"
        }
      },
      "additionalProperties": false
    }
  }
}
~~~

# Implementation Status {#implementation}

A Web browser extension for presenting feed menus is available for Safari, Firefox, and Chrome here:
  https://github.com/mnot/feedmenu-extension

The following Web site(s) have a demonstration feed menu:

* https://www.mnot.net/

(other implementations can be listed as the appear; please contact me)


