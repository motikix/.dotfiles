#--------------------------------------------------------------------#
#                            zsh options                             #
#--------------------------------------------------------------------#

setopt no_beep
setopt no_list_beep
setopt ignore_eof

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

setopt share_history
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

setopt auto_menu
setopt menu_complete
setopt complete_aliases
setopt auto_list
setopt list_packed
setopt list_types

zstyle ':completion:*' menu yes select

setopt no_auto_remove_slash
setopt auto_param_slash
setopt auto_param_keys
setopt magic_equal_subst

autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit

#--------------------------------------------------------------------#
#                               zinit                                #
#--------------------------------------------------------------------#

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-syntax-highlighting

zinit light hlissner/zsh-autopair

zinit light Aloxaf/fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-min-height 20

#--------------------------------------------------------------------#
#                             functions                              #
#--------------------------------------------------------------------#

function _exists_cmd() { type "$1" > /dev/null 2>&1; }

function _fzf_ghq() {
  local q=$([[ -n $BUFFER ]] && echo $BUFFER || echo '')
  local root=$(ghq root)
  local repo=$(ghq list | fzf --query "$q" --preview "$FZF_PREVIEW_DIR_CMD $root/{}")
  if [[ -n $repo ]] then
    BUFFER="cd $root/$repo"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N _fzf_ghq
bindkey "^g" _fzf_ghq

function _do_nothing() {}
zle -N _do_nothing
bindkey "^d" _do_nothing

function gi() { curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;}

#--------------------------------------------------------------------#
#                               setup                                #
#--------------------------------------------------------------------#

if command -v mise > /dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v fzf > /dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide > /dev/null 2>&1; then
  export _ZO_FZF_OPTS=($FZF_DEFAULT_OPTS "--preview '$FZF_PREVIEW_DIR_CMD {2..}'")
  eval "$(zoxide init zsh)"
fi

if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

#--------------------------------------------------------------------#
#                            environments                            #
#--------------------------------------------------------------------#

# zsh
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=2000
export SAVEHIST=1000
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
compctl -M 'm:{a-z}={A-Z}'
export fpath=(~/.local/share/zsh/completions ~/.local/share/zsh/site-functions $fpath)

# lang
export LANG=en_US.UTF-8

# xdg
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# gpg
export GPG_TTY=$(tty)

# fzf
export FZF_PREVIEW_FILE_CMD='bat --color=always --style=numbers'
export FZF_PREVIEW_DIR_CMD='eza -1 --color=always'
export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="\
  --height 40% --layout=reverse --border --bind ctrl-u:preview-up,ctrl-d:preview-down \
  --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
  --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
  --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
  --color=selected-bg:#45475A \
  --color=border:#6C7086,label:#CDD6F4
  --multi"
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW_FILE_CMD {}'"
export FZF_ALT_C_OPTS="--preview '$FZF_PREVIEW_DIR_CMD {}'"

# bin
export PATH=$HOME/.local/bin:$PATH

# npm
export NPM_CONFIG_PREFIX="$HOME/.local"

# go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# rust
export PATH=$HOME/.cargo/bin:$PATH

# python
export PYTHONDONTWRITEBYTECODE=1
export PIPENV_VENV_IN_PROJECT=true
export PIPENV_VERBOSITY=-1

# dotnet
export PATH=$HOME/.dotnet/tools:$PATH

# AWS
export AWS_VAULT_BACKEND=pass

# turso
export PATH=$HOME/.turso:$PATH

#--------------------------------------------------------------------#
#                              aliases                               #
#--------------------------------------------------------------------#

if command -v nvim > /dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim --noplugin -c "set nohlsearch" -c "set inccommand=" -c "highlight Normal ctermbg=none guibg=none"'
fi
if command -v eza > /dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza --icons -l --header --git --git-repos --time-style=long-iso'
  alias tree='eza --icons -l -T --header --git --git-repos --time-style=long-iso -I=.git'
fi
if command -v bat > /dev/null 2>&1; then
  alias cat='bat'
fi
if command -v zoxide > /dev/null 2>&1; then
  alias z='__zoxide_zi "$@"'
fi
if command -v pbcopy > /dev/null 2>&1; then
  alias clip='pbcopy'
fi
if command -v xsel > /dev/null 2>&1; then
  alias clip='xsel -bi'
fi
if command -v win32yank.exe > /dev/null 2>&1; then
  alias clip='win32yank.exe -i --crlf'
fi
alias g++="g++ -std=c++23 -Wall"

#--------------------------------------------------------------------#
#                               tmux                                 #
#--------------------------------------------------------------------#

if command -v tmux > /dev/null 2>&1; then
  if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != 'vscode' ]] && [[ "$TERM_PROGRAM" != 'kiro' ]]; then
    tmux && exit
  fi
fi
