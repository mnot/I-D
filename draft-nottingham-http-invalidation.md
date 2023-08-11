---
title: An HTTP Cache Invalidation API
abbrev:
docname: draft-nottingham-http-invalidation-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/http-invalidation"

github-issue-label: http-invalidation

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
  HTTP: RFC9110
  HTTP-CACHING: RFC9111
  GROUPS: I-D.nottingham-http-cache-groups
  DESCRIPTION: I-D.nottingham-gateway-description
  JSON: RFC8259
  URI: RFC3986
  IRI: RFC3987


--- abstract

This document specifies an HTTP-based API that gateway caches (such as those in reverse proxies and content delivery networks) can expose to allow origin servers to their invalidate stored responses.

--- middle


# Introduction

{{Section 4.4 of HTTP-CACHING}} defines invalidation as the side effect of a state-changing request on one or more stored responses in an HTTP cache.

In practice, it has become common for caches to allow invalidation to be triggered through other mechanisms -- often, using a dedicated HTTP API. This is especially useful for caches that have a relationship with the origin server and wish to offer them finer-grained control, as is the case for reverse proxies and content delivery networks.

While many such APIs already exist, they are proprietary. That makes it difficult for the origin server or its delegates (for example, content management systems) to take advantage of those facilities, because each integration needs to created and maintained, hindering interoperability.

This document standardises an HTTP-based API for HTTP cache invalidation. {{resource}} describes an HTTP resource that accepts requests to invalidate stored responses, using a format described in {{event-format}}.


## Notational Conventions

{::boilerplate bcp14-tagged}



# HTTP Cache Invalidation Resources {#resource}

An HTTP Cache Invalidation Resource (hereafter, 'invalidation resource') is an HTTP resource ({{Section 3.1 of HTTP}}) that has the behaviours described in this section.

Invalidation resources SHOULD require requests to include some form of authentication. The specific mechanism is out of scope for this document, but note that {{DESCRIPTION}} describes a way to specify a mechanism and credentials in the description format.

When an invalidation resource receives a POST request whose content is in the format described in {{event-format}}, its expected behaviour will be to process the request and invalidate the responses it indicates that are stored in the cache(s) associated with it.

As described in {{Section 4.4 of HTTP-CACHING}}:

> invalidate means that the cache will either remove all stored responses whose target URI matches the given URI or mark them as "invalid" and in need of a mandatory validation before they can be sent in response to a subsequent request.

This includes all responses for the URI, including those who have cache keys that include information derived from the Vary response field (see {{Section 4.1 of HTTP-CACHING}}).

The authenticated user MUST be authorized to perform each invalidation. Unauthorized invalidations MUST be ignored; future extensions might allow description of which invalidations succeeded or failed.

Furthermore, some features in the event format described in {{event-format}} are not required to be implemented; for example, some event selector types might not be supported, or the "purge" member might not be supported. An invalidation resource that receives a request using an unsupported feature SHOULD respond with a 501 (Not Implemented) status code.

TODO: specify a problem details object for these errors

If the cache is able to invalidate the indicated stored responses in a reasonable amount of time (for example, 30 seconds), the invalidation resource SHOULD respond with a 200 (OK) status code only once all of those responses have been invalidated.

Otherwise (i.e., the cache cannot invalidate within a reasonable amount of time, or cannot estimate how long invalidation will take), it SHOULD immediately respond with a 202 (Accepted) status code.

This specification does not define a format for successful responses from invalidation resources; implementations MAY send responses with empty content. Future extensions might allow description of the results of invalidation.


# HTTP Cache Invalidation Event Format {#event-format}

The HTTP Cache Invalidation Event Format (hereafter, 'event format') is a JSON-based {{JSON}} format that conveys a list of selectors that are used to identify the stored responses in a cache, along with additional instructions about the nature of invalidation being requested.

Its content is an object with the following two required members:

* "type": a case-sensitive string indicating the selector type for the invalidation event; see {{selector-types}}
* "selectors": an array of strings, each being a selector of the indicated type.

For example, this document contains an event using the "URI" selector type, and invalidates two URIs:

~~~ json
{
    "type": "uri",
    "selectors": [
      "https://example.com/foo/bar",
      "https://example.com/foo/bar/baz"
    ]
}
~~~

Additionally, this document defines one optional member of the top-level object:

* "purge": a boolean that when true indicates that the selected stored responses should be removed from cache, rather than just marked as invalid.

