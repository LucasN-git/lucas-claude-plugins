# Framework blocks for ~/.claude/CLAUDE.md

- [English](#english): the eight blocks in English.
- [German](#german): the same eight blocks in German.

Copy the blocks of the chosen language verbatim, including the sentinel comments. A block
that is already present is replaced between its sentinels. Text outside the sentinels stays
untouched.

## English

```markdown
<!-- starter:agents -->
## Agents
Subagents run on their own model, not automatically the coordinator's. A small model for
find-and-report work (searching, listing, reading logs), a large one for anything that
judges or changes code. Several short agents with different angles, including one arguing
against the plan, beat one long agent.
<!-- /starter:agents -->

<!-- starter:finishing -->
## Finishing work
A change is done when a review has run over it and, if it touched a user interface, the
screen was clicked through in a real browser. Everyday work gets one starter:quick-review
pass; above the threshold the project's own CLAUDE.md names, starter:review runs instead.
Do not stop before both are clean.
<!-- /starter:finishing -->

<!-- starter:git -->
## Git
Never merge or push to the production branch on your own. Finished work lands in the local
main branch and stays there unpushed, an open pull request stays open. Going live happens
only on an explicit command, and then in one go without further questions.
<!-- /starter:git -->

<!-- starter:docs -->
## Docs
After a change to behavior, schema or architecture, update the affected docs in the same
commit: project CLAUDE.md, README, migration comments. Write them as the current state
("the table holds ..."), never as a log of what was changed.
<!-- /starter:docs -->

<!-- starter:foreign-systems -->
## Foreign systems
Anything this project does not own is read-only until someone decides otherwise. No writes
to another system's database, no test row, no quick fix. Enforce it technically, with a
read-only connection flag or a hook, so an accidental write fails instead of landing. An
intention is not protection.
<!-- /starter:foreign-systems -->

<!-- starter:answer-style -->
## Answer style
Answer at the level of the problem and the decision, not at the level of file and variable
names. Bullets over prose, one thought per line. No preamble that repeats the question, no
closing summary. Name an identifier only when it carries the answer.
<!-- /starter:answer-style -->

<!-- starter:memory -->
## Memory
One fact per memory file, with the index pointing at them. Worth saving: feedback, a
constraint that is not written down anywhere, a decision and its reason. Not worth saving:
anything the repository already states.
<!-- /starter:memory -->

<!-- starter:skills -->
## Skill triggers
Writing or editing a skill, a subagent or a CLAUDE.md: read starter:writing-skills first.
After building a user-facing page or its copy: starter:remove-ai-tells. Before reporting a
change as done: starter:quick-review, or starter:review above the project's threshold. A
substantial deliverable (plan, review, report, comparison): starter:html-output.
<!-- /starter:skills -->
```

## German

```markdown
<!-- starter:agents -->
## Agenten
Subagenten laufen auf einem eigenen Modell, nicht automatisch auf dem des Koordinators. Ein
kleines Modell fürs Suchen, Auflisten und Logs lesen, ein großes für alles, was urteilt oder
Code ändert. Mehrere kurze Agenten mit verschiedenen Blickwinkeln, darunter einer, der gegen
den Plan argumentiert, bringen mehr als ein langer.
<!-- /starter:agents -->

<!-- starter:finishing -->
## Fertig ist eine Änderung erst
Wenn ein Review darüber gelaufen ist und, sofern eine Oberfläche betroffen war, der Bildschirm
im echten Browser durchgeklickt wurde. Für Alltagsarbeit reicht ein Durchgang
starter:quick-review; oberhalb der Schwelle, die die CLAUDE.md des Projekts nennt, läuft
stattdessen starter:review. Vorher nicht aufhören.
<!-- /starter:finishing -->

<!-- starter:git -->
## Git
Nie von selbst auf den Production-Branch mergen oder pushen. Fertige Arbeit landet im lokalen
main-Branch und bleibt dort ungepusht, ein offener Pull Request bleibt offen. Live geht es nur
auf ausdrückliches Kommando, dann aber in einem Zug ohne weitere Rückfragen.
<!-- /starter:git -->

<!-- starter:docs -->
## Dokumentation
Nach einer Änderung an Verhalten, Schema oder Architektur die betroffene Doku im selben Commit
nachziehen: CLAUDE.md des Projekts, README, Migrationskommentare. Immer als aktuellen Zustand
formuliert ("die Tabelle hält ..."), nie als Protokoll dessen, was geändert wurde.
<!-- /starter:docs -->

<!-- starter:foreign-systems -->
## Fremde Systeme
Was diesem Projekt nicht gehört, wird nur gelesen, bis jemand anderes entscheidet. Kein
Schreibzugriff auf die Datenbank eines anderen Systems, keine Testzeile, kein schneller Fix.
Technisch erzwingen, über eine schreibgeschützte Verbindung oder einen Hook, damit ein
versehentlicher Schreibvorgang scheitert statt zu landen. Ein Vorsatz schützt nicht.
<!-- /starter:foreign-systems -->

<!-- starter:answer-style -->
## Antwortstil
Auf der Ebene des Problems und der Entscheidung antworten, nicht auf der von Datei- und
Variablennamen. Stichpunkte statt Fließtext, ein Gedanke pro Zeile. Kein Vorspann, der die
Frage wiederholt, keine abschließende Zusammenfassung. Einen Bezeichner nur nennen, wenn er
die Antwort trägt.
<!-- /starter:answer-style -->

<!-- starter:memory -->
## Memory
Ein Fakt pro Memory-Datei, der Index zeigt darauf. Festhalten lohnt sich bei Feedback, bei
einer Einschränkung, die nirgends steht, und bei einer Entscheidung samt Grund. Nicht
festhalten, was das Repository ohnehin schon sagt.
<!-- /starter:memory -->

<!-- starter:skills -->
## Skill-Auslöser
Wer einen Skill, einen Subagenten oder eine CLAUDE.md schreibt oder ändert, liest vorher
starter:writing-skills. Nach dem Bau einer Seite für Nutzer oder ihrer Texte:
starter:remove-ai-tells. Bevor eine Änderung als fertig gemeldet wird: starter:quick-review,
oberhalb der Projektschwelle starter:review. Ein größeres Arbeitsergebnis (Plan, Review,
Bericht, Vergleich): starter:html-output.
<!-- /starter:skills -->
```
