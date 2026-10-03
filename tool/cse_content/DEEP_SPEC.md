# Deep course spec (one course = one level of ~25 lessons, ~100 A4 pages)

Read SPEC.md first for tone rules (kid-friendly, Bangla in CHOLITO spoken style, Bangladesh examples). Those still apply.

Output: one file per lesson: parts/deep_<course id>/NN_en.json and NN_bn.json in this folder (NN = 01..25,
course id from CSE_PROGRESS.md, e.g. cse-1-2). Lesson ids: deep-<course id>-NN.
Outline first: write outlines/<course id>.md (~25 topics, see outlines/cse-1-1.md), then the lessons in order.
Each file = ONE lesson object:
{"id": "...", "title": "...", "minutes": 20, "content": "...", "key_points": [6-8], "tip": "...", "task": "...",
 "quiz": [5 x {"q","options":[4],"answer":0-3,"explain"}]}

One lesson = one topic of the course, ~4 A4 pages:
- English content 1,800-2,200 words; Bangla content similar depth (a natural retelling, not word-for-word).
- 18-28 paragraphs separated by "\n\n". No markdown, no bullet characters. A paragraph may start with a short
  sub-heading followed by ":" (e.g. "Cache memory: ...").
- Flow: hook/analogy -> what it is -> each sub-topic explained step by step with small concrete examples
  (numbers, tiny worked problems, inline pseudo-code where useful) -> 2 real-life examples (Bangladesh welcome)
  -> common mistakes / what exams ask -> short recap.
- Cover the real university syllabus depth for that topic (definitions, types, how it works, worked examples),
  but explained simply. Accurate facts only; when unsure, leave it out.
- Don't repeat what other lessons of the course cover in depth; mention and move on (see the outline).
Quiz: 5 questions, answers spread over 0-3. Task: something doable with paper/phone/computer, no special setup.
Validate: JSON loads; en/bn have same ids and same answer indices; word counts in range. Report word counts.
