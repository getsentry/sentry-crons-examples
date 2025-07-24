# Ruby Whenever Scheduler Example

A simple Ruby application demonstrating how to use the [whenever](https://github.com/javan/whenever) gem for cron job scheduling with Sentry cron monitoring integration.

## Setup

1. Install dependencies:
   ```bash
   cd ruby/whenever
   bundle install
   ```

2. Create log directory:
   ```bash
   mkdir -p log
   ```

3. Configure Sentry:
   
   **Option A: Using .env file (for local development)**
   ```bash
   cp .env.example .env
   ```
   Then edit `.env` and set your actual Sentry DSN:
   ```
   SENTRY_DSN=https://your-actual-dsn@o0.ingest.sentry.io/0
   SENTRY_ENVIRONMENT=production  # or development, staging, etc.
   ```
   
   **Option B: Using environment variables (for production)**
   ```bash
   export SENTRY_DSN="https://your-actual-dsn@o0.ingest.sentry.io/0"
   export SENTRY_ENVIRONMENT="production"
   ```

## Files

- `tasks.rb` - Ruby script that sends a heartbeat with Sentry cron monitoring
- `config/schedule.rb` - Whenever configuration to run the heartbeat every minute

## Usage

### Docker

Build and run the application in Docker:

```bash
# Build the Docker image
docker build -t ruby-whenever-example .

# Run the container with .env file (shows cron schedule and tails logs)
docker run --name whenever-app --env-file .env ruby-whenever-example

# Run in detached mode with .env file
docker run -d --name whenever-app --env-file .env ruby-whenever-example

# Or run with environment variables directly
docker run -d --name whenever-app \
  -e SENTRY_DSN="your-dsn-here" \
  -e SENTRY_ENVIRONMENT="production" \
  ruby-whenever-example

# View logs
docker logs whenever-app

# Run the heartbeat task manually with .env file
docker run --rm --env-file .env ruby-whenever-example ruby tasks.rb

# Or with environment variables
docker run --rm \
  -e SENTRY_DSN="your-dsn-here" \
  -e SENTRY_ENVIRONMENT="production" \
  ruby-whenever-example ruby tasks.rb

# Stop and remove the container
docker stop whenever-app && docker rm whenever-app
```

### Local Setup

View the generated crontab:
```bash
bundle exec whenever
```

Update your crontab:
```bash
bundle exec whenever --update-crontab
```

Clear the crontab:
```bash
bundle exec whenever --clear-crontab
```

Run the heartbeat task manually:
```bash
ruby tasks.rb
```

Check cron logs:
```bash
tail -f log/cron.log
```

## How it works

The `whenever` gem translates the Ruby DSL in `config/schedule.rb` into standard cron syntax. When you run `whenever --update-crontab`, it adds the scheduled jobs to your system's crontab.

### Environment Variables in Docker

When running in Docker, the container's startup script saves Sentry environment variables to `/app/.env.cron` which the cron job sources. This is necessary because cron runs with a minimal environment and doesn't inherit Docker's environment variables.

## Sentry Integration

The heartbeat task includes Sentry cron monitoring integration:

1. **Automatic Monitor Creation**: The monitor is created/updated automatically when the cron job runs
2. **Check-in Tracking**: Each execution sends a check-in to Sentry with:
   - Start status (`in_progress`)
   - End status (`ok` on success, `error` on failure)
3. **Error Reporting**: Any exceptions are automatically captured and sent to Sentry
4. **Monitor Configuration**:
   - Schedule: Every minute (`* * * * *`)
   - Check-in margin: 1 minute
   - Max runtime: 2 minutes

To view your cron monitors in Sentry:
1. Go to your Sentry project
2. Navigate to Crons section
3. Look for the `ruby-whenever-heartbeat` monitor