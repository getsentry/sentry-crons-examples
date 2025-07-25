# Working with the Sentry Crons Examples Repository

This document provides guidelines for adding and maintaining examples in the Sentry Crons demonstration repository.

## Purpose

This repository showcases Sentry Crons monitoring across various platforms. Each example should demonstrate the most natural and idiomatic way to implement scheduled jobs for that specific platform while integrating Sentry Crons monitoring.

## Core Principles

### 1. Platform Authenticity
- Use the scheduling approach that developers would naturally choose for that platform
- Follow platform conventions and best practices
- Don't force patterns that don't fit the ecosystem

### 2. Simplicity
- One scheduled job per example (preferably a simple heartbeat)
- Minimal code - just enough to demonstrate the integration
- Clear separation between scheduling logic and Sentry integration

### 3. Real-World Usability
- Examples should be copy-paste ready for developers
- Use standard project structures for each platform
- Include all necessary configuration files

## Creating a New Example

### Step 1: Research the Platform

Before writing code:
1. Research the most common scheduling solution for your platform
2. Look at real projects to understand conventions
3. Check if Sentry has specific integration guidance:
   ```
   mcp__sentry__search_docs(query="[platform] cron scheduling", guide="[platform]")
   ```

### Step 2: Build a Minimal Working Example

Create the simplest possible scheduled job for your platform:
- Use the platform's standard project structure
- Implement a basic task (e.g., logging "Heartbeat at [timestamp]")
- Ensure it can run locally without Sentry

### Step 3: Add Sentry SDK

Integrate Sentry following platform conventions:
1. Add Sentry SDK to dependencies using the platform's package manager
2. Initialize Sentry where it makes sense for that platform
3. Use environment variables for configuration (SENTRY_DSN, SENTRY_ENVIRONMENT)

### Step 4: Add Crons Monitoring

Research the platform-specific approach:
```
mcp__sentry__search_docs(query="[platform] cron monitoring check-in", guide="[platform]")
```

Implement monitoring in the most natural way:
- Some platforms have decorators/attributes
- Others need manual check-in calls
- Use upserting when available to auto-create monitors

### Step 5: Environment Configuration

#### Required Files

**.env.example**
```
SENTRY_DSN=https://your-dsn-here@o0.ingest.sentry.io/0
SENTRY_ENVIRONMENT=development
```

**.gitignore**
Include platform-specific ignores plus:
- `.env`
- Log files
- Build artifacts

#### Configuration Approach
- Support both .env files (development) and environment variables (production)
- Use the platform's standard approach for configuration
- Provide clear error messages if configuration is missing

### Step 6: Dockerfile

Create a production-ready Dockerfile:
- Use official base images
- Follow Docker best practices for the platform
- Ensure the scheduler runs properly in a container
- Include any system dependencies (e.g., cron for systems that need it)

#### Ruby-specific Docker Tips
- Remove `Gemfile.lock` if it exists from previous local development
- Let Docker create a fresh lock file to avoid bundler version conflicts
- Use `bundle install` without complex flags unless needed
- For cron-based systems, handle environment variable passing carefully

### Step 7: Documentation

Write a README.md that includes:

1. **Brief Description**: What this example demonstrates
2. **Prerequisites**: Any system requirements
3. **Setup Instructions**: Both local and Docker
4. **How It Works**: Brief explanation of the implementation
5. **Platform Specifics**: Any quirks or important notes
6. **Links**: Relevant Sentry documentation

Keep it concise but complete. Developers should be able to run the example without additional research.

### Step 8: Update Main README

Add your example to the main README.md with a brief, accurate description.

## Platform-Specific Considerations

### Cron-based Systems
- May need system cron installed in Docker
- Consider timezone handling
- Log output might need special handling

### Application Schedulers
- Often run as part of the main application
- May have built-in error handling to consider
- Could have existing health check patterns

### Distributed Systems
- Consider worker vs scheduler separation
- May need additional services (Redis, RabbitMQ, etc.)
- Docker Compose might be more appropriate than single Dockerfile

### Serverless/Cloud Functions
- Might not use traditional Dockerfiles
- Could have platform-specific deployment files
- Environment variables might be configured differently

## Quality Checklist

Before submitting an example, verify:

- [ ] Runs successfully without Sentry configured (graceful degradation)
- [ ] Sends check-ins to Sentry when configured
- [ ] Follows platform naming conventions
- [ ] Uses platform-standard project structure
- [ ] Docker build succeeds and container runs properly
- [ ] README is clear and complete
- [ ] Code is minimal but realistic
- [ ] Error messages are helpful
- [ ] Example is self-contained (no external dependencies beyond standard services)
- [ ] Never run package managers locally - always use Docker for testing changes
- [ ] Test with placeholder DSN values to ensure proper error handling

## Common Patterns to Avoid

1. **Over-engineering**: Keep it simple
2. **Cross-platform patterns**: Use platform-specific approaches
3. **Unnecessary abstractions**: Direct implementation is fine
4. **Complex configurations**: Stick to environment variables
5. **Multiple examples in one**: One scheduling approach per example

## Getting Help

- Use Context7 tools to look up Sentry documentation
- Check existing examples in the same language (but don't copy blindly)
- When multiple approaches exist, choose the most common one
- Ask: "What would a developer experienced in this platform expect?"

## Maintenance

When updating examples:
1. Check if the platform's best practices have changed
2. Update to latest stable versions
3. Ensure Sentry SDK features are current
4. Test everything still works
5. Update documentation if needed

Remember: The goal is to help developers integrate Sentry Crons into their existing projects. Make examples that they can learn from and adapt to their needs.