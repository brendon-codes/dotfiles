---
name: trello
description: Use when working with the trello CLI to manage Trello authentication, boards, lists, cards, labels, search, sync, debug checks, autocomplete, plugins, and interactive terminal mode.
---

# Trello CLI

Use the local `trello` command for Trello work. This skill is generic: do not add project, workspace, board, list, card, user, API key, token, or other local account data to it.

## Safety

- Never print, paste, store, or log Trello API keys or tokens.
- Prefer existing auth from `~/.trello-cli/<profile>/config.json`, `TRELLO_API_KEY`, and `TRELLO_TOKEN`.
- Ask before running credential-writing commands: `trello auth`, `trello auth:api-key <api_key>`, or `trello auth:token <token>`.
- Ask before destructive or broad mutations, including deleting boards/cards/labels, closing boards, archiving cards, archiving lists, archiving all cards in a list, moving all cards, and bulk label/member changes.
- Use placeholder names in examples and plans unless the user provides real Trello names or IDs.
- Treat `trello debug` output as potentially sensitive; redact paths, env vars, and config values before sharing.

## Workflow

1. Run `trello --version` first. This reference matches `trello-cli/1.5.0`; if the installed version differs, re-check `trello --help` and `trello <topic> --help`.
2. Use `trello --help` for top-level commands and `trello card --help`, `trello board --help`, `trello list --help`, `trello label --help`, or exact command help before unfamiliar work.
3. Run `trello sync` when name-to-ID lookups may be stale, after confirming that syncing is acceptable.
4. Prefer `--format json` for commands whose output will be parsed. Use `--format silent` only when a command's result does not need inspection.
5. For ambiguous cards, lists, labels, or boards, prefer IDs or ask for confirmation before mutating.

## Authentication

- `trello auth`: interactive setup that writes config.
- `trello auth:api-key <api_key>`: stores the API key used to generate a token.
- `trello auth:token <token>`: stores the API token used for API calls.
- Config path: `~/.trello-cli/<profile>/config.json`.
- Environment variables: `TRELLO_API_KEY`, `TRELLO_TOKEN`.
- Optional profile selector: `TRELLO_CLI_PROFILE`.

## Common Examples

```bash
trello board:list --format json
trello list:list --board "Board Name" --format json
trello card:list --board "Board Name" --list "List Name" --format json
trello card:create --board "Board Name" --list "List Name" --name "Card Name" --description "Card description"
trello card:move --board "Board Name" --list "List Name" --card "Card Name" --to "Target List Name"
trello search --query "Card Name" --type cards --format json
trello interactive --mouse
```

## Trello Command Reference

Most Trello resource commands accept `--format default|silent|json|csv` with default `default`.

| Command | Purpose | Arguments and flags |
| --- | --- | --- |
| `auth` | Manage authentication credentials | `--format default|silent|json|csv` |
| `auth:api-key` | Set Trello API key | required arg `api_key`; `--format default|silent|json|csv` |
| `auth:token` | Set Trello API token | required arg `token`; `--format default|silent|json|csv` |
| `board` | Board command topic | `--format default|silent|json|csv` |
| `board:create` | Create a board | required `--name, -n`; optional `--description, -d`, `--org`, `--prefs.permissionLevel org|private|public`, `--prefs.cardAging regular|pirate`, `--prefs.cardCovers`, `--prefs.selfJoin`, `--defaultLists`, `--format` |
| `board:delete` | Delete a board | required `--board`; `--format` |
| `board:list` | List accessible boards | optional `--filter all|closed|members|open|organization|public|starred` default `open`; `--format` |
| `board:members` | List board members | required `--board`; `--format` |
| `board:set-closed` | Change board closed status | required `--board`; optional `--open`; `--format` |
| `board:show` | Show board details | required `--board`; `--format` |
| `board:update` | Update a board | required `--board`; optional `--name, -n`, `--description`; `--format` |
| `card` | Card command topic | `--format default|silent|json|csv` |
| `card:archive` | Archive a card | required `--board`, `--list`, `--card`; `--format` |
| `card:assign` | Assign a card | required `--board`, `--list`, `--card`, `--user`; `--format` |
| `card:assigned-to` | Show cards assigned to a user | optional `--user` default `me`; `--format` |
| `card:attach` | Add attachment to a card | required `--board`, `--list`, `--card`, `--url`; optional `--name`; `--format` |
| `card:attachments` | List card attachments | required `--board`, `--list`, `--card`; `--format` |
| `card:check-item` | Update checklist item state | required `--board`, `--list`, `--card`, `--item`, `--state complete|incomplete`; optional `--checklist`; `--format` |
| `card:checklist` | Add a checklist | required `--board`, `--list`, `--card`, `--name, -n`; `--format` |
| `card:checklists` | List checklists | required `--board`, `--list`, `--card`; `--format` |
| `card:comment` | Add a comment | required `--board`, `--list`, `--card`, `--text`; `--format` |
| `card:comments` | List comments | required `--board`, `--list`, `--card`; `--format` |
| `card:create` | Create a card | required `--name, -n`, `--board`, `--list`; optional `--position top|bottom` default `bottom`, repeatable `--label`, `--due`, `--description`; `--format` |
| `card:delete` | Delete a card | required `--board`, `--list`, `--card`; `--format` |
| `card:get-by-id` | Show card details by ID | required `--id`; `--format` |
| `card:label` | Add a label to a card | required `--board`, `--list`, `--card`, `--label`; `--format` |
| `card:list` | List cards in a list | required `--board`, `--list`; `--format` |
| `card:move` | Move a card | required `--board`, `--list`, `--card`, `--to`; optional `--position top|bottom` default `bottom`; `--format` |
| `card:show` | Show card details | required `--board`, `--list`, `--card`; `--format` |
| `card:unassign` | Unassign a card | required `--board`, `--list`, `--card`, `--user`; `--format` |
| `card:unlabel` | Remove a label from a card | required `--board`, `--list`, `--card`, `--label`; `--format` |
| `card:update` | Update a card | required `--board`, `--list`, `--card`; optional `--name, -n`, `--description`, `--due`, `--clear-due`; `--format` |
| `debug` | Debug installation | `--format default|silent|json|csv` |
| `interactive` | Launch terminal UI | optional `--mouse`, `--no-mouse` |
| `label` | Label command topic | `--format default|silent|json|csv` |
| `label:create` | Create a label on a board | required `--board`, `--name, -n`, `--color green|yellow|orange|red|purple|blue|sky|lime|pink|black`; `--format` |
| `label:delete` | Delete a label | required `--board`, `--color green|yellow|orange|red|purple|blue|sky|lime|pink|black`; optional `--text`; `--format` |
| `label:list` | List labels on a board | required `--board`; `--format` |
| `label:update` | Update label text or create matching color | required `--board`, `--color green|yellow|orange|red|purple|blue|sky|lime|pink|black`, `--name, -n`; optional `--old-name`; `--format` |
| `list` | List command topic | `--format default|silent|json|csv` |
| `list:archive` | Archive a list | required `--id`; `--format` |
| `list:archive-cards` | Archive all cards in a list | required `--board`, `--list`; `--format` |
| `list:create` | Create a list | required `--name, -n`, `--board`; optional `--position top|bottom` default `top`; `--format` |
| `list:list` | Show lists on a board | required `--board`; optional `--filter all|closed|none|open` default `open`; `--format` |
| `list:move-all-cards` | Move all cards between lists | required `--board`, `--list`, `--destination-board`, `--destination-list`; `--format` |
| `list:rename` | Rename a list | required `--board`, `--list`, `--name, -n`; `--format` |
| `search` | Search Trello | required `--query`; optional `--board`, `--type cards|boards|organizations`; `--format` |
| `sync` | Build local name-to-ID cache | `--format default|silent|json|csv` |

## Oclif Support Commands

Use these for CLI maintenance, not Trello data work. Ask before plugin install, link, reset, uninstall, update, or any command that changes shell configuration.

| Command | Purpose | Arguments and flags |
| --- | --- | --- |
| `autocomplete` | Display autocomplete setup instructions | optional arg `shell` as `zsh|bash|powershell`; optional `--refresh-cache, -r` |
| `autocomplete:create` | Create autocomplete setup scripts and completion functions | no flags; hidden support command |
| `autocomplete:script` | Output autocomplete config script | optional arg `shell` as `zsh|bash|powershell`; hidden support command |
| `help` | Display help | optional arg `command`; optional `--nested-commands, -n` |
| `plugins` | List installed plugins | optional `--core`; global `--json` |
| `plugins:inspect` | Display plugin installation properties | optional repeated arg `plugin` default `.`; optional `--verbose, -v`, `--help, -h`; global `--json` |
| `plugins:install` | Install plugin | required repeated arg `plugin`; optional `--force, -f`, `--silent, -s`, `--verbose, -v`, `--help, -h`; global `--json`; alias `plugins:add` |
| `plugins:link` | Link plugin for development | optional arg `path` default `.`; optional `--install`, `--no-install`, `--verbose, -v`, `--help, -h` |
| `plugins:reset` | Remove all user-installed and linked plugins | optional `--hard`, `--reinstall` |
| `plugins:uninstall` | Remove plugin | optional repeated arg `plugin`; optional `--verbose, -v`, `--help, -h`; aliases `plugins:unlink`, `plugins:remove` |
| `plugins:update` | Update installed plugins | optional `--verbose, -v`, `--help, -h` |
