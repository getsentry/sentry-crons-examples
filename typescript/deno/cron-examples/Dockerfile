# Simple Dockerfile for Deno Cron Example
FROM denoland/deno:1.40.0

WORKDIR /app

# Copy files
COPY deno.json .
COPY src/ ./src/

# Cache dependencies
RUN deno cache src/main.ts

# Set environment variables
ENV SENTRY_ENVIRONMENT=production

# Run the application
CMD ["deno", "run", "--allow-env", "--allow-net", "src/main.ts"] 