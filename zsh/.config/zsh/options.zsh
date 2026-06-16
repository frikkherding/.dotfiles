# history
HISTSIZE=1000000
SAVEHIST=1000000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# default applications
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export EDITOR="/opt/homebrew/bin/nvim"

# starship
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
{
  eval "$(starship init zsh)"
}

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color $realpath'
zstyle ':fzf-tab:complete:*' fzf-preview 'eza $realpath'

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# Add idea to path
export PATH="/Applications/IntelliJ IDEA.app/Contents/MacOS:$PATH"

# Add go to path (go itself is installed via Homebrew, already on PATH)
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# load and initialise completion system
# needs to happend at the end to avoid slow startup
autoload -Uz compinit && compinit
