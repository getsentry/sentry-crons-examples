# Deno + Sentry Crons Simple Example

A minimal example showing how to use Deno's built-in `Deno.cron` API with Sentry monitoring.

## 🎯 What This Shows

- ✅ Simple Deno cron job (runs every 2 minutes)
- ✅ Basic Sentry integration for monitoring
- ✅ Error tracking and reporting
- ✅ Docker deployment ready

## 🏗️ Project Structure

```
deno/cron-examples/
├── README.md          # This file
├── Dockerfile         # Docker setup
├── docker-compose.yml # Docker Compose
├── deno.json         # Deno config
└── src/
    └── main.ts       # Single file with cron job
```

## 🚀 Quick Start

1. **Setup Environment**:
   ```bash
   cd deno/cron-examples
   export SENTRY_DSN="your_sentry_dsn_here"
   ```

2. **Run Locally**:
   ```bash
   deno task start
   ```

3. **Development Mode** (with file watching):
   ```bash
   deno task dev
   ```

## 🐳 Docker

```bash
# Build and run
docker-compose up --build

# Or with plain Docker
docker build -t deno-cron .
docker run -e SENTRY_DSN="your_dsn" deno-cron
```

## 🔧 Environment Variables

```bash
SENTRY_DSN=your_sentry_dsn_here
SENTRY_ENVIRONMENT=development  # optional
```

## 📋 The Cron Job

- **Schedule**: `*/2 * * * *` (every 2 minutes)
- **Function**: Simple job that simulates work and occasionally fails
- **Monitoring**: Automatic Sentry error capture and monitoring

## 🧪 Testing

The job runs every 2 minutes automatically. It will:
- Log when it starts and completes
- Randomly fail ~10% of the time (for testing Sentry error capture)
- Send all errors to Sentry automatically

## 📊 Sentry Features

- **Error Tracking**: Automatic exception capture
- **Cron Monitoring**: Uses `Sentry.withMonitor()` 
- **Performance**: Basic job duration tracking

## 📚 Requirements

- Deno 1.38+ (for `Deno.cron` support)
- Sentry account and DSN

## 🚨 Notes

- If `Deno.cron` is not available, the job runs once and exits
- The job is intentionally simple to demonstrate the core concepts
- For production, adjust the cron schedule as needed 