---
name: jira-acli
description: "Use Atlassian CLI acli for Jira Cloud work: authenticate or check auth, search/view/create/edit/assign/transition Jira work items, manage comments, and inspect projects, boards, sprints, or filters. Trigger when the user asks to use acli, Jira CLI, Atlassian CLI, or local Jira work item commands."
---

# Jira acli

## Baseline

Use this skill for Atlassian's local `acli` command. The inspected local command is `acli version 1.3.18-stable`; its Jira noun is `workitem`, not `issue`.

Verify the installed surface when syntax matters:

```sh
command -v acli
acli --version
acli jira --help
acli jira workitem --help
```

If local help differs from these notes, trust the local help output.

Examples use placeholders such as `PROJECTKEY`, `KEY-123`, and `FILTER_ID`. Replace them with the user's actual Jira project key, work item key, or filter ID.

## Auth and Safety

- Check auth when needed with `acli jira auth status`; global OAuth status is `acli auth status`.
- Log in with `acli jira auth login --web`, or with an API token from stdin: `acli jira auth login --site "site.atlassian.net" --email "user@example.com" --token`.
- Never put API tokens directly in command text. Pipe from a protected file or prompt/stdin.
- Browser login and `--web` commands may require GUI or unsandboxed execution.
- Prefer read-only commands first. Before bulk edit, assign, transition, delete, archive, or unarchive operations, search/count the affected work items and confirm intent unless the user explicitly requested the exact change.

## Output Rules

- Prefer `--json` for parsing, exact reporting, or follow-on automation.
- Use `--fields` to keep output small and stable.
- Use `--paginate` only when complete results matter; otherwise set `--limit`.
- Use `--csv` when the requested output is a spreadsheet-style export.

## Work Items

Search with JQL:

```sh
acli jira workitem search --jql "project = PROJECTKEY ORDER BY updated DESC" --fields "key,summary,status,assignee" --limit 20 --json
acli jira workitem search --jql "project = PROJECTKEY" --count
acli jira workitem search --filter FILTER_ID --json
```

View a work item:

```sh
acli jira workitem view KEY-123 --json
acli jira workitem view KEY-123 --fields "key,issuetype,summary,status,assignee,description,comment" --json
acli jira workitem view KEY-123 --web
```

Create a work item:

```sh
acli jira workitem create --project "PROJECTKEY" --type "Task" --summary "New task" --description "Details" --json
acli jira workitem create --project "PROJECTKEY" --type "Bug" --summary "Bug summary" --description-file "description.txt" --assignee "@me" --label "bug,cli"
acli jira workitem create --generate-json
acli jira workitem create --from-json "workitem.json"
```

Edit, assign, or transition:

```sh
acli jira workitem edit --key "KEY-1,KEY-2" --summary "New summary" --json
acli jira workitem edit --jql "project = PROJECTKEY AND status = 'To Do'" --assignee "user@example.com" --yes
acli jira workitem assign --key "KEY-1" --assignee "@me" --yes
acli jira workitem assign --filter FILTER_ID --remove-assignee --yes
acli jira workitem transition --key "KEY-1" --status "Done" --yes
acli jira workitem transition --jql "project = PROJECTKEY AND assignee = currentUser()" --status "In Progress" --yes
```

Use `--ignore-errors` for batch operations only when partial success is acceptable. Use `--yes` only after the target set is known or the user has clearly authorized the batch action.

## Comments

Use the explicit `comment create` subcommand even if help examples omit `create`.

```sh
acli jira workitem comment list --key KEY-123 --json
acli jira workitem comment list --key KEY-123 --limit 100 --order "+created" --json
acli jira workitem comment create --key "KEY-123" --body "Comment text" --json
acli jira workitem comment create --key "KEY-123" --body-file "comment.txt" --json
acli jira workitem comment create --jql "project = PROJECTKEY" --body-file "comment.txt" --edit-last
```

Comment and description bodies accept plain text or Atlassian Document Format. Use files for multiline bodies to avoid shell quoting errors.

## Related Jira Commands

Projects:

```sh
acli jira project list --recent --json
acli jira project list --paginate --json
acli jira project view --key "PROJECTKEY" --json
```

Filters:

```sh
acli jira filter list --my --json
acli jira filter list --favourite --json
acli jira filter search --help
```

Boards and sprints:

```sh
acli jira board search --help
acli jira board list-sprints --help
acli jira sprint view --help
acli jira sprint list-workitems --help
```

Use `--help` for less common admin or destructive operations, because flags vary by subcommand.

## Troubleshooting

- `unauthorized`: run `acli jira auth status`; if the sandbox is unauthorized but the user's terminal is authorized, explain the session mismatch and ask the user to run the command or request the needed execution context.
- `unknown command issue`: use `acli jira workitem ...`.
- Empty or missing fields: inspect `acli jira workitem view KEY --fields "*all" --json`, then narrow the field list.
- JQL or shell quoting failures: put the JQL in double quotes and quote status names with single quotes inside the JQL, for example `--jql "project = PROJECTKEY AND status = 'In Progress'"`.