Support for purge is OPTIONAL. When a cache supports for purge, the cache MUST remove the relevant response(s) from volatile and non-volatile storage as promptly as possible, and if the cache indicates success with a 200 (OK) status code, MUST do so before returning the response.

Unrecognised members of the top-level object MUST be ignored, to allow future updates of this specification to add new features.


## Selector Types {#selector-types}

This document defines the following cache invalidation selector types:

### URI Selectors {#uri-selector}

The "uri" selector type selects one or more stored responses by their URI. When the invalidation event type is "uri", the content each selector string MUST be either a URI {{URI}} or an IRI {{IRI}}.

When a selector value is compared to a stored response URI to determine whether it selects that response, the following process is used:

1. If the selector value is a IRI, it is converted to a URI, per {{Section 3.2 of IRI}}.
2. Syntax-based normalization is applied to both the selector and stored response URI, per {{Section 6.2.2 of URI}}.
3. Scheme-based normalization is applied to both the selector and stored response URI, per {{Section 6.2.3 of URI}}.

For example, "https://www.example.com/foo/bar" selects stored responses with the following URIs:

* "https://www.example.com/foo/bar"
* "HTTPS://www.example.com:443/foo/bar"
* "https://www.example.com/fo%6f/bar"
* "https://www.example.com/fo%6F/bar"
* "https://www.example.com/../foo/bar"
* "https://www.example.com:/foo/bar"

... but does not select stored responses with the following URIs:

* "https://www.example.com/FOO/bar" (different path)
* "https://www.example.com/foo/bar/baz" (different path)
* "https://www.example.com/foo/barbaz" (different path)
* "https://www.example.com/foo/bar/" (different path)
* "http://www.example.com/foo/bar" (different scheme)
* "https://example.com/foo/bar" (different authority)
* "https://www.example.com/foo/bar?baz" (different query)
* "https://www.example.com/foo/bar?" (different query)
* "https://www.example.com:8080/foo/bar" (different authority)

### URI Prefix Selectors {#prefix-selector}

The "uri-prefix" selector type selects one or more stored responses by their URI prefix. When the invalidation event type is "uri-prefix", the content each selector string MUST be either a URI {{URI}} or an IRI {{IRI}}.

When a selector value is compared to a stored response URI to determine whether it selects that response, the same normalization process described in {{uri-selector}} is used. However, the selector value is considered to be a prefix to match. Additionally, each segment of the selector value's path must have a matching segment in the stored response URI.

For example, "https://www.example.com/foo/bar" would select all of the following URIs:

* "https://www.example.com/foo/bar"
* "https://www.example.com/foo/bar/"
* "https://www.example.com/foo/bar/baz"
* "https://www.example.com/foo/bar/baz/bat"
* "https://www.example.com/foo/bar?"
* "https://www.example.com/foo/bar?baz"

... but does not match stored responses with the following URIs:

* "https://www.example.com/foo/barbaz" (last segment does not match)
ww.example.com/foo/BAR/baz" (second segment does not match)

### Origin Selectors {#origin-selector}

The "origin" selector type selects all stored responses associated with a URI origin ({{Section 4.3.1 of HTTP}}). When the invalidation event type is "origin", the content of each selector string MUST be a normalized (using the process defined in {{uri-selector}}) URI prefix, without a trailing "/". If the port is not present, it is assumed to be the default port for the scheme.

For example, all of these are origin selectors:

* "https://www.example.com:443"
* "http://example.com"
* "https://example.net:8080"


### Group Selectors

The "group" selector type selects all stored responses associated with a group on a specified origin. When the invalidation event type is "group", the content of each selector string MUST be a normalized (using the process defined in {{uri-selector}}) URI prefix with port always present, and without a trailing "/". See {{origin-selector}} for examples.

Additionally, when the invalidation event type is "group", the document's root object MUST contain an additional member, "groups", whose value is an array of strings that correspond to the group(s) being invalidated, per {{GROUPS}}.

For example:

~~~ json
{
    "type": "group",
    "selectors": [
      "https://example.com:443",
      "https://www.example.com:443"
    ],
    "groups": [
      "scripts"
    ]
}
~~~


# IANA Considerations

## Media Types

_TBD_

## Cache Invalidation Selector Types

_TBD_

# Security Considerations

_TBD_


--- back

# Acknowledgements

Thanks to Stephen Ludin for his review and suggestions.
