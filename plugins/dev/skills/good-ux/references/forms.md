# Forms

## Decision rule

Never let the user discover a rule after submitting. Every constraint the form enforces should be visible or checkable before the submit button is pressed.

## The six rules

**1. Gate submit, but explain the gate.** A greyed-out button with no explanation is worse than an enabled button that fails, because the user has nothing to act on.

Two ways to do it, and the accessible one is usually better. A truly `disabled` button is removed from the tab order and announces nothing, so a keyboard or screen reader user hits a dead end. Prefer keeping the button focusable, marking it `aria-disabled="true"`, and on click moving focus to the first invalid field with its error announced. Use a hard `disabled` only while a submit is in flight, where the point is to prevent a double send. Either way, mark required fields explicitly so nobody has to guess what the gate wants.

**2. Validate inline, on blur.** The moment someone leaves an email field with an invalid address, say so. The failure mode this replaces: fill everything, submit, wait, then scroll back up hunting for the one bad field. Validate on blur rather than on every keystroke, so the user is not corrected mid-typing.

**3. Show the character count when there is a limit.** Live, while typing. Letting someone write a paragraph and then telling them to cut half of it wastes work you could have prevented.

**4. Prefill what you already know.** A logged-in user should never retype their own email. Same for country from locale, or a name already on the account.

**5. Show password requirements as they are met.** List the rules up front and tick them off live. Revealing "needs a capital letter" only after submit is the canonical version of this mistake.

**6. Be forgiving with formatting.** Accept a phone number with dashes, spaces, parentheses or none of them, and normalise it in the backend. Same for dates, IBANs, postcodes and card numbers. If the machine can fix it, do not make the human do it.

## Anti-patterns

- Clearing fields on a failed submit.
- One generic error at the top of the form for a problem that belongs to a single field.
- Placeholder text used as the label, which disappears exactly when the user needs it.
- Validation that rejects legitimate input: apostrophes in names, plus-addressing in email, non-Latin characters.
- A multi-step form with no indication of how many steps remain.

## What to check in code

```
onSubmit|handleSubmit|disabled=|required|zodResolver|yup|maxLength|pattern=|aria-invalid|aria-describedby
```

For each form in scope, walk the six rules in order. Check that error messages are wired to their input via `aria-describedby` and that invalid fields carry `aria-invalid`, otherwise the error exists visually but not for assistive tech.

Cross-check with `error-states.md`: form errors belong inline, next to the field, never in a toast.
