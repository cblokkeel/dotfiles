import assert from "node:assert/strict";
import test from "node:test";
import { hideFakeCaret } from "./index.ts";

test("removes the fake caret but keeps the character under it", () => {
  assert.deepEqual(hideFakeCaret(["top", "ab\x1b[7mc\x1b[0mde", "bottom"]), [
    "top",
    "abcde",
    "bottom",
  ]);
});

test("removes an end-of-input caret but keeps its space", () => {
  assert.deepEqual(hideFakeCaret(["\x1b[7m \x1b[0m"]), [" "]);
});

test("leaves lines without a fake caret unchanged", () => {
  assert.deepEqual(hideFakeCaret(["plain"]), ["plain"]);
});
