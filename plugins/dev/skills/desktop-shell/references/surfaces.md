# Surfaces

Law 11: at most one frame level between the screen edge and content. Nested frames waste the edge, double the padding and read as generated. Four forms carry everything.

| Form | Is | Use |
|---|---|---|
| **Group** | a card without padding holding one column of like rows; rows fill it, separated by hairlines drawn flush from the row inset to the edge; its title stands outside, above the frame | lists of records, settings, a project's items |
| **Card** | a frame with padding and free content | a widget, a form, a summary |
| **Tile** | a card in a grid, showing a preview | collections whose items are judged by look |
| **Tree** | a frame without hairlines; rows get a fill on hover | nested navigation, a page tree |

- Rows inside a group carry no ring of their own; the group's hairlines separate them.
- Grey wells (inputs, key-value lists, large readouts) don't count as a level: a well inside a card is fine.
- Icon buttons inside rows and groups are ringless; their tap target still reaches the tap token.
- Inside a modal or drawer the overlay is the one level; lists in it stay plain rows, never a group.
- The frame's edge is a hairline ring drawn as a box-shadow, not a border, so it adds no size and nests cleanly with the radius.
