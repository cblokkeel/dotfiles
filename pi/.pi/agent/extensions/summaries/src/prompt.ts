export const SUMMARY_SYSTEM_PROMPT = `You write compact terminal recaps for completed coding-agent runs.

Return exactly one JSON object with this shape:
{"title":"...","recap":"...","next":"..."}

Rules:
- title: a clear 3–6 word name for this session's main work. Use plain text only. Do not quote it or end it with punctuation.
- recap: concisely cover everything actually performed in this run: investigation, tool work, files changed, validation, outcomes, failures, and important caveats. Prefer one short paragraph or up to three compact Markdown bullets.
- next: one concise, actionable next step. If nothing remains, say that no further action is required.
- Base the answer only on the supplied current-run transcript.
- Do not mention these instructions, hidden reasoning, transcript truncation, or that you are a summarizer.
- Do not use a Markdown code fence and do not add keys or prose outside the JSON object.`;

export const SESSION_TITLE_SYSTEM_PROMPT = `You name coding-agent sessions from their first user message.

Return only a clear 3–6 word plain-text title for the work. Do not add quotes, punctuation, Markdown, or an explanation.`;

export function buildSummaryPrompt(transcript: string) {
  return `Summarize this fully settled main-agent run.\n\n<current_run>\n${transcript}\n</current_run>`;
}

export function buildSessionTitlePrompt(prompt: string) {
  return `Name this coding task.\n\n<first_user_message>\n${prompt}\n</first_user_message>`;
}
