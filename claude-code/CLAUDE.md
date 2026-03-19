# Global Agent Instructions

## GitHub Identity

- **Username:** WMahoney09
- **Personal repos:** WMahoney09/*
- **Organizations:** TheGnarCo, Smartphones-Plus, AMP-SCZ, trustedadvisorassociates, wealth-kitchen, elevenfortyseven, Foundation-for-International-Services
- **Skills repo:** WMahoney09/agent_skills

When resolving `{owner}` for GitHub API calls or `gh` commands, use the remote origin of the current repo — do not guess or ask.

## Bash: One Command Per Call (MANDATORY)

Every Bash tool call must contain exactly one simple command. This is a hard constraint, not a guideline. Violations cause permission prompts that block autonomous execution.

NEVER combine commands with `&&`, `||`, `;`, or pipes.
NEVER use shell substitution `$(...)` inside arguments.
ALWAYS make separate Bash tool calls for each command.

Instead of: `git add file && git commit -m "msg"`
Do: Two separate Bash calls — first `git add file`, then `git commit -F /tmp/msg.txt`

Instead of: `git commit -m "$(cat <<'EOF'...EOF)"`
Do: Write message to `/tmp/msg.txt` with the Write tool, then `git commit -F /tmp/msg.txt`

Instead of: `cd /path && git status`
Do: `git -C /path status`

Instead of: `gh pr create --body "$(cat file)"`
Do: `gh pr create --body-file /tmp/pr_body.txt`

Instead of: `command | tail -20`
Do: Run the command alone in a single Bash call

## Temp Files: Use the Write Tool

When you need a temp file (e.g., commit messages, PR bodies), use the **Write tool** to create it at `/tmp/<filename>`. Never use Bash-based file creation — that triggers permission prompts.

## No Throwaway Scripts (MANDATORY)

NEVER write Python, shell, awk, jq, or other scripts to parse, filter, or transform data. Instead, read files directly with the Read tool and reason over their contents in-context.

This applies to logs, JSON, CSVs, command output — any data. If a file is large, use Read with offset/limit to page through it. Do not pipe files through inline scripts for processing.

The only exception is if the user explicitly asks you to write a script.

Why: The user has no visibility into what ad-hoc scripts do. Token cost is not a concern — transparency is.
