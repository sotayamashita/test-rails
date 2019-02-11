#!/bin/bash
set -eu

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

# if [[ "$1" == "bundle" ]] && [[ "$2" == "exec" ]] && [[ "$3" == "rails" ]] && [[ "$4" == "server" ]]; then
#   if [[ -f /app/config.ru ]]; then
#     echo "Rails project found. Skipping creation..."
#   else
#     # Create a rails application
#     echo "Creating new Ruby on Rails project..."
#     rails new . --force --skip-bundle --skip-test --skip-yarn --skip-coffee --database=postgresql
#
#     echo "Configuring database.yml..."
#     sed -i -e '1,/default:\  &default/ s/encoding:.*$/encoding:\ utf8/g' /app/config/database.yml
#     sed -i -e '1,/default:\  &default/ s/encoding:.*/& \n\ \ host:\ db\n\ \ username:\ postgres\n\ \ password:/g' /app/config/database.yml
#
#     echo "Installing dependencies..."
#     bundle_install
#   fi
#
#   bunlde_install_if_need
# fi

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
