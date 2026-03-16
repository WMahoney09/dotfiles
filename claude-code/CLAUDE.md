# Global Agent Instructions

## Bash: One Command Per Call

Claude Code's permission system matches Bash commands by prefix. Compound commands and shell substitution create strings that bypass permission patterns and **always trigger interactive prompts**, breaking autonomous flow.

**Never do these:**

| Anti-pattern | Why it breaks | Use instead |
|---|---|---|
| `cd /path && git status` | Compound `&&` — won't match `Bash(git *)` | `git -C /path status` |
| `git add file && git commit` | Compound `&&` — matches neither pattern | Separate Bash calls: `git add file`, then `git commit` |
| `git status && echo "---" && git log` | Compound `&&` — no prefix match | Separate Bash calls for each command |
| `git commit -m "$(cat <<'EOF'...)"` | Shell substitution `$(...)` | Write to `/tmp/commit_msg.txt`, then `git commit -F /tmp/commit_msg.txt` |
| `gh pr create --body "$(cat file)"` | Shell substitution `$(...)` | `gh pr create --body-file /tmp/pr_body.txt` |
| `command | tail -20` | Pipe — won't match `Bash(command *)` | Run command alone; accept full output |

**Rules:**
- One command per Bash call — no `&&`, `||`, `;`, or pipes
- Use `git -C /path` instead of `cd /path && git`
- Use file flags (`-F`, `--body-file`) instead of shell substitution (`$(cat ...)`)
- Use MCP tools when available instead of complex CLI invocations

## Temp Files: Use the Write Tool

When you need a temp file (e.g., commit messages, PR bodies), use the **Write tool** to create it at `/tmp/<filename>`. Never use `cat > /tmp/file << 'EOF'` or other Bash-based file creation — that's a compound command that triggers permission prompts.
