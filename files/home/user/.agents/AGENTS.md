- Never put emoji in code.
- Use global commands for the following commands. Dont use `npx`, `bunx`, `pnpmx`, or `node_modules/.bin/*`: `ctx7`, `oxlint`, `oxfmt`, `vercel`, `wrangler`, `shopify`, `vitest`, `vp`, `vite`
- Always provide a `--scope` argument at the end of any `vercel` command. Example `vercel logs --scope foo`.
- Always provide a `--profile` argument at the end of any `aws` command. Example `aws s3 ls --profile foo`.
- Always use `neon` instead of the alias `neonctl`.
- Always create Git worktrees under `.worktrees/` at the root of the current Git project. Resolve the project root with `git rev-parse --show-toplevel` and use `<project-root>/.worktrees/<worktree-name>`.
- When connecting `agent-browser` to Chrome 144+ with remote debugging enabled at `chrome://inspect/#remote-debugging`, try `--auto-connect` first. If Chrome owns the debugging port but `/json/version` returns HTTP 404, connect directly with `agent-browser --cdp ws://127.0.0.1:<port>/devtools/browser <command>`. Chrome may display a permission dialog that the user must approve. Do not hard-code the debugging port.
- When uploading attachments into Jira, use the `acli-extras` cli tool instead of `acli` and web browser.
- Some commands might show as being not authenticated.  This could be because the AI agent is running inside a sandbox.  Examples of these include: `acli jira`, `acli-extras jira`, and `gh`.

