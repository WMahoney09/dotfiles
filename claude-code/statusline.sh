#!/usr/bin/env bash
# Powerline status line for Claude Code
# Receives session JSON on stdin, outputs ANSI-colored powerline segments

input=$(cat)

# --- Parse fields ---
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // 0')
ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')
vim_mode=$(printf '%s' "$input" | jq -r '.vim.mode // empty')

# --- Derived values ---

# Shorten cwd: ~/last-two/components
dir="${cwd/#$HOME/\~}"
IFS='/' read -ra parts <<< "$dir"
n=${#parts[@]}
if (( n > 3 )); then
  dir="~/${parts[n-2]}/${parts[n-1]}"
fi

# Palette (defined early — git/context color logic references these)
BG1=238   # dark gray
BG2=240   # medium gray
FG_LT=252 # light text
FG_DK=235 # dark text

# Git status
branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
commit_hash=$(git -C "$cwd" rev-parse --short=7 HEAD 2>/dev/null)
git_dirty=false
git_unpushed=false
git_icons=""
if [[ -n "$branch" ]]; then
  # Dirty working directory (staged or unstaged changes, untracked files)
  if [[ -n $(git -C "$cwd" status --porcelain 2>/dev/null) ]]; then
    git_dirty=true
    git_icons+=" ●"
  fi
  # Ahead/behind upstream
  git_diverged=false
  upstream=$(git -C "$cwd" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    ahead=$(git -C "$cwd" rev-list --count "${upstream}..HEAD" 2>/dev/null)
    behind=$(git -C "$cwd" rev-list --count "HEAD..${upstream}" 2>/dev/null)
    if (( ahead > 0 )); then
      git_unpushed=true
      git_diverged=true
      git_icons+=" ⇡${ahead}"
    fi
    if (( behind > 0 )); then
      git_diverged=true
      git_icons+=" ⇣${behind}"
    fi
  fi
  # Git segment color: red=dirty, amber=diverged from upstream, green=clean
  if $git_dirty; then
    GIT_BG=124   # red
    GIT_FG=255
  elif $git_diverged; then
    GIT_BG=172   # amber
    GIT_FG=$FG_DK
  else
    GIT_BG=65    # green
    GIT_FG=255
  fi
fi

# Duration: Xm Ys
total_s=$(( duration_ms / 1000 ))
mins=$(( total_s / 60 ))
secs=$(( total_s % 60 ))
duration="${mins}m ${secs}s"

# Cost
cost=$(printf '$%.2f' "$cost")

# Context
ctx="${ctx_pct}%"

# --- Powerline rendering ---
# Powerline separator (U+E0B0) via hex bytes — works on bash 3.2+
SEP=$(printf '\xee\x82\xb0')

fg()    { printf '\e[38;5;%dm' "$1"; }
bg()    { printf '\e[48;5;%dm' "$1"; }
reset() { printf '\e[0m'; }

# Context segment color — shifts from green → yellow → red by usage
ctx_int=${ctx_pct%.*}  # strip any decimal
if (( ctx_int < 50 )); then
  CTX_BG=65    # muted green
  CTX_FG=255
elif (( ctx_int < 75 )); then
  CTX_BG=172   # amber (matches cost)
  CTX_FG=$FG_DK
elif (( ctx_int < 90 )); then
  CTX_BG=166   # orange
  CTX_FG=$FG_DK
else
  CTX_BG=124   # red
  CTX_FG=255
fi

# Row 1: directory  branch+status
r1=""
r1+="$(bg $BG1)$(fg $FG_LT) ${dir} "
if [[ -n "$branch" ]]; then
  r1+="$(bg $GIT_BG)$(fg $BG1)${SEP}$(fg $GIT_FG) ${branch}${git_icons} "
  r1+="$(bg $BG2)$(fg $GIT_BG)${SEP}$(fg $FG_LT) ${commit_hash} "
  r1+="$(reset)$(fg $BG2)${SEP}$(reset)"
else
  r1+="$(reset)$(fg $BG1)${SEP}$(reset)"
fi

# Row 2: model  context  cost  duration
r2=""
r2+="$(bg $BG1)$(fg $FG_LT) ${model} "
r2+="$(bg $CTX_BG)$(fg $BG1)${SEP}$(fg $CTX_FG) ${ctx} "
r2+="$(bg $BG2)$(fg $CTX_BG)${SEP}$(fg $FG_LT) ${cost} "
r2+="$(bg $BG1)$(fg $BG2)${SEP}$(fg $FG_LT) ${duration} "
r2+="$(reset)$(fg $BG1)${SEP}$(reset)"

# Row 3: vim mode — only show NORMAL (Claude Code already shows INSERT)
r3=""
if [[ "$vim_mode" == "NORMAL" ]]; then
  r3="-- NORMAL --"
fi

if [[ -n "$r3" ]]; then
  printf '%s\n%s\n%s' "$r1" "$r2" "$r3"
else
  printf '%s\n%s' "$r1" "$r2"
fi
