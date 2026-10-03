# CSE category content spec

Output: two files in this folder: part{N}_en.json and part{N}_bn.json.
Each file = a JSON array of level objects, same ids/order in both:
{"id":"cse-L","title":"...","lessons":[{"id":"cse-L-K","title":"...","minutes":7,"content":"...","key_points":[3-4 strings],"tip":"...","task":"...","quiz":[3x {"q":"...","options":[4 strings],"answer":0-3,"explain":"..."}]}]}

One lesson = one university course. Title = course name (bn: Bangla + English name in brackets is fine, e.g. "ডেটা স্ট্রাকচার (Data Structures)").

content: 5 paragraphs separated by "\n\n" (no markdown, no bullet lists):
 1. Eta ki? (what the course is about, in the simplest words)
 2. Keno porbo? (why it matters, where it's used)
 3. Kivabe kaj kore? (the core ideas of the course, 3-5 main topics, explained simply)
 4. Real life example (a concrete everyday example, Bangladesh context welcome: rickshaw, bazar, bKash, Daraz, cricket, mayer ranna, school, traffic jam, Pathao, Facebook...)
 5. Short wrap-up: what you'll be able to do after this course / what to learn next.
~250-350 words (en). Accurate CS facts; simplify, never be wrong.

Tone: explain like to a curious 10-12 year old. Short sentences. Friendly, playful.
- English: plain spoken English ("Imagine...", "Here's the trick...").
- Bangla: CHOLITO, everyday spoken Bangla, the way people actually talk — NOT boi-er bhasha/sadhu/formal.
  Use "tumi", "dhoro", "mane holo", "byapar ta emon", "simple", "tai na?", "ekdom", "bujhla?". Common English tech words stay in English or common Banglish-in-Bangla-script (কম্পিউটার, প্রোগ্রাম, ডেটা, অ্যাপ, মেমোরি). Avoid heavy tatsama words (e.g. say "কাজে লাগে" not "ব্যবহৃত হয়", "মানে" not "অর্থাৎ", "খুঁজে বের করা" not "অনুসন্ধান").
  Bangla content is a natural retelling, not word-for-word translation, but quiz answers/indices must match en.

tip: one friendly mentor tip for studying this course. task: one small hands-on thing to try (paper/phone ok, no setup).
Quiz: 3 questions testing the lesson, answer index varied (not always 0/1).
Validate both files with: python3 -c "import json;json.load(open('FILE'))" and check same ids + same answer indices in en/bn.

## UPDATE: LONG VERSION (overrides the length/paragraph rules above)
User said lessons are too short. Each lesson's content is now 12-15 paragraphs, ~900-1200 words in English (Bangla similar), still "\n\n" separated, no markdown/bullets:
 1. Eta ki? Simple definition + an everyday analogy.
 2. Keno porbo? Why it matters, where it is used, which jobs/next courses need it.
 3. Course e ki ki thake: one paragraph naming the main topics of the real syllabus.
 4-10. One paragraph PER main topic (5-7 topics, the real syllabus topics of that course). Start with the topic name then ":" (e.g. "Stack: ..."). Explain what it is, how it works, and a tiny concrete example (small numbers, a 1-2 line pseudo-code or formula written inline is ok).
 11. Real life example 1, walked through step by step (Bangladesh context welcome).
 12. Real life example 2, a different area.
 13. Kothay sobai bhul kore / exam e ki ashe: common confusions and typical exam questions.
 14. Wrap-up: what you can do after this course and what to learn next.
key_points: 5-6. minutes: 12-15. Tone unchanged: kid-friendly; Bangla stays CHOLITO spoken style.
