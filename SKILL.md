---
name: which-skill
description: Recomienda las skills que mejor calzan con el hilo actual y lo pendiente, hasta 5, con razón y costo, para que el usuario elija. Router sobre todas las skills de esta máquina.
argument-hint: "[qué querés hacer, en una frase]"
disable-model-invocation: true
---

# Which skill

Recomendador, no catálogo. Encargo explícito: $ARGUMENTS

## Procedimiento

1. **Fijar el caso.** Con `$ARGUMENTS`, ese es el encargo. Sin argumentos, sacalo
   de la conversación: hilo en curso, próxima decisión, tareas abiertas (todo
   list, lo que el usuario dijo que falta). Imprimí una línea `Caso: …`. Si la
   sesión está vacía y no hay argumentos, preguntá en una línea qué quiere hacer
   y terminá.
2. **Barrer el repertorio entero.** Dos fuentes, las dos obligatorias: la lista
   de skills de tu contexto (solo muestra las de invocación por modelo) y el mapa
   de abajo (incluye las de invocación manual, que vos no ves en la lista). Es
   candidata toda skill cuyo disparador calce con el caso, esté o no en el mapa.
   Una skill de la lista sin descripción y sin entrada en el mapa: leé el
   frontmatter de su `SKILL.md` antes de descartarla. Terminado cuando cada área
   del mapa fue considerada contra el caso.
3. **Rankear y recortar.** Hasta 5, de más a menos ajustada. Dos skills que hacen
   lo mismo (p. ej. `/tdd` y `mattpocock-skills:tdd`): una sola, la local. Si el
   caso es una secuencia (grill → spec → implement), presentala como pasos
   numerados, no como alternativas.
4. **Imprimir para elegir.** Por candidata, tres líneas:
   - **`/nombre`** — qué hace, en media línea.
   - *Por qué acá:* el dato concreto del caso que la hace calzar.
   - *Costo:* tiempo aproximado y precondición (repo, red, archivo que debe existir).

   Última línea: la recomendada y cómo dispararla. Si está en tu lista de
   contexto: "decime *dale* y la invoco". Si no (invocación manual): "tipeá
   `/nombre`".
5. **Cubrir los huecos.** Un hueco es una parte del caso que ninguna skill
   instalada cubre con un proceso propio: quedó sin candidata, o solo la cubre
   una persona de rol genérica (`/senior-developer`, `/backend-architect`).
   Por cada hueco, invocá `find-skills` con el dominio y la tarea como consulta
   (p. ej. `supabase migrations`, `playwright e2e`). Imprimí lo que devuelva en
   un bloque aparte, **Para sumar al repertorio**: nombre, qué cubre, instalaciones
   y fuente, comando `npx skills add …`. Instalar queda para después de un *sí*
   explícito del usuario; nunca lo hagas dentro de esta skill. Sin huecos, omití
   el bloque. Si se instala algo, recordá al usuario que entra al mapa de abajo
   (`check.sh` lo va a reclamar en la próxima sesión si no).

## Mapa

Cada skill figura como `/nombre`, el nombre que se tipea. `check.sh` corre en
`SessionStart` y avisa de skills instaladas que este archivo no menciona; las
omitidas a propósito van en `ignore.txt`.

## 1. Engineering: idea → ship

The main flow is Matt Pocock's; **`/ask-matt`** has the full map (on-ramps, phase boundaries, context hygiene). Short version:

1. **`/grill-with-docs`** sharpens the idea (in a repo; leaves `CONTEXT.md` + ADRs). No repo → **`/grill-me`**. Both run the **`/grilling`** primitive. **`/loop-me`** grills specifically about workflows to build in this workspace.
2. Question needs runnable code → **`/handoff`** out, **`/prototype`**, **`/handoff`** back.
3. Multi-session → **`/to-spec`** → **`/to-tickets`** → **`/implement`** per ticket. Single session → **`/implement`** directly (or **`/implement-spec`** when you already hold a written spec). Both drive **`/tdd`** and close with **`/code-review`**.
4. After the session → **`/retro`**.

On-ramps: **`/triage`** (incoming issues), **`/diagnosing-bugs`** (hard bugs), **`/wayfinder`** (huge foggy efforts). Precondition: **`/setup-matt-pocock-skills`**.

