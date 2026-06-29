---
name: slacksearch-cli
description: Help end users run and use the `slacksearch` command-line tool, including installation assumptions, config file setup, Slack authentication, search filters, output formats, server mode, and troubleshooting CLI usage. Use only for end-user support; do not use for planning, implementation, source code, tests, CI, code review, or repo-local development work.
---

# Slacksearch CLI

## Scope

Support people who are using `slacksearch` as a command-line tool. Focus on how to run commands, configure the CLI, authenticate with Slack, choose search filters, read output, and troubleshoot user-facing errors.

## CLI Shape

`slacksearch` is a command-line tool that searches Slack messages and reads config from `~/.slacksearch/slacksearch.jsonc`.

Commands:

- `slacksearch search [filters] <query>`
- `slacksearch make-config`
- `slacksearch validate-config`
- `slacksearch auth`
- `slacksearch server`

Current command details:

- `search`, `make-config`, `validate-config`, and `auth` accept `--config <path>`.
- `search` accepts `--before`, `--after`, `--search-channel`, `--search-chat`, `--text`, `--json`, `--markdown`, `--api-base-url`, `--page-size`, and `--max-results`.
- `make-config` refuses to overwrite existing config unless `--force` is passed.
- `server` accepts `--bind` and defaults to `127.0.0.1:3000`.

Default generated example config must contain only a placeholder top-level `slack_web_api_token` and must be free of credentials.

## End-User Guidance

- Prefer examples that users can paste into a shell.
- Show the default config path unless the user is using `--config <path>`.
- Use `slacksearch make-config` for first-time setup and `slacksearch validate-config` when checking configuration.
- Use `slacksearch auth` when the user needs to capture or update their Slack Web API token.
- Recommend `--json` for scripting, `--markdown` for readable copied output, and the default text output for terminal use.
- Mention `--api-base-url` only for private deployments or a user-provided compatible Slack API endpoint.
- Treat Slack tokens and message content as sensitive. Do not ask users to paste real tokens or private Slack messages unless strictly necessary, and redact examples.

## Slack Search Notes

- Do not use App Configuration Tokens as Slack Web API access tokens. Treat them as app configuration/bootstrap material only unless current official Slack documentation proves otherwise.
- For broad user-visible search across DMs, group DMs, private channels, and public channels, the Slack token must have access to the content being searched and the required Slack search capability.
- If users hit rate limits, advise waiting and retrying with narrower filters, smaller `--page-size`, or lower `--max-results`.
