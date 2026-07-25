# safr-platform (Agent Skill)

Source-grounded knowledge package for **SAFR** (RealNetworks) covering the on-premises
SAFR Server, SAFR SCAN readers, the SAFR Web API, and Genetec Security Center integration.

Built from vendor documentation retrieved 2026-07-24 from `docs.real.com/safr/`.

## Layout

| Path | Purpose |
|---|---|
| `SKILL.md` | Router. Frontmatter trigger, quick facts, decision table, top-5 triage flows. |
| `references/` | Dense topic files. Every section carries source IDs (S1...Sn). |
| `scripts/` | Read-only health checks built from verbatim documented commands. |
| `sources.md` | Source inventory with doc version and retrieval date. |
| `known-gaps.md` | What the docs do not answer, plus gated sources. |

## Conventions

- Every factual claim traces to a source ID recorded in `sources.md`.
- Statements marked `[INFERRED - verify]` are high-confidence but unverified.
- Where documentation is silent the text says **Not documented** rather than guessing.
- Exact strings (paths, service names, ports, config keys, commands, error text) are verbatim.

## Caution

SAFR documentation sits behind vendor sign-in and at least one page returns a
U.S. export-control access wall. Keep this repository private.
