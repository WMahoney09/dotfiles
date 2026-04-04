#!/usr/bin/env bash
# Powerline status line for Claude Code
# Receives session JSON on stdin, outputs ANSI-colored powerline segments
# Reads ~/.config/current-theme for palette — falls back to citadel

input=$(cat)

# --- Parse fields ---
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // 0')
duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // 0')
ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')
vim_mode=$(printf '%s' "$input" | jq -r '.vim.mode // empty')

# --- Theme palette (true color hex, no #) ---
theme=$(cat ~/.config/current-theme 2>/dev/null)
case "$theme" in
  citadel)
    BG1="071e28"; BG2="205263"; FG_LT="e3b19d"; FG_DK="051a22"
    GIT_DIRTY_BG="eba31c"; GIT_DIRTY_FG="051a22"
    GIT_DIVERGED_BG="ffd54c"; GIT_DIVERGED_FG="051a22"
    GIT_CLEAN_BG="14ad35"; GIT_CLEAN_FG="ffffff"
    CTX_LOW_BG="14ad35"; CTX_LOW_FG="ffffff"
    CTX_MED_BG="eba31c"; CTX_MED_FG="051a22"
    CTX_HIGH_BG="e98842"; CTX_HIGH_FG="051a22"
    CTX_CRIT_BG="c71726"; CTX_CRIT_FG="ffffff"
    ;;
  grizzly)
    BG1="1a120e"; BG2="3c312d"; FG_LT="f1bc94"; FG_DK="150e0a"
    GIT_DIRTY_BG="ff9029"; GIT_DIRTY_FG="150e0a"
    GIT_DIVERGED_BG="ffb618"; GIT_DIVERGED_FG="150e0a"
    GIT_CLEAN_BG="399227"; GIT_CLEAN_FG="ffffff"
    CTX_LOW_BG="399227"; CTX_LOW_FG="ffffff"
    CTX_MED_BG="ff9029"; CTX_MED_FG="150e0a"
    CTX_HIGH_BG="e98842"; CTX_HIGH_FG="150e0a"
    CTX_CRIT_BG="c71726"; CTX_CRIT_FG="ffffff"
    ;;
  ox)
    BG1="190a0c"; BG2="332726"; FG_LT="ecaf87"; FG_DK="140709"
    GIT_DIRTY_BG="ff6550"; GIT_DIRTY_FG="140709"
    GIT_DIVERGED_BG="ffc918"; GIT_DIVERGED_FG="140709"
    GIT_CLEAN_BG="39a150"; GIT_CLEAN_FG="ffffff"
    CTX_LOW_BG="39a150"; CTX_LOW_FG="ffffff"
    CTX_MED_BG="ff6550"; CTX_MED_FG="140709"
    CTX_HIGH_BG="e98842"; CTX_HIGH_FG="140709"
    CTX_CRIT_BG="c71726"; CTX_CRIT_FG="ffffff"
    ;;
  terabyte)
    BG1="081514"; BG2="243d36"; FG_LT="e6d4b2"; FG_DK="061211"
    GIT_DIRTY_BG="63c888"; GIT_DIRTY_FG="061211"
    GIT_DIVERGED_BG="ffcb2f"; GIT_DIVERGED_FG="061211"
    GIT_CLEAN_BG="3bce16"; GIT_CLEAN_FG="061211"
    CTX_LOW_BG="3bce16"; CTX_LOW_FG="061211"
    CTX_MED_BG="fdab3f"; CTX_MED_FG="061211"
    CTX_HIGH_BG="fdab3f"; CTX_HIGH_FG="061211"
    CTX_CRIT_BG="c4454f"; CTX_CRIT_FG="ffffff"
    ;;
  frost)
    BG1="e3f0ee"; BG2="bfdad7"; FG_LT="186554"; FG_DK="f6faf8"
    GIT_DIRTY_BG="d37d0d"; GIT_DIRTY_FG="ffffff"
    GIT_DIVERGED_BG="cc894b"; GIT_DIVERGED_FG="ffffff"
    GIT_CLEAN_BG="098a3a"; GIT_CLEAN_FG="ffffff"
    CTX_LOW_BG="098a3a"; CTX_LOW_FG="ffffff"
    CTX_MED_BG="d37d0d"; CTX_MED_FG="ffffff"
    CTX_HIGH_BG="ffa05b"; CTX_HIGH_FG="186554"
    CTX_CRIT_BG="ff5c69"; CTX_CRIT_FG="ffffff"
    ;;
  *)
    BG1="071e28"; BG2="205263"; FG_LT="e3b19d"; FG_DK="051a22"
    GIT_DIRTY_BG="eba31c"; GIT_DIRTY_FG="051a22"
    GIT_DIVERGED_BG="ffd54c"; GIT_DIVERGED_FG="051a22"
    GIT_CLEAN_BG="14ad35"; GIT_CLEAN_FG="ffffff"
    CTX_LOW_BG="14ad35"; CTX_LOW_FG="ffffff"
    CTX_MED_BG="eba31c"; CTX_MED_FG="051a22"
    CTX_HIGH_BG="e98842"; CTX_HIGH_FG="051a22"
    CTX_CRIT_BG="c71726"; CTX_CRIT_FG="ffffff"
    ;;
esac

# --- Derived values ---

# Shorten cwd: ~/last-two/components
dir="${cwd/#$HOME/\~}"
IFS='/' read -ra parts <<< "$dir"
n=${#parts[@]}
if (( n > 3 )); then
  dir="~/${parts[n-2]}/${parts[n-1]}"
fi

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
  # Git segment color
  if $git_dirty; then
    GIT_BG="$GIT_DIRTY_BG"; GIT_FG="$GIT_DIRTY_FG"
  elif $git_diverged; then
    GIT_BG="$GIT_DIVERGED_BG"; GIT_FG="$GIT_DIVERGED_FG"
  else
    GIT_BG="$GIT_CLEAN_BG"; GIT_FG="$GIT_CLEAN_FG"
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

# --- Powerline rendering (true color) ---
SEP=$(printf '\xee\x82\xb4')

fg() { printf '\e[38;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
bg() { printf '\e[48;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
reset() { printf '\e[0m'; }

# Context segment color by usage threshold
ctx_int=${ctx_pct%.*}
if (( ctx_int < 50 )); then
  CTX_BG="$CTX_LOW_BG"; CTX_FG="$CTX_LOW_FG"
elif (( ctx_int < 75 )); then
  CTX_BG="$CTX_MED_BG"; CTX_FG="$CTX_MED_FG"
elif (( ctx_int < 90 )); then
  CTX_BG="$CTX_HIGH_BG"; CTX_FG="$CTX_HIGH_FG"
else
  CTX_BG="$CTX_CRIT_BG"; CTX_FG="$CTX_CRIT_FG"
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
