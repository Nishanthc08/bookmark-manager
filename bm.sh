# Shell integration for bm - source this file from ~/.bashrc:
#   source /usr/share/bm/bm.sh

bm() {
  if [[ "$1" == "go" ]] && [[ -n "${2:-}" ]]; then
    local dir
    dir=$(command bm path "$2") || return $?
    if [[ -d "$dir" ]]; then
      builtin cd "$dir"
    else
      echo "bm: directory '$dir' not found" >&2
      return 1
    fi
  else
    command bm "$@"
  fi
}
