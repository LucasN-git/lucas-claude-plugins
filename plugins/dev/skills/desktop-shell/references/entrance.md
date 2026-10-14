# The way in

Law 9 of `dev:desktop-shell`; phone specifics under Phone below.

## Sign-in and invitation

- One centred card on a bright surface; behind it runs a quiet scene from the app's own world in one drawing style and brand colours: two to four small objects from the app's subject crossing the sky or a ground line (a plane towing a partner's banner, a delivery van).
- Decoration without information: `aria-hidden`, `pointer-events: none`, never colour behind text.
- Each object shows only in a window of its own loop, loops of different length; the first appears within about 5 s.
- Server-rendered, CSS keyframes on `transform`, no script, every loop and colour a token. Content paints above by DOM order, never a z-index; ground elements are `absolute` in the frame, not `fixed`, and padding keeps the card and caption off them.
- Reduced motion removes every moving object (`display: none`, not a shorter duration); the still parts stay as a picture and the logo shows finished.
- A valid invitation greets once with a single welcome pass; an expired or used one gets a plain sentence and the way to sign in.

## First-run introduction

- Once per account; "completed at" on the account, progress in `sessionStorage` so a reload resumes, skip always, restart only from settings, ending back there.
- Opens with the logo mark building in, then a greeting with the first name. Renders nothing before hydration; the device path is chosen once and stored.
- Desktop: a tour through the real app, about six clicks, one sentence per card, titles as calls to action. The spotlight marks a real nav entry or an element with a data attribute; the step advances when that real click happens; a capture listener only observes it, never `preventDefault`. Nothing is saved the person did not trigger; a missing target shows a fallback sentence and "Next"; the card moves aside from an open drawer.
- Modal: Escape goes through the app's one Escape stack. A guard test keeps every target present in code and every nav step in the navigation source. A new area replaces a step instead of adding one.

## Phone

Three or four swipe pages (a drawing, a title, one sentence each), then at most two taps in the real app. The scene scales down and its ground fits 360 px.
