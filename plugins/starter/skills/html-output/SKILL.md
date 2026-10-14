---
name: html-output
description: Use when producing a substantial deliverable (plan, review, research report, comparison) or when asked for HTML output
---

# HTML output

A long deliverable reads better as a page in the browser than as terminal scrollback: tables
line up, severity shows as colour, and the reader can keep the file. The page is the
deliverable; the terminal only points to it. Anything that fits on one screen, or is meant to
be pasted into a PR, issue or chat, stays as plain text.

## Producing the file

1. Copy [template.html](template.html). Add CSS only inside its marked `/* page-specific CSS */`
   zone; everything above it stays as it is.
2. Keep it one self-contained file that makes no network request when opened. Diagrams are
   inline SVG, images are base64 `data:` URIs.
3. Write it to the session scratchpad directory if the system prompt names one, otherwise to
   `${TMPDIR:-/tmp}`, as `<slug>-<timestamp>.html`. Never inside the repository.
4. Open it: `open <path>` on macOS, `xdg-open <path>` elsewhere.
5. The terminal message is the absolute path plus a one- or two-line verdict. The findings live
   in the page only; repeating them in the terminal means nobody opens the page.

## What the page contains

- **Lead:** the `.lead` paragraph states the verdict and what the reader must decide or do, once.
  Later sections expand on it and never repeat it as a summary.
- **Body:** one `h2` per decision the reader has to make, usually three or four, ordered by
  importance to the reader. At most about 800 words visible without expanding anything.
- **Evidence:** each finding gives the one figure or line that carries it plus a pointer (path,
  URL) to the full material. Lists of items go in a collapsed `<details>` below it, one line each.
- **Tables:** open tables stay under 8 rows; longer ones go into a `<details>`.
- **Severity:** `.badge.ok|warn|danger` inline, `.callout.ok|warn|danger` for a block.
- **Visuals:** only when they show something stated nowhere else on the page.
