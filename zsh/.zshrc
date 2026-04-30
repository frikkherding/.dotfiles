# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-completions"
plug "jeffreytse/zsh-vi-mode"
plug "Aloxaf/fzf-tab"

# source
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/hflex-aliases.zsh"
plug "$HOME/.config/zsh/options.zsh"

export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
