# Audit

Checking an existing app against the laws. Two passes: grep the code, then look at the running app at desktop width. Where a phone shell exists, `dev:mobile-shell` adds its own rows and its phone pass. Report findings by law number prefixed D (D1 … D11); the completion report follows `dev:app-blueprint`.

## Code pass

| Law | Look for |
|---|---|
| 1 | more than one navigation array; more than five areas; two scroll surfaces, or `html`/`body` scrolling beside an inner one; a template conditional keyed to a media query or width inside the shell; a width query other than the threshold literals; a second navigation for the rail; a transform, filter or `contain` on the frame or scroll surface; the sidebar's slide driven by script instead of CSS |
| 2 | numeric `z-index` outside the token file; a `--z-` token added in a feature commit |
| 3 | old and new page mounted at the same time during a transition; `position: absolute` on a leaving page; slide-left/right variants; a page animation that fills forwards |
| 4 | transitions on height, width, top, left, margin, color (phone bottom sheet excepted); an empty reduced-motion branch; modal, drawer or sheet without one |
| 5 | more than one easing; scale bounces; `navigator.vibrate` |
| 6 | `window.confirm`; a toast as success channel; filled danger buttons; a detail or edit in a centred modal; a detail as its own page; a light thing behind a confirmation, or a record deleted with only an undo toast |
| 7 | skeleton or spinner without a 300 ms delay; two indicators for one wait; no prefetch of neighbours; `aria-current` bound to anything but the real route; a list that blanks on refetch or filter switch; no cache tier for the cold start, or one without a max age; writes that rely on realtime alone; a toggle that waits for the server; an editor without autosave flush on close |
| 8 | raw ms or colours in components; durations parsed from `getComputedStyle`; no guard test; a responsive token in the script source; token source and fallback set unequal |
| 9 | no scene behind sign-in, or one with a z-index, a script or colour behind text; no first-run tour, or one that navigates by itself, swallows clicks or renders before hydration; no restart in settings; no guard test on tour targets |
| 10 | a full-round utility outside the round token; a gradient or accent surface on a button; a hand-built chip row; a field with its own border; a height or icon size set in a page |
| 11 | a card or group inside a card; rows with their own rings inside a group; a group title inside the frame; a ringed icon button in a row; a group inside a modal or drawer; a border used as the hairline ring; glass inside an element with opacity or filter |

## Browser pass, desktop and tablet width

- Reload with a real pointer and no cookie: rail, top bar, title matches the page; hover the rail: it slides out over the content, nothing shifts; leave it: it slides back after a beat. Ctrl/Cmd + B pins it.
- Resize across both thresholds: phone chrome, rail, wide sidebar; no flash, no second navigation, the frame keeps its margin and ring.
- Click each area: active marking moves at once; content follows; re-click does nothing.
- Navigate away and back: second visit noticeably shorter, and the list paints before its fetch returns.
- Open a detail: drawer on the right, page underneath unchanged and readable; drag its edge, reload: width kept. Open a second one: Escape closes the top only; background does not scroll.
- Edit a field in the drawer: saved status appears without a button; close at once: the change is there after reload.
- Delete a record: confirmation with consequence, outlined danger button, no toast afterwards. Delete a light thing: gone at once, undo toast for 5 s, undo restores it.
- Change something in a second window: the first shows it within a moment, without reload.
- Lists show as tables; one network request per list.
- Throttle the network: skeleton appears after a pause, not instantly, and nothing else appears with it.
- Reduced motion on: everything lands instantly in its end state, drawer and modal included; nothing stuck hidden.
- With a phone shell: a two-finger trackpad swipe and a scroll at the top of a list do nothing.
- Sign in with a fresh account: within 5 s something crosses the scene, the card stays usable; the tour starts, each step advances only on the real click, reload resumes it, skip ends it; restart from settings ends back there.
