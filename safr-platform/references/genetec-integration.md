# SAFR and Genetec Security Center Integration

## 1. Scope note - read before answering Genetec questions

There are **five separate Genetec integration guides**, and they describe genuinely different integrations. Picking the wrong one is the most common source of wrong answers. [S39] [S40] [S41] [S42] [S43]

| # | Guide | What it integrates | Source |
|---|---|---|---|
| 1 | Genetec Cardholder Integration Guide | Cardholder records in Genetec Synergis synchronised with the SAFR Person Directory. Includes Synergis operation, federated systems, and a troubleshooting chapter | [S39] |
| 2 | Genetec SaaS Cardholder Integration Guide | The same cardholder concept against **Genetec SaaS** rather than on-prem Security Center | [S40] |
| 3 | Genetec RIO Integration Guide | Restricted Input/Output integration | [S41] |
| 4 | Genetec Security Center Camera Integration Guide | SAFR consuming **Genetec-managed cameras** as video sources | [S42] |
| 5 | Genetec Security Center SAFR Camera Integration Guide | **SAFR Camera** presented into Genetec Security Center | [S43] |

Disambiguating question to ask the user: *are you syncing people, or moving video?* Guides 1, 2 and 3 are identity/access; guides 4 and 5 are video.

## 2. Installer plugin flags

Genetec support is a VMS plugin selected at SAFR Platform install time. Both are **Disabled by default**. [S5]

| Plugin | Flag |
|---|---|
| Genetec | `/Genetec` |
| GenetecFR | `/GenetecFR` |

**Only one VMS plugin is allowed - the first specified plugin will be used.** [S5] A single SAFR Server therefore cannot run `/Genetec` and `/GenetecFR` simultaneously, nor Genetec alongside Milestone, Avigilon, Digifort, Geutebrueck or Video Insight.

Which of the five integration scenarios maps to `/Genetec` versus `/GenetecFR` is **Not documented**. Do not guess - confirm with the vendor. Logged in `known-gaps.md`.

## 3. Genetec licence part numbers

The Genetec-side SDK certificate part number appears in the guides with **four different casings and suffixes**. All four are reproduced verbatim because a part number typed with the wrong casing will be rejected by a Genetec order desk. [S39] [S40] [S41] [S42] [S43]

| Verbatim string |
|---|
| `GSC-1SDK-RealN-FR1` |
| `GSC-1SDK-REALN-FR` |
| `GSC-1SDk-RealN-FR` |
| `GSC-1SDK-RealN-FaceRec` |

These are almost certainly the same SKU rendered inconsistently. `GSC-1SDk-RealN-FR` contains a lower-case `k` mid-acronym, which is clearly a typo. Ask Genetec to confirm the canonical part number before quoting. [INFERRED - verify]

## 4. Minimum SAFR versions

| Requirement | Stated in |
|---|---|
| SAFR **3.28+** | Cardholder, SaaS Cardholder, and RIO guides [S39] [S40] [S41] |
| SAFR **3.6+** | SAFR Camera integration guide and API-related integration text [S42] [S43] |

The 3.6 figure is older than 3.28 in SAFR's numbering (3.6 < 3.28), so the two floors are not contradictory, but the 3.6 reference is likely stale. On a modern on-prem build both are satisfied. Treat **3.28** as the effective floor for the identity-side integrations. [INFERRED - verify]

## 5. Image and face-size requirements - conflicting figures

This is the most consequential documentation conflict in the Genetec set, because it determines whether enrolment photos are accepted.

| Figure | Value | Where |
|---|---|---|
| Maximum cardholder image size | **200KB** | Cardholder Integration Guide [S39] |
| Maximum image size | **128k** | Security Center Camera Integration Guide [S42] |
| Minimum face width, camera placement | **80 px** | Security Center Camera Integration Guide [S42] |
| Minimum face width, SCAN enrolment and troubleshooting | **150 px** | SCAN guides [S46] |
| Target face width, ear to ear | **220 px** | SCAN reader documentation [S44] |

Practical guidance: size enrolment images to the **most restrictive** figure that applies to your path - 128k where the camera guide governs, 200KB where the cardholder guide governs - and aim for the **largest** face-pixel figure you can achieve, since 220 px satisfies all three thresholds. Never quote a single number as *the* SAFR requirement. All five figures logged in `known-gaps.md`.

## 6. External identity host

