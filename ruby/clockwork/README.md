# Ruby Clockwork Example with Sentry

A simple example demonstrating how to use Sentry Crons monitoring with [Clockwork](https://github.com/Rykian/clockwork), a Ruby job scheduler.

## Features

- Runs a heartbeat task every minute
- Reports check-ins to Sentry Crons with upserting
- Handles errors gracefully

## Setup

### Local Development

1. Install dependencies:
   ```bash
   cd ruby/clockwork
   bundle install
   ```

2. Configure Sentry:
   
   **Option A: Using .env file (for local development)**
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` and set your actual Sentry DSN:
   ```
   SENTRY_DSN=https://your-actual-dsn@o0.ingest.sentry.io/0
   SENTRY_ENVIRONMENT=development
   ```
   
   **Option B: Using environment variables (for production)**
   ```bash
   export SENTRY_DSN="https://your-actual-dsn@o0.ingest.sentry.io/0"
   export SENTRY_ENVIRONMENT="production"
   ```

3. Run the scheduler:
   ```bash
   bundle exec clockwork clock.rb
   ```

### Docker

1. Build the image:
   ```bash
   docker build -t ruby-clockwork-example .
   ```

2. Run with environment variables:
   ```bash
   docker run -d --name clockwork-app \
     -e SENTRY_DSN="your-dsn-here" \
     -e SENTRY_ENVIRONMENT="development" \
     ruby-clockwork-example
   ```

   Or with .env file:
   ```bash
   docker run -d --name clockwork-app --env-file .env ruby-clockwork-example
   ```

3. View logs:
   ```bash
   docker logs -f clockwork-app
   ```

4. Stop and remove:
   ```bash
   docker stop clockwork-app && docker rm clockwork-app
   ```

## How it Works

Clockwork is a simple Ruby daemon that runs scheduled jobs. Unlike cron, it runs as a persistent process and doesn't require system cron to be installed.

The example:
1. Initializes Sentry SDK with environment variables
2. Defines a heartbeat job that runs every minute
3. Uses Sentry check-ins to monitor job execution
4. Automatically creates/updates the monitor in Sentry (upserting)

## Sentry Integration

The heartbeat task includes full Sentry cron monitoring:

1. **Automatic Monitor Creation**: The monitor is created/updated automatically when the job runs
2. **Check-in Tracking**: Each execution sends:
   - Start status (`in_progress`)
   - End status (`ok` on success, `error` on failure)
3. **Error Reporting**: Any exceptions are captured and sent to Sentry
4. **Monitor Configuration**:
   - Schedule: Every minute (`* * * * *`)
   - Check-in margin: 1 minute
   - Max runtime: 2 minutes
   - Monitor slug: `ruby-clockwork-heartbeat`

## Sentry Documentation

- [Ruby SDK Guide](https://docs.sentry.io/platforms/ruby/)
- [Crons Monitoring for Ruby](https://docs.sentry.io/platforms/ruby/crons/)
- [Clockwork Manual Setup](https://docs.sentry.io/platforms/ruby/crons/#manual-setup)