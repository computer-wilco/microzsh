# This file is taken from
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/theme-and-appearance.zsh

# Sets color variables such as $fg, $bg, $color and $reset_color
autoload -U colors && colors

# Expand variables and commands in PROMPT variables
setopt prompt_subst

# Prompt function theming defaults
ZSH_THEME_GIT_PROMPT_PREFIX="git:("   # Beginning of the git prompt, before the branch name
ZSH_THEME_GIT_PROMPT_SUFFIX=")"       # End of the git prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"        # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""         # Text to display if the branch is clean
ZSH_THEME_RUBY_PROMPT_PREFIX="("
ZSH_THEME_RUBY_PROMPT_SUFFIX=")"

# Set up caching directory reference cleanly
local cache_dir="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/microzsh}"
typeset -A __microzsh_probes
local __microzsh_probe_cache="$cache_dir/appearance-probes"
local __microzsh_probe_cached=("$__microzsh_probe_cache"(Nm-1))

if [[ -f "$__microzsh_probe_cache" && -n "$__microzsh_probe_cached" ]]; then
  source "$__microzsh_probe_cache"
fi

function __microzsh_test_cmd_args {
  local key="$*"
  if (( ! ${+__microzsh_probes[$key]} )); then
    command "$@" /dev/null &>/dev/null
    __microzsh_probes[$key]=$?
    if [[ -d "$cache_dir" || -w "$HOME" ]]; then
      mkdir -p "$cache_dir" 2>/dev/null
      print -r -- "__microzsh_probes=(" "${(@qqkv)__microzsh_probes}" ")" >| "$__microzsh_probe_cache"
    fi
  fi
  return $__microzsh_probes[$key]
}

# Use diff --color if available
if __microzsh_test_cmd_args diff --color /dev/null; then
  function diff {
    command diff --color "$@"
  }
fi

# Set up ls coloring parameters securely
() {
  [[ "$DISABLE_LS_COLORS" != true ]] || return 0

  export LSCOLORS="Gxfxcxdxbxegedabagacad"

  if [[ -z "$LS_COLORS" ]]; then
    if (( $+commands[dircolors] )); then
      local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
      if [[ -f "$config_dir/dircolors" ]]; then
        source <(dircolors -b "$config_dir/dircolors")
      elif [[ -f "$HOME/.dircolors" ]]; then
        source <(dircolors -b "$HOME/.dircolors")
      else
        source <(dircolors -b)
      fi
    else
      export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
    fi
  fi

  case "$OSTYPE" in
    netbsd*)
      __microzsh_test_cmd_args gls --color && alias ls='gls --color=tty'
      ;;
    openbsd*)
      __microzsh_test_cmd_args gls --color && alias ls='gls --color=tty'
      __microzsh_test_cmd_args colorls -G && alias ls='colorls -G'
      ;;
    (darwin|freebsd)*)
      __microzsh_test_cmd_args ls -G && alias ls='ls -G'
      zstyle -t ':microzsh:lib:theme-and-appearance' gnu-ls \
        && __microzsh_test_cmd_args gls --color \
        && alias ls='gls --color=tty'
      ;;
    *)
      if __microzsh_test_cmd_args ls --color; then
        alias ls='ls --color=tty'
      elif __microzsh_test_cmd_args ls -G; then
        alias ls='ls -G'
      fi
      ;;
  esac
}

unfunction __microzsh_test_cmd_args
unset __microzsh_probes __microzsh_probe_cache __microzsh_probe_cached
