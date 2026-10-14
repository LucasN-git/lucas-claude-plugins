# Detail panel

One record in detail, without leaving the list or the drawing it was opened from. There is one panel shell in the app. A second right-hand drawer implementation is a defect, not a variant: two shells mean the user learns the panel twice and the scrolling bugs get fixed twice.

## Geometry

An edge column anchored right, over the sheet. Its top is the page's top, level with the sheet, so panel and page begin on one line; its bottom is the window's floor, an edge the screen already ends at, which needs no gutter under it. The panel paints the strip up to the top bar in the frame's fill itself. A page scrolls under a fixed top bar, so a strip left open beside the panel has rows travelling through it and reads as a gap. That gutter is paint and nothing else: no border, no radius, no shadow. Square on every corner, because it is an edge column and not a floating card. A hairline on the left edge alone, the only edge lying on the page; the other three meet painted fill, the window's floor and the screen's right edge, all drawn already. The fill is the surface that floats, a half step lighter than the sheet, and that half step is the panel's whole elevation. No scrim and no wash: a tint would make a record read as navigation, and dimming the page is exactly what a non-modal panel does without. The panel slides over the page and the page keeps its full width. The list underneath is hidden on that side, never displaced, so a panel can be opened, read and closed without the page reflowing under the reader's eye. Publish the covered width for the one surface that needs it (a canvas pans the selected element clear of the panel), read one frame later, and never let the layout spend it.

Below the layout breakpoint the panel is the screen: full width, no grip, no painted gutter.

## The grip

A thin vertical strip on the left edge, tinting on hover, dragged to resize. Width is remembered per panel key, written once on pointer release rather than sixty times a second, and clamped on read to the floor and the viewport share. Clamping on read is what lets a narrow window shrink the panel without destroying the width the user picked; the upper bound is the window alone, because a wide-screen width costs a narrow page nothing, it only hides more of what is still there. The default width and the floor per kind of record are named tokens; a call site names the kind, never a pixel. Wider for a record with a long tail, narrower for a document. Never inset the drawer element horizontally. A closed drawer is usually translated by exactly its own width, so an inset element stops one gutter short of gone and leaves a permanent strip against the window edge. Vertical geometry is free to override; the translate runs along x.

## Anatomy

```
┌ grip ─────────────────────────────────────────┐
│ [mark] Nordwerk Industries              (badge)│  identity row, one line, truncates
│ [✎ Edit]  [⤢ Full screen]      … [✕ Close]    │  action row, always ends in Close
├───────────────────────────────────────────────┤
│ PROPERTIES                                    │  section
│ OPEN ITEMS  ②                                 │  section
└───────────────────────────────────────────────┘   body scrolls, header stays
```

The identity row is a mark plus the record's name and at most one badge the record wears. One line high, truncating rather than wrapping, so every panel in the app has the same header height. The panel names the record the way the surface that opened it named it; one element cannot have two names. The shell appends Close itself and Close is always last, so closing sits in the same corner whichever panel is open. A spacer pushes the shell's controls right of the caller's. The body is a scrolling column with even side padding, a tail of empty space, and one gap step between sections. It scrolls down and never sideways: a section that does not fit the width is a bug in that section. Free text from people or external systems breaks anywhere, which also drops its min-content width to zero and stops one long token forcing a grid column wider. A block that genuinely needs width brings its own scroller. Contain the overscroll, or the panel's scroll chains into the page behind it, and there is no scrim between them.

Sections in the body must be pinned against flex shrinking. A flex item is held at content height by an automatic minimum that resolves to zero for an item which is itself a scroll container, and any card is one. Unpinned, plain blocks look fine while cards silently lose their last rows. There is no footer slot. A panel's actions are in its header, visible without scrolling to the end of an arbitrarily long body. A panel that seems to need a footer is the wrong shape for its content: it is a form, and a form that commits belongs in a centred dialog.

## Opening, switching, closing

| Gesture | Result |
|---|---|
| Row click | opens on that record and marks the row selected; the same row again closes it |
| A canvas node selection | opens on that element and pans it clear of the panel |
| Clicking a different row | switches the record; a row that has left the list closes the panel |
| Close button, Escape | closes it |
| Route change | closes it first, then navigates |
| Click outside | closes it only where the host opted in |

The toggle matters: the row that opened the panel closes it, and stays marked while its record is showing. A row that only opens leaves the user hunting for the close button. Outside-click closing is opt-in, because on a canvas a click beside the panel selects the next node. Where it is on, the condition whitelists two things that sit outside the element but belong to the panel: the overlay container every menu and picker inside the panel is teleported into, and the toggle or row that switches records. Missing the first closes the panel when a select opens inside it; missing the second undoes the click that was just made to switch. Close before navigating. A panel left open animates out over the page it just sent you to.

## List reads, panel details, page owns

The list shows what is needed to choose a row: identity, one or two figures, a state mark. No derived hints, no second lines. The panel shows the record in full and is where a record reached from a list is edited. The page is the same record at a permanent URL, linkable, and the surface the trail leads to. The panel's expand action opens that page carrying the current view state, so the reader does not lose the window they were looking at. Page and panel render the same blocks through the same components. A block shared between them keeps its own heading and takes a density flag; the panel's own wrappers and the page's own wrappers each belong to their surface, and everything between is mounted once and rendered twice. Two renderings of one record drift within a month, and then two people quote different figures from the same system.

The open record never enters the URL. Which record is open lives in the host's own state; the URL keeps naming the list and the view state that produced it. The page is the addressable form of a record, so an open panel in the URL would be a second address for one record, and a shared link would reproduce a reading position instead of a subject. A canvas may accept a one-shot intent that opens the panel and is consumed and stripped: an arriving instruction, not an address.

## One panel, mounted once

The shell mounts the panel and a small state holder drives it: open, and the key of the record to show. It renders nothing until a key is named, so mounting it costs a closed drawer. Module-level state, not component state, is what lets unrelated screens address one panel without a store or a prop chain. Keep a per-instance registry rather than one bare value where a page can hold several panels, or the closed one clears the open one's published width.

Mount a panel app-wide when its content is a reference consulted while other work happens. A record the reader works on belongs to the surface that lists it. Editing inside the panel is per section, one section in edit at a time, with the rules in `writes.md`.
