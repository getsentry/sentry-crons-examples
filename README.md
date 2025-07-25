# Sentry Crons Examples

This repository contains examples demonstrating how to use Sentry Crons monitoring across various platforms, frameworks, and libraries.

## Overview

Sentry Crons allows you to monitor recurring jobs and get alerts when they fail or don't run when expected. These examples show how to integrate Sentry Crons with different scheduling frameworks.

## Examples by Language

### Ruby
- [Whenever](ruby/whenever/) - Cron job management with the whenever gem
- [Clockwork](ruby/clockwork/) - Ruby daemon for scheduling with clockwork
- [Sidekiq-Cron](ruby/sidekiq-cron/) - Cron scheduling for Sidekiq background jobs

### TypeScript/JavaScript
- [Deno](typescript/deno/cron-examples/) - Deno runtime with built-in cron
- [Next.js](typescript/next/crons-nextjs-example/) - Next.js API routes with Vercel Cron

## Coming Soon

Additional examples for other languages and frameworks are in development. Check back soon for:
- Python (Celery, Django, Flask, etc.)
- More Ruby frameworks (Rails, Sidekiq, Clockwork)
- Java (Quartz, Spring Boot)
- PHP (Laravel, Symfony)
- Go
- .NET
- Elixir
- And more!

## Getting Started

Each example includes:
- Simple, focused implementation
- Dockerfile for easy deployment
- Environment variable configuration
- README with setup instructions
- Links to relevant Sentry documentation

## Documentation

- [Sentry Crons Documentation](https://docs.sentry.io/product/crons/)
- [Sentry SDK Documentation](https://docs.sentry.io/platforms/)

## Contributing

See [CLAUDE.md](CLAUDE.md) for guidelines on adding new examples.

## Key Principles

- **Simplicity**: Each example demonstrates one integration
- **Consistency**: Similar structure across all examples
- **Portability**: Docker support for all examples
- **Documentation**: Clear setup and usage instructions

## Support

For questions about Sentry Crons:
- [Sentry Documentation](https://docs.sentry.io)
- [Sentry Discord](https://discord.gg/sentry)
- [GitHub Issues](https://github.com/getsentry/sentry/issues)