# Perceived speed and data

The shell answers a click before the app does, shows data it already has, and shows waiting only when waiting is real.

Contents: optimistic active state · waiting · prefetching · revisit · scroll restoration · data and speed (cache, live data, writes, autosave, deleting, delivery).

## Optimistic active state

A click stores the target path at once. The navigation's active marking is `target ?? current route`, so it moves before routing resolves. Two safeguards:

- A fallback timer: if the navigation never lands, the target is cleared and the marking returns to the real route.
- Cleanup on the router's finish hook, synchronously, so no placeholder frame sits over a finished page.

`aria-current` and the page title read the real route, never the target.

## Waiting

A skeleton appears after 300 ms, not before: a prefetched navigation never shows one, a cached hit never flashes. Skeleton rows stagger by one step. One indicator per wait; no progress bar in addition to the skeleton.

## Prefetching

After every route change, prefetch the neighbouring areas first (the two beside the active one in navigation order), then the remaining areas, each href at most once per session. Everything else in the app loads on interaction intent, not on viewport visibility.

## Revisit

A module-level set of visited paths, filled before the navigation commits in the one hook that also sees back/forward and redirects (in Vue Router, the global before-guard). While the target is in the set, the root element carries the revisit class and the page transition uses the revisit values (see `motion.md`).

## Scroll restoration

All three cases read and write the one scroll surface (`layout.md`), in order:

1. Browser back or forward: the saved position.
2. A tab or gesture that switched area (see `dev:mobile-shell`): the position stored just before navigating, read once and then forgotten.
3. Otherwise: top.

Scrolling waits until the framework signals the new page is settled (loading finished and the page transition resolved), then one animation frame, so it never scrolls while the old page is still on screen.

## Data and speed

### Cache first, then revalidate

Every read paints what the app already has and fetches fresh data behind it. Two tiers under one key that encodes every filter: session memory for navigation, local storage for the cold start of the installed app. A stored entry past the max age (`SKILL.md`) is dropped: a skeleton is better than day-old data. A filter switch paints the cached result for the new key before its fetch; a fetch never blanks a list it already showed.

### Live data

Realtime changes trigger a refetch of the watched query, debounced, never a patch of the local result: a refetch stays correct under any filter. Realtime alone is not enough: in the same tab its echo arrives late or not at all (an expired socket token, a dropped channel). So every successful write also notifies a local mutation bus per table, and every query watching that table refetches at once. Realtime then carries changes from other devices.

### Writes

- A toggle (done, pinned, starred) flips at once, writes behind, rolls back on error, and afterwards takes the server's values, never the local guess.
- Text and forms in the drawer save themselves: debounced after the last change, never on mount, saves serialised (a change during a save runs after it), the pending change flushed when the drawer closes. A small status says saving, saved or failed; failure keeps the text and offers retry.
- Deleting follows `sheets.md`: a light thing soft-deletes with undo, a record confirms.

### Delivery

- Hashed assets are served `immutable` with a year's max age; the HTML and the service worker file are `no-cache`, so a deploy reaches the next load.
- Fonts are self-hosted and preloaded; no font from a third-party origin.
- One scroll surface with `overscroll-behavior: contain`; `html` and `body` never scroll (`layout.md`).
