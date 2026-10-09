# which-skill

Skill de Claude Code que **recomienda**, no ejecuta: lee el hilo en curso y lo
pendiente, barre todas las skills instaladas y devuelve hasta 5 candidatas con
*por qué acá* y *costo*, para que el usuario elija. Si detecta un hueco de
expertise, dispara `find-skills` y propone qué sumar, sin instalar nada.

## Instalar

```bash
npx skills add TomasPinolini/which-skill -g      # o: git clone … ~/.claude/skills/which-skill
```

Después, dos ajustes que son tuyos:

1. **El mapa es personal.** La sección `## Mapa` de `SKILL.md` lista las skills de
   *mi* máquina agrupadas por área. Reescribila con las tuyas: el procedimiento
   (pasos 1–5) es genérico, el mapa no. Es la única forma de que el agente vea las
   skills con `disable-model-invocation: true`, que no aparecen en su contexto.
2. **Hook opcional.** `check.sh` avisa al abrir sesión qué skills instaladas faltan
   en el mapa. En `~/.claude/settings.json`, dentro de `hooks.SessionStart`:

   ```json
   { "matcher": "*", "hooks": [ { "type": "command",
     "command": "sh \"$HOME/.claude/skills/which-skill/check.sh\"", "timeout": 10 } ] }
   ```

   Skills que no querés mapear van en `ignore.txt`, una por línea.

## Uso

```
/which-skill                      # infiere el caso de la conversación
/which-skill migrar la DB sin downtime   # caso explícito
```

Escrito siguiendo `writing-for-agents` (Matt Pocock). Licencia MIT.
