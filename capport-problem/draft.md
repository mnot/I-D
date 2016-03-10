---
title: Captive Portals Problem Statement
abbrev: CAPPORT Problem Statement
docname: draft-nottingham-capport-problem-01
date: 2016
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
  RFC6108:

informative:


--- abstract

This draft attempts to establish a problem statement for "Captive Portals", in order to inform discussions of improving their operation.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/capport-problem>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/capport-problem/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/capport-problem>.


--- middle

# Introduction

This draft attempts to establish a problem statement for "Captive Portals", in order to inform discussions of improving their operation.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# Defining Captive Portals and Networks

A "_captive network_" is a network that employs a captive portal for a variety of purposes; see {{why}}. A "_captive portal_" is a Web site that captive networks direct users to. 

This is achieved by directing requests for "normal" Web access to the captive portal, through variety of techniques, including DNS poisoning, TCP interception, HTTP response modification and/or HTTP redirection.

Once the captive network's goals are met, the network "remembers" that the user is allowed network access, usually by MAC address, although there is a significant amount of variance between implementations.

Over time, operating systems have developed "_captive portal detection_" processes to discover captive networks, and to assist users through the process of obtaining full network access. They often involve specialised "_captive portal browsers_" which only allow the captive portal to use a subset of the full capabilities of a Web browser, and have a different user experience.


## Why Captive Portals Are Used {#why}

Captive portals are deployed in a variety of situations, but the most common motivations are:

* **Authentication** - Obtaining user credentials before authorising network access

* **Payment** - Obtaining payment for using the network.

* **Information** - Presenting information to the user. This might include displaying legal notices, details about the network provider and/or its location, advertisements, policies, etc., and obtaining user consent.

* **Notifications** - Some networks use the same mechanisms as captive portals to notify users of account status, network downtime, emergency alerts, etc. See {{RFC6108}} for an example of one way this is done.

In all of these cases, using a Web browser is attractive, because it gives the network the ability to tailor the user's interface and experience, as well as the ability to integrate third-party payment, advertising, authentication and other services.


# Issues Caused by Captive Portals {#issues}

When a network imposes a captive portal, it can cause a variety of issues, both for applications and end users.

* **False Negatives** - Because so many different heuristics are used to detect a captive portal, it's common for an OS or browser to think it's on an open network, [when in fact there is a captive portal](https://discussions.apple.com/thread/6251349) in place.

* **Longevity** - Often, it's necessary to [repeatedly log into a captive portal](https://community.aerohive.com/aerohive/topics/ios_7_captive_portal_issues), thanks to timeout issues. The effects of this range from annoyance to inability to complete tasks, depending on the timeout and the task at hand.

* **Interoperability Issues** - Captive portals often depend on specific operating system and browser capabilities and behaviours. Client systems that do not share those quirks often have difficulty connecting to captive portals.

* **Confusion** - Because captive portals are effectively a man-in-the-middle attack, they can confuse users as well as user agents (e.g., caches). For example, when the portal's TLS certificate doesn't match that of the requested site, or the captive portal's /favicon.ico gets used as that of the originally requested site.

* **DNS**/**DNSSEC** - When portals respond with forged DNS answers, they confuse DNS resolvers and  interoperate poorly with host-validating DNSSEC resolvers and applications.

* **TLS** - Portals that attempt to intercept TLS sessions (HTTPS, IMAPS, or other) can cause certificate error messages on clients, encouraging bad practice to click through such errors.

* **Unexpected Configuration** - Some captive portals do not work with clients using unexpected configurations, for example clients using static IP, custom DNS servers, or HTTP proxies.

* **Stealing Access** - because captive portals often associate a user with a MAC address, it is possible for an attacker to impersonate an authenticated client (e.g., one that has paid for Internet access). Note that this is specific to open Wifi, and can be prevented by using a secure wireless medium. However, configuration of secure wireless is often deemed to be too complex for captive networks.

* **Non-Browser Clients** - It is becoming more common for Internet devices without the ability to run a browser to be used, thanks to the "Internet of Things." These devices cannot easily use most networks that interpose a captive portal.

* **Connectivity Interruption** - For a device with multiple network interfaces (e.g., cellular and WiFi), connecting to a network can require dropping access to alternative network interfaces.  If such a device connects to a network with a captive portal, it can lose network connectivity until the captive portal requirements are satisfied.


# Issues Caused by Captive Portal Detection {#issues-detection}

Many operating systems attempt to detect when they are on a captive network. Detection aims to minimize the negative effects caused by interposition of captive portals, but can cause different issues, including:

* **False Positives** - Some networks don't use a Web browser interface to log in; e.g., they [require a VPN to access the network](http://stackoverflow.com/questions/14606131/using-captive-network-assistant-on-macosx-to-connect-to-vpn), so captive portal detection relying on HTTP is counterproductive.

* **Non-Internet Networks** - [Some applications](http://forum.piratebox.cc/read.php?9,8879) and/or networks don't assume Internet access, but captive portal detection often conflates "network access" with "Internet access".

* **Sandboxing** - When a captive portal is detected, some operating systems access the captive portal in a highly sandboxed captive portal browser.  This might have reduced capabilities, such as limited access to browser APIs.  In addition, this environment is separate from a user's normal browsing environment and therefore does not include state. While sandboxing seems a good idea to protect user data (particularly on Open WiFi), it is implemented differently on various platforms and often causes a (severely) broken user experience on the captive portal (even when the operator is protecting user data end-to-end with HTTPS). To offer a consistent and rich experience on the captive portal, some operators actively try to defeat operating system captive portal detection.


## Issues Caused by Defeating Captive Portal Detection

Many captive portal devices provide optional mechanisms that aim to defeat captive portal detection.

Such defeat mechanisms aim to avoid the problems caused by captive portal detection (see {{issues-detection}}), with the consequence that they also cause the same problems that detection was intended to avoid (see {{issues}}).


# Security Considerations

TBD


--- back

# Acknowledgements

This draft was seeded from the [HTTP Working Group Wiki Page on Captive Portals](https://github.com/httpwg/wiki/wiki/Captive-Portals); thanks to all who contributed there.

Thanks to Martin Thomson, Yaron Sheffer, David Bird and Jason Livingood for their suggestions.

