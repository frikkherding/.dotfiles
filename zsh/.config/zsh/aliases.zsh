# Neovim 
alias vim='nvim'
alias v='nvim .'

# git
alias gs='git status'
alias g-='git switch -'
alias gsw='git switch'
alias gamend='git commit --amend'
alias gnb='git switch -c'
alias gm='git switch main'
alias gd='git diff'
alias lg='lazygit'

# directories
alias home='cd $HOME'
alias repos='cd $HOME/repos'
alias config='cd $HOME/.config'
alias dotfiles='cd $HOME/.dotfiles'

# navigation
alias ls='eza --long'
alias l='eza --color=always --long --git --icons=always --no-time --no-user --no-permissions -A'
alias tree='eza --tree'
alias cd='z'
alias cdd='z -'

# files
alias c='bat'
alias cat='bat'
alias catp='cat -p'
alias rgg='rg -S -L -p -uuu'
alias zv='vim $(fzf)'
alias zd='cd $(find * -type d | fzf)'
alias o='open'

# configuration
alias c-zsh='vim $HOME/.zshrc'
alias c-aliases='vim $HOME/.config/zsh/aliases.zsh'
alias c-options='vim $HOME/.config/zsh/options.zsh'
alias c-starship='vim $HOME/.config/starship.toml'
alias c-vim='vim $HOME/.config/nvim/init.lua'
alias c-hyper='vim $HOME/.hyper.js'
alias c-zellij='vim $HOME/.config/zellij/config.kdl'
alias c-kitty='vim $HOME/.config/kitty/kitty.conf'
alias c-wezterm='vim $HOME/.config/wezterm/wezterm.lua'
alias c-ghostty='vim $HOME/.config/ghostty/config'
alias c-aerospace='vim $HOME/.config/aerospace/aerospace.toml'
alias c-tmux='vim $HOME/.config/tmux/tmux.conf'

# actions
alias rcsource='source $HOME/.zshrc'

# applications
alias python='python3'
alias pip='pip3'

