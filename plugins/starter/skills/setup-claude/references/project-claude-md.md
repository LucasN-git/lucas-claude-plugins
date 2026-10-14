# Project CLAUDE.md template

Facts about this one repository. How to work in general belongs in the global file, not here.
Fill every angle-bracket slot and delete the lines that do not apply. Keep it short. A file
nobody can hold in their head stops being read.

```markdown
# <project name>

<one sentence: what this does and for whom>

## Stack

<framework and version>, <database>, <hosting>. Package manager: <pnpm|npm|uv|...>.

## Commands

- Install: `<command>`
- Run locally: `<command>` (serves on <url>)
- Tests: `<command>`
- Lint and types: `<command>`
- Build: `<command>`

## Branches and deploy

Production branch: `<main>`. <what a push to it triggers>
Feature work branches off `<main>` and returns through <pull request|direct merge>.
<staging environment and how to reach it, or: there is none>

## Review threshold

`/starter:review` runs for a change that <touches the schema, auth, payments, or several
modules at once>. Everything smaller ends with one `quick-review` pass.

## Gates

One shell command per line in the code block, run exactly as written by the review before
and after fixes. `<changed-tests>` is filled from the diff; an empty placeholder means not
applicable. A `merge-only:` line runs once on the final tree. No section means no gates defined.

```sh
<lint command>
<typecheck command>
<test command> <changed-tests>
merge-only: <full test suite>
```

## Foreign systems

- `<system>`: <read-only|owned by this project>. <how read-only is enforced>
- `<system>`: <same>

## Things that surprise people

- <a trap that has cost time already, one line each>
```
