- Never put emoji in code
- When available, use direct commands instead of `npx`/`bunx`/`pnpmx`. For example use `ctx7` instead of `npx ctx7`, or use `oxfmt` instead of `npx oxmft`.
- Always provide a `--scope` argument at the end of any `vercel` command. Example `vercel logs --scope foo`.
- Always provide a `--profile` argument at the end of any `aws` command. Example `aws s3 ls --profile foo`.

