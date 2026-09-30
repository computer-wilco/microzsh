# Namespace: microzsh

# background worker function
_microzsh_bg_check() {
  local repo_dir="$1"
  local cache_file="$2"

  cd "$repo_dir" 2>/dev/null || return 1

  # fetch upstream changes
  git fetch --quiet origin master 2>/dev/null || return 1

  # check if local master is behind origin/master
  local local_hash=$(git rev-parse @ 2>/dev/null)
  local remote_hash=$(git rev-parse @{u} 2>/dev/null)

  if [[ -n "$local_hash" && -n "$remote_hash" && "$local_hash" != "$remote_hash" ]]; then
    touch "$cache_file.update_available" 2>/dev/null
  else
    rm -f "$cache_file.update_available" 2>/dev/null
  fi
}

# main initialization hook run at startup
() {
  local cache_base="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/microzsh}"
  local check_stamp="$cache_base/last_update_check"

  # if an update was flagged on a PREVIOUS run, prompt the user right now at startup
  if [[ -f "$check_stamp.update_available" ]]; then
    printf "\n\033[1;35m>> There is an update available for MicroZsh!\033[0m\n"
    printf "Do you want to update now? [Y/n] "
    
    # read user input interactively before the prompt loads
    local reply
    read -r REPLY

    case "$REPLY" in
      [Nn]*)
        printf "Update skipped.\n\n"
        ;;
      *)
        printf "\n"
        if [[ -f "$ZSH/tools/update.zsh" ]]; then
          source "$ZSH/tools/update.zsh"
          # clean up the flag file immediately so it doesn't prompt again
          rm -f "$check_stamp.update_available" 2>/dev/null
        else
          echo "Error: Update script could not be found."
        fi
        printf "\n"
        ;;
    esac
  fi

  # check if we already checked for updates today
  if [[ -f "$check_stamp" ]]; then
    local last_check=$(zstat +mtime "$check_stamp" 2>/dev/null || stat -c %Y "$check_stamp" 2>/dev/null || stat -f %m "$check_stamp" 2>/dev/null)
    local current_time=$(date +%s)
    if (( current_time - last_check < 86400 )); then
      return 0
    fi
  fi

  # update the timestamp file immediately so we don't spam background forks on every tab open
  mkdir -p "$cache_base" 2>/dev/null
  touch "$check_stamp" 2>/dev/null

  # trigger the background worker cleanly using the background operator
  ( _microzsh_bg_check "$ZSH" "$check_stamp" & ) 2>/dev/null
}
