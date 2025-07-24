import type { NextApiRequest, NextApiResponse } from "next";
import * as Sentry from "@sentry/nextjs";

export const config = {
  maxDuration: 300,
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse
) {
  if (req.method !== "GET") {
    return res.status(405).json({ message: "Method not allowed" });
  }

  try {
    const monitorSlug = "sync-orders";
    const checkInId = Sentry.captureCheckIn(
      {
        monitorSlug,
        status: "in_progress",
      },
      {
        schedule: {
          type: "crontab",
          value: "* * * * *",
        },
        checkinMargin: 1,
        maxRuntime: 15,
      }
    );

    try {
      Sentry.captureCheckIn({
        checkInId,
        monitorSlug: monitorSlug,
        status: "ok",
      });
    } catch (e) {
      Sentry.captureException(e);
      Sentry.captureCheckIn({
        checkInId,
        monitorSlug: monitorSlug,
        status: "error",
      });

      throw e;
    }

    return res.status(200).send("OK");
  } finally {
    await Sentry.flush();
  }
}