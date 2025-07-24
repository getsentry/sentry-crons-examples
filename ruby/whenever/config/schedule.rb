# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Set the output for cron job logs
set :output, "/app/log/cron.log"

# Run heartbeat every minute
every 1.minute do
  command "/app/run_heartbeat.sh"
end