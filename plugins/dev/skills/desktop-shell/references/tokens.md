# Tokens and guards

One file decides how the shell looks and moves; tests make sure nothing else does.

## One token file

All tokens in one source, under namespaces that keep brand and structure apart. The source is either one stylesheet, or one script file whose values are written inline on `:root` at start (themes switch by rewriting them); then a stylesheet holds the same values as a fallback set for the first paint, so nothing flashes before the script runs, and a test keeps both equal.

| Namespace | Holds | Changes on re-brand |
|---|---|---|
| `--color-*` | semantic names: page, ink, surface, card, well, accent, highlight, stage, on-stage, border, separator, danger, success, warning, scrim, glass; the raw palettes feeding them | yes, only this block |
| `--duration-*`, `--delay-*`, `--ease-*` | the motion ladder (values in `SKILL.md`) | no |
| `--z-*` | the layers (values in the table): backdrop, header, content, bar, overlay (non-modal popovers), sheet (everything modal, ordered by the stack) | no |
| `--radius-*` | control, chip, round (`controls.md`), card, sheet, tile, frame, icon, inline | family may change |
| `--shadow-*` | ring (the hairline), card, lift, bar, glow, focus | no |
| `--size-*` | top bar, sidebar, rail, drawer, frame margin, content max width | no |
| layout, responsive | page inset, card inset, section gap, row height, tap target | no |
| script mirror | the width thresholds, gesture thresholds, spring values (see below) | no |

Responsive layout tokens live only in the stylesheet, under the media queries of the width thresholds: a value set inline on `:root` beats every media query, so a responsive token in the script source would freeze at one width. The tap target follows the pointer, not the width (`pointer: coarse` or fine; values in `SKILL.md`).

The hairline ring around cards and the frame is a box-shadow, not a border: it adds no size and survives the radius. Glass (translucent with backdrop blur) is for overlays only: modal, drawer, toast, popover; never the tab bar (`dev:mobile-shell` law 2). It never sits inside an element with opacity below 1 or a filter, which stops the blur.

A phone shell adds its own tokens in these namespaces (`dev:mobile-shell`, `layout.md`).

Spacing is a 4 px scale with eight allowed steps (4 to 64), written down once next to the tokens.

The gaps in the layer ladder are deliberate: a new layer is a new token in a gap, not a renumbering. A feature never needs one; modals live in the sheet layer, non-modal panels in the overlay layer, and the overlay stack orders them (see `sheets.md`).

A component library, if used, is fed from these tokens (its theme variables set from `var(--…)`), so it inherits the brand without per-component overrides.

## JS mirror

Gesture thresholds and spring values are needed in script. Either generate stylesheet and script constants from one source file, or keep one hand-written mirror file with a test that asserts equality. Never read a duration from the compiled stylesheet: the build shortens `220ms` to `.22s` and a parse returns 0.22.

## Guards

Tests that run with the unit suite and fail the build:

- No hex, rgb, hsl or named colour and no raw palette class outside the token file.
- No raw millisecond value outside the token file and its mirror.
- No full-round utility outside the round token.
- Navigation: one source file; at most five areas.
- No width query in a stylesheet except the threshold literals.
- Import boundary between browser and server code, checked over the transitive graph.
- Token file and mirror equal.

Component tests pin the shell's invariants: reduced-motion end states, scroll lock depth, overlay stack top-closes-first.
