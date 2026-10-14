# Controls

Buttons, chips, fields, icons and focus, shared by both shells. Values live in tokens and the shared components; a page never sets a radius, height or icon size.

- **Three radii** (values in `SKILL.md`). Control for buttons, fields and toggle tracks; chip for chips and badges; round only for what must be round (avatars, round icon buttons, counters, dots, switches).
- **Buttons.** Primary is a filled ink surface, hover 90 %, disabled 40 % opacity. The accent or gradient is a line or border, kept for the one highlight per screen (a highlighted card, the own avatar, the nav marker), never a button. Secondary, ghost and danger besides. Heights phone / desktop: small 36 / 32 px, medium 44 / 40, large 48 / 44; the icon inside 16 px. On the phone an invisible pseudo-element extends small buttons and chips to the 44 px tap target; a page never pads for touch.
- **Chips.** One chip for tabs, filter rows and list views: chip radius, no border, 36 px high on the phone and 32 from the breakpoint, inactive on the sunken surface (rows sit on the page surface), active in ink. A segmented toggle is a control-radius track with chips inside, the chosen one light. A chip row keeps 4 px air for the tap extension. Nobody builds a chip row by hand.
- **Fields.** Input, textarea, select, pickers and editor rest sunken without visible border and rise on focus to the card surface with a strong hairline; control radius, 44 px high on the phone, 40 from the breakpoint. A field right on the page (search, filter) takes the chip surface.
- **Icons.** 18 px, stroke 1.75 in shell and building blocks, 2.25 on the active nav item; tab bar 20 px.
- **Focus.** Button, chip and field show one focus token: a 2 px gap in the surface colour, then a 2 px ring in the full accent; a translucent halo fails 3:1 on a light surface. Everything else keeps a neutral outline from the base layer.
