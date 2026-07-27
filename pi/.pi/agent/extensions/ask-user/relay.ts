import type { ExtensionUIContext } from "@earendil-works/pi-coding-agent";

const RELAY_KEY = Symbol.for("pi.ask-user.relay");

type RelayState = {
  ui?: ExtensionUIContext;
  surfaceClarification?: (markdown: string) => void;
  owner?: symbol;
};

function relayState(): RelayState {
  const target = globalThis as typeof globalThis & {
    [RELAY_KEY]?: RelayState;
  };
  return (target[RELAY_KEY] ??= {});
}

/** Install the UI owned by the interactive parent Pi session. */
export function installAskUserRelay(
  ui: ExtensionUIContext,
  surfaceClarification: (markdown: string) => void,
): () => void {
  const state = relayState();
  const owner = Symbol("ask-user-relay");
  state.ui = ui;
  state.surfaceClarification = surfaceClarification;
  state.owner = owner;

  return () => {
    if (state.owner !== owner) return;
    state.ui = undefined;
    state.surfaceClarification = undefined;
    state.owner = undefined;
  };
}

/** Return the interactive parent UI for a child session, if one exists. */
export function getAskUserRelay(): ExtensionUIContext | undefined {
  return relayState().ui;
}

/** Surface a child answer's clarification in the parent transcript. */
export function surfaceAskUserClarification(markdown: string): void {
  relayState().surfaceClarification?.(markdown);
}
