# Usage: python3 assemble_course.py <course id from CSE_PROGRESS.md, e.g. cse-1-1>
# Joins the lessons in parts/deep_<id>/ into one level of the "Computer Science" category
# (assets/content/<lang>/cse-courses.json) under its year section, in course order.
# Bumps content_version and refreshes CSE_PROGRESS.md.
import glob, json, os, re, sys

here = os.path.dirname(os.path.abspath(__file__))
repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + '/'
content = repo + 'assets/content/'
cid = sys.argv[1]

SECTION_OF = {'cse-1': 'y1', 'cse-2': 'y2', 'cse-3': 'y2', 'cse-4': 'y3', 'cse-5': 'y3', 'cse-6': 'y4',
              'cse-7': 'msc', 'cse-8': 'msc', 'cse-9': 'msc'}
SECTION = {'en': {'y1': '1st Year', 'y2': '2nd Year', 'y3': '3rd Year', 'y4': '4th Year', 'msc': 'MSc'},
           'bn': {'y1': '১ম বছর', 'y2': '২য় বছর', 'y3': '৩য় বছর', 'y4': '৪র্থ বছর', 'msc': 'MSc'}}
CAT_ID = 'cse-courses'

overview = {lang: json.load(open(f'{content}{lang}/cse.json', encoding='utf-8')) for lang in ('en', 'bn')}
courses = {lang: [(l['id'], s) for l in overview[lang]['levels'] for s in l['lessons']] for lang in overview}
n = [s['id'] for _, s in courses['en']].index(cid)
level_of, course_en = courses['en'][n]
section = SECTION_OF[level_of]

lessons = {}
for lang in ('en', 'bn'):
    # one file per lesson (parts/deep_<id>/NN_<lang>.json) or older multi-lesson parts
    single = sorted(glob.glob(f'{here}/parts/deep_{cid}/[0-9][0-9]_{lang}.json'))
    files = sorted(glob.glob(f'{here}/parts/deep_{cid}_part*_{lang}.json'), key=lambda f: int(re.search(r'part(\d+)', f).group(1)))
    assert single or files, f'no lessons for course {cid}'
    lessons[lang] = [json.load(open(f, encoding='utf-8')) for f in single] or [s for f in files for s in json.load(open(f, encoding='utf-8'))]
shape = lambda ls: [(s['id'], [q['answer'] for q in s['quiz']]) for s in ls]
assert shape(lessons['en']) == shape(lessons['bn']), 'en/bn mismatch'
for s in lessons['en'] + lessons['bn']:
    assert len(s['quiz']) == 5 and all(len(q['options']) == 4 for q in s['quiz']), s['id']

for lang in ('en', 'bn'):
    course = courses[lang][n][1]
    level = {'id': f"deep-{course['id']}", 'title': course['title'], 'section': SECTION[lang][section],
             'lessons': lessons[lang]}
    path = f'{content}{lang}/{CAT_ID}.json'
    cat = json.load(open(path, encoding='utf-8'))
    cat['levels'] = [l for l in cat['levels'] if l['id'] != level['id']] + [level]
    # keep levels in course order
    rank = {f"deep-{s['id']}": i for i, (_, s) in enumerate(courses[lang])}
    cat['levels'].sort(key=lambda l: rank[l['id']])
    open(path, 'w', encoding='utf-8').write(json.dumps(cat, ensure_ascii=False, indent=2) + '\n')

index = json.load(open(content + 'index.json'))
assert CAT_ID in index['categories'], f'{CAT_ID} missing from index.json'
index['content_version'] += 1
open(content + 'index.json', 'w').write(json.dumps(index, indent=2) + '\n')

import subprocess
subprocess.run([sys.executable, here + '/tracker.py'], check=True)

words = [len(s['content'].split()) for s in lessons['en']]
print(f'course {cid} {course_en["title"]} -> {CAT_ID} / {SECTION["en"][section]}: {len(words)} lessons, {sum(words)} en words '
      f'(~{sum(words) // 500} A4 pages), content_version {index["content_version"]}')
