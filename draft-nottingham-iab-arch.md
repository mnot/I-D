---
title: More Architectural Principles of the Internet
abbrev:
docname: draft-nottingham-iab-arch-latest
date: {DATE}
category: info

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
smart_quotes: no
pi: [toc, tocindent, sortrefs, symrefs, strict, compact, comments, inline]

venue:
  home: "https://projects.mnot.net/I-D/"
  repo: "https://github.com/mnot/I-D/labels/arch"

github-issue-label: arch

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

informative:
  RFC1958:
  RFC1984:
  RFC2804:
  RFC3365:
  RFC3552:
  RFC3724:
  RFC3935:
  RFC5218:
  RFC6973:
  RFC7258:
  RFC7452:
  RFC7624:
  RFC7754:
  RFC8170:
  RFC8280:
  RFC8558:
  RFC8890:
  RFC9170:
  RFC9413:
  RFC9446:
  RFC9518:
  RFC9614:
  TUSSLE:
    target: https://groups.csail.mit.edu/ana/Publications/PubPDFs/Tussle2002.pdf
    title: "Tussle in Cyberspace: Defining Tomorrow's Internet"
    date: August 2002
    seriesinfo:
      DOI: 10.1145/633025.633059
    author:
      - ins: D. Clark
        name: David D. Clark
      - ins: J. Wroclawski
        name: John Wroclawski
      - ins: K. Sollins
        name: Karen R. Sollins
      - ins: R. Braden
        name: Robert Braden
  DESIGN-RULES:
    target: https://direct.mit.edu/books/book/1856/Design-RulesThe-Power-of-Modularity
    title: "Design Rules, Vol. 1: The Power of Modularity"
    date: 2000
    refcontent: MIT Press
    author:
      - ins: C. Y. Baldwin
        name: Carliss Y. Baldwin
      - ins: K. B. Clark
        name: Kim B. Clark

--- abstract

This document continues, in the tradition of RFC 1958 and RFC 3439, to document some aspects of the Internet's architecture that have been proven to be important to consider when designing protocols for it.

It also explains why these principles are important to the continued success of the Internet.

--- middle

# Introduction

The Internet works as it does because of certain architectural principles that have, over time, proven to be significant contributors to its success. Experience suggests that technical proposals for changes to the Internet that align with them are more likely to be deployable. These principles can also influence more than technical designs: social and policy goals can be achieved not only through application of the law, social norms, and markets, but also by the architecture of the Internet itself.

The sections below document some of these principles and show how they support these goals. This document aims to help those who shape the Internet understand these principles, so that their work can build on them where appropriate and avoid unintended harm to the Internet and the benefits it brings society.


# Open

The Internet is an _open system_. Its boundaries are not fixed: no party can list everyone on the Internet, or all of the ways they use it. Anyone can connect to it, and anyone can introduce a new application without coordination (so-called 'permissionless innovation'). The breadth and depth of the Internet's impact -- including all of the associated social, economic, and cultural benefits -- can be directly attributed to its openness.

In contrast, consider a closed system, such as the pre-Internet telephone system in many countries. In those systems, it was common to have tight restrictions not only on what a telephone could be used for, but even what equipment could be connected to the network. Such barriers to participation and reuse may make operation of the system more predictable, but they also constrain innovation; requiring permission (and often, certification and licensing) had the effect of delaying new, innovative uses of the network.

Closed systems can still work at global scale: the international postal and telephone systems are reliable, and they can be closed because their services change little and new participants join on one side only, as end users.

The Internet is not like that; its value comes from admitting new participants of all kinds and sizes -- such as publishers, services, and infrastructure -- not just end users. Low barriers to entry also give businesses of any size access to a global market. Requiring permission to use the Internet discourages new applications, and tends to concentrate power in large organizations that are better able to navigate the hurdles.

Some harms associated with the Internet are harder to fight due to its openness: low barriers to entry invite abuse such as spam, and fighting it without a gatekeeper, with each participant seeing only part of the system, is a much harder design problem than excluding bad actors from a closed one.

Building closed systems on top of the Internet is a reasonable response to that tradeoff, and doing so is not, in itself, against the Internet's nature. A limited, closed system built on top of the Internet can fail without threatening the entire infrastructure, and can be replaced by other systems -- open or closed. However, once a system (e.g., a given application, infrastructure component or other facility) becomes so important to people's experience of the Internet or its operation that it cannot practically be replaced, its enclosure should be questioned (see {{Section 2.2 of RFC9518}}).

