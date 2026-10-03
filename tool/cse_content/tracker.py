# Rebuilds CSE_PROGRESS.md from the cse overview order. Status is worked out from the files:
# done = the course's level is in its year category, in progress = tool/cse_content/parts/deep_<id>* exists.
import glob, json, os
here = os.path.dirname(os.path.abspath(__file__))
repo = os.path.dirname(os.path.dirname(here)) + '/'
YEAR = {'cse-1': '1st Year', 'cse-2': '2nd Year', 'cse-3': '2nd Year', 'cse-4': '3rd Year', 'cse-5': '3rd Year',
        'cse-6': '4th Year', 'cse-7': 'MSc', 'cse-8': 'MSc', 'cse-9': 'MSc'}
done = {l['id'][len('deep-'):] for f in glob.glob(repo + 'assets/content/en/cse-*.json')
        for l in json.load(open(f, encoding='utf-8'))['levels']}
c = json.load(open(repo + 'assets/content/en/cse.json', encoding='utf-8'))
out = ['# CSE full courses: progress', '',
       'Goal: every CSE course as its own level of ~25 lessons (~100 A4 pages), English and Bangla.',
       'The short overview lessons in the `cse` category stay as they are. See tool/cse_content/README.md.', '',
       'Status: `done` = in the app, `in progress` = lessons being written, `todo` = not started.',
       'Regenerate with `python3 tool/cse_content/tracker.py`.']
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
