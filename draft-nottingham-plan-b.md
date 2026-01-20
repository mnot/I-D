---
title: Application Directives in robots.txt
abbrev:
docname: draft-nottingham-plan-b-latest
date: {DATE}
category: std
updates: 9309

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/plan-b"

github-issue-label: plan-b

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
  URI: RFC3986
  ROBOTS: RFC9309
  FIELDS: RFC9651

--- abstract

This document defines a way for Web sites to express preferences about how their content is handled by specific applications in their robots.txt files.

--- middle


# Introduction

The Robots Exclusion Protocol {{ROBOTS}} allows Web site owners to "control how content served by their services may be accessed, if at all, by automatic clients known as crawlers." While this provides an effective way to direct cooperating crawlers' behaviour when accessing a site, it does not consider what happens afterwards: in particular, what is done with the data that is obtained through crawling. This has created tensions, especially when crawlers have more than one purpose, or when a purpose changes (for example, a search engine changes its user interface in a way that's undesirable to the site).

{{?I-D.ietf-aipref-vocab}} defines a universal vocabulary that describes how content should be handled for uses involving AI, and {{?I-D.ietf-aipref-attach}} describes how that vocabulary should be attached to content in robots.txt and through other means. This framework allows sites to specify how their data should be handled in a manner that's separate to the question of how crawlers show behave when the access the site.

However, it has become apparent that defining such a universal vocabulary is difficult, because it requires broad agreement on sometimes hard-to-define concepts, and necessitates imprecision, so as to be broadly applicable across both different implementations as well as over time. As a result, sites may not have obvious ways state their preferences regarding specific behaviours.

To address this shortcoming, this document defines a complementary mechanism: a robots.txt extension that allows sites to express preferences about how specified applications should behave in certain circumstances.

For example, a site might wish to express that it does not want ExampleSearch to use its content with ExampleSearch's new "Widgets" feature. ExampleSearch has registered a "widgets" control, so that the site can express this in its robots.txt file:

~~~
User-Agent: *
Allow: /
App-Directives: examplesearch;widgets=?0
~~~

In this manner, sites can provide specific directives to applications that wish to use their data.

## Creating New Application Directives

To allow a site to express its preferences about how specific applications are to treat their content, an identifier for the application needs to be chosen (in the above example, 'examplesearch') and the syntax and semantics of its directives need to be defined (in the example above, 'widgets=?0' to enable or disable the 'widgets' feature).

This specification creates IANA registries for application identifiers and directives to facilitate easy discovery of these artefacts. It is expected that applications that consume data obtained from the Web will register specific controls for their features (including but not limited to the entire application itself) in this registry.

However, this specification does not mandate registration. It is anticipated that non-technical regulation (e.g., competition regulation) might play some role in encouraging or even requiring certain applications to register appropriate controls for their features.

## Interaction with AI Preferences

Application Directives are complimentary to the vocabulary described in {{?I-D.ietf-aipref-vocab}}. Whereas the AI Preferences vocabulary are generic and potentially applicable to any application consuming a given piece of content, Application Directives are tightly scoped to the application and semantics defined in the appropriate registry entry.

In particular, AI Preferences are applicable even to unknown uses and consumers of content, whereas Application Directives do not apply to any application except the one nominated. Because of this, it is anticipated that they will often be used together: AI Preferences to set general policy about how content is treated, and Application Directives to fine-tune the behavior of specific applications.

Because Application Directives are a more specific, targeted mechanism, they can be considered to override applicable AI preferences that are attached in the same robots.txt file, in the case of any conflict. Such override is only applicable, however, within the defined scope of the semantics of the given directive(s).

## Interaction with the User-Agent Line

Because the robots.txt format requires that all extensions be scoped to a User-Agent line, it is possible for nonsensical things to be expressed. For example:

~~~
User-Agent: ExampleSearch/1.0
Allow: /
App-Directives: someothersearch;foo=bar
~~~

Here, directives for SomeOtherSearch are limited to content retrieved by the ExampleSearch crawler, and so are unlikely to be applied by SomeOtherSearch.

Therefore, it is RECOMMENDED that App-Directives extensions always occur in a group with "User-Agent: *", so that they are most broadly applicable.

## Notational Conventions

{::boilerplate bcp14-tagged}

# The App-Directives robots.txt Extension

This specification adds an App-Directive rule to the set of potential rules that can be included in a group for the robots.txt format.