Consider the 'app store' approach to controlling what applications are available on some platforms (including many mobile phones). While control points like these create an opportunity to refuse applications that are security threats, poorly conceived, or against policy objectives such as child protection, they also raise governance questions, create security and reliability vulnerabilities, and, often, impose questionable economic arrangements that constrain innovation on that platform.

Building such control points into the Internet itself by requiring permission to deploy or use applications would also be ineffective, because the permission has to be enforced somewhere. Enforcing it at the source needs authority over everyone who might deploy an application, which no party has, because the system spans many jurisdictions. Enforcing it in the middle means blocking, which is often easy to evade and harms services it did not target because the layers of the Internet depend on each other ({{Section 4.1 of RFC7754}}).

Social and policy goals -- competition, safety, inclusion, resilience -- can be pursued without closing the infrastructure. They are best met where the responsible party can be identified and held to account, which means the applications, hosts, and commercial entities built on top of the Internet. Because the infrastructure stays open, alternatives remain free to emerge and displace a system that has become difficult to replace.


# Decentralized

If an architecture is to be open, it must also be _decentralized_ -- it must not have 'choke points' where a single party or small group can observe, control, or extract rent from communication between others.

Permissionless innovation depends on decentralization. If one party sits in the path of every application, coordinating with them becomes a barrier to entry. They need not refuse anyone for the effect to be felt; the mere capability can shape what people attempt. Where a function has no substitute, its operator can also extract rent from everyone who relies on it, and use what it sees to improve its own offerings while denying that data to others ({{Section 2.1 of RFC9518}}).

The same position gives that party -- and any state with authority over it -- the means to observe what people do and to deny or shape it, which are available for coercion whether or not they are ever used that way ({{Section 2.1 of RFC9518}}).

Open, secure, and reliable connectivity is necessary, though not sufficient, to exercise rights such as freedom of expression and freedom of association ({{Section 1 of RFC8280}}). Political centralization, where one country can control how a function is supplied across the whole Internet, is as much a concern as commercial concentration ({{Section 2 of RFC9518}}). A jurisdiction's goals for its own territory can be met by acting on the parties within it.

Centralization also concentrates failure. When one provider's outage disrupts a large part of the Internet, or a single codebase or algorithm replicates one flaw everywhere it runs, the impact is out of proportion to the size of the fault. A monoculture of this kind is a systemic cybersecurity risk, and a single content recommendation algorithm can have severe social impact for the same reason ({{Section 2.1 of RFC9518}}). Many independent operators and implementations tend to keep failures local and leave users somewhere else to go.

Some centralization cannot be avoided. A function that needs one globally agreed answer is centralized by nature: the root of the Domain Name System, which turns names into addresses consistently everywhere; the allocation of IP addresses, which must be unique; and the certificate authorities that let browsers know they have reached the right website. The Internet's answer has been to govern the choke point: ICANN oversees the name space, and the CA/Browser Forum oversees the Web's certificates ({{Section 3.1.3 of RFC9518}}).

Decentralized standards are necessary but not sufficient to avoid centralization ({{Section 1 of RFC9518}}). Email lets anyone run a mail server, yet the cost of getting other servers to accept its mail has contributed to concentration in a small number of large providers ({{Section 3.1.1 of RFC9518}}). Standards are voluntary, and much centralization has non-technical causes that no specification can prevent.

Decentralization serves competition and consumer choice, the resilience of services that society depends on, and protection from undue surveillance and coercion. Protocols that keep it possible and cheap to choose give those goals a foundation to build on ({{Section 4.3 of RFC9518}}).

# Trusted

The Internet's users depend on infrastructure they rarely inspect, and so they need to be able to trust that it is working in their interests: that it will not snoop on them, track them, or report on them. This is true even when untested, because the possibility of surveillance can be enough to change how people behave ({{Section 5.1.1 of RFC6973}}).

Protocols support that trust by dividing the work of a communication into distinct roles and constraining what each role can do, so that the interests of the parties involved check one another. Third parties are most often added to a communication as intermediaries or in designated agent roles, and constraints on those roles can prevent the most egregious abuses of their power ({{Section 4.5 of RFC9518}}). The IAB has argued that trust relationships should be defined before a protocol is designed, with boundaries drawn between the elements that share them ({{Section 4.1.2 of RFC3724}}).

Distinct roles also support accountability and consumer protection: a relying party, a certificate authority, or a relay each has a defined function that can be examined for how well it operates -- not only technically, but also in terms of political economy.

A user visiting a website trusts not only the site but also the browser acting on their behalf and the system that lets the browser know the site is what it claims to be, which is what allows commerce with parties a user has never met. Critically, the browser's interests need to be separate from those of the sites being accessed for this to occur.

