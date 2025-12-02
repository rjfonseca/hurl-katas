# Hurl Katas

This repository provides an interactive, TDD‑driven kata environment built on top of **Hurl**, **Docker Compose**, and a custom CLI written in Bash. Each kata is composed of multiple phases, each represented by a `.hurl` test file. The goal is to progress through all phases by passing tests incrementally.

The CLI enhances the workflow with interactivity via **gum**, optional auto‑commits, automatic log management, and phase navigation.

---

## ⚙️ How It Works

### Overall Structure

```
hurl-katas/
│
├─ katas-catalog/              # All available katas
│   ├─ scaffold/                # Global scaffold applied to any new kata
│   └─ <kata-name>/
│       ├─ scaffold/            # Kata-specific scaffold
│       └─ phases/              # Ordered *.hurl files (01-..., 02-..., ...)
│
└─ .kata/                      # The working directory created by the CLI
    ├─ phases/                 # Copy of all phases for the selected kata
    ├─ active/                 # Currently enabled phases
    ├─ logs/                   # Per-phase logs from last run
    └─ state/                  # kata_name, last_status, last_run_ts
```

### Runtime Architecture

All tests are executed **inside Docker**, using:

```
docker compose exec hurl hurl /tests/<phase>.hurl
```

Your application should be added to `compose.yml` under the service name `api`, exposing port `8000` internally. Tests reference it as:

```
http://api:8000/...
```

---

## 🧪 CLI Commands

All commands are invoked via:

```
./scripts/kata <command>
```

### `kata init <name>`

Initialize a kata.

* Applies global scaffold
* Applies kata-specific scaffold
* Copies all phases into `.kata/phases`
* Activates the first phase
* Updates state
* Offers to run the first test immediately

If called without `<name>`, gum presents an interactive menu.

### `kata run`

Runs all **active** phases.

* Logs stored in `.kata/logs/phase-XX.log`
* Status saved in `.kata/state`
* On failure: offers **rerun**
* On success: offers **next phase** automatically

### `kata next`

Enables the next phase.

* Detects dirty git tree
* Offers **autocommit** or **abort**
* Once all phases are completed, prints a celebratory nerd message

### `kata prev`

Disables the last enabled phase.

### `kata goto <phase>`

Activates all phases up to the selected one.

* If `<phase>` is omitted, gum shows an interactive list

### `kata status`

Shows current kata status, active phases, and timestamps.

---

## 🐋 Docker Compose

The global scaffold must include a file:

```
katas-catalog/scaffold/compose.yml
```

This file defines the `hurl` service and comments guiding the user to add their own `api` service. Example snippet:

```yaml
services:
  hurl:
    image: ghcr.io/orange-opensource/hurl:latest
    working_dir: /tests
    volumes:
      - ./.kata/active:/tests:ro
    entrypoint: ["tail", "-f", "/dev/null"]

#  api:
#    image: golang:1.25-alpine
#    working_dir: /go/src
#    volumes:
#      - ./:/go/src:ro
#    entrypoint: ["go", "run", "./cmd/api"]
```

---

## ✨ Interactive Workflow

The CLI is intentionally interactive:

* `kata init` asks if you want to run immediately
* `kata run` loops on failures with **rerun** option
* `kata next` confirms auto-commits
* `kata goto` allows interactive phase selection

This enables fast iteration without returning to the shell.

---

## 📁 Example Kata (hello-world)

Your catalog may include katas like `hello-world` with two phases:

1. **GET** `/hello` → expect `"hello world!"`
2. **POST** `/hello` with `{ "name": "X" }` → expect `"hello X!"`

These phases are stored in:

```
katas-catalog/hello-world/phases/
```

---

## 🧙‍♂️ Best Practices for Agents (AGENTS.md Summary)

* Only use CLI commands (`kata init/run/next/...`) — avoid modifying `.kata/` manually
* Do not edit scaffold files unless explicitly instructed
* Use interactive prompts instead of assuming state
* When the repo is dirty: prefer `autocommit` instead of branching

(Full details are in `AGENTS.md`.)

---

## 🐾 Contributing

* New katas go under `katas-catalog/<kata-name>/`
* Phases must be numbered lexicographically (01-, 02-, 03-...)
* Keep CLI changes compatible with non-interactive shells too

---

## ☕️ Final Notes

This environment is designed for **incremental, interactive, TDD-centered practice**.
Have fun, refactor boldly, and enjoy watching the phases turn green!
