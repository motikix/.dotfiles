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
  --color=bg+:-1,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#f2cdcd,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi"
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW_FILE_CMD {}'"
export FZF_ALT_C_OPTS="--preview '$FZF_PREVIEW_DIR_CMD {}'"

# bin
export PATH=$HOME/.local/bin:$PATH

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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
