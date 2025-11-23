# export PATH=$(pyenv root)/shims:$HOME/bin:$HOME/.local/bin:/usr/local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:$PATH

# envs
export CLAUDE_CODE_USE_BEDROCK=1

#aliases
alias zshconfig="nvim ~/.zshrc"
alias starshipconfig="nvim ~/.config/starship.toml"
alias ghosttyconfig="nvim ~/.config/ghostty/config"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ai="claude"
alias nvimconfig="cd ~/.config/nvim && nvim ."
alias tmuxconfig="nvim ~/.tmux.conf"
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias paxi="cd ~/scratch/paxi/ && nvim ."

source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

