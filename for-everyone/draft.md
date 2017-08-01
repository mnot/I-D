---
title: 
abbrev:
docname: draft-nottingham-for-everyone-00
date: 2017
category: info

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


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/for-everyone>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/for-everyone/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/for-everyone>.

See also the draft's current status in the IETF datatracker, at
<https://datatracker.ietf.org/doc/draft-nottingham-for-everyone/>.

--- middle

# Introduction

Internet Standards are used in a variety of environments; connectivity now reaches from universities to homes, businesses, coffee shops, data centres and beyond, to more exotics places like airplanes, Antarctica and even deep space {{?RFC4838}}. It also has expanded from NN terrestrial countries in YYYY to more than MM today.

Likewise, the Internet is now used for an ever-expanding set of users. From its origination as a network of university computers in that filled rooms, it now connects a diverse range of endpoints, from desktop and laptop computers to phones, radios, toys, cameras, industrial control systems, military hardware, the international financial system, many other businesses, government databases and much more.

This expansion of both deployment and uses is a desirable outcome; as the network grows, so does its value {{}}. As a result, the IETF has a long history of adapting its technology to different environments and different use cases, to assure the widest possible reach.

Proposals for new Internet Standards or changes to existing ones are often brought to the IETF from these diverse communities of users and deployments often seek to improve specific conditions for them.

While doing so is generally encouraged (since the Internet often needs to adapt to its environment), there are cases where proposals that represent improvements in a specific environment can be hazardous to deploy elsewhere.

For example, a datacentre network might want to change how congestion control operates (or remove it entirely) inside its confines. While this might be advantageous in a controlled environment, it would be disastrous to do so on the open Internet, as it would result in congestion collapse {{?I-D.draft-ietf-tcpm-dctcp}}. 

Or, a financial institution might need to conform to regulations specific to them, and thus need to change how encrypted protocols on their network operate to enable efficient monitoring of activity, while still adhering to their security requirements. While this might be seen as pragmatic in that environment, using such techniques on the open Internet would be widely seen as a step (or many steps) backwards in security, as it would sacrifice Forward Security {{}}, and furthermore be prone to abuse for attacks such as pervasive monitoring {{?RFC7258}}.

In discussing such proposals, there is often a question of whether it is appropriate to promote something to Internet Standard if it could be harmful when deployed inappropriately.

Clearly, every Internet Standard need not be deployable on every Internet-connected network; likewise, the possibility of harm does not preclude standardisation. However, when the potential consequences and/or likelihood of deployment outside the intended environment are too great, such a proposal needs much more careful vetting.

This document explores the properties of such proposals and suggests guidelines for evaluating whether they should become Internet Standards.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The Internet is for Everyone

Engineers often concentrate on the problems immediately in front of them, and propose solutions that minimally solve those problems. While this is acceptable practice in a limited, known environment, this style of engineering often fails when proposing changes to the Internet, because it is such a diverse environment.





## Diversity and the Internet

## Containment

## The Impact of Standardisation



# IANA Considerations

This document has no actions for IANA.

# Security Considerations

TBD

--- back
