#!/bin/bash

set -o errexit
set -o pipefail

# Load libraries
. /opt/create-rails-app/base/functions

bundle_check() {
  bundle check 1> /dev/null
}

bundle_install() {
  bundle install -j "$(getconf _NPROCESSORS_ONLN)" --quiet --retry 5
}

bunlde_install_if_need() {
  if ! bundle_check; then
    bundle_install
  fi
}

if [[ "$1" == "bundle" ]] && [[ "$2" == "exec" ]] && [[ "$3" == "rails" ]] && [[ "$4" == "server" ]]; then
  if [[ ! -f /app/config.ru ]]; then
    # Create a rails application
    rails new . --force --skip-bundle --skip-test --skip-yarn --skip-coffee --database=postgresql

    # Setup database configuration
    sed -i -e '1,/default:/ s/encoding:.*$/encoding: utf8/g' /app/config/database.yml
    sed -i -e '1,/default:/ s/encoding: utf8/& \n\ \ host:\ db\n\ \ username:\ postgres\n\ \ password:/g' /app/config/database.yml

    # Fire 🚀
    bundle_install
    rake db:setup
  fi

  bunlde_install_if_need
fi

exec tini -- "$@"
