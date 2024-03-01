---
title: Public API Principles
abbrev:
docname: draft-nottingham-public-apis-latest
date: {DATE}
category: std

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://mnot.github.io/I-D/"
  repo: "https://github.com/mnot/I-D/labels/public-apis"

github-issue-label: public-apis

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


--- abstract

This document introduces the concept of a "public API" -- one that is imposed upon the market by regulators -- and documents principles to help guide their development in order to assure that they genuinely serve the public.


---note_Note_to_Readers

This is a very preliminary document; it needs a considerable amount of additional content, examples, discussion, and refinement. At this point, feedback would be greatly appreciated on:
* The general approach and suitability for purpose (as described in the introduction)
* Whether the principles are at the appropriate level of abstraction
* Major concepts or ideas that are missing
Thank you for reading!

--- middle

# Introduction
To improve competitive conditions in Internet-related markets, legal regulators around the world are starting to require "big tech" companies, "gatekeepers", firms with "strategic market status" and similar to offer interfaces so that potential competitors can interoperate with them.

This document captures a number of principles for such interfaces, which it refers to as "public APIs." It is drawn from the experience that the IETF community has in defining APIs for interoperation. In particular, it explores the factors that differentiate a cooperatively defined API (as is usually the case for standards-defined APIs) and those that are adversarial in nature -- in particular, when the requirement to offer an API is imposed upon a party.

In doing so, it seeks to illustrate the properties of APIs that are more likely to offer genuine interoperability and thus combat not only anti-competitive abuses of power, but also other effects that can harm the Internet, such as centralization {{?RFC9518}}.
# The Public API Principles
The following principles are widely observed in APIs that provide value to their users and the Internet ecosystem at large. While there is considerable latitude in how they are applied to a specific function that is exposed, they are considered to be invariant.
## Simplicity
A public API will require the least possible effort from clients that wish to engage with it. Typically, this means judicious reuse of existing, widely familiar and used "building block" technologies and following the best practices for those technologies, with the minimal amount of application-specific protocol elements being defined to achieve the goals of the API.

For most applications, this means exposing an API over the HTTP protocol {{?RFC9110}}, following the Best Current Practices described in Building Protocols with HTTP {{?RFC9205}}. In cases where HTTP is not capable of meeting core goals of the application, other base protocols might be appropriate, but serious consideration should be given to the tradeoffs in doing so.

## Implementation Independence
The interface provided by a Public API should be defined by a formal specification, not the behaviour of an implementation -- even if there is only one implementation.

Basing interoperability on a specification assures substitutability (because other parties can implement it on equal footing) and equal access to the features of the API (because they are all documented). Doing so also allows the application to evolve its implementation separately from the interface, promoting stability. Specification-based interoperability can promote the growth of a market, because interoperability is not a high-cost, pairwise effort.

In particular, the implementation of the API server should not be tightly coupled to the API's definition. Its documentation should be separate (ideally, an open standard), and should not refer to data structures, behaviours, or requirements that are specific to that implementation.

Implementation independence is also important for consumers; requiring a particular client SDK, version of a particular piece of software, or a particular proprietary framework are all signs that the API is not implementation independent.

Where necessary, implementations should be encouraged (or required) to avoid the development of unintentional dependencies on their undocumented behaviour -- referred to in the industry as "Hyrum's Law," see <https://www.hyrumslaw.com>. This can be achieved through judicious use of "greasing." {{?RFC9170}}

## Modularity
APIs seldom offer just one function or access to one type of data. To be useful, they usually have to offer access to many different types of data and behaviours, so that they can be used in concert to achieve more complex goals.

When this is the case, there should be well-defined boundaries between the different functions and data types, separated into distinct modules that can be used and evolve independently.

Doing so enhances the use of an API's capabilities for purposes that may not have been foreseen when it was created -- also known as unintended reuse. Enabling unintended reuse ensures that the API can serve users' needs, rather than the vendors' wishes to steer user activity.

The decision of where to draw boundaries between modules is a design issue; many factors can influence it. The motivation for these choices, however, should be centred on the users' needs.

## Stability
It is critical for public APIs to be stable over time; that is, to avoid capricious change. When an API changes, its consumers must also change, and updating disparate clients widely distributed by unrelated parties around the globe causes significant work, raises associated costs, and introduces risks those consumers.

One cause of instability is the introduction of needed changes to APIs, as their capabilities evolve and demands from users are revised. If such changes are "backwards compatible", they are made in such a way that clients that have not yet been updated can still interoperate, avoiding the nearly impossible task of a simultaneous update of all clients (a so-called "flag day").

For an API to allow backwards compatible change, it must carefully document the behaviours that it guarantees will be invariant, and where clients should ignore unknown changes. Many standard Internet protocols and formats have conventions that enable this; for example, HTTP header fields can be introduced without breaking existing consumers. When present, these conventions should be honoured and leveraged by public APIs.

At times, an API might need to make an incompatible change; for example, where there is a security or legal flaw. Such changes should be rare, and need to be advertised widely for a substantial amount of time before they are executed.

A more abstract cause of instability is the ownership of the definition of an API by a single entity, both because they are able to introduce capricious change more easily, and because if that entity were to go away (for example, go out of business), its status becomes unclear.

Because of this, public APIs should be defined by openly available specifications who are maintained by recognised community organisations -- typically, Standards Developing Organisations. These organisations have the expertise and processes in place to assure responsible stewardship and change control over these APIs.

## Functionality
A public API needs to actually provide the full function desired by its users.

Often, open APIs will stop short of the functionality necessary to fully recreate a product or service. This is especially true when the API's exposed features are chosen from the already-built product selectively, often using an adapter layer that is brittle and prone to mistranslation.

One way to assure the functionality of a public API is to require "API-First Development" -- building the product offered by a company upon the APIs that it has exposed. Since doing so requires that all functionality is available in the APIs, there are no "hidden" features or low-fidelity capabilities.




--- back

