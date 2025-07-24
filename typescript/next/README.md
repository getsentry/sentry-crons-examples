# Next.js + Sentry Crons Example

This example demonstrates how to set up Sentry Crons monitoring in a Next.js application with Vercel Cron Jobs integration.

## 🎯 What This Example Shows

- ✅ Automatic Vercel Cron Jobs instrumentation
- ✅ API Routes with cron job scheduling
- ✅ Server-side cron monitoring
- ✅ Error tracking for scheduled tasks
- ✅ Performance monitoring
- ✅ Environment-based configuration

## 🏗️ Project Structure

```
typescript/next/
├── README.md                    # This file
├── package.json                 # Dependencies and scripts
├── next.config.js               # Next.js configuration with Sentry
├── .env.example                 # Environment variables template
├── vercel.json                  # Vercel cron job configuration
├── pages/
│   └── api/
│       └── cron/
│           ├── daily-report.js  # Daily report cron job
│           ├── hourly-sync.js   # Hourly data sync job
│           └── cleanup.js       # Weekly cleanup job
├── lib/
│   ├── sentry.js               # Sentry configuration
│   └── jobs/
│       ├── report-generator.js  # Business logic for reports
│       ├── data-sync.js        # Data synchronization logic
│       └── cleanup-tasks.js    # Cleanup operations
└── docs/
    ├── SETUP.md                # Detailed setup instructions
    └── DEPLOYMENT.md           # Vercel deployment guide
```

## 🚀 Quick Start

1. **Clone and Install**
   ```bash
   cd typescript/next
   npm install
   ```

2. **Environment Setup**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your Sentry configuration
   ```

3. **Development**
   ```bash
   npm run dev
   ```

4. **Deploy to Vercel**
   ```bash
   vercel --prod
   ```

## 🔧 Configuration

### Environment Variables
```bash
# Sentry Configuration
SENTRY_DSN=your_sentry_dsn_here
SENTRY_ORG=your_sentry_org
SENTRY_PROJECT=your_sentry_project
SENTRY_AUTH_TOKEN=your_auth_token

# Application Configuration
NODE_ENV=production
NEXT_PUBLIC_APP_ENV=production
```

### Vercel Cron Configuration (vercel.json)
```json
{
  "crons": [
    {
      "path": "/api/cron/daily-report",
      "schedule": "0 9 * * *"
    },
    {
      "path": "/api/cron/hourly-sync", 
      "schedule": "0 * * * *"
    },
    {
      "path": "/api/cron/cleanup",
      "schedule": "0 2 * * 0"
    }
  ]
}
```

## 📋 Example Cron Jobs

### Daily Report Job
- **Path**: `/api/cron/daily-report`
- **Schedule**: `0 9 * * *` (9 AM daily)
- **Function**: Generates and sends daily reports
- **Monitoring**: Automatic check-ins with Sentry

### Hourly Data Sync
- **Path**: `/api/cron/hourly-sync`  
- **Schedule**: `0 * * * *` (Every hour)
- **Function**: Synchronizes data from external APIs
- **Monitoring**: Performance tracking and error alerts

### Weekly Cleanup
- **Path**: `/api/cron/cleanup`
- **Schedule**: `0 2 * * 0` (2 AM every Sunday)
- **Function**: Cleans up old data and temporary files
- **Monitoring**: Duration tracking and failure alerts

## 🔍 Testing Locally

Since Vercel cron jobs only run in production, you can test locally by:

1. **Direct API calls**:
   ```bash
   curl http://localhost:3000/api/cron/daily-report
   ```

2. **Using the test script**:
   ```bash
   npm run test:cron
   ```

3. **Manual trigger via browser**:
   Visit `http://localhost:3000/api/cron/daily-report`

## 📊 Monitoring Features

- **Automatic Check-ins**: Jobs automatically report start/finish
- **Error Tracking**: Exceptions are captured and reported
- **Performance Monitoring**: Job duration and resource usage
- **Alert Configuration**: Get notified when jobs fail or are missed
- **Dashboard Views**: Real-time status of all scheduled jobs

## 🚨 Troubleshooting

### Common Issues

1. **Jobs not running in Vercel**
   - Check `vercel.json` syntax
   - Verify deployment succeeded
   - Check Vercel Functions logs

2. **Sentry not receiving data**
   - Verify `SENTRY_DSN` is correct
   - Check Sentry project settings
   - Ensure auth token has correct permissions

3. **Jobs timing out**
   - Vercel has 10s timeout for Hobby plan
   - Consider upgrading plan or optimizing job logic
   - Use background tasks for long-running jobs

## 📚 Resources

- [Next.js API Routes](https://nextjs.org/docs/api-routes/introduction)
- [Vercel Cron Jobs](https://vercel.com/docs/cron-jobs)
- [Sentry Next.js Integration](https://docs.sentry.io/platforms/javascript/guides/nextjs/)
- [Sentry Crons Documentation](https://docs.sentry.io/product/crons/) 