# Rebuilds CSE_PROGRESS.md from the cse overview order, keeping each course's status by id.
# Usage: python3 tracker.py [<course id> <status>]
import json, os, re, sys
repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + '/'
YEAR = {'cse-1': '1st Year', 'cse-2': '2nd Year', 'cse-3': '2nd Year', 'cse-4': '3rd Year', 'cse-5': '3rd Year',
        'cse-6': '4th Year', 'cse-7': 'MSc', 'cse-8': 'MSc', 'cse-9': 'MSc'}
try:
    old = open(repo + 'CSE_PROGRESS.md', encoding='utf-8').read()
except FileNotFoundError:
    old = ''
status = dict(re.findall(r'^\| \d+ \| (cse-[\d-]+) \| .* \| ([a-z ]+) \|$', old, re.M))
if len(sys.argv) == 3:
    status[sys.argv[1]] = sys.argv[2]
c = json.load(open(repo + 'assets/content/en/cse.json', encoding='utf-8'))
out = ['# CSE full courses: progress', '',
       'Goal: every CSE course as its own level of ~25 lessons (~100 A4 pages), English and Bangla.',
       'The short overview lessons in the `cse` category stay as they are.', '',
       'Status: `done` = in the app, `in progress` = being written, `todo` = not started.']
n, cur = 0, None
for l in c['levels']:
    if YEAR[l['id']] != cur:
        cur = YEAR[l['id']]
        out += ['', f'## {cur}', '', '| # | Id | Course | Status |', '|---|---|---|---|']
    for s in l['lessons']:
        n += 1
        out.append(f"| {n} | {s['id']} | {s['title']} | {status.get(s['id'], 'todo')} |")
open(repo + 'CSE_PROGRESS.md', 'w', encoding='utf-8').write('\n'.join(out) + '\n')
print(n, 'courses;', {v: list(status.values()).count(v) for v in set(status.values())})
