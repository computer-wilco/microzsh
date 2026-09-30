#!/usr/bin/env zsh
# MicroZsh updater

# visual formatting text
FMT_GREEN="\033[0;32m"
FMT_BLUE="\033[0;34m"
FMT_BOLD="\033[1m"
FMT_RESET="\033[0m"

print_msg() {
  printf "${FMT_BLUE}>> %s${FMT_RESET}\n" "$1"
}

# ensure the framework root path variable is available
if [ -z "$ZSH" ] || [ ! -d "$ZSH" ]; then
  printf "\033[0;31mError: \$ZSH environment path variable is not set or invalid.\033[0m\n" >&2
  return 1
fi

# store the current directory location so we can return the user back to it
local old_pwd="$PWD"
cd "$ZSH"

print_msg "Updating MicroZsh..."

if git pull --rebase --stat origin master; then
  print_msg "${FMT_GREEN}Updated successfully!${FMT_RESET}"
  printf "${FMT_GREEN}${FMT_BOLD}MicroZsh is now up to date!${FMT_RESET}\n"
  cd "$old_pwd"
else
  printf "\033[0;31mError: Failed to update MicroZsh.\033[0m\n" >&2
  cd "$old_pwd"
  return 1
fi
