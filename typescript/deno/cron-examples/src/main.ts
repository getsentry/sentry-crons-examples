import * as Sentry from "npm:@sentry/deno";

// Initialize Sentry
Sentry.init({
  dsn: Deno.env.get("SENTRY_DSN"),
  environment: Deno.env.get("SENTRY_ENVIRONMENT") || "development",
  tracesSampleRate: 1.0,
});

console.log("🚀 Starting Deno Cron Example with Sentry");

// Simple job function
async function simpleJob() {
  console.log("⏰ Running simple cron job at:", new Date().toISOString());

  try {
    // Simulate some work
    await new Promise((resolve) => setTimeout(resolve, 1000));

    // Randomly fail 10% of the time for testing
    if (Math.random() < 0.1) {
      throw new Error("Random job failure for testing");
    }

    console.log("✅ Job completed successfully");
  } catch (error) {
    console.error("❌ Job failed:", error);
    Sentry.captureException(error);
    throw error;
  }
}

// Register the cron job - runs every 2 minutes for testing
// Note: Deno.cron requires Deno 1.38+
if (typeof (Deno as any).cron === "function") {
  (Deno as any).cron("simple-job", "*/2 * * * *", () => {
    return Sentry.withMonitor("simple-job", simpleJob);
  });
  console.log("✅ Cron job registered (runs every 2 minutes)");
} else {
  console.warn("⚠️ Deno.cron not available, running job once for testing");
  // Fallback: run once for testing
  await simpleJob();
  Deno.exit(0);
}

console.log("📊 Sentry monitoring active");
console.log("⏰ Waiting for cron jobs...");

// Keep the process alive
setInterval(() => {
  // Just keep alive, the cron will handle execution
}, 60000);
