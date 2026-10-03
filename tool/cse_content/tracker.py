# Rebuilds CSE_PROGRESS.md from the cse overview order. Status is worked out from the files:
# done = the course's level is in the Computer Science category (cse-courses), in progress = tool/cse_content/parts/deep_<id>* exists.
import glob, json, os
here = os.path.dirname(os.path.abspath(__file__))
repo = os.path.dirname(os.path.dirname(here)) + '/'
YEAR = {'cse-1': '1st Year', 'cse-2': '2nd Year', 'cse-3': '2nd Year', 'cse-4': '3rd Year', 'cse-5': '3rd Year',
        'cse-6': '4th Year', 'cse-7': 'MSc', 'cse-8': 'MSc', 'cse-9': 'MSc'}
done = {l['id'][len('deep-'):] for f in [repo + 'assets/content/en/cse-courses.json'] if os.path.exists(f)
        for l in json.load(open(f, encoding='utf-8'))['levels']}
c = json.load(open(repo + 'assets/content/en/cse.json', encoding='utf-8'))
out = ['# CSE full courses: progress', '',
       'Goal: every CSE course as its own level of ~25 lessons (~100 A4 pages), English and Bangla.',
       'Full courses live in the "Computer Science" category (`cse-courses`), grouped by year sections. The short overview lessons are',
       'the "Computer Science Roadmap" category (`cse`). See tool/cse_content/README.md.', '',
       'Status: `done` = in the app, `in progress` = lessons being written, `todo` = not started.',
       'Regenerate with `python3 tool/cse_content/tracker.py`.', '',
       '## Rules (follow these when asked to continue; no extra instructions needed)', '',
       '1. Finish every `in progress` course first, then take `todo` courses from the top of the list down.',
       '2. "Continue" with no number means one batch: the next 6 courses. Then stop, test, commit and report.',
       '3. One agent per course, at most 6 running at once. Never start more courses than the batch. When told to stop, stop at once and start nothing new.',
       '4. Do not add new courses, categories or app features unless the user asks for them.',
       '5. Lessons follow `tool/cse_content/SPEC.md` (tone) and `DEEP_SPEC.md` (shape): ~25 lessons per course, 1,800-2,200 English words each,',
       '   explained like to a curious 10-12 year old, Bangla in everyday spoken (cholito) style with Bangladesh examples, 5 quiz questions,',
       '   same quiz answers in English and Bangla, accurate facts only (leave out anything unsure).',
       '6. Per course: write `outlines/<id>.md`, then `parts/deep_<id>/NN_{en,bn}.json`, run `check_course.py <id>` until it prints OK,',
       '   then `assemble_course.py <id>` (adds it to the Computer Science category under its year, bumps content_version, refreshes this file).',
       '   A half-written course: keep the lessons already written, write only the missing ones from its outline.',
       '7. After the batch: `flutter analyze`, `flutter test`, then commit the content, this file and `tool/cse_content/` together. Do not push.',
       '8. Never change existing lesson ids (learner progress is stored by id).',
       '9. Cost: one course is about 1.3-1.5M tokens and 45-50 minutes per agent. Say so before starting anything bigger than one batch.']
n, cur, count = 0, None, {}
for l in c['levels']:
    if YEAR[l['id']] != cur:
        cur = YEAR[l['id']]
        out += ['', f'## {cur}', '', '| # | Id | Course | Status |', '|---|---|---|---|']
    for s in l['lessons']:
        n += 1
        st = 'done' if s['id'] in done else 'in progress' if glob.glob(f"{here}/parts/deep_{s['id']}*") else 'todo'
        count[st] = count.get(st, 0) + 1
        out.append(f"| {n} | {s['id']} | {s['title']} | {st} |")
open(repo + 'CSE_PROGRESS.md', 'w', encoding='utf-8').write('\n'.join(out) + '\n')
print(n, 'courses;', count)
