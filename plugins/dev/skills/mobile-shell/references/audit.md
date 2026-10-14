# Audit, phone

Runs after the `dev:desktop-shell` audit. Same shape: grep, then look, at phone width with touch emulation on. Findings by law number prefixed M (M1 … M9).

## Code pass

| Law | Look for |
|---|---|
| 1 | a template conditional or viewport hook deciding what renders inside the shell; a second DOM split, or a breakpoint constant outside the script mirror; a script width check used to show or hide |
| 2 | a floating, blurred or gradient-topped tab bar; a z-index on the content card; a sheet rendered inside the header; an inner scroll container in the phone shell |
| 3 | per-tab active backgrounds or fades; a spring or script animation on the marker; a second count of tabs beside the navigation file |
| 4 | a transform on the swipe frame or a page bound to a live pointer delta; neighbour pages kept alive; swipe listeners without a coarse-pointer check; no left-edge exclusion; a level-up that switches areas; release steps out of order |
| 5 | drag handlers on sheet content outside the ownership rule; a threshold as a bare number; a fixed snap duration instead of finger speed; only two detents |
| 6 | pull-to-refresh firing with an overlay open or when scrolled; browser overscroll still on; inline styles left after a gesture |
| 7 | the desktop tour on the phone; more than two interactive steps; swipe pages with thresholds of their own instead of those in `gestures.md` |
| 8 | a sheet without a history entry; Escape closing more than the top overlay; a close path that works while an action runs; a toast after a sheet's success |
| 9 | a re-tap that navigates again; scroll restored on a plain link; no position stored before a tab or swipe navigation |
| `pwa.md` | `maximum-scale` or `user-scalable=no`; inputs below body size under the breakpoint; anything beyond the shell in the service worker cache; more than one prompt at a time (report under the reference, not a law) |

## Browser pass, 390 px wide

- Nothing scrolls sideways on any page (`document.scrollingElement.scrollWidth > clientWidth` is false).
- Reload at 1280 px and at 390 px: no flash of the other chrome.
- Tap each tab: the line glides, no fade; re-tap scrolls up; leave and return: the area is where it was.
- Swipe on a sub-page: it climbs one level. Swipe at a root: switch on release, not during; nothing near the left edge; nothing inside a sideways scroller.
- Open a detail: sheet at half; drag up: it follows the finger to full; drag in the content scrolls; back closes it, Escape closes only the top one.
- Pull from the top: only the spinner moves, one refresh; at the bottom nothing rubber-bands.
- Installed: status bar area shows the stage, safe areas respected, zoom works, no update dialog, at most one prompt.
- Reduced motion on: marker, sheet and spinner land instantly in their end state; nothing stuck hidden.
