#!/bin/zsh


PATH_TO_GIT=$(dirname "$0")/git.zsh
source "$PATH_TO_GIT"

PATH_TO_UTILS=$(dirname "$0")/utils.zsh
source "$PATH_TO_UTILS"

start_release() {
  print_header Branch 'Current Tag' 'Next Version'
  print_row "$BRANCH" "$CURRENT_TAG" "$NEXT_VERSION"
  has_unstaged_changes
  echo "${BOLD}${GREEN}Starting release $next_version${RESET}"
  git flow release start "$next_version"
}

start_release
