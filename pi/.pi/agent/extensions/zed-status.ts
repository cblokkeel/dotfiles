import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

function getBaseTitle(ctx: ExtensionContext): string {
  const sessionName = ctx.sessionManager.getSessionName();
  return sessionName ? `π - ${sessionName}` : "π";
}

function runningCount(value: unknown): number {
  if (!value || typeof value !== "object") return 0;
  const running = (value as { running?: unknown }).running;
  return typeof running === "number" && Number.isFinite(running)
    ? Math.max(0, Math.floor(running))
    : 0;
}

export default function (pi: ExtensionAPI) {
  let timer: ReturnType<typeof setInterval> | undefined;
  let parentRunning = false;
  let subagentsRunning = 0;
  let wasRunning = false;
  let sessionContext: ExtensionContext | undefined;

  const stop = (ctx: ExtensionContext) => {
    if (timer) clearInterval(timer);
    timer = undefined;
    ctx.ui.setTitle(getBaseTitle(ctx));
  };

  const start = (ctx: ExtensionContext) => {
    if (timer) return;
    let i = 0;
    const updateTitle = () => {
      ctx.ui.setTitle(`${frames[i++ % frames.length]} ${getBaseTitle(ctx)}`);
    };
    updateTitle();
    timer = setInterval(updateTitle, 80);
  };

  const sync = (ctx: ExtensionContext) => {
    const active = parentRunning || subagentsRunning > 0;
    if (active) start(ctx);
    else stop(ctx);

    if (wasRunning && !active) {
      pi.events.emit("zed-status:idle", { mode: ctx.mode });
    }
    wasRunning = active;
  };

  pi.on("session_start", (_event, ctx) => {
    sessionContext = ctx;
    sync(ctx);
  });

  pi.on("session_info_changed", (_event, ctx) => {
    if (parentRunning || subagentsRunning > 0) {
      ctx.ui.setTitle(`${frames[0]} ${getBaseTitle(ctx)}`);
    } else {
      ctx.ui.setTitle(getBaseTitle(ctx));
    }
  });

  pi.on("agent_start", (_event, ctx) => {
    parentRunning = true;
    sync(ctx);
  });

  pi.on("agent_settled", (_event, ctx) => {
    parentRunning = false;
    sync(ctx);
  });

  pi.events.on("subagents:activity", (activity) => {
    subagentsRunning = runningCount(activity);
    if (sessionContext) sync(sessionContext);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    parentRunning = false;
    subagentsRunning = 0;
    wasRunning = false;
    sessionContext = undefined;
    stop(ctx);
  });
}
