# Phone layout

The phone anatomy and the contract that lets it share one DOM with the desktop shell (`dev:desktop-shell`, `layout.md`).

## One DOM for both shells

Phone chrome is hidden above the breakpoint by a CSS class and desktop chrome below it. Never a template conditional or a viewport hook: the server does not know the width, and a mismatch flashes the wrong chrome on first paint. Where markup must differ (a table cell edited inline on the desktop, a row on the phone), both versions stand in the HTML and CSS shows one.

The tab bar precedes the sidebar in the DOM; both carry the same hrefs and `aria-current`, so tests scope by `aria-label`. A script media query exists only for behaviour CSS cannot express: focus targeting, whether a gesture is wired. It acts after hydration and is never used to show or hide.

Lists: the table's dataset also renders as rows, hidden above the breakpoint; a tap opens the sheet; the fetch stays the desktop one.

## Regions

DOM order, which is also layer order (values in `dev:desktop-shell`):

```
stage        fixed backdrop in the stage colour; the root also paints it
             above the fold so the iOS rubber band never shows another
             colour                                           (layer backdrop)
header       fixed on the stage: wordmark, actions, round account button;
             height token + safe-area top                     (layer header)
content      the card that scrolls over the header: rounded top, its own
             surface; margin-top = header + safe-area top    (layer content)
tab bar      fixed, full width, hairline on top, opaque, safe-area bottom
                                                              (layer bar)
sheet host   portal target, beside the header, never inside it (layer sheet)
```

A full bar instead of a floating pill: the content already floats as a card over the stage, and a second floating shape below it doubles the build. No blur and no gradient above the bar for the same reason.

The header is not a bar but the backdrop the content card scrolls over. The wordmark is centred when the actions slot is empty and left-aligned when it is filled; alignment is derived from the slot, not a prop. Actions are round buttons on the right. A fixed element opens its own stacking context, so a sheet triggered from the header is portalled beside it.

## Tab bar

- The same navigation file as the desktop sidebar; the bar shows exactly the items flagged for it, at most five, and the swipe reads the same list (two counts drift apart). Every slot is an area; there is no "more" sheet. Account items live behind the account button.
- Active state is colour, a bolder icon stroke and one label weight step. On touch-only devices the tabs carry no focus ring: focus stays on the tapped link and the browser draws it as keyboard focus.
- Re-tapping the active tab scrolls the area to the top (instantly under reduced motion); on a sub-page of the area it leads to the area root like any link.

### The marker

- One element, a slot wide, carrying a 2 px line at its top edge. The slots are equal, so its position is `index · 100%`, exact from the server frame on; it moves by a CSS transform over the base duration. No spring, no per-tab fade, no surface behind the active tab: a pill behind it was too small to read as focus on a phone and stood in the way.
- It follows the optimistic target set by tap and swipe (`dev:desktop-shell`, `speed.md`); `aria-current` follows the real route.
- On a page outside the areas (account, inbox) the marker fades and stays where it was; the account button shows the ring instead.
- Reduced motion: it jumps.

## Tap targets and add buttons

- Small buttons and chips are drawn at 36 px; an invisible pseudo-element extends their hit area to 44 px. It lives in the shared components, so a page never pads for touch.
- An add button is the plus alone in a 44 px round target below the breakpoint and plus with a short label above it; the label stays as the accessible name on the phone. Only creating gets a plus.

## Sheet

The desktop drawer (`dev:desktop-shell`, `sheets.md`: state, stack, busy lock, confirm) is the same component: it rises from below on the phone and docks right from the breakpoint up, by CSS.

- Three detents: content (as high as its content), half (as high as its content, at most 60 % of the window, so a short record stays short) and full. A start detent picks the opening one: a form opens at content, a reading sheet at half.
- Drag at handle, head and content. Handle and head take every vertical drag; in the content the ownership rule in `gestures.md` decides. An element can reserve every drag for itself (an image crop); a no-swipe marker is not enough for that.
- Upward the sheet follows the finger up to full and rubber-bands beyond it; on release it snaps to the new or the old detent and continues at the finger's speed instead of a fixed duration. Height and radius animate here, the one exception to `dev:desktop-shell` law 4.
- Close paths: handle or content drag, browser back, Escape, backdrop. Browser back closes the top sheet: each open sheet owns a history entry, and every own close path goes through the same book so back never closes twice. Escape closes only the top overlay. While an action runs no close path works; a maximum busy time is the backstop.
- Errors stay inside the sheet; success closes it onto the changed list. No toast.

## Scroll per area

Each area keeps its scroll position. Tap and swipe store the leaving area's position before they navigate; the arriving page restores only when this very navigation asked for it, so a plain link lands at the top. Back and forward use the browser's own restoration. The request expires with the optimistic-target fallback.

## Tokens this shell adds

In the namespaces of `dev:desktop-shell`: `--z-install` 60 (a gap in the ladder), `--size-header`, `--size-tabbar`, `--size-tab-icon`, `--size-tab-label`, `--size-tap`, `--delay-prompt`; gesture thresholds and the sheet's detent cap in the script mirror.
