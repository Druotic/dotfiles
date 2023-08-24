#!/usr/bin/env bash

set -e

HOOK_NAME="$(basename "$0")"
LOCAL_PROJECT_ROOT=$(git rev-parse --show-toplevel)

execute_local_hook () {
  # e.g. <repo_root>/.git/
  LOCAL_HOOK="$LOCAL_PROJECT_ROOT/.git/hooks/$HOOK_NAME"
  if [[ -f "$LOCAL_HOOK" ]]; then
      eval "$LOCAL_HOOK $@"
  #else
    #echo "WARNING: $LOCAL_HOOK not found. Skipping."
  fi
}
