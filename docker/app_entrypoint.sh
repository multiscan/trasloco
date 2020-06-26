#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

cd /app
if [ "$RAILS_ENV" == "development" ] ; then
  bundle install
  yarn install --check-files
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
