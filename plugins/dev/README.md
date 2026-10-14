# dev

Standards for building apps with Claude Code. The skills carry rules, not designs: what is
decided before the first line of code, where a fact lives, how a shell behaves, which states
every screen owes its user. Colours, type and brand stay free in all of them.

Three modes run through most skills: **Kickoff** (a new app or area), **Build** (a feature
inside an existing one) and **Audit** (checking an app or taking over a codebase). Detail rules
live in `references/` next to each `SKILL.md` and are loaded one at a time, so only what the
current topic needs lands in context.

The generated look of pages and copy is handled by `starter:remove-ai-tells`, which this plugin
points to. Install `starter` from the same marketplace.

## Skills

### app-blueprint

The blueprint for any web app with a database, roles and foreign systems. Kickoff walks through
eight decision blocks (users and their daily path, vocabulary, entities and process model,
roles, numbers, foreign systems, environments and release gate, design system and checkers).
Build holds ten core rules and a fixed completion report that names environment, state and
what was left out. Audit produces a findings list with a target state per finding.

| File | Content |
|---|---|
| `kickoff.md` | The eight decision blocks in order |
| `data-and-truth.md` | One source of truth: pick lists as master data, thresholds as settings, provenance and history of every number, loosely coupled modules |
| `foreign-systems.md` | One door per foreign system, read-only, with an inventory; writes, notifications and costs need a release |
| `feature-done.md` | From requirement to completion report: acceptance criteria, only what was asked, the fields of "done", an end-to-end walk over the user's path |
| `working-mode.md` | Release gate, branches and worktrees, several agents in one repository, status and explanations |
| `audit.md` | Audit areas with search patterns and the report form |

### data-app-ui

The shell and behaviour of an internal data app: a tool in which people read, filter and edit
records under roles. Left sidebar; a top bar with the path derived from the route pattern; a
record opens in a right-docked, resizable panel over the list (the list stays visible and
clickable) and always has a page of its own; creating and confirming share one centred dialog;
filters apply live; tables scroll virtually without pagination; loading shows progress, not a
skeleton; save is gated on dirty. Twelve laws, a numbers table and a decision table for where
a thing opens (panel, dialog, page, inline, tab).

| File | Content |
|---|---|
| `shell.md` | Regions, one navigation taxonomy feeding sidebar, path and palette, path derivation, page head, the one way back |
| `panel.md` | Geometry and handle of the right panel, anatomy, open/switch/close, panel and page from the same blocks |
| `toolbar.md` | The top bar writes, the control row filters; order of the control row, filter menu with chips, sort menu, view state |
| `writes.md` | One dialog shell for create and confirm, section editing with a dirty gate, instant writers, server validation, feedback |
| `data.md` | Virtual table, number format per unit, KPI tiles, the five states, three kinds of empty, directing attention |
| `page-types.md` | Six page forms and the question that selects one |
| `audit.md` | Audit order, search patterns per law, click-through plan, report form |

### desktop-shell and mobile-shell

Two skills for the shell of a consumer app or PWA: the desktop shell on a laptop and the phone
shell on top of it. Data apps follow `data-app-ui` instead; the two shells decide panel,
confirmation and loading state differently on purpose, and one app follows one of the two.
`desktop-shell` carries everything both consumer shells share, `mobile-shell` adds the phone
layer without repeating it. Both are framework-neutral and brand-free. Every rule goes back to
a mistake agents made without the skills: overlapping page transitions, a page following the
finger, a toast as the success signal, a z-index ladder per overlay, a desktop decided by a
template conditional.

**desktop-shell**: a framed canvas with one scroll surface and three widths (phone, rail,
wide sidebar) in one DOM; navigation from one source; the drawer as editing surface; the
shared laws: layers as tokens, page transitions out-then-in, only transform and opacity, one
easing, an overlay stack with an inline confirmation, perceived speed, a data layer that is
cache-first with live updates, a token file with guard tests, at most one frame between screen
edge and content, and the way in that every app brings from kickoff (sign-in and invitation in
front of a quiet scene, a short tour through the real app).

