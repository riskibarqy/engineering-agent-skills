# Agent Skills

Reusable AI agent skills for engineering workflows. Designed for Claude, Codex, Cursor, Gemini CLI, and other AI coding agents.

## Skills

[Task assessment](skills/task-assessment/SKILL.md): classify task difficulty before implementation, recommend a Codex model and reasoning level, identify safe cheaper-model subtasks, and define verification. Instruction-only; stops after the assessment.

### ticket-context

Helps an AI agent understand a ticket, inspect repository architecture, ask clarification questions, and prepare safe implementation plan.

Use Clarify Mode first for vague tickets. Use Build Mode only after questions are answered and implementation is explicitly requested.

## Installation

Different clients support different skill/prompt locations. Use method matching your client.

### Claude Code / Generic Agent Skills Directory

Install every skill:

```bash
mkdir -p ~/.agents/skills
cp -r skills/* ~/.agents/skills/
```

This installs every skill directory currently in the checkout. Re-run the command after adding a skill. Adjust the destination if your client uses another skills directory.

### Codex-Style Manual Usage

Open `skills/ticket-context/PROMPT.md`, copy contents into your agent prompt, then paste ticket below it.

```txt
Use ticket-context in Clarify Mode.

Here is the ticket:
[paste ticket]
```

### Cursor / Editor Prompt Usage

Use `skills/ticket-context/PROMPT.md` as reusable project rule, composer prompt, or chat context.

Recommended flow:

1. Paste prompt.
2. Paste ticket.
3. Ask for Clarify Mode first.
4. Switch to Build Mode only after ambiguity is resolved.

### Gemini CLI / Generic CLI Agents

Pass prompt file content before ticket text.

```bash
cat skills/ticket-context/PROMPT.md ticket.md | gemini
```

If your CLI supports system/developer prompts, use `PROMPT.md` there and provide ticket as user input.

### Manual Copy-Paste Fallback

Copy `skills/ticket-context/PROMPT.md` into any agent chat, then paste ticket below it.

Use this when client has no skill directory support.

## Satpam: Install, Use, And Update

Satpam is an instruction-only skill for handling secrets, personal data, and sensitive organization identifiers. It requires no packages, models, services, or Presidio installation. It guides the agent; it is not an automatic data filter and cannot guarantee that every sensitive value is detected.

### Install Satpam Only

Clone or download this repository, then open a terminal in its root directory. For Codex and clients that load skills from `~/.agents/skills`, run:

```bash
mkdir -p ~/.agents/skills/satpam
cp -R skills/satpam/. ~/.agents/skills/satpam/
```

The installed skill file is `~/.agents/skills/satpam/SKILL.md`. If your client uses another skills directory, use that directory instead. Start a new agent session after installation so the client can discover it.

### Use Satpam

In Codex CLI or the IDE extension, explicitly mention the skill:

```text
$satpam Help debug this configuration. Inspect code and schemas first.
If local values are necessary, report only presence, shape, and validation
status. Do not expose credentials or personal data.
```

In other clients, select Satpam through the client's skill interface or ask the agent to use the installed Satpam skill. Clients may activate it when a task matches its description, but automatic activation is not guaranteed.

Do not paste real secrets to test it. Start with synthetic values. Satpam instructs the agent to keep raw secret-bearing input out of model context, minimize sensitive output, and use metadata-only inspection when safe redaction cannot be established.

### Update An Existing Installation

If you installed from a Git clone, run this from a clean repository checkout to fetch the latest published changes:

```bash
git pull --ff-only
```

If you downloaded an archive instead, download and extract the latest version first. Then, from the updated repository root, repeat the copy command:

```bash
mkdir -p ~/.agents/skills/satpam
cp -R skills/satpam/. ~/.agents/skills/satpam/
```

Copying overwrites installed files with the same names. Back up any personal edits before updating; updates to the checkout do not automatically update the installed copy. The copy does not delete extra files you added. Start a new agent session afterward to load the updated instructions.

To check that the installed instructions match this checkout:

```bash
cmp skills/satpam/SKILL.md ~/.agents/skills/satpam/SKILL.md
```

No output and exit status 0 means the files match.

## Usage

### Clarify Mode

Use for vague tickets, PRDs, bugs, or feature requests.

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect related codebase first.
Ask questions before implementation.
Do not write code yet.
```

### Build Mode

Use only when requirements are clear and you want implementation.

```txt
Use ticket-context skill in Build Mode.

Here is the ticket:
[paste ticket]

Inspect related codebase first.
Implement minimal safe change.
Add/update relevant tests.
```

## Validate

```bash
./scripts/validate.sh
```

## Structure

```txt
README.md
LICENSE
.gitignore
scripts/
  validate.sh
skills/
  satpam/
    SKILL.md
  ticket-context/
    SKILL.md
    PROMPT.md
    examples/
      clarify-mode.md
      build-mode.md
      realistic-ticket-example.md
```
