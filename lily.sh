#!/bin/bash

PM="package-manager"

sync_pm() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    PM="brew"
  else
    echo "now we are supporting only macos"
    exit 1
  fi
}

sync_pm

check_pm() {
  if ! command -v $PM >/dev/null 2>&1; then
    echo "Can you install $PM manually?"
    exit 1
  fi
}

check_pm

set_packages() {
  $PM list --installed-on-request >brew_list.txt
  $PM list --cask >>brew_list.txt
  echo "brew_list is setted"
}

install_packages() {
  while read line; do
    $PM install $line
  done <brew_list.txt
}

show_usage() {
  echo "Usage: $0 {set|install}"
}

while [[ $# -gt 0 ]]; do
  case $1 in
  sync)
    set_packages
    ;;
  install)
    install_packages
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
