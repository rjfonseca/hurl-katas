# Contributing Guide

Thank you for your interest in contributing to **Hurl Katas**!
This project is designed to help developers practice TDD using incremental phases and interactive workflows.
To keep the repository organized and consistent, please follow the guidelines below.

---

## 📁 Repository Structure

```
hurl-katas/
├─ katas-catalog/
│   ├─ scaffold/                # Global scaffold applied during kata init
│   └─ <kata-name>/             # Each kata lives in its own directory
│       ├─ scaffold/            # Optional kata-specific scaffold
│       └─ phases/              # Ordered *.hurl test phases (01-*, 02-*, ...)
│
├─ .kata/                       # Auto-generated working directory (ignored)
│
└─ scripts/kata                 # Main CLI used for interactions
```

You only need to edit files under:

* `katas-catalog/<kata-name>/`
* `katas-catalog/scaffold/`
* `scripts/kata`

Everything under `.kata/` is ephemeral and must **never** be modified manually.

---

## 🧪 Creating a New Kata

To contribute a new kata, create a directory under:

```
katas-catalog/<kata-name>/
```

### 1. Add Phases

Each kata consists of one or more `.hurl` test files stored in:

```
katas-catalog/<kata-name>/phases/
```

Phases must:

* be plain `.hurl` files
* be ordered lexicographically using a numeric prefix:

  * `01-basic.hurl`
  * `02-edge-cases.hurl`
  * `03-validation.hurl`
* contain one or more Hurl tests each
* target the internal service: `http://api:8000/...`

The CLI uses lexicographic ordering to determine progression.

### 2. Add Optional Kata-Specific Scaffold

If your kata requires additional project files when `kata init` runs, place them under:

```
katas-catalog/<kata-name>/scaffold/
```

They will be merged on top of the global scaffold.

### 3. Keep Kata Phases Minimal

Phases should be:

* incremental
* focused on a single behavior
* designed to encourage TDD, not brute-force coding

Avoid phases that:

* require large codebases
* depend on external services
* introduce massive amounts of boilerplate

---

## 🐋 Editing the Global Scaffold

Global scaffold files live in:

```
katas-catalog/scaffold/
```

These files are copied to the project root on `kata init`.
Contributors may update these files if changes improve:

* portability
* clarity
* Docker reliability
* developer experience

Any change should be backwards-compatible with existing katas.

---

## 🛠 Modifying the CLI (scripts/kata)

If you wish to update the CLI script:

### Guidelines

* Maintain compatibility with non-interactive shells.
* Preserve interactivity: `gum choose`, `gum confirm`, etc.
* Ensure all user decisions echo clear explanations.
* Keep `.kata/state` consistent and minimal.
* Use defensive Bash practices (`set -uo pipefail`).
* Test against `shellcheck` when possible.

### Prohibited

* Adding dependencies outside Bash + gum + docker compose.
* Removing interactive prompts.
* Introducing persistent state outside `.kata/state`.

---

## 🧹 Code Style & Quality

* Hurl tests should be readable and explicit.
* Docker Compose services must remain simple and portable.
* CLI patches should be small and focused.
* Commit messages must follow **Semantic Commit Messages**. When the change affects a specific kata, use the kata name as the **scope**.

Examples:

* `feat(scaffold): add new global file`
* `fix(cli): improve next-phase detection`
* `feat(hello-world): refine POST phase`

---

## 🧪 Testing Your Changes

After contributing:

### Test a kata manually

```
./scripts/kata init <kata>
./scripts/kata run
./scripts/kata next
```

### Validate scaffold merging

Ensure:

* no accidental file overwrites
* prompts appear correctly
* global + kata-specific scaffolds merge cleanly

### Test the rerun loop

Introduce a failing expectation intentionally and confirm:

* gum prompts for rerun
* rerun works
* abort works

---

## 🤝 Submitting Contributions

Before submitting a PR:

1. Ensure no changes were made manually under `.kata/`.
2. Run through at least one full kata to ensure UX flow.
3. Provide clear commit messages.
4. Document new katas with a short description if applicable.

---

## ☕️ Final Words

We welcome contributions that make the kata platform:

* clearer
* more interactive
* more educational
* more enjoyable for developers

Thanks for helping build a better TDD practice environment!
