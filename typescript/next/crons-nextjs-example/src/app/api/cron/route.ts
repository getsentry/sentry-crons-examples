import { NextRequest, NextResponse } from "next/server";
import * as Sentry from "@sentry/nextjs";

export const GET = async (req: NextRequest) => {
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

    return new NextResponse("OK", {
      status: 200,
    });
  } finally {
    await Sentry.flush();
  }
};

export const dynamic = "force-dynamic";
export const runtime = "nodejs";
export const maxDuration = 300;
