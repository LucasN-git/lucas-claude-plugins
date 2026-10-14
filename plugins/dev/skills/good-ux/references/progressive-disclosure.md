# Progressive disclosure

## Decision rule

Show what the user needs at the current step. Nothing is removed, it is just not thrown at them all at once.

The analogy: a navigation system calls out one turn at a time. Nobody wants all 35 turns listed before leaving the driveway, even though the full route is exactly the same information.

## Patterns

**Reveal on intent.** Notion hides an enormous feature set behind the slash key. The insert menu appears when asked for, then narrows as the user keeps typing. The surface stays calm while the capability stays complete.

**Layer by frequency.** Primary action visible, secondary actions one click away, rare and dangerous actions behind an explicit menu. Sort by how often each is used, not by how impressive it is.

**Defaults over dialogs.** A sensible default with an "adjust" affordance beats a settings panel presented up front.

**Group and label.** When many options must coexist, group them into labelled sections so the eye can skip whole blocks instead of reading every item.

## The failure this prevents

A dropdown so long it scrolls, where a genuinely useful option sits at the bottom and never gets found, because attention lands on the first item. Higgsfield's generation menus are the example from the source: the creator only discovered the motion graphic option while recording a video about the site.

## The counter-rule

Do not hide core functionality so deep that people need a tutorial. Progressive disclosure is a hierarchy, not a hiding place. If a feature is central to the job the product does, it stays visible even when the menu gets crowded.

Signals you overdid it: support questions asking where a basic function went, analytics showing a shipped feature at near-zero usage, or your own onboarding needing to explain where things live.

## What to check in code

There is no reliable grep for this one, so read the rendered surface instead of the source. Count the interactive elements visible on first paint for a given screen, and ask three questions:

1. Which of these does the user need for the primary job of this screen?
2. Which are shown only because they were easy to add here?
3. Is anything critical currently behind two or more interactions?

Findings from this reference are usually medium or low severity, unless a core function is genuinely unreachable, which makes it high.
