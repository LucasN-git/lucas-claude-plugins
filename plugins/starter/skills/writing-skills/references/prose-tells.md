# Prose tells

1. [Words and phrases](#words-and-phrases)
2. [Structure](#structure)
3. [Form](#form)

A tell is text that reads as machine-written. Each row names the pattern and the fix.
Apply to skill bodies, subagent bodies, CLAUDE.md, and anything a skill makes an agent
write for a human.

## Words and phrases

| Tell | Fix |
| --- | --- |
| Em-dash in running text ("the build fails — usually on cache") | Period, comma, parentheses, or a new sentence. In tables and code it is fine |
| "not only X but also Y" | Two statements. "It caches. It also retries." |
| "more than just", "far more than", "not merely" | Say what it is. Drop the comparison |
| "It's worth noting", "It's important to note", "Note that" | Delete the frame, keep the fact |
| "In essence", "At its core", "Ultimately", "Fundamentally" | Delete. If the sentence needs it, the sentence before it failed |
| "Let's dive in", "Let's explore", "Buckle up" | Delete |
| Unbacked superlatives: revolutionary, seamless, robust, powerful, cutting-edge, best-in-class | A number, a concrete noun, or nothing |
| "leverage", "utilize", "delve into", "unlock", "empower" | use, dig into, enable. Plain verb |
| Sentence-initial "Additionally", "Moreover", "Furthermore" | Start with the subject. The order already implies the link |
| Hedge stacks: "may potentially", "could possibly", "might perhaps" | One hedge or none. "may fail" |
| "In today's fast-paced world", "As we all know" | Delete the opener, start at the fact |

## Structure

| Tell | Fix |
| --- | --- |
| Tricolon for rhythm: three parallel clauses because three sounds good | Write the number of items the content has. Two is fine, four is fine |
| Exactly three items in every list, section and example set | Vary the count. If every group has three, the shape is driving the content |
| Mirrored contrast as a heading: "Clarity, not cleverness" | Name the thing. "Naming rules" |
| Rhetorical question as a heading: "Why does this matter?" | State the answer as the heading |
| Subtitle stack: heading, then a one-line tagline, then another line before the body | One heading, then the body. A single caption under a number is allowed |
| Bulleted list where one sentence carries it | Write the sentence |
| Bolded first words in every bullet, used as pseudo-labels | Bold only where a label is genuinely being defined, and not in every bullet |
| Emoji as bullet markers or section icons | Plain bullets and plain headings |
| Opening sentence that restates the question or the task | Start with the answer |
| Closing sentence that recaps what was just said ("In summary", "To wrap up") | End on the last real point |
| A paragraph whose only job is to announce the list below it | Delete it. The list stands on its own |

## Form

Short sentences. One idea each. Break a sentence with two commas into two sentences.

Active voice. Name the actor: "the hook blocks the push", not "the push is blocked".

Numbers over adjectives. "Under 150 lines" beats "concise". "Three retries, 2s apart"
beats "resilient retry logic".

One term per concept, reused. Do not alternate between field, box, and element for the
same thing.

No preamble and no recap. The first sentence carries information, and the last sentence
is the last point, not a summary of the points above it.

Delete before rewriting. A line that only smooths the transition between two other lines
is the line to cut first.