| File | Content |
|---|---|
| `layout.md` | Desktop regions, framed canvas, three widths, navigation from one source, drawer and modal, lists as tables |
| `motion.md` | Durations and easing, page transitions, stagger, tap feedback, reduced motion |
| `sheets.md` | One sheet component (panel/drawer), overlay stack, scroll lock, busy lock, confirming, feedback without toast |
| `speed.md` | Optimistic marking, skeleton after 300 ms, prefetching neighbours, revisit, scroll restoration, data and speed (cache tiers, live refetch, mutation bus, autosave) |
| `surfaces.md` | One frame between edge and content: group, card, tile, tree |
| `tokens.md` | Token namespaces, script mirror, responsive layout tokens, guard tests |
| `controls.md` | Buttons, chips, fields, badges and icons from shared pieces in three radii |
| `entrance.md` | Sign-in and invitation with a scene behind them, the first-run tour through the real app |
| `audit.md` | Search patterns per law and the click-through plan at desktop width |

**mobile-shell**: a stage, the header as its backdrop, the content card over it, a full-width
tab bar with a gliding marker, bottom sheets that follow the finger, a swipe that climbs a
level before it changes area, pull-to-refresh, the installed-app shell, and the phone version
of the way in.

| File | Content |
|---|---|
| `layout.md` | The contract "one DOM, switched by CSS at the breakpoint", phone regions, tab bar and marker, bottom sheet detents, lists as rows |
| `gestures.md` | The area swipe as an algorithm, dragging a sheet, pull-to-refresh |
| `pwa.md` | Viewport meta without a zoom ban, safe areas, service worker, update, prompts |
| `audit.md` | Phone search patterns and a click-through with touch emulation |

### good-ux

State coverage for data-driven interfaces. Every region of a page owes the user five states:
loading, empty, partial, error, success. Added to that: honest forms, progressive disclosure,
safe actions, consistency through reused components and minimum rules for touch. In Build
mode it is a reference; in Audit mode it produces a state matrix per region and a gap list
sorted by severity.

| File | Content |
|---|---|
| `loading-states.md` | Fast data without an indicator; skeleton, progress bar, inline spinner or optimistic UI only after a noticeable wait |
| `empty-states.md` | First use, unused section, empty search result, emptiness as the goal |
| `partial-states.md` | Graceful degradation, independent boundaries |
| `error-states.md` | Toast, modal or inline by severity, plus the wording of the message |
| `success-states.md` | Confirmation scales with the weight of the action |
| `forms.md` | Six rules against form frustration |
| `progressive-disclosure.md` | Show options as needed without hiding core functions |
| `actions.md` | Hover as information, undo and back navigation, type-to-confirm for risky actions |
| `consistency.md` | One thing, one look, one behaviour; the ladder from reuse to a special component |

Based on the series "building with good UX" by Katherine Gilligan (@synsation_), parts 2, 3,
6, 7, 8, 9, 11 and 15, extended with common frontend practice (actions, consistency, touch).

### chart-design and data-storytelling

Two skills for charts and data stories, distilled from the redesigns, critiques and videos of
Chartosaur (chartosaur.com). Both are tool-neutral: they decide what a chart does, not what
draws it. Every rule in the main text goes back to a decision an agent without the skill made
differently or inconsistently; what a capable model does anyway (zero baseline, grey for
context, labels instead of a legend) is left out.

**chart-design** applies when choosing a chart form and when judging or rebuilding a chart, a
heatmap, a KPI tile or a dashboard: one job and one audience, the answer on the chart instead
of in the reader's head, colour rules, encodings that cost trust, and a title checked against
the marks plus the mandatory line measure · period · n · source · exclusions.

| File | Content |
|---|---|
| `patterns.md` | Constructions with a selection predicate: Likert stacks, anchor bars, heatmaps with margin sums, small multiples, waffle instead of pie, beeswarm, dumbbell, stacks with a net line, histogram bins, hexbin, sparklines |
| `dashboards.md` | Context per number, layout along the users' workflow, checks before publishing |

**data-storytelling** applies when deciding what a chart, slide or report claims, and before
anyone reacts to a dip in a metric: four answers before drawing, the rule for a wanted but
uncovered headline, the formula "visual cue plus statement title", and the seven explanations a
dip has to survive before it is a signal.
