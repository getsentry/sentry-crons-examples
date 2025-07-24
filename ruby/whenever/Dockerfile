FROM ruby:3.2-slim

# Install cron and build dependencies
RUN apt-get update && apt-get install -y \
    cron \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile ./
RUN bundle install

# Copy application files
COPY . .

# Make the heartbeat script executable
RUN chmod +x /app/run_heartbeat.sh

# Create log directory
RUN mkdir -p log reports

# Update crontab with whenever schedule (set path explicitly)
RUN bundle exec whenever --update-crontab --set environment=production

# Create a script to start cron and tail logs
RUN echo '#!/bin/bash\n\
echo "Starting cron daemon..."\n\
# Write environment variables to a file for cron to source\n\
printenv | grep -E "^SENTRY_" > /app/.env.cron\n\
service cron start\n\
echo "Cron started. Showing scheduled jobs:"\n\
bundle exec whenever\n\
echo ""\n\
echo "Tailing cron log (press Ctrl+C to exit)..."\n\
touch log/cron.log\n\
tail -f log/cron.log' > /app/start.sh && chmod +x /app/start.sh

# Set environment variables (can be overridden at runtime)
ENV SENTRY_ENVIRONMENT=production

# Run the start script
CMD ["/app/start.sh"]