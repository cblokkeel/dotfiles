import assert from "node:assert/strict";
import test from "node:test";
import {
  parseRecapResponse,
  parseSessionTitleResponse,
  reasoningOptions,
} from "./src/summarizer.ts";

test("omits reasoning when configured off", () => {
  assert.deepEqual(reasoningOptions("off"), {});
  assert.deepEqual(reasoningOptions("medium"), { reasoning: "medium" });
});

test("normalizes a compact session title", () => {
  assert.equal(
    parseSessionTitleResponse("  Fix \u001b[31mZed\u001b[0m   terminal titles  "),
    "Fix Zed terminal titles",
  );
});

test("parses strict recap JSON", () => {
  assert.deepEqual(
    parseRecapResponse(
      '{"title":"Check summary configuration","recap":"Updated config and ran focused tests.","next":"Review the diff."}',
    ),
    {
      title: "Check summary configuration",
      recap: "Updated config and ran focused tests.",
      next: "Review the diff.",
    },
  );
});

test("defensively extracts fenced or surrounded JSON and normalizes Next", () => {
  assert.deepEqual(
    parseRecapResponse(
      'Result follows:\n```json\n{"title":"Add Pi extension","recap":"- Added the extension\\n- Tests pass","next":"Next: Reload Pi."}\n```',
    ),
    {
      title: "Add Pi extension",
      recap: "- Added the extension\n- Tests pass",
      next: "Reload Pi.",
    },
  );
});

test("rejects malformed or incomplete output", () => {
  assert.throws(() => parseRecapResponse("not json"), /valid recap JSON/);
  assert.throws(
    () =>
      parseRecapResponse(
        '{"title":"Missing next","recap":"missing next"}',
      ),
    /valid recap JSON/,
  );
  assert.throws(
    () =>
      parseRecapResponse(
        '{"title":"Done","recap":"done","next":"nothing","extra":"not allowed"}',
      ),
    /valid recap JSON/,
  );
});

test("strips terminal control sequences from recap fields", () => {
  assert.deepEqual(
    parseRecapResponse(
      '{"title":"Update \\u001b[31mconfig\\u001b[0m","recap":"Updated \\u001b[31mconfig\\u001b[0m.","next":"Review it.\\u0007"}',
    ),
    {
      title: "Update config",
      recap: "Updated config.",
      next: "Review it.",
    },
  );
});
