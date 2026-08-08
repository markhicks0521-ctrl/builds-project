*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# 12oz Can Koozie

**Designed in:** Autodesk Fusion 360, via the Fusion MCP connector (Claude Code + Claude desktop app talking directly to a live Fusion session)

**Fusion file:** "HC - 12oz - Can Koozie" (saved in Fusion's own cloud storage, not this repo — repo holds exported STL only)

## Current geometry
- Inner diameter: 68mm (66mm standard 12oz can + 1mm clearance — unverified, may need tuning after fit test)
- Wall thickness: 3mm
- Height: 100mm
- Material: rigid PLA (not TPU/flexible) — solid wall, snug fit, no lattice/stretch design
- Bottom: solid disc with 30mm finger-access hole (both edges rounded, ~0.8mm fillet)
- Top and bottom outer rim edges: rounded, 1mm fillet
- Text: "Hicks Creations" engraved (indented) around the front, Englebert font (Google Font, installed as system font for Fusion to reference)
- Dimple grip texture: 87→126 circular indents (1.5mm radius, 0.6mm deep) across 3 wrap zones (~92° coverage each, spaced 120° apart around the circumference)

## Known issues (unresolved as of this session)
- **Dimple coverage has gaps.** The 3 wrap zones don't fully overlap (each covers ~92° of the required ~120°), leaving blank strips between them, including most of the back.
- **Sliver/degenerate mesh artifacts near the bottom rim.** Confirmed via Fusion API inspection: 201 tiny sliver faces clustered at the outer edge (y≈±3 range boundary) of the dimple wrap zones, specifically in the row closest to the bottom (10mm up). Visible as jagged artifacts in both Fusion's viewport and Bambu Studio's slice preview, in two localized spots matching the wrap-zone boundaries. Confirmed NOT a broken-feature error (0 timeline warnings/errors) — it's valid but ugly geometry from wrap distortion at the edge of each flat-sketch-to-cylinder projection.
- **Root cause:** Fusion's Emboss feature wraps a flat sketch profile onto a curved face. This works cleanly near the center of each wrap zone but produces messy/sliver geometry near the edges of the zone as angular distortion increases. Wider zones (attempted at ±5cm y-range to close gaps) failed outright — 110 of 168 attempted embosses returned a "Reference Failures" warning and produced no cut at all, despite the API call reporting success with no exception thrown. This is a real Fusion API gotcha: emboss.add() can silently create a broken/warning-state feature without raising a Python error.

## Fixes identified for next session
1. Use MORE wrap zones with NARROWER individual coverage (e.g. 6 planes at 60° spacing, each covering ~70-80°) instead of fewer wide zones — keeps every wrap comfortably within its reliable range and closes coverage gaps without the failure risk of stretching zones wider.
2. Pull dimple y-range in from ±3 to ±2.5 to stay clear of each zone's distortion-prone outer edge.
3. Skip the dimple row closest to the bottom rim (currently 10mm up) — keep more buffer from the rounded edge.
4. When batch-embossing multiple profiles in one API call, Fusion throws "Input profiles are not coplanar" even for genuinely coplanar profiles once more than ~1 profile is passed at a time. Workaround: emboss profiles one at a time in a loop, re-fetching the face reference fresh each iteration (fresh model state after each recompute). ALWAYS use the loop index (not a hardcoded item(0)) when iterating — a hardcoded-index bug caused 87 wasted duplicate-cut calls on the same profile in this session.
5. When cleaning up a mistake, use design.timeline rollTo() then DELETE all rolled-back items afterward via entity.deleteMe() — rollTo() alone does NOT delete anything, it just marks items as rolled-back while they remain in the timeline (discovered the hard way — caused a 193-item bloated timeline that appears to have triggered an MCP connector hang requiring a full Fusion + Claude desktop restart).
6. Not yet built: literal "lips" grip texture (kiss-mark shape) — first attempt via hand-coded spline points produced an unrecognizable blob and was abandoned for time. Needs either more careful point-plotting or a different construction method (e.g. import a 2D profile from an SVG/DXF instead of hand-coding spline points).
7. Not yet built: multi-body color separation (text as one body, dimple/spot groups as separate bodies) for no-paint multi-filament printing — requested for a future leopard-print or grouped-color version, out of scope for tonight's single-material fitment prototype.

## Print history
- This session — First prototype printing in PLA on the Bambu P2S (still in progress as of session end). Purpose: fitment check only. Fit result: TBD, pending print completion. Cosmetic issues present (see Known Issues above) but do not block fitment testing.
