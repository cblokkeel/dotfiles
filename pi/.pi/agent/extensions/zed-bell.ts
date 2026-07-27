import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.events.on("zed-status:idle", (activity) => {
    if (
      activity &&
      typeof activity === "object" &&
      (activity as { mode?: unknown }).mode === "tui"
    ) {
      process.stdout.write("\x07");
    }
  });
}