Standards define the browser as a distinct role: it stands between the user and the site, limiting what the site can reach on the user's system, and so removes the need to trust every site completely. Competition between browsers gives their makers a reason to work for their users, although a browser represents its user imperfectly, since a few browsers serve a diverse population ({{Section 4.2 of RFC8890}}).

On the Web, browsers have strong incentives to protect users' privacy and security. Certificate authorities have a strong incentive to be included in browsers' trust stores. The CA/Browser Forum brings both into a body that sets operational and security requirements for the authorities. The protocols do not define this governance; it is applied on top of them. Its legitimacy is difficult to establish and maintain, and it is vulnerable to capture by the interests being governed ({{Section 3.1.3 of RFC9518}}).

The strongest infrastructure is that which cannot snoop, track, or report because it cannot see. Encryption protects communication from outsiders but not from the party at the other end. When the roles of the service being accessed can be partitioned, no single party other than the user sees the totality of communication, a technical form of data minimization ({{Section 1 of RFC9614}}) that delivers privacy goals by design. Data protection law relies on the same principle.

Partitioning protects users only while the parties remain apart: it depends on their not colluding, which technical means cannot guarantee. Audited agreements, protocol requirements that make sharing harder, and further partitions reduce the risk ({{Section 5.1 of RFC9614}}).

What a party does with data it can see, such as secondary use, is largely beyond what protocols control ({{Section 5.2.3 of RFC6973}}), so users' confidence also rests on law, norms, and the commitments parties make.


# Secure

Internet protocols are designed to protect the parties to a communication from attackers external to it. Without that protection, communication that must remain confidential or unaltered, including commercial transactions, could not safely use the Internet ({{RFC1984}}). Secure protocols are also the technical basis for cybersecurity more broadly: protecting critical infrastructure and limiting fraud and other cybercrime. No central authority is responsible for security across the Internet, so protection has to be provided by the communicating parties and the protocols they use ({{Section 1 of RFC3365}}).

Protocol designers therefore assume a hostile network. An attacker positioned on the path between the parties is assumed able to read any message, and to remove, alter, or inject others, including messages that appear to originate from a trusted party ({{Section 3 of RFC3552}}). The protections that result are separable: confidentiality, integrity, and authentication. Not every application requires all three; some need integrity and authentication without confidentiality ({{Section 8 of RFC3365}}).

The environment in which a protocol will be deployed cannot be predicted, and a protocol designed for a protected environment has tended to end up in an unprotected one, by which time it is too late to add security ({{Section 6 of RFC3365}}). The IAB therefore urges that protocols be designed for confidential operation by default ({{Section 4 of RFC8558}}). Security by default also means that protection does not depend on each deployer choosing to turn it on.

Pervasive monitoring is treated as an attack, regardless of who carries it out or why. Nation states, commercial enterprises, and criminals use the same techniques, so a protocol cannot defend against some while permitting others ({{Section 1 of RFC7258}}). Monitoring for legitimate purposes, such as network management and spam filtering, is not the target, and protocol design is expected to find the balance as real cases are considered ({{Section 2 of RFC7258}}).

Protocols cannot prevent pervasive monitoring, but mitigation raises its cost, forces what was covert to be overt, or increases the likelihood of detection ({{Section 2 of RFC7258}}). In practice, mitigation has meant encrypting more of what network observers could previously read and reducing the long-term identifiers that allow a device to be tracked. It also changes who is able to observe and control traffic, which is one reason it has been contested ({{Section 3 of RFC9446}}).

Public safety, including the protection of children, and national security rely on the same secure infrastructure as everything else. The IETF takes no position on whether a given act of surveillance is justified, which is a legal and moral question ({{Section 3 of RFC2804}}, {{Section 4 of RFC2804}}), and it considers itself the wrong forum for features that address the laws of individual countries, which vary widely ({{Section 1 of RFC2804}}).

What protocols can offer is a secure baseline that works the same everywhere. A mechanism that lets a third party read protected communications without the sender's knowledge cannot also guarantee privacy against anyone else who finds or misuses it, and it lowers the security of the system even when it is never exercised ({{Section 6 of RFC2804}}). Where endpoints protect their communications, the IETF sees no engineering solution that preserves that protection and also allows interception ({{Section 1 of RFC2804}}), so investigative goals can be pursued where the information is held: at the endpoints, and through cooperation between providers and governments ({{Section 6 of RFC7754}}).

Encryption between the communicating parties provides no protection against one of them disclosing its keys or data, whether willingly or because it has been compromised ({{Section 5.1 of RFC7624}}). Whether a party merits trust is a separate question (see Trusted).


