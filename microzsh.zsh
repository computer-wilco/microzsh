# global path helpers
export THEMES="$ZSH/themes"
export PLUGINS="$ZSH/plugins"

# determine cache directory
export ZSH_CACHE_DIR="${XDG_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/microzsh}"
mkdir -p "$ZSH_CACHE_DIR" 2>/dev/null

# check for updates
source "$ZSH/tools/upgrade.zsh"

# autocomplete initialization
autoload -Uz compinit
local zcompdir="$ZSH_CACHE_DIR/zcompdump"
if [[ -n "$zcompdir"(#qN.m-1) ]]; then
    compinit -C -d "$zcompdir"
else
    compinit -d "$zcompdir"
fi

# universal git_prompt_info helper
git_prompt_info() {
  local ref=$(git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
  [[ -z "$ref" ]] && return

  local dirty=""
  if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# load all core configuration scripts from lib folder automatically
if [[ -d "$ZSH/lib" ]]; then
    for lib_file in "$ZSH/lib"/*.zsh(N); do
        source "$lib_file"
    done
fi

# universal plugin loader function
load_plugin() {
    local p_name="$1"
    
    for entry in "$PLUGINS/$p_name/$p_name.plugin.zsh" "$PLUGINS/$p_name/$p_name.zsh" "$PLUGINS/$p_name/$p_name.sh"; do
        if [[ -f "$entry" ]]; then
            source "$entry"
            return 0
        fi
    done
}

# load the plugins in the exact order specified by the user
for plugin in "${plugins[@]}"; do
    load_plugin "$plugin"
done

# load the selected theme
if [[ -n "$ZSH_THEME" && -f "$THEMES/$ZSH_THEME.zsh-theme" ]]; then
    source "$THEMES/$ZSH_THEME.zsh-theme"
fi

microzsh() {
  if [[ "$1" == "update" ]]; then
    if [[ -f "$ZSH/tools/update.zsh" ]]; then
      source "$ZSH/tools/update.zsh"
    else
      echo "Error: Update script could not be found."
    fi
  else
    echo "MicroZsh Commands:"
    echo "  microzsh update  - Update MicroZsh to the newest available version."
  fi
}
