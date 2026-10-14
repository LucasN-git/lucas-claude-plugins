# Error states

## Decision rule

Placement follows severity. The test question for any error: if the user looks away for three seconds and misses this, are they still fine?

| Placement | Use when | Consequence of misuse |
|---|---|---|
| Toast | Missing it costs nothing. "Couldn't connect, retrying" | An important error auto-dismisses and the user never learns why their work vanished |
| Modal | The user genuinely cannot continue until they act | Interrupts flow for something that did not need an interruption |
| Inline | Anything tied to a specific element, which is most errors | Error appears far from the cause and the user hunts for it |

The general rule underneath all three: the closer the error sits to the thing that went wrong, the better.

## Patterns

**Inline.** A red border and a message on the field that needs correcting. "Try again" beside the button that just failed, because the user's eyes are already there. Never make someone scroll to find out what broke.

**Modal.** Only for blocking conditions, and always with a way forward. Payment failed, so offer a button to update the payment method. No access to this project, so offer a button to request access. A modal that states a problem and offers only "OK" is a dead end.

**Toast.** Transient, recoverable, informational. Retrying a connection, an autosave that will retry, a background sync notice.

## Writing the message

Say what happened and what the user can do. "Something went wrong" fails both. Name the object ("Could not save the note"), then the action ("Retry" or "Copy your text so it is not lost"). Keep technical detail behind a disclosure for anyone who wants it, and log the real error rather than showing a stack trace.

## Anti-patterns

- Critical failure delivered by toast.
- Blocking modal with no action other than dismiss.
- A single full-page error for a failure that only affected one region. See `partial-states.md`.
- Clearing the user's input as part of the error. Never destroy typed work on failure.
- An error state that is styled so quietly it is mistaken for helper text.

## What to check in code

```
isError|onError|catch \(|error\.tsx|ErrorBoundary|toast\.|showToast|Alert|role="alert"|aria-live
```

Per finding, check three things: is the placement right for the severity, does the message name an action, and does the failure leave the rest of the page usable. Also confirm errors are announced to assistive tech (`role="alert"` or an `aria-live` region), otherwise screen reader users get nothing at all.