# User-Focused

Internet protocols are meant to serve the people who use them. Technical decisions afford some uses and discourage others, so they define what is possible on the Internet, and the IETF has said that it is not neutral about the Internet's purpose ({{Section 4.1 of RFC3935}}). As the Internet mediates more of society's essential functions, those decisions have social and political consequences ({{Section 1 of RFC8890}}).

Standards are not a zero-sum game, and a successful specification benefits all of the relevant parties, governments among them ({{Section 1 of RFC8890}}). The IAB has argued that where the interests of an end user conflict with those of another party, the IETF should favor the end user ({{RFC8890}}).

Here an _end user_ is a human whose activities a protocol supports, even indirectly, including people with an interest in a system they do not use directly, such as a person who appears in a photograph that the system processes, or the parent or guardian of a child using a browser ({{Section 2 of RFC8890}}).

Users deal with sellers, advertisers, network operators, and the vendors of the software they run, whose interests often differ from theirs. Clark et al. call the resulting contest the 'tussle' ({{TUSSLE}}): parties with adverse interests adapt their mechanisms, and others adapt theirs in response. No protocol ends the tussle; a design can leave room for variation in outcome, so that the contest plays out within the design ({{Section 5 of RFC7452}}). Rights can also conflict with one another, as freedom of expression and privacy can, and then have to be balanced ({{Section 1 of RFC8280}}).

Harm to users is not limited to attacks on the connection. Data collection by applications inside otherwise secure connections is a major problem, and intrusive sharing of people's data for advertising is an example of a harm that protocols alone cannot mitigate ({{Section 3 of RFC9446}}).

Because the Internet spans many jurisdictions, a decision that benefits users in one place at the cost of potential harm elsewhere is not a good trade-off. Protective measures that act at the endpoint have effects that are usually local in scope ({{Section 4.4.1 of RFC7754}}), which lets a jurisdiction protect its users without exporting the cost. The IAB's stance is to design for the worst-case environment, on the basis that a user who can be harmed probably will be, somewhere ({{Section 4.4 of RFC8890}}).

The IETF has no unique insight into what is good for end users and has to consult those affected, and {{RFC8890}} places end users above internal concerns, including architectural purity for its own sake.


# Layered

Internet protocols are layered. Each layer has a distinct responsibility and relies on the layers beneath it without depending on how they work. Because the Internet's core protocol is independent of the underlying hardware, any new transmission technology can be used to carry it ({{Section 2.2 of RFC1958}}), and the same independence applies higher up: a layer can change, and have competing implementations, as long as its interface to its neighbors holds. Modularity of this kind multiplies the design options available and disperses them, so that many parties can adopt them without the permission of a central architect ({{DESIGN-RULES}}).

Applications rely on the networks beneath them, which gives the operators of those networks some power over every service above: a network provider can block, slow, or alter a service for financial, political, operational, or criminal reasons ({{Section 4.6 of RFC9518}}). How network operators treat the traffic of the services above them therefore bears directly on competition and innovation among those services.

Interventions at a lower layer are also blunt. Many specialized applications depend on the same generic functions, such as routing and naming, so an action there to restrict one application affects every application that relies on those functions ({{Section 4.1.2 of RFC7754}}). Understanding the layers helps pursue goals such as safety or competition without unintended harm to other services, by acting at the layer, and on the party, best placed to address the problem.

Networks have often inferred information from traffic that was not intended for them, and encryption stops those inferences from working. The IAB's advice is to avoid implicit signals, and to expose information to the network only where its sender intends the network to use it ({{Section 4 of RFC8558}}).


# End-to-End

The end-to-end principle places functionality at the edges. The devices and software at each end of a communication -- the _endpoints_ -- are responsible for making it succeed, and the network between them moves the data. The principle determines whose cooperation a new service requires: a service in the endpoints can be offered by anyone who can distribute software, while one that needs the network to change requires the agreement of the operators involved ({{Section 4.1.1 of RFC3724}}). Deploying without asking network operators is permissionless innovation in practice.

Goals such as safety and competition can be pursued at the applications and devices without giving up the innovation and user control that the principle protects, because the network stays free for new services.

The principle has a technical basis: some functions can be performed correctly only by the endpoints, and the network can at best help ({{Section 2.1 of RFC3724}}). The same reasoning keeps information about a conversation in the endpoints, so that it is lost only if an endpoint itself fails (_fate-sharing_), and conversations survive partial network failures ({{Section 2.3 of RFC1958}}).

