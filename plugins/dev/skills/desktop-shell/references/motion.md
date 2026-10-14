# Motion

Everything that moves in the shell.

## Ladder

Durations, delays and easings are tokens (see `tokens.md`); the values are in the table in `SKILL.md` and are not repeated here. One easing transports everything; a second easing needs a written reason at its token. Only transform and opacity animate, except the phone sheet's height and radius (see `dev:mobile-shell`, `layout.md`).

## Page transition

The old page unmounts before the new one mounts (in Vue terms `mode="out-in"`). The leaving page has no transition; the entering page goes from transparent and slightly below to rest over the page duration. No direction: areas are siblings, and a slide across a full-width page moves too much. The animation sits on the page inside the frame and never fills forwards: a lasting transform or opacity would make the page the containing block of every fixed sheet in it.

Revisit: while the target was visited before (see `speed.md`), the root element carries a revisit class; the page duration and offset halve.

Staggered entrance for widgets and rows: rise plus fade over the page duration, one stagger step per item, five steps at most.

Tap feedback is pure CSS on `:active`: a small scale, felt, not seen. No haptics.

The skeleton shimmer is the only loop inside the shell; the sign-in scene (`entrance.md`) sits outside it.

## Reduced motion

A global net first: `@media (prefers-reduced-motion: reduce)` sets every animation and transition duration to 0.01 ms. Then semantic branches per animation, each naming the end state: page transition none and no offset, stagger removed, shimmer replaced by a static fill, no scale on `:active`, markers set instantly, and modal, drawer and sheet standing at once with their content visible and the backdrop at full strength. The overlays are not optional here: their content reveals after a delay, so a missing branch leaves it hidden. An empty reduced-motion object is a bug (it writes nothing, so the hidden initial state stays).