The rule ABNF pattern from {{Section 2.2 of ROBOTS}} is extended as follows:

~~~
rule =/ app-directive

app-directive-rule = *WS "app-directive" *WS ":" *WS
                     [ path-pattern 1*WS ] app-directives *WS EOL
app-directives     = <List syntax, per Section 3.1 of FIELDS>
~~~

Each group contains zero or more App-Directive rules. Each App-Directive rule consists of a path and then Directives.

The path might be absent or empty; if a path present, a SP or HTAB separates it from the Directives.

The Directives use the syntax defined for Lists in {{Section 3.1 of FIELDS}}. Each member of the list is a Token ({{Section 3.3.4 of FIELDS}}) corresponding to a registered application identifier, per {{reg-id}}. Parameters on each member ({{Section 3.1.2 of FIELDS}}) correspond to directives for that application as registered in {{reg-directive}}.

When multiple app-directive-rules with the same (character-for-character) path-pattern are present in a group, their app-directives are combined in the same manner as specified in {{Section 4.2 of FIELDS}}. As a result, this group:

~~~
User-Agent: *
Allow: /
App-Directives: examplesearch;widgets=?0
App-Directives: someothersearch;foo=bar
~~~

is equivalent to this group:

~~~
User-Agent: *
Allow: /
App-Directives: examplesearch;widgets=?0,someothersearch;foo=bar
~~~

## Applying Application Directives

Application directives apply solely to the applications that they identify; their presence or absence does not communicate or imply anything about the behaviour of other applications, and likewise makes no statements about the behavior of crawlers.

When applying directives from a robots.txt file, an application MUST merge identical groups (per {{Section 2.2.1 of ROBOTS}} and choose either the (possibly merged) group that matches its registered product token. If there is no matching group, the application MUST use the (possibly merged) group identified with "*".

When applying directives from a chosen group, an application MUST use those associated with the longest matching path-pattern, using the same path prefix matching rules as defined for Allow and Disallow. That is, the path prefix length is determined by counting the number of bytes in the encoded path.

Paths specified for App-Directive rules use the same percent-encoding rules as used for Allow/Disallow rules, as defined in Section 2.1 of {{URI}}. In particular, SP (U+20) and HTAB (U+09) characters need to be replaced with "%20" and "%09" respectively.

The ordering of rules in a group carries no semantics. Thus, app-directives rules can be interleaved with other rules (including Allow and Disallow) without any change in their meaning.


# IANA Considerations

## The Application Identifiers Registry {#reg-id}

IANA should create a new registry, the Application Identifiers Registry.

The registry contains the following fields:

* Application Identifier: _a Token identifying the application; see {{Section 3.3.4 of FIELDS}}_
* Product Token: _an identifier for the crawler associated with the application in robots.txt; see {{Section 2.2.1 of ROBOTS}}_
* Change Controller: _Name and contact details (e.g., e-mail)_

Registrations are made with Expert Review ({{Section 4.5 of !RFC8126}}). The Expert(s) should assure that application identifiers are specific enough to identify the application and are not misleading as to the identity of the application or its controller.


## The Application Directives Registry {#reg-directive}

IANA should create a new registry, the Application Directives Registry.

The registry contains the following fields:

* Application Identifier: _a value from the Application Identifiers Registry_
* Directive Name: _an identifier for the directive; must be a Structured Fields key (see {{Section 4.1.1.3 of FIELDS}})_
* Directive Value Type: _one of "Integer", "Decimal", "String", "Token", "Byte Sequence", "Boolean", "Date", or "Display String"; see {{Section 3.3 of FIELDS}}_
* Directive Description: _A short description of the directive's semantics_
* Documentation URL: _A URL to more complete documentation for the directive_
* Status: _one of "active" or "deprecated"_

Registrants in this registry MUST only register values for application identifiers that they control. The change controller for an entry in this registry is that of the corresponding application identifier.

New registrations are made with Expert Review ({{Section 4.5 of !RFC8126}}). The Expert will assure that the change controller is correct (per above), that the value type is appropriate, and that the documentation URL is functioning.


# Security Considerations

Like all uses of robots.txt, directives for applications are merely stated preferences; they have no technical enforcement mechanism. Likewise, because they are exposed to all clients of the Web site, they may expose information about the state of the application on the server, including sensitive paths.


--- back

