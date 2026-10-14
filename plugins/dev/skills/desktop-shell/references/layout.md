# Layout

The desktop shell. Where a phone shell exists, `dev:mobile-shell` shares this DOM (its `layout.md` holds the contract).

## Three widths, one DOM

| Width | Chrome |
|---|---|
| Phone, below the first threshold | `dev:mobile-shell`: header, tab bar, sheets; no frame |
| Tablet, between the thresholds | framed canvas, the sidebar as an icon rail |
| Desktop, from the second threshold | framed canvas, the sidebar wide with labels |

The rail is the same sidebar in its rail state, not a second navigation: only its measure changes, so the second threshold never splits the DOM. With a single threshold the rail is a state instead (below). The threshold numbers live once in the script mirror; CSS writes only those literals, and a test fails any other width query in a stylesheet. Layout that depends on a column's width rather than the window uses container queries.

## Regions

```
page         the page colour behind everything; the sidebar sits on it
sidebar      fixed left: wordmark, the areas, an additive admin group,
             an account block; rail or wide                       (layer bar)
frame        the canvas: the frame margin to the window and the sidebar,
             frame radius, a hairline ring, its own surface
  top bar    the page title                                       (layer bar)
  content    one column, max width 72rem, scrolls on the frame's
             one scroll surface                               (layer content)
sheet host   portal target for drawer and modal                  (layer sheet)
```

- **One scroll surface.** Inside the frame the content scrolls on one element with `overscroll-behavior: contain`; `html` and `body` never scroll, because the rounded frame clips its content and a scrolling document would carry the frame away. Without a frame the document is the scroller. Never both, so scroll restoration and position memory read one number.
- **Never a transform, filter or `contain` on the frame or the scroll surface:** each makes it the containing block of every `position: fixed` descendant (fullscreen views, popovers, sheets). The page transition animates the page inside, not the frame.
- Top bar title resolution: the page's own declared title, else the label of the active navigation item. A heading is content, so it follows the real route, never an optimistic target. Pages whose title comes from data show it in-page instead.
- No back button in the shell: areas are siblings. A detail opens in the drawer (see `sheets.md`), so the page underneath stays where it was.
- Layouts outside the shell: auth (one card, no navigation) and public pages (static header, footer, no app chrome).

## Navigation

- One configuration file is the only source: `href`, `label`, `icon`, optional `covers` (paths that belong to the area without an entry of their own) and flags for admin-only or account items. A test pins the maximum of five areas. Admin and account items are additive groups in the sidebar, never mixed into the areas.
- Active = longest prefix match over `href` and `covers`. Re-click on the active item does nothing.
- The active item is marked on click, before routing resolves (see `speed.md`); `aria-current` follows the real route.
- Rail and wide: labels stay in the tree and fade on the rail, so a link keeps its name; icons never jump. The marker is a line at the edge on the rail, a dot when wide.
- With one threshold the rail is a state: out over top bar and content on hover with a real pointer (`hover: hover`, against a tablet's sticky hover) or on `:has(:focus-visible)`, back after the delay in the table against flicker at the edge, or pinned wide. The slide is a CSS transform from one custom property, no script; reduced motion skips it. Button or Ctrl/Cmd + B toggles (not in a field); a cookie read on the server holds the state. A touch device starts pinned wide, since nothing hovers there.

## Lists

Lists render as tables: a fixed header row, one row per record, row click opens the drawer. The page fetches once, with one key; the table only presents.
