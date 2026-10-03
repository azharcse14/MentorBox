# CSE content tools

How the full CSE courses (~25 lessons, ~100 A4 pages each) are made. Progress: `CSE_PROGRESS.md` at the repo root.

1. Pick the next `todo` course in `CSE_PROGRESS.md`; mark it: `python3 tool/cse_content/tracker.py <id> "in progress"`.
2. Write `outlines/<id>.md` (25 topics), then the lessons following `SPEC.md` (tone) and `DEEP_SPEC.md` (shape)
   into `parts/deep_<id>_part<N>_{en,bn}.json` (parts/ is not committed).
3. `python3 tool/cse_content/assemble_course.py <id>` puts the course into its year category
   (`assets/content/{en,bn}/cse-y1..y4|cse-msc.json`), bumps `content_version` and marks it done.
4. `flutter test` (test/content_test.dart checks en/bn parity).

After adding an overview course to `cse.json`, run `tracker.py` with no arguments to rebuild the list.
