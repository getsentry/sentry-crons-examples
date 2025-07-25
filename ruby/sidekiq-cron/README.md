# Ruby Sidekiq-Cron Example with Sentry

A simple example demonstrating how to use Sentry Crons monitoring with [Sidekiq-Cron](https://github.com/sidekiq-cron/sidekiq-cron), a popular cron scheduler for Sidekiq background jobs.

## Features

- Runs a heartbeat job every minute using Sidekiq-Cron
- Automatic Sentry cron monitoring integration
- Uses Redis for job persistence
- Docker Compose setup for easy deployment

## Prerequisites

- Docker and Docker Compose
- Or: Ruby 3.0+, Redis server

## Setup

### Using Docker Compose (Recommended)

1. Clone and navigate to this example:
   ```bash
   cd ruby/sidekiq-cron
   ```

2. Configure Sentry:
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` and set your actual Sentry DSN:
   ```
   SENTRY_DSN=https://your-actual-dsn@o0.ingest.sentry.io/0
   SENTRY_ENVIRONMENT=development
   ```

3. Start the services:
   ```bash
   docker-compose up
   ```

4. View logs:
   ```bash
   docker-compose logs -f sidekiq
   ```

5. Stop services:
   ```bash
   docker-compose down
   ```

### Using Docker (Single Container)

If you already have Redis running elsewhere:

1. Build the image:
   ```bash
   docker build -t ruby-sidekiq-cron-example .
   ```

2. Run with environment variables:
   ```bash
   docker run -d --name sidekiq-cron-app \
     -e SENTRY_DSN="your-dsn-here" \
     -e SENTRY_ENVIRONMENT="production" \
     -e REDIS_URL="redis://your-redis-host:6379/0" \
     ruby-sidekiq-cron-example
   ```

## How it Works

Sidekiq-Cron extends Sidekiq with cron-like scheduling capabilities:

1. **Schedule Definition**: Jobs are defined in `config/schedule.yml` with cron syntax
2. **Job Loading**: On startup, Sidekiq loads the schedule and creates recurring jobs
3. **Execution**: Sidekiq-Cron checks every 30 seconds for jobs to enqueue
4. **Monitoring**: Sentry automatically tracks each job execution

The example includes:
- A `HeartbeatWorker` that runs every minute
- Automatic Sentry check-in monitoring via the `enabled_patches` configuration
- Redis for storing job schedules and queues
- Docker Compose for easy local development

## Sentry Integration

This example uses automatic Sentry monitoring through the `enabled_patches` configuration:

```ruby
config.enabled_patches += [:sidekiq_cron]
```

This automatically:
1. Creates/updates monitors in Sentry when jobs run
2. Sends check-in events (in_progress, ok, error)
3. Captures any exceptions during job execution
4. Monitors based on the cron schedule defined in `schedule.yml`

## Architecture

- **Redis**: Stores job queues and cron schedules
- **Sidekiq**: Processes background jobs
- **Sidekiq-Cron**: Adds cron scheduling to Sidekiq
- **Sentry**: Monitors job execution and errors

## Sentry Documentation

- [Ruby SDK Guide](https://docs.sentry.io/platforms/ruby/)
- [Sidekiq Integration](https://docs.sentry.io/platforms/ruby/guides/sidekiq/)
- [Crons Monitoring for Ruby](https://docs.sentry.io/platforms/ruby/crons/)
- [Sidekiq-Cron Setup](https://docs.sentry.io/platforms/ruby/crons/#sidekiq-cron)