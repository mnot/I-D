---
title: Cache Digests for HTTP/2
abbrev:
docname: draft-kazuho-h2-cache-digest-00
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
    ins: K. Oku
    name: Kazuho Oku
    organization: DeNA Co, Ltd.
    email: kazuhooku@gmail.com

 -
    ins: M. Nottingham
    name: Mark Nottingham
    organization: 
    email: mnot@mnot.net
    uri: https://www.mnot.net/

normative:
  RFC2119:
  RFC3986:
  RFC6234:
  RFC6454:
  RFC7230:
  RFC7232:
  RFC7234:
  RFC7540:

informative:
  RFC6265:


--- abstract

This specification defines a HTTP/2 frame type to allow clients to inform the server of their
cache's contents. Servers can then use this to inform their choices of what to push to clients.


--- note_Note_to_Readers

The issues list for this draft can be found at <https://github.com/mnot/I-D/labels/h2-cache-digest>.

The most recent (often, unpublished) draft is at <https://mnot.github.io/I-D/h2-cache-digest/>.

Recent changes are listed at <https://github.com/mnot/I-D/commits/gh-pages/h2-cache-digest>.


--- middle

# Introduction

HTTP/2 {{RFC7540}} allows a server to "push" synthetic request/response pairs into a client's cache
optimistically. While there is strong interest in using this facility to improve perceived Web
browsing performance, it is sometimes counterproductive because the client might already have
cached the "pushed" response.

When this is the case, the bandwidth used to "push" the response is effectively wasted, and
represents opportunity cost, because it could be used by other, more relevant responses. HTTP/2
allows a stream to be cancelled by a client using a RST_STREAM frame in this situation, but there
is still at least one round trip of potentially wasted capacity even then.

This specification defines a HTTP/2 frame type to allow clients to inform the server of their
cache's contents using a Golumb-Rice Coded Set. Servers can then use this to inform their choices
of what to push to clients.


## Notational Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT",
"RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.


# The CACHE_DIGEST Frame

The CACHE_DIGEST frame type is 0xf1. NOTE: This is an experimental value; if standardised, a
permanent value will be assigned.

A CACHE_DIGEST frame can be sent from a client to a server on any stream in the "open" state, and
conveys a digest of the contents of the client's cache for associated stream.

CACHE_DIGEST MUST NOT include cached responses whose URLs do not share origins {{RFC6454}} with the
request of the stream that the frame is sent upon.

A client MAY choose a subset of the suitable stored responses to include in a CACHE_DIGEST
frame.

In typical use, a client will send one or more CACHE_DIGESTs immediately after the first request on
a connection for a given origin, on the same stream, because there is usually a short period of
inactivity then, and servers can benefit most when they understand the state of the cache before
they begin pushing associated assets (e.g., CSS, JavaScript and images).

Clients MAY send CACHE_DIGEST at other times, but servers ought not expect frequent updates;
instead, if they wish to continue to utilise the digest, they will need to remember responses
sent to that client on the connection, using that knowledge in conjunction with it.

Servers MAY use all CACHE_DIGESTS received for a given origin as current, as long as they do not
have the RESET flag set; a CACHE_DIGEST frame with the RESET flag set MUST clear any previously
stored CACHE_DIGESTs for its origin. Servers MUST treat an empty Digest-Value with a RESET flag set
as effectively clearing all stored digests for that origin.

A client can indicate what responses it has fresh in cache by sending one or more CACHE_DIGESTs
with the STALE flag unset. when all such CACHE_DIGESTs sent since the start of the connection (or
the last CACHE_DIGEST of any kind with a RESET flag) represent the complete state of fresh cached
responses for the origin, the client SHOULD indicate that with the COMPLETE flag on the last STALE
CACHE_DIGEST. Note that this does not need to include any responses cached since the beginning of
the connection or sending of the RESET flag, as appropriate.

Likewise, a client can indicate what responses it has stale in cache by sending one or more
CACHE_DIGESTs with the STALE flag set. When all such CACHE_DIGESTs sent since the start of the
connection (or since the last CACHE_DIGEST of any kind with a RESET flag) represent the complete
state of stale cached responses for the origin, the client SHOULD indicate that with the COMPLETE
flag on the last STALE CACHE_DIGEST, with the same caveats as above.

CACHE_DIGEST can be computed to include cached responses' ETags, as indicated by the VALIDATORS
flag. This information can be used by servers to decide what kinds of responses to push to clients;
for example, a stale response that hasn't changed could be refreshed with a 304 (Not Modified)
response; one that has changed can be replaced with a 200 (OK) response, whether the cached
response was fresh or stale.

CACHE_DIGEST has no defined meaning when sent from servers to clients, and MAY be ignored.

~~~~
+-----------------------------------------------+
|              Digest-Value? (\*)              ...
+-----------------------------------------------+
~~~~

The CACHE_DIGEST frame payload has the following fields:

* **Digest-Value**: A sequence of octets containing the digest as computed in {{computing}}.

The CACHE_DIGEST frame defines the following flags:

* **RESET** (0x1): When set, indicates that any and all cache digests for the applicable origin held by the recipient MUST be considered invalid.

* **COMPLETE** (0x2): When set, indicates that the currently valid set of cache digests held by the server constitutes a complete representation of the cache's state regarding that origin, for the type of cached response indicated by the `STALE` flag.

* **VALIDATORS** (0x3): When set, indicates that the `validators` boolean in {{computing}} is true.

* **STALE** (0x4): When set, indicates that all cached responses represented in the digest-value are stale {{RFC7234}} at the point in them that the digest was generated; otherwise, all are fresh.


## Computing the Digest-Value {#computing}

Given the following inputs:

* `validators`, a boolean indicating whether validators ({{RFC7232}}) are to be included in the digest;
* `URLs'`, an array of (string `URL`, string `ETag`) tuples, each corresponding to the Effective Request URI ({{RFC7230}}, Section 5.5) of a cached response {{RFC7234}} and its entity-tag {{RFC7232}} (if `validators` is true and if the ETag is available; otherwise, null);
* `P`, an integer that MUST be a power of 2 smaller than 2\*\*32, that indicates the probability of a false positive that is acceptable, expressed as `1/P`.

`digest-value` can be computed using the following algorithm:

1. Let N be the count of `URLs`' members, rounded up to power of 2.  If N is greater than 2\*\*32, then round N to the nearest power of 2 smaller than 2\*\*32.
2. Let `hash-values` be an empty array of integers.
3. Append 0 to `hash-values`.
4. For each (`URL`, `ETag`) in `URLs`:
    1. Let `key` be `URL` converted to an ASCII string by percent-encoding as appropriate {{RFC3986}}.
    2. If `validators` is true and `ETag` is not null:
       1. Append `ETag` to `key` as an ASCII string, including both the `weak` indicator (if present) and double quotes, as per {{RFC7232}} Section 2.3.
    3. Let `hash` be the SHA-256 message digest {{RFC6234}} of `key`, expressed as an integer.
    4. Truncate `hash` to log2( `N` \* `P` ) bits.
    5. Append `hash` to `hash-values`.
5. Sort `hash-values` in ascending order.
6. Let `digest-value` be an empty array of bits.
7. Write log base 2 of `N` to `digest-value` using 5 bits.
8. Write log base 2 of `P` to `digest-value` using 5 bits.
9. For each `V` in `hash-values`:
    1. Let `W` be the value following `V` in `hash-values`.
    2. If `W` and `V` are equal, continue to the next `V`.
    3. Let `D` be the result of `W - V - 1`.
    4. Let `Q` be the integer result of `D / P`.
    5. Let `R` be the result of `D modulo P`.
    6. Write `Q` '0' bits to `digest-value`.
    7. Write 1 '1' bit to `digest-value`.
    8. Write `R` to `digest-value` as binary, using log2(P) bits.
    9. If `V` is the second-to-last member of `hash-values`, stop iterating through `hash-values` and continue to the next step.
10. If the length of `digest-value` is not a multiple of 8, pad it with 1s until it is.



# IANA Considerations

This draft currently has no requirements for IANA. If the CACHE_DIGEST frame is standardised, it
will need to be assigned a frame type.

# Security Considerations

The contents of a User Agent's cache can be used to re-identify or "fingerprint" the user over
time, even when other identifiers (e.g., Cookies {{RFC6265}}) are cleared. 

CACHE_DIGEST allows such cache-based fingerprinting to become passive, since it allows the server
to discover the state of the client's cache without any visible change in server behaviour.

As a result, clients MUST mitigate for this threat when the user attempts to remove identifiers
(e.g., "clearing cookies"). This could be achieved in a number of ways; for example: by clearing
the cache, by changing one or both of N and P, or by adding new, synthetic entries to the digest to
change its contents.

TODO: discuss how effective the suggested mitigations actually would be.

Additionally, User Agents SHOULD NOT send CACHE_DIGEST when in "privacy mode."


--- back


# Acknowledgements

Thanks to Adam Langley and Giovanni Bajo for their explorations of Golumb-coded sets. In
particular, see
<http://giovanni.bajo.it/post/47119962313/golomb-coded-sets-smaller-than-bloom-filters>, which
refers to sample code.

Thanks to Stefan Eissing for his suggestions.
