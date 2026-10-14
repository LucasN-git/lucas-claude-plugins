---
name: mobile-shell
description: Use when a consumer web app or PWA gets or has a phone shell - tab bar, swipe between areas, bottom sheets, pull-to-refresh, installed feel - /dev:mobile-shell
---

# Mobile shell

The phone layer of a consumer app. It sits on `dev:desktop-shell`, which holds the laws both shells share (layers, motion, panels, perceived speed, tokens and guards) and the desktop shell itself; this skill never repeats it. Its files live beside this skill at `../desktop-shell/` (SKILL.md and `references/`). Colours, type and brand stay free.

## Three modes

| Mode | When | Read |
|---|---|---|
| **Kickoff** | A phone shell for a new or existing app | `dev:desktop-shell` kickoff first, then `references/layout.md` |
| **Build** | A feature that touches the phone chrome, a gesture or the installed app | the laws below, plus the reference whose topic is in play |
| **Audit** | "Check this app on the phone", or taking over a codebase | `dev:desktop-shell` audit, then `references/audit.md` |

References by topic, each read when its topic is in play:

- `references/layout.md` when the header, the tab bar, its marker, an add button or the sheet on the phone changes.
- `references/gestures.md` when anything is meant to follow a finger: swipe between areas, dragging a sheet, pulling to refresh. Thresholds become code only through the token mirror in `dev:desktop-shell` `references/tokens.md`.
- `dev:desktop-shell` `references/sheets.md` when a sheet opens or a destructive action is confirmed; the sheet section of `references/layout.md` here adds detents and the phone close paths.
- `references/pwa.md` when the app is installed, or the work touches viewport meta, status bar, service worker, splash or prompts.

## The laws

1. **One DOM, split by CSS at one breakpoint.** Phone chrome hidden above it, desktop chrome below; a second width threshold may only switch the desktop sidebar between rail and wide, never what renders; where markup must differ, both versions stand in the HTML. Script asks the breakpoint only for behaviour, never to show or hide. (`layout.md`)
2. **The phone shell is a card on a stage.** Fixed header as backdrop, the content card scrolling over it, a full-width tab bar with a hairline: no floating pill, no blur. (`layout.md`)
3. **One marker glides, never five that fade:** a slot-wide line over equal slots, moved by CSS over the base duration; nothing behind the active tab. (`layout.md`)
4. **A swipe climbs a level or, at an area's root, switches areas; it commits on release.** The page never follows the finger and nothing transforms the frame that carries fixed children. Coarse pointers only; the left edge belongs to the OS. (`gestures.md`)
5. **A sheet drags at handle, head and content,** one ownership rule deciding whether the content scrolls or the sheet moves; it follows the finger, rests at three detents and coasts at finger speed. (`layout.md`, `gestures.md`)
6. **The app owns its pull gesture.** Browser overscroll is off; only the spinner moves, and it sleeps while any overlay is open. (`gestures.md`)
7. **The phone way in shows before it asks:** swipe pages first, then at most two taps in the real app. (`dev:desktop-shell` `references/entrance.md`, section Phone)
8. **Back and Escape close the top overlay only.** Browser back closes the top sheet; no close path works while an action runs. (`layout.md`)
9. **Each area keeps its scroll position;** a second tap on the active tab scrolls to the top. (`layout.md`)

## Red flags while building

Stop and read the reference: a transform on the swipe frame or `translateX(dx)` on a page while a finger is down; neighbour pages kept alive for swipe; a floating or blurred tab bar; a surface behind the active tab; a viewport hook deciding what renders; drag handlers on sheet content without the ownership rule; a bare gesture threshold; `user-scalable=no`; swipe listeners without a coarse-pointer check; user data in the service worker cache; a second DOM split (a second width threshold that only changes the sidebar's measure, rail or wide, is allowed: `dev:desktop-shell` `layout.md`).

## The numbers

Phone-only values; the shared ones (durations, easing, page, sheet timing, waiting, layers) are in `dev:desktop-shell`. Gesture thresholds stand inline where the gesture is described (`gestures.md`); the tokens this shell adds are listed at the end of `layout.md`.

| What | Value |
|---|---|
| Breakpoint | 48rem, the same constant in CSS, utility classes and the script mirror (the rail/wide threshold lives there too) |
| Header | 88 px + safe-area top below the breakpoint; the desktop top bar is its own token |
| Tab bar | 56 px slots + safe-area bottom; icon 20 px, label 10 px; marker a 2 px line, base duration |
| Tap targets | 44 px; small buttons and chips drawn at 36 px reach it through an invisible pseudo-element; the add button is a 44 px round plus |
| Sheet | detents content · half (content height, at most 60 % of the window) · full |
| Prompts | at most one at a time, earliest 6 s after load, never on first paint |