The principle has never been absolute, because parties in the middle have reasons to be there, some more benign than others ({{Section 3 of RFC3724}}). Some of these conflicts cannot be settled technically. They involve social and legal choices that standards bodies are not empowered to make, and they play out on the architecture that results ({{Section 5 of RFC3724}}).

A service in the network is consistent with the principle when the endpoints are aware of it and involved where the service needs them to be, and it is for the endpoints to decide which third parties to trust ({{Section 4.2 of RFC3724}}, {{Section 3.1 of RFC3724}}). The same logic applies to controls on content: where filtering is done at all, the endpoint is the least damaging place for it, although that depends on the endpoint's cooperation ({{Section 4.4.6 of RFC7754}}). Measures that protect children, such as filtering and parental controls, are among those that can act at the endpoint.


# Interoperable

Internet protocols are _interoperable_: systems built and run by different parties work together because they follow shared specifications, with no one coordinating or approving each combination. Interoperability is what makes openness usable. Anyone can build a new browser, mail server, or application and have it work with what already exists, and users can move to another product or provider when one fails them. Without that ability, users cannot exercise choice or fully realize the value of their efforts ({{Section 4.4 of RFC9518}}).

New implementations are key to a protocol's continued viability, and are often where new capabilities originate, so a protocol that is costly to implement for the first time loses a source of improvement ({{Section 4.2 of RFC9413}}).

A specification alone does not provide interoperability. Specifications are never perfect, so deployed software meets cases they did not anticipate, and the long-standing practice (the 'robustness principle') has been for software to tolerate them. Tolerated faults become the practice that later products must copy, and the cost of compatibility accumulates and falls on newcomers, which erodes the openness that interoperability exists to serve.

The alternative to tolerating faults is continued maintenance, in which specification and software are corrected together as problems surface. Maintenance depends on deployed software being updatable, and it sometimes means excluding products that will not change, a choice that should be deliberate ({{RFC9413}}).

Interoperability serves competition, consumer choice, and resilience. It is increasingly proposed as a remedy for concentration, and it delivers when a specification is precise enough for products to replace one another, more than one party implements it, and a community maintains it as problems surface. Standards bodies can supply those conditions, and liaison with those who set policy helps it deliver what is expected of it ({{Section 4.3 of RFC9518}}).

Extensibility lets a protocol outlive its designers' foresight ({{Section 2.2.1 of RFC5218}}), but each extension point is also a place where compatibility can break and where control can be captured. The flexibility of SOAP, a Web services framework, combined with its lack of standalone value, allowed vendors to require their preferred extensions, favoring those with the most market power ({{Section 4.7 of RFC9518}}). A standard also has to be precise enough for products to replace one another, but if it grows so complex that a complete implementation is prohibitively costly, few will attempt one, as with Web browsers ({{Section 4.4 of RFC9518}}).


# Evolvable

Protocols have to change while they are in use, because the Internet cannot be stopped and upgraded. No party can list everyone who participates in it, so no party can coordinate a change across all of them; changes have to be deployable by some participants without breaking the others. Protocols that can be deployed piecemeal and remain compatible with older software have a better chance of success than those that need everyone to change at once ({{Section 2.1.2 of RFC5218}}). Such flag days are possible but costly ({{Section 3.5 of RFC9170}}).

In HTTP, clients and servers generally ignore the header fields -- labeled items of information attached to a message -- that they do not understand, so new ones can be deployed without waiting for the rest of the Internet ({{Section 3.4 of RFC9170}}).

The ability to change has to be kept in use. Extension and version-negotiation mechanisms that go unexercised tend to fail when they are needed, and a protocol whose installed base mishandles anything new is said to have _ossified_ ({{RFC9170}}).

Parties in the middle of a communication can prevent change, deliberately or not: devices that apply policies prohibiting unknown capabilities make new features unusable on the paths through them, and encryption reduces the number of parties able to influence whether a feature can be used ({{Section 2 of RFC9170}}, {{Section 4.3 of RFC9170}}). Where the network has a legitimate need for information, such as for network management, an explicit signal that the endpoints choose to send (see Layered) can meet it without freezing the protocol.

Goals such as keeping users secure and critical infrastructure current depend on protocols being able to change, and on changes being adopted. Adoption depends on incentives as well as design: transitions are easiest when the benefits accrue to those who bear the costs, a condition that policy-making bodies can help bring about ({{Section 1 of RFC8170}}).

Change also depends on deployed software being updatable, which is how security fixes and every later improvement reach users ({{Section 3 of RFC9413}}). For connected devices this makes updatability a consumer protection matter, since a solid software update mechanism is needed to fix security bugs ({{Section 5 of RFC7452}}).




--- back

