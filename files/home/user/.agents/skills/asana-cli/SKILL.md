---
name: asana-cli
description: "Help end users use the asana CLI. Use for questions about installing or running the `asana` command, creating or validating config, dry-run versus live mode, command syntax, output formats, Asana operation calls, attachment upload, webhook operations, mock-server usage, and generating this end-user skill into another repository."
---

# Asana CLI

Use this skill to answer end-user questions about the `asana` command. Keep guidance focused on how to run the CLI and interpret its output. Avoid implementation details about the Rust codebase, generated registries, tests, or local source files unless the user explicitly asks how the tool is built.

## Core Facts

- Binary name: `asana`.
- Home config path: `~/.asana/asana.jsonc`.
- Example config path: `examples/.asana/asana.jsonc`.
- The example config defaults to `dryrun`, which validates requests and prints what would be sent without network I/O.
- `live` mode sends requests to Asana using `Authorization: Bearer <token>`.
- Asana API base URL defaults to `https://app.asana.com/api/1.0`.
- `--json` is the default output mode for `asana cmd`.

## Command Families

- `asana cmd`: run an Asana REST operation by OpenAPI operation ID.
- `asana server`: run the local resettable mock Asana API server.
- `asana util make-config`: create a home-directory example config.
- `asana util validate-config`: validate config.
- `asana util status`: print redacted config and optional live status.
- `asana util make-skill <codex|claude>`: copy project skills into the current repo.

## Config Workflow

Create the home config:

```sh
asana util make-config
```

Validate it:

```sh
asana util validate-config
```

Inspect status with token redaction:

```sh
asana util status
```

Use `dryrun` until the user is ready to make live Asana changes. In dry-run mode, `asana cmd` still validates arguments and request bodies, then renders a redacted request preview.

## Operation Syntax

- Run operations by operation ID, for example `getTask`, `createTask`, `getWebhooks`, or `createAttachmentForObject`.
- Path and query parameters use named double-hyphen args such as `--task_gid`, `--workspace`, `--limit`, or `--opt_fields`.
- JSON request bodies are passed as one stringified JSON value through `--body`.
- Asana write request bodies generally use a top-level `data` object.
- Attachment upload uses `--file` plus operation-specific form fields, usually including `--parent`.
- Use `--markdown` or `--text` for alternate output when the user wants human-readable output.
- Use `cmd --base-url <url>` to point commands at `asana server` or another compatible API endpoint.

Examples:

```sh
asana cmd getWorkspaces
asana cmd getTask --task_gid 1200123456789
asana cmd createTask --body '{"data":{"workspace":"1200123456789","name":"Follow up"}}'
asana cmd getTasks --workspace 1200123456789 --limit 10 --opt_fields name,completed,permalink_url
asana cmd createAttachmentForObject --parent 1200123456789 --file ./report.pdf
```

## Mock Server

Start a local mock API:

```sh
asana server --host 127.0.0.1 --port 0
```

The server prints a base URL like `http://127.0.0.1:54321/api/1.0`. Pass that URL to `cmd`:

```sh
asana cmd --base-url http://127.0.0.1:54321/api/1.0 getWorkspaces
```

Mock data is stored under `.asana/data/` unless `--data-dir` is provided. Managed mock files are reset on startup and graceful shutdown while unrelated files in the data directory are left alone.

## Skill Generation

Copy this end-user skill into another repository:

```sh
asana util make-skill codex
asana util make-skill claude
```

The command writes `.codex/skills/asana-cli/SKILL.md` or `.claude/skills/asana-cli/SKILL.md` under the current Git repository root. An existing destination `asana-cli` skill directory is replaced.
