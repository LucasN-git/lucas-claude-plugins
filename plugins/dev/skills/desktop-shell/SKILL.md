---
name: desktop-shell
description: Use when a consumer web app or PWA gets or has a desktop shell (sidebar, top bar, panels, page transitions) or styles a button, chip, field, card, icon or focus - /dev:desktop-shell
---

# Desktop shell

The shell of a consumer app on a laptop; the phone shell sits on top (`dev:mobile-shell`). A data app (internal tool, records, roles) follows `dev:data-app-ui` instead, which decides panels, confirmation and loading differently on purpose; one app follows one of the two. This skill carries the desktop shell and everything both consumer shells share: layers, motion, overlays, surfaces, perceived speed and data, tokens and their guards. Colours, type and brand are not in it.

Data, roles, foreign systems and the completion report belong to `dev:app-blueprint`; interface states, forms, undo and tap targets to `dev:good-ux`; the generated look to `starter:remove-ai-tells`.

## Three modes

| Mode | When | Read |
|---|---|---|
| **Kickoff** | A new app, or the first shell for an existing one | `references/layout.md`, `references/tokens.md`, `references/entrance.md`; questions below |
| **Build** | A feature inside an existing shell | the laws below, plus the reference whose topic is in play |
| **Audit** | "Check this app", or taking over a codebase | `references/audit.md` |

References by topic, each read when its topic is in play:

- `references/layout.md` when navigation, the sidebar, the frame, the top bar or a list changes.
- `references/surfaces.md` when a card, group, tile, tree or list frame is placed on a page.
- `references/motion.md` when anything moves, appears or disappears.
- `references/sheets.md` when a detail, form or confirmation opens over the page, or an action needs feedback.
- `references/speed.md` when a navigation or fetch can take longer than a blink, or data is cached, refreshed live, saved or deleted.
- `references/controls.md` when a button, chip, field, badge or icon is added or styled.
- `references/entrance.md` when sign-in, an invitation or the first-run introduction is built or changed.

When the app also has a phone shell, `dev:mobile-shell` adds its laws on top of these; it never replaces them.

## The laws

1. **One shell, one navigation source, at most five areas, one scroll surface.** Phone, tablet and desktop are one DOM split by CSS: one threshold separates phone from sidebar chrome, a second may only switch the sidebar between rail and wide. A viewport conditional in the template is a server/client mismatch (`dev:mobile-shell` holds the contract). (`layout.md`)
2. **Layers are named tokens with gaps.** A feature never adds a z-index: anything modal (drawer, sheet, confirm) joins the sheet layer, a non-modal popover the overlay layer, and a stack decides who is on top within each. (`tokens.md`, `sheets.md`)
3. **The old page leaves, then the new one arrives.** No crossfade, no two pages on screen, no direction. Enter is fade plus rise; a revisit is shorter and flatter (revisit values in the table). (`motion.md`)
4. **Only transform and opacity animate,** with one exception: the phone bottom sheet's height and radius. Everything else in layout and colour snaps. Every animation, modal, drawer and sheet included, has a reduced-motion branch that names its end state. (`motion.md`)
5. **One easing, every duration a token, no flourish.** No bounce, no haptics, no second flourish on the same event; the way in is the one exception. (`motion.md`)
6. **More opens in a drawer on the right,** the editing surface; never a new page. A centred modal only confirms or holds a small form. A destructive action on a record confirms and names the consequence, with an outlined danger button; a light thing deletes softly with an undo toast. Success is the visible state change, never a toast. (`sheets.md`)
7. **The shell answers before the app does.** Navigation marks the target on click; `aria-current` and the page title follow the real route. Data paints from cache and revalidates behind it; a write shows at once. Waiting shows after 300 ms, in one place. Neighbouring areas are prefetched. (`speed.md`)
8. **A millisecond, a colour or a z-index outside the token file is a bug,** and a guard test says so. The script mirror of the tokens is a file with an equality test, never a read from compiled CSS. (`tokens.md`)
9. **Every consumer app has a way in, built at kickoff:** sign-in and invitation in front of a quiet scene from the app's own world, and a short first-run tour through the real app. No app ships without it. (`entrance.md`)
10. **Controls come from shared pieces in three radii:** control, chip, round. Primary is an ink surface, the accent the one highlight per screen; one chip for every tab and filter row; fields rest sunken and rise on focus. (`controls.md`)
11. **At most one frame between the screen edge and content:** a group, a card, a tile or a tree, never a card in a card. (`surfaces.md`)

## The numbers

Measured in shipped apps and tuned by hand; perception values transfer as they are, sizes and radii may be re-tuned once at kickoff, and any change gets a reason written next to the token.

| What | Value |
|---|---|
| Durations | tap 100 · fast 160 · base 220 · slow 320 ms; sheet 350; backdrop 250; reveal 140; shimmer 1500; sidebar slides back after 120 ms |
| Easing | `cubic-bezier(0.22, 1, 0.36, 1)` for everything that transports |
| Page enter | 220 ms, opacity 0→1, translateY 16 px→0; revisit 120 ms and 6 px; leave 0 ms |
| Stagger | 60 ms per step, 14 px rise, same duration as the page (so it halves on revisit too) |
| Tap feedback | `:active` scale 0.98 on cards, 0.97 on buttons, 0.85 on icon-only buttons, 100 ms |
| Drawer | slides in over the sheet duration; content reveals after a 100 ms delay; backdrop separately |
| Waiting | skeleton after 300 ms; shimmer linear, the only loop in the shell; busy lock expires after 20 s |
| Data | cache max age 24 h; realtime refetch debounced 150 ms; autosave after 800 ms |
| Toast | info 2.4 s · error 4 s · with an action (undo) 5 s |
| Sizes | top bar 64 px; sidebar rail 4.5rem, out or pinned 16rem; drawer 480 px (340–900); frame margin 12 px; content column max 72rem; base text 16 px; tap 44 px touch, 36 px fine pointer |
| Radii | control 12 · chip 8 · round only where it must be (`controls.md`); card, sheet, tile 24; frame 28; icon 12; inline 8 |
| Layers | backdrop 0 · header 5 · content 10 · bar 50 (sidebar) · overlay 55 · sheet 100; gaps are for `dev:mobile-shell` |
| Spacing | 4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 |

## Red flags while building

Stop and read the reference: a new `--z-` token in a feature; `position: absolute` on a leaving page; a toast as success channel; a filled red button; a centred modal for a detail or an edit; a template conditional on a media query inside the shell; a duration parsed from a stylesheet; a transform, filter or `contain` on the frame; a card inside a card; a responsive token set inline on `:root`; a fetch that blanks a list it already showed; a pill-shaped or gradient button; a hand-built chip row; a radius, height or icon size set in a page.

## Kickoff questions

Before the first screen, through the question tool, several at once, each with a recommended option: the areas (at most five) and their order; which paths each area covers without an entry of its own; whether the app also gets a phone shell (`dev:mobile-shell`) now, later or never; the brand tokens (colours, type, radius family), which are the only free variables; what the sign-in scene shows and which clicks the tour asks for (about six: one per area plus a key action); the framework. Everything else here is decided.
