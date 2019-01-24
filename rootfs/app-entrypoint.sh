#!/bin/bash

set -o errexit
set -o pipefail

# Load libraries
. /opt/create-rails-app/base/functions

is_gems_updated() {
  bundle check 1> /dev/null
}

install_gems() {
  bundle install -j "$(getconf _NPROCESSORS_ONLN)" --quiet --path vendor/bundle --retry 5
}

if [[ "$1" == "bundle" ]] && [[ "$2" == "exec" ]] && [[ "$3" == "rails" ]] && [[ "$4" == "server" ]]; then
  if [[ -f /app/config.ru ]]; then
    log "nothing special"
  else
    # Create a rails application
    rails new . --force --skip-bundle --skip-test --skip-yarn --skip-coffee --database=postgresql
    # Install other gems which are based on rails generates
    install_gems
    # Update default encoding to utf8
    sed -i -e '1,/default:/ s/encoding:.*$/encoding: utf8/g' /app/config/database.yml
  fi

  # Verify if dependencies are satisfied. If it are not, it starts to install them.
  if ! is_gems_updated; then
    install_gems
  fi
fi

exec tini -- "$@"
