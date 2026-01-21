# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Esto es lo que carga NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Configuración básica de Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# Inicializar pyenv-virtualenv (opcional pero útil)
#eval "$(pyenv virtualenv-init -)"


# opencode
export PATH=/home/jsuarez/.opencode/bin:$PATH
export PATH="$PATH:/usr/bin"

#phpenv
export PHPENV_ROOT="/home/jsuarez/.phpenv"
if [ -d "${PHPENV_ROOT}" ]; then
  export PATH="${PHPENV_ROOT}/bin:${PATH}"
  eval "$(phpenv init -)"
fi


# Created by `pipx` on 2025-12-22 13:06:55
export PATH="$PATH:/home/jsuarez/.local/bin"
export GEMINI_API_KEY='AIzaSyA1SZFJiD0wuWZp1_eiKoioQvbCoWOucmo'

alias hh="code ~/dev/hh.code-workspace"

export EDITOR="vim"
