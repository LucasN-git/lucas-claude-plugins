# Gestures

The three shell gestures that are not a plain scroll. All maths lives in one script module without DOM: axis, rubber band, velocity, ownership over an ancestor chain, and one decision per gesture with its named thresholds. Components only build the chain and write styles; a threshold never appears as a bare number in a component. Thresholds become code through the token mirror (`dev:desktop-shell`, `tokens.md`).

Every gesture declares its axis to the browser first: `touch-action` on the element, and a non-passive `touchmove` only where `preventDefault` must stop scrolling (swipe frame, sheet content, pull to refresh). Only the first move event is cancelable, so the decision falls there.

Common maths: an axis is decided once one direction passes 8 px and outweighs the other by 1.3; velocity comes from the samples of the last 100 ms only (the thumb brakes or flicks at the end); the rubber band is `max · tanh(distance / max)`.

## Swipe

Touch only, below the breakpoint. The frame carries `touch-action: pan-y` and never a transform: a transform makes it the containing block of every `position: fixed` descendant, so sheets would move with the page. The page does not follow the finger; the switch happens on release, as a real navigation.

**Level before area.** Below an area's root a swipe in either direction climbs one level; only at the root does it switch to the neighbouring area in bar order. The target of "up", first match wins:

1. the page header's back link,
2. else the second-to-last breadcrumb,
3. else the area root, when the first two would leave the area.

A page outside the areas (account, inbox) climbs only within its own root and never switches areas. The target is a pure function with a test.

Ownership: the content keeps the gesture when an ancestor up to the frame scrolls sideways and has something to scroll, or carries a no-swipe attribute (carousels, drawing surfaces, editors, onboarding slides). Starts within 24 px of the left edge are ignored: the OS back gesture lives there.

Commit at ≥ 50 px, or at a flick faster than 0.35 px/ms with at least 24 px moved. No neighbour, no commit: no rubber band at the ends.

On release, in this order: store the origin direction (the arriving page enters from that side), set the optimistic target (the marker starts moving), store the leaving area's scroll position, then navigate. A level-up stores only the origin: no target, no scroll position. No inline style remains on the frame; a test asserts that.

Neighbours are prefetched, never pre-rendered.

## Sheet drag

Handle and head: `touch-action: none` and pointer capture. Content: `touch-action: pan-y`; the first move beyond a 10 px tap slack asks the ownership rule, and until then a tap stays a tap (taking the drag earlier makes iOS drop the click). The rule, first match wins:

- mostly horizontal (|dx| > 1.3 |dy|): the content;
- a scroller in the chain that is not at its top: the content;
- within 250 ms after the content last scrolled: the content (a fling still running into the top edge);
- downward with everything at the top: the sheet;
- upward: the sheet when the content cannot scroll, and always at half, where the first swipe up expands to full before the list scrolls.

During the drag the sheet gets its own compositing layer and one style write per frame. Release: down ≥ 88 px or a flick > 0.5 px/ms with ≥ 24 px closes from content or half; from full only ≥ 160 px closes, a flick alone only drops it to half (a downward swipe there is usually a scroll). Up ≥ 48 px or a flick expands to full; beyond full it gives at most 16 px of rubber band. The snap continues at the finger's last speed: duration from remaining distance and speed, clamped to the slow duration.

## Pull to refresh

The root's `overscroll-behavior-y: none` on `html` removes the browser's own (`contain` only stops the chain; the document itself still bounces and drags the header along), so the app's pull-to-refresh owns the gesture. Only the 36 px spinner moves, starting below the header; its inline styles clear after every gesture. Triggers at 64 px of rubber-banded pull (max 112), or on a flick > 0.5 px/ms with ≥ 32 px. Off when the scroll surface is not at its top, inside a no-swipe region, while a dialog or any overlay is open, and without a coarse pointer, so trackpads never trigger it.
