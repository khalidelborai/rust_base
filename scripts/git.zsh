#!/bin/zsh

# import colors
# shellcheck source=colors.zsh
PATH_TO_COLORS=$(dirname "$0")/colors.zsh
source "$PATH_TO_COLORS"


get_current_branch() {
  git branch --show-current
}

get_current_tag() {
  git describe --tags --abbrev=0
}

get_next_version() {
  local current_tag
  current_tag=$(get_current_tag)
  local current_version
  current_version=$(echo "$current_tag" | cut -d'v' -f2)
  local next_version
  next_version=$(echo "$current_version" | awk -F. -v OFS=. '{$NF++; print}')
  echo "v$next_version"
}

has_unstaged_changes() {
  git diff --quiet
  if [ $? -ne 0 ]; then
    echo "${BOLD}${RED}You have unstaged changes. Please commit or stash them before starting a release.${RESET}"
    exit 1
  fi
}

export BRANCH=$(get_current_branch)
export CURRENT_TAG=$(get_current_tag)
export NEXT_VERSION=$(get_next_version)
export has_unstaged_changes
