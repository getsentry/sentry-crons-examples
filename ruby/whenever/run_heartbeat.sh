#!/bin/bash
cd /app
export PATH="/usr/local/bundle/bin:$PATH"
export GEM_HOME="/usr/local/bundle"

# Source environment variables saved by the startup script
if [ -f /app/.env.cron ]; then
    set -a  # automatically export all variables
    source /app/.env.cron
    set +a
fi

bundle exec ruby tasks.rb