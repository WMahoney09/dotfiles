# ─── EDITOR ───────────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

# ─── PATH ─────────────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ─── ASDF fpath (must be before compinit) ────────────────────────────────────
fpath=(${ASDF_DIR}/completions $fpath)

# ─── HISTORY ──────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ─── ASDF ─────────────────────────────────────────────────────────────────────
. "$HOME/.asdf/asdf.sh"

# ─── ZSH-AUTOSUGGESTIONS: must be set before antidote loads the plugin ────────
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ─── ANTIDOTE ─────────────────────────────────────────────────────────────────
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load

# ─── COMPLETIONS (after antidote so kind:fpath additions are in $fpath) ───────
autoload -Uz compinit && compinit -C

# ─── ZOXIDE (after compinit so its completions are registered correctly) ──────
eval "$(zoxide init zsh)"

# ─── STARSHIP (last, so it's not overwritten by other prompt setup) ───────────
eval "$(starship init zsh)"

# ─── KEYBINDINGS ──────────────────────────────────────────────────────────────
bindkey '^h' backward-char
bindkey '^j' down-line-or-history
bindkey '^k' up-line-or-history
bindkey '^l' forward-char

# ─── DIR ALIASES ──────────────────────────────────────────────────────────────
alias ll="ls -l"
alias la="ls -la"

# ─── GIT ALIASES ──────────────────────────────────────────────────────────────
alias gri="git rebase -i"
alias gf="git fetch --prune"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gdl="git branch -D"
alias gdlo="git push -d origin"
alias gap="git add -p"
alias gc="git commit"
alias gdf="git diff"
alias gb="git branch"
alias gpfl="git push --force-with-lease"
alias gloga="git log --graph --decorate --oneline --all origin/main"
alias gls="git log --graph --decorate --stat"
alias gst="git status"
alias gdf="git diff"
