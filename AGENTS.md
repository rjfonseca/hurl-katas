# AGENTS.md

This document describes how AI agents (or automated tools) should interact with the **Hurl Katas** repository. The goal is to ensure safety, reproducibility, and consistency when agents participate in Hurl Katas development or execution.

Agents must follow these rules carefully to avoid corrupting user progress or damaging the repository scaffolds.

---

## 1. General Principles

### **Do not modify state manually**

Agents must **never edit** any file under:

```
.kata/state/
.kata/active/
.kata/logs/
```

These directories are fully managed by the CLI and are considered ephemeral.

### **Do not modify scaffold files unless explicitly asked**

Agents should not edit files under:

```
katas-catalog/scaffold/
katas-catalog/<kata>/scaffold/
```

unless explicitly instructed.

These files define the behaviour of all katas and should be treated as stable templates.

### **Do not assume the state of the environment**

Agents must **never assume** that `.kata/` is initialized, clean, or aligned with a previous run. Always use CLI commands to query or update state.

---

## 2. Allowed Commands for Agents

Agents may run the following commands:

### `./scripts/kata init`

* If selecting a kata, agents should defer to interactive gum menus **unless instructed**.
* After running `./scripts/kata init`, agents may accept or decline the optional first run.

### `./scripts/kata status`

* Safe for agents to read current state.
* Useful to determine which phase is active.

### `./scripts/kata run`

* Agents may run tests normally.
* On failure, the agent should follow user instructions on whether to rerun.
* Must not attempt to modify test files or `.kata/active`.

### `./scripts/kata next`

* Agents may advance to the next phase.
* If the Git tree is dirty, agents may select `autocommit`.
* Agents must not manually commit changes.

### `./scripts/kata goto <phase>`

* If the phase is not provided, agents should allow `gum` to prompt.
* Agents must not manually alter `.kata/active`.

### `./scripts/kata prev`

* Agents may roll back a phase.

---

## 3. Forbidden Actions for Agents

### ❌ Manual file changes

Agents must not:

* Edit `.kata/active/*`
* Edit `.kata/state/*`
* Edit `.kata/logs/*`
* Edit Hurl test files inside a kata unless explicitly instructed

### ❌ Running Hurl directly

Do **not** run:

```
hurl *.hurl
```

or alternative invocations.

Tests must always be executed using the Docker Compose pipeline:

```
./scripts/kata run
```

which calls:

```
docker compose exec hurl hurl /tests/<phase>.hurl
```

### ❌ Modifying Docker or Compose configuration

Agents must not edit `compose.yml` without explicit instructions.

---

## 4. Workflow Recommendations for Agents

### **Use interactive confirmation when possible**

Agents must prefer using CLI decisions instead of guessing user intent.

### **Prefer incremental updates**

Never jump ahead multiple phases by manipulating `.kata` manually.
Always use:

```
./scripts/kata next
```

or:

```
./scripts/kata goto <phase>
```

### **Respect user refactoring**

Agents must never force a `next` operation unless the state indicates all active phases passed.

The user may intentionally be refactoring code without advancing.

---

## 5. Example Agent Scenarios

### Scenario 1: User asks agent to move to next phase

Agent should:

```
./scripts/kata status
./scripts/kata next
```

If git is dirty and `autocommit` is offered, agent may select `autocommit`.

### Scenario 2: User asks agent to re-run tests

Agent simply executes:

```
./scripts/kata run
```

If tests fail, allow the rerun prompt.

### Scenario 3: User asks agent to initialize a kata

Agent should:

```
./scripts/kata init
```

and let gum prompt for selection unless the user explicitly specifies a kata name.

---

## 6. Final Notes

The interactive behavior is **intentional** and agents should embrace it rather than bypass it. All test execution, phase enabling, and state transitions must flow through the CLI.

Following these rules ensures:

* predictable kata progress
* safe collaboration between humans and agents
* reproducible environments using Docker

Agents that respect this document will behave correctly inside the Hurl Katas ecosystem.