The Genetec guides describe **Genetec** and **Genetec SaaS** appearing as External identity host options for external identity synchronisation. [S39] [S40]

The Web Console Status page documentation, however, lists only **two** possible values for External identity host: `AMAG` and `Software House`. [S14]

Resolution: the Status page documentation is stale. Trust the Genetec guides for Genetec, and expect the live Web Console to offer more options than its own documentation lists. See `configuration.md` section 7.

## 7. Camera GUID carried on the back-channel property

The Genetec camera integration reuses the VIRGO feed property `input.back-channel.type` to carry the **Genetec camera GUID**. [S42] [S23]

This matters because `input.back-channel.type` is documented in the VIRGO Video Feeds Properties reference as a **Mobotix-specific** property. [S23] Anyone reading the VIRGO reference alone will conclude the property is irrelevant to Genetec and may strip it from a feed definition, breaking the integration.

If a Genetec-sourced feed stops associating events with the correct camera, check that this property still carries the GUID. [INFERRED - verify]

## 8. Cardholder integration structure

The Cardholder Integration Guide is organised as a main page plus three sub-pages. [S39]

| Sub-page | Covers |
|---|---|
| Synergis Operation | Day-to-day operation against Genetec Synergis |
| Federated Systems | Behaviour across federated Genetec systems |
| Troubleshooting | Genetec-specific fault isolation |

### Federation caveat

In a federated Genetec deployment, a SAFR Server pointed at a **Federation Host** does not receive incremental cardholder updates the way it does from a directly attached system. Point SAFR at the system that owns the cardholder records rather than at the federation layer. [S39] [INFERRED - verify the exact wording in the guide before relying on this for design]

## 9. Known documentation defects in the Genetec guides

All logged in `known-gaps.md`. They matter because following the text literally will fail.

| Defect | Detail |
|---|---|
| Broken cross-references | The Cardholder guide contains `Error! Reference source not found.` and a dangling reference to `section 1.2.2.1` [S39] |
| Contradictory template name | Cardholder guide section 1.6.1 step 3 says to use the **Supervisor** template, while the introductory text says **Provisioning** or **Administrator** [S39] |
| Garbled headings | RIO guide section 2.8 has malformed headings [S41] |
| Unverifiable UI path | The RIO guide references **Authentication Mode > Facial Recognition** within Genetec Access Rules; this path could not be verified against any other source [S41] |
| Malformed diagnostic command | The troubleshooting text prints `telnet 10.124.14.20 telnet`, where the second `telnet` should be a port number [S39] |

### Corrected telnet check

The intended command is a TCP reachability test. Substitute the real port - use `portcheck` output or the service table in `configuration.md`:

```
telnet 10.124.14.20 8081
```

`8081` is the documented CoVi HTTP port. [S14] [S26] Confirm the actual port for your deployment first. [INFERRED - verify]

## 10. Genetec troubleshooting entry points

| Symptom | Where to start |
|---|---|
| Cardholders not syncing | Cardholder guide troubleshooting sub-page [S39]; check External identity host config in `configuration.md` section 7; check `cv-event\logs\sync.log` [S3] |
| Sync works one way only | Identity sync is bidirectional unless *Only sync from host but not back to host* is enabled [S14] |
| Video feed from Genetec camera fails | `virgo service monitor` Status column, then `troubleshooting.md` sections 8 to 13 [S19] |
| Events not reaching Genetec | CVEV long-poll pattern in `api-integration.md` section 7 |
| Plugin appears absent | Confirm the server was installed with `/Genetec` or `/GenetecFR`; only one VMS plugin can be active [S5] |
| Licence rejected | Verify the Genetec SDK part number casing, section 3 above |

## 11. Ports

The Genetec guides do not publish a port table, and neither does the rest of the SAFR documentation set. Use `portcheck` on the SAFR side and Genetec's own documentation on theirs. See `network-ports.md`. **Do not supply a Genetec-side port number from memory.**

## 12. Coverage honesty statement

This file records the cross-cutting facts, version floors, part numbers, conflicts and defects verified across all five guides. It deliberately does **not** reproduce the step-by-step click paths, because those run to many pages and are best read from the vendor guides directly at:

```
docs.real.com/safr/access/integrations/genetec/
docs.real.com/safr/video/software/integrations/genetec/
```

When a user needs a procedure, send them to the specific guide named in section 1 rather than paraphrasing it.
