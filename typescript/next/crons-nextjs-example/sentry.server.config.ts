// This file configures the initialization of Sentry on the server.
// The config you add here will be used whenever the server handles a request.
// https://docs.sentry.io/platforms/javascript/guides/nextjs/

import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: "https://da92e0f3b6bd195caba0bfe1334fa360@o4507215757443072.ingest.de.sentry.io/4508762976682064",

  // Setting this option to true will print useful information to the console while you're setting up Sentry.
  debug: false,
});
