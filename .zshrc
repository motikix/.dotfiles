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

zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
#                              aliases                               #
#--------------------------------------------------------------------#

_exists_cmd nvim && {
  alias vim='nvim'
  alias vi='nvim --noplugin -c "set nohlsearch" -c "set inccommand=" -c "highlight Normal ctermbg=none guibg=none"'
}
_exists_cmd eza && {
  alias ls='eza --icons'
  alias ll='eza --icons -l --header --git --git-repos --time-style=long-iso'
  alias tree='eza --icons -l -T --header --git --git-repos --time-style=long-iso -I=.git'
}
_exists_cmd bat && {
  alias cat='bat'
}
_exists_cmd zoxide && {
  alias z='__zoxide_zi "$@"'
}
_exists_cmd pbcopy && {
  alias clip='pbcopy'
}
_exists_cmd xsel && {
  alias clip='xsel -bi'
}
_exists_cmd win32yank.exe && {
  alias clip='win32yank.exe -i --crlf'
}
alias g++="g++ -std=c++23 -Wall"

#--------------------------------------------------------------------#
#                               setup                                #
#--------------------------------------------------------------------#

_exists_cmd fzf && {
  source <(fzf --zsh)
}

_exists_cmd zoxide && {
  export _ZO_FZF_OPTS=($FZF_DEFAULT_OPTS "--preview '$FZF_PREVIEW_DIR_CMD {2..}'")
  eval "$(zoxide init zsh)"
}

_exists_cmd mise && {
  eval "$(mise activate zsh)"
}
