#!/bin/bash
set -eu

# Load libraries
. /opt/create-rails-app/base/functions

bundle_check() {
  bundle check 1> /dev/null
}

bundle_install() {
  bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5
}

bunlde_install_if_need() {
  if ! bundle_check; then
    bundle_install
  fi
}

if [[ "$1" == "bundle" ]] && [[ "$2" == "exec" ]] && [[ "$3" == "rails" ]] && [[ "$4" == "server" ]]; then
  if [[ -f /app/config.ru ]]; then
    log "Rails project found. Skipping creation..."
  else
    # Create a rails application
    log "Creating new Ruby on Rails project..."
    rails new . --force --skip-bundle --skip-test --skip-yarn --skip-coffee --database=postgresql

    log "Configuring database.yml..."
    sed -i -e '1,/default:\  &default/ s/encoding:.*$/encoding:\ utf8/g' /app/config/database.yml
    sed -i -e '1,/default:\  &default/ s/encoding:.*/& \n\ \ host:\ db\n\ \ username:\ postgres\n\ \ password:/g' /app/config/database.yml

    log "Installing dependencies..."
    bundle_install
  fi

  bunlde_install_if_need
fi

exec tini -- "$@"
