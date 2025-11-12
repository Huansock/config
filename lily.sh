#!/bin/bash

PM="package-manager"

set_pm() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    PM="brew"
  else
    echo "now we are supporting only macos"
    exit 1
  fi
}

set_pm

check_pm() {
  if ! command -v $PM >/dev/null 2>&1; then
    echo "Can you install $PM manually?"
    exit 1
  fi
}

check_pm

sync_packages() {
  $PM list --installed-on-request >brew_list.txt
  $PM list --cask >>brew_list.txt
  echo "brew_list is synced"
}

install_packages() {
  while read line; do
    $PM install $line
  done <brew_list.txt
}

show_usage() {
  echo "Usage: $0 {set|install}"
}

set_alias() {
  echo 'alias lily="~/.config/lily.sh"' >>~/.zshrc
}

while [[ $# -gt 0 ]]; do
  case $1 in
  sync)
    sync_packages
    ;;
  install)
    install_packages
    ;;
  set-alias)
    set_alias
    ;;
  -h | --help)
    show_usage
    ;;
  *)
    show_usage
    ;;
  esac
  shift
done