**Plan & stress-test before building:** **`/premortem`** (imagine it failed, find why), **`/brainstorming`** (explore intent before creative work), **`/discovery-interview`** (vague idea → spec, also for non-technical people), **`/to-questionnaire`** (the answer is in someone else's head).

**Understand the code:** **`/graphify`** (knowledge graph of a codebase or docs), **`/zoom-out`** (big picture), **`/wait-what`** (last message didn't land), **`/teach`** (learn a concept over sessions).

**Design & health:** **`/improve-codebase-architecture`** (find deepening opportunities), **`/codebase-design`** (deep-module vocabulary), **`/domain-modeling`** (domain language, ADRs), **`/setup-ts-deep-modules`** (enforce module boundaries in TS with dependency-cruiser).

**Simplify (Ponytail):** **`/ponytail`** is the always-on lazy mode. **`/ponytail-review`** (over-engineering in a diff), **`/ponytail-audit`** (whole repo), **`/ponytail-debt`** (ledger of `ponytail:` comments), **`/ponytail-gain`** (impact scoreboard), **`/ponytail-help`** (cheat sheet). Built-in **`/simplify`** reviews and *applies* cleanups on changed code.

**Quality gates & ops** (pick by the question you're asking):
- CI pipeline → **`/ci-cd-and-automation`**
- Pre-commit hooks (Husky, lint-staged) → **`/setup-pre-commit`**
- Block dangerous git in Claude Code → **`/git-guardrails-claude-code`**
- Vulnerabilities → **`/security-and-hardening`** (auditing), built-in **`/security-review`** (pending branch changes)
- Logs/metrics/tracing → **`/observability-and-instrumentation`**
- Going to production → **`/shipping-and-launch`**
- Removing or migrating an API/system → **`/deprecation-and-migration`**
- Mid merge/rebase conflict → **`/resolving-merge-conflicts`**
- Steps only a human can do (secrets, dashboards) → **`/wizard`**
- Test files with `as` casts → **`/migrate-to-shoehorn`**
- Course exercises → **`/scaffold-exercises`**
- Primary-source reading in the background → **`/research`**
- Many sources synthesised into a narrative report → **`/deep-research`**; what people are saying *now* (Reddit, X, HN, YouTube, last 30 days) → **`/last30days`**

**Built-in Claude Code:** **`/init`** (write CLAUDE.md), **`/run`** (launch the app to see a change), **`/loop`** (repeat on an interval), **`/schedule`** (cron cloud agents), **`/workflow-authoring`** (multi-agent workflow scripts), **`/claude-api`** (building on the Claude API), **`/claude-in-chrome`** (drive the browser).

**Role personas** (a specialist voice, not a process; reach for one when you want a domain lens on a question): `/software-architect`, `/backend-architect`, `/frontend-developer`, `/mobile-app-builder`, `/senior-developer`, `/rapid-prototyper`, `/code-reviewer`, `/git-workflow-master`, `/database-optimizer`, `/data-engineer`, `/ai-engineer`, `/ai-data-remediation-engineer`, `/autonomous-optimization-architect`, `/devops-automator`, `/sre-site-reliability-engineer`, `/incident-response-commander`, `/security-engineer`, `/threat-detection-engineer`, `/embedded-firmware-engineer`, `/solidity-smart-contract-engineer`. Prefer a process skill above when one fits.

## 2. Frontend & Vercel

- React/Next.js performance → **`/vercel-react-best-practices`**; component API shape → **`/vercel-composition-patterns`**; animations between states → **`/vercel-react-view-transitions`**; React Native/Expo → **`/vercel-react-native-skills`**
- UI/accessibility review → **`/web-design-guidelines`**
- Deploy → **`/deploy-to-vercel`** (interactive) or **`/vercel-cli-with-tokens`** (token auth); cost/perf of a deployed app → **`/vercel-optimize`**

## 3. This machine: Omarchy, Claude Code, Herdr

- Hyprland, bar, themes, keybindings, terminal config → **`/omarchy`**
- Something crashed / core dump → **`/diagnose-crash`**
- Panes, workspaces, other agents → **`/herdr`**; hand work to a fresh background agent → **`/claude-handoff`**
- Claude Code settings, permissions, hooks → **`/update-config`**; too many permission prompts → **`/fewer-permission-prompts`**; keyboard shortcuts → **`/keybindings-help`**
- Skills: find/install one → **`/find-skills`**; write one → **`/skill-creator`** (build + eval) with **`/writing-for-agents`** (the prose); bring memory from another assistant → **`/import-memory`**
- Resumen de la sesión para retomar o cerrar (hilos, hecho+verificado, pendiente, próximo paso) → **`/recap`**; `/recap guardar` lo anexa a la bitácora del proyecto.
- Browser & desktop control (read the matching one *before* the first tool call): the Claude in Chrome extension (`mcp__claude-in-chrome__*`) → **`/chrome-browser`**; the browser pane inside the Claude desktop app → **`/built-in-browser`**; screenshots, clicks and typing on the desktop itself → **`/computer-use`**. Scope: global, every session under `/home/pinola` (synced from claude.ai).

## 4. Documents & artifacts

- A living doc to share/edit → **`/docs`**. A specific file format → **`/docx`**, **`/pdf`**, **`/pptx`**, **`/xlsx`**.
- A standalone branded diagram as HTML/SVG/PNG (architecture, sequence, ER, Gantt, org chart, redraw a `.drawio`/`.mmd`/`.excalidraw`) → **`/diagram-design`**. Mermaid *inside* a Markdown/Obsidian note → **`/mermaid-diagrams`**.
- A web page artifact → **`/artifact-design`** first; add **`/artifact-diagramming`** for diagrams, **`/artifact-capabilities`** for runtime behaviour, **`/dataviz`** for any chart.
- Writing: **`/writing-fragments`** (explore: mine raw fragments) → **`/writing-beats`** (exploit: assemble into beats) or **`/writing-shape`** (exploit: shape into an article paragraph by paragraph; plugin-only, in progress). Review prose → **`/writing-guidelines`**. Developer docs → **`/technical-writer`**.

## 5. Process capture (relevamiento)

A pipeline, in order:

1. **`/captura-de-proceso`**: build the capture instrument before shadowing or an interview.
2. **`/runbook-canonico`**: turn the capture into the canonical runbook.
3. **`/ramas-del-proceso`**: enumerate the contingencies off the happy path.
4. **`/consulta-a-la-fuente`**: pack the open questions to validate with the source.

## 6. Product & project management

**`/product-manager`** (lifecycle, roadmap), **`/sprint-prioritizer`** (what goes in the sprint), **`/senior-project-manager`** (spec → tasks), **`/project-shepherd`** (cross-team coordination), **`/experiment-tracker`** (design and track experiments), **`/studio-producer`** (portfolio-level orchestration), **`/studio-operations`** (day-to-day efficiency).

## 7. Personal & finance

- Morning brief → **`/morning`**
- Portfolio review on IOL → **`/revision-cartera`**; check an investment idea against your rules before trading → **`/validar-posicion`**

## Router itself

- **`/ask-matt`**: the original router this one extends; still the deepest reference for the engineering flow.
- **`/which-skill`**: this file.
