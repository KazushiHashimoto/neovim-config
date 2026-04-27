# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ---------- History ----------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ---------- Completion ----------
autoload -Uz compinit && compinit

# ---------- lesspipe ----------
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ---------- Colors / ls aliases ----------
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ---------- conda ----------
# >>> conda initialize >>>
__conda_setup="$('/home/kazushi-hashimoto/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kazushi-hashimoto/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/kazushi-hashimoto/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/kazushi-hashimoto/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda deactivate

# ---------- PATH / env ----------
export PATH=$HOME/.robotech/bin:$PATH
export CPPYGEN_LIBCLANG_PATH=/usr/lib/llvm-17/lib/libclang.so

. "$HOME/.local/bin/env"

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/.robotech/mujoco/lib
export PATH=${PATH}:${HOME}/.robotech/mujoco/bin
export PATH=${PATH}:${HOME}/go/bin

# ---------- Auto-activate local .venv ----------
function _venv_deactivate() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        if (( $+functions[deactivate] )); then
            deactivate
        else
            export PATH="$(echo "$PATH" | tr ':' '\n' | grep -v "^${VIRTUAL_ENV}/bin$" | paste -sd ':')"
            unset VIRTUAL_ENV _OLD_VIRTUAL_PATH _OLD_VIRTUAL_PROMPT VIRTUAL_ENV_DISABLE_PROMPT
        fi
    fi
}

function auto_venv_activate() {
    local dir="$PWD"
    local venv_dir=""

    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.venv" ]]; then
            venv_dir="$dir/.venv"
            break
        fi
        dir="${dir:h}"
    done

    local target_venv=""
    if [[ -n "$venv_dir" ]]; then
        target_venv="$venv_dir"
    elif [[ "$PWD/" == "$HOME/robotech/"* ]]; then
        target_venv="$HOME/.robotech/venv/robotech"
    fi

    if [[ -z "$target_venv" ]]; then
        _venv_deactivate
        return
    fi

    if [[ "$VIRTUAL_ENV" != "$target_venv" ]] || [[ ":$PATH:" != *":$target_venv/bin:"* ]]; then
        _venv_deactivate
        VIRTUAL_ENV_DISABLE_PROMPT=1 source "$target_venv/bin/activate"
    fi
}

# Hook into directory changes (zsh-native; no need to override cd)
autoload -Uz add-zsh-hook
add-zsh-hook chpwd auto_venv_activate

function ncd() {
    local path=""
    for ((i=1; i<=$1; i++)); do
        path="../$path"
    done
    echo "Moving to $path" >&2
    cd "$path" || return
}

# Run once for initial directory
auto_venv_activate

# ---------- nvm ----------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ---------- ROS / cargo / build env ----------
source /opt/ros/jazzy/setup.zsh
. "$HOME/.cargo/env"
export IS_SIM=ON
export CC=/usr/bin/clang-18
export CXX=/usr/bin/clang++-18

# ---------- uv completion ----------
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# ---------- Aliases ----------
alias at0="tmux attach -t 0"
alias at1="tmux attach -t 1"
alias at2="tmux attach -t 2"

alias c=clear
alias nv="nvim ."

alias main="sudo ./build/main"
alias build="cmake --build build -j"
alias sim="./build/sim_mujoco"

alias reload="source ~/.zshrc"

# ---------- Prompt (starship) ----------
eval "$(starship init zsh)"

# ---------- Load shared zsh config (autosuggestions, syntax highlighting, etc.) ----------
# Sourced last so syntax-highlighting wraps ZLE widgets correctly.
if [ -f "$HOME/.config/zsh/.zshrc" ]; then
  source "$HOME/.config/zsh/.zshrc"
fi
