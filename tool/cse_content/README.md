# CSE content tools

How the full CSE courses (~25 lessons, ~100 A4 pages each) are made. Progress: `CSE_PROGRESS.md` at the repo root.

1. Pick the next `todo` course in `CSE_PROGRESS.md`.
2. Write `outlines/<id>.md` (25 topics), then the lessons following `SPEC.md` (tone) and `DEEP_SPEC.md` (shape)
   into `parts/deep_<id>/NN_{en,bn}.json` (parts/ is not committed; the course shows `in progress` while it exists).
3. `python3 tool/cse_content/assemble_course.py <id>` adds the course to the "Computer Science" category
   (`assets/content/{en,bn}/cse-courses.json`) under its year section, bumps `content_version` and marks it done.
4. `flutter test` (test/content_test.dart checks en/bn parity).

After adding an overview course to `cse.json`, run `tracker.py` to rebuild the list.
