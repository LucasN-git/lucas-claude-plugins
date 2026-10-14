# Shell

The frame every page renders inside. The layout mounts it once and no page touches it.

```
┌──────────────────────────────────────────────────────────┐
│ mark  App   │  Start › Dashboard › Analytics   [search] ●│  top bar
│             ├──────────────────────────────────────────┬─┤
│ AREA        │ ┌──────────────────────────────────────┐ │ │
│  ▸ Records  │ │ ←  Records            [+ New record] │ │p│
│  ▸ Reports  │ │ [search][filters ▾][sort ▾]  [N of M]│ │a│
│             │ │ ────────────────────────────────────  │ │n│
│ ADMIN       │ │ content                              │ │e│
│  ▸ Users    │ └──────────────────────────────────────┘ │l│
│  « collapse │        content sheet, inset by one gutter │ │
└──────────────────────────────────────────────────────────┘
```

Sidebar and top bar carry the same fill and meet at the corner with no seam, so the eye reads one tinted frame with a single sheet lying on it. The sheet is a half step lighter than the frame and a half step darker than what floats above it (panel, dialog). That half step is the whole depth system: no shadows. The sidebar carries no border, because the same fill sits on both sides of its right edge. An edge is drawn once, by whichever of the fill or the hairline gets there first.

## Navigation taxonomy

One file, three readers: the sidebar renders it, the breadcrumb takes its pillars and titles from it, the palette searches it. Fields per entry: `path`, `label`, an optional shorter `crumb` for the trail, `icon`, `pillar` (top-level grouping, no page behind it), `section` (a fold of consecutive entries, its icon keyed on the section name rather than on an entry), `covers` (extra path prefixes that keep this entry active), role flags, and search-only synonyms that are matched and never rendered. Order is load-bearing: a section folds consecutive entries, so a page out of order silently opens a second group of the same name.

A destination that must stay out of the menu goes in a second, palette-only list, not in the menu list behind a flag. Auth pages, error pages and public pages are in neither list and render a layout without the shell: one card, no navigation, no trail.

Active state is longest-prefix-wins over `path` plus `covers`, so a page nested under another page lights only its own row. A plain prefix test lights both. Sections start collapsed; the one holding the current route is seeded open once at mount, not recomputed, or navigating inside a section folds its neighbours shut under the reader.

The sidebar has one row appearance. Every row wears the same ink and weight, whether it expands or navigates; a control's label is never muted. The answer to "where am I" is the tinted pill behind the active row, one device on one row, not a second class of type down the whole menu. A pillar is a label and never clickable. A section holding exactly one page renders flat as that page. Rail mode collapses each top-level entry to one centred icon with a tooltip, toggled from a footer row. It is component state, not a stored preference: the sidebar mounts expanded. Only the open/closed state is app-wide, because the top bar toggles it from outside.

## Top bar

Trail at the left, spacer, then the search or palette trigger and the account control at the right. No fill of its own and no bottom border: it shows the frame's fill, and a rule here draws a line across exactly the corner where the two meet. Nothing else ever goes there. No notification bell, no page actions, no context switcher. Every item added is an item every user skips on every page for ever.

The left inset is derived from the sheet's geometry (gutter plus border plus card padding), so the trail's first glyph lands on the x of the page title beneath it and the eye follows one vertical line from "where am I" into "what is this". A typed pixel value is correct until someone edits the gutter. The right inset stops one space step short of the sheet's edge, because the last control is round and aligns by its circle. The search trigger is a pill lighter than the bar around it, with the platform's shortcut badge. It is a button, not an input; it opens the palette, which searches the navigation taxonomy and the palette-only list, debounces 160 ms and sends no remote query under two characters. One rule carries the shell: lighter comes forward.

## Trail derivation

Built from the route pattern, never from the path string. The pattern is the only thing that tells a URL id from URL structure. Where the pattern's segment count disagrees with the path's, treat every segment as static: that drops a crumb, it never mistitles one.

| Segment | Crumb? | Link? |
|---|---|---|
| Pillar (opens the trail) | yes | never |
| Section | no | the trail is the pillar, then the URL |
| Static segment named in the taxonomy | yes | yes, unless it only redirects to its first child |
| Static segment with no page behind it | no | a naive trail links it and lands on a 404 |
| Id segment | yes, titled by the registered human name | yes, unless it is the current page |
| Current page | yes | never |

An id crumb is named by the page that resolves the record, including ancestors a page counts back by segments rather than by a built path. Until the name arrives, an opaque id renders as an ellipsis; a readable slug renders as itself. Prettifying (separators to spaces, capitalise) applies to static segments only, or a record called `Plant-North` gets renamed by the breadcrumb. Nothing is removed from the name map on unmount: the outgoing page unmounts after the incoming one has written its entry. Key each name on the path snapshotted at setup, never on the live route, or a transition stamps this page's title onto the next page's crumb. Below the layout breakpoint the bar renders `Parent › Current` on one truncating line.

## Page heading

One flex row at the top of the sheet: back arrow, mark or icon, title as the page's single `h1`, subtitle, a hint behind an info glyph, identity badges inline, spacer, actions at the right. The subtitle says what the page is and always prints; the hint holds the caveat, which is what keeps a standing paragraph off the surface. A subtitle that is a fact about the record may stack under the title on the same left x. The mark is one fixed size set inside its component, so every heading in the app is the same height whether it carries a logo or a glyph.

The back arrow resolves from the trail to the nearest ancestor that actually has a page, which is deliberately not the second-to-last crumb. Its tooltip names the destination. Suppression is its own boolean prop: a prop typed `string | false` is cast to `false` when absent, so every page passing nothing would lose its arrow. A record's mark may also link up to its parent record; the arrow says one level, the mark says whose, so the two do not compete. Two views of one subject get a symmetric pair of buttons labelled by destination, no arrow on either.

## Trail versus tabs

A reader who asks for a "tab flow" across the top usually means the trail. Tabs exist in one place: on a record page, across that record's own collections. They never carry navigation between areas, and a tab is never a crumb.
