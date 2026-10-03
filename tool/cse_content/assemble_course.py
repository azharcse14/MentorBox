# Usage: python3 assemble_course.py <course id from CSE_PROGRESS.md, e.g. cse-1-1>
# Joins parts/deep_<id>_part*_{en,bn}.json into one level and puts it in the year category
# (cse-y1 .. cse-y4, cse-msc), creating the category if needed. Bumps content_version
# and marks the course done in CSE_PROGRESS.md.
import glob, json, os, re, sys

here = os.path.dirname(os.path.abspath(__file__))
repo = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))) + '/'
content = repo + 'assets/content/'
cid = sys.argv[1]

YEAR = {'cse-1': 'y1', 'cse-2': 'y2', 'cse-3': 'y2', 'cse-4': 'y3', 'cse-5': 'y3', 'cse-6': 'y4',
        'cse-7': 'msc', 'cse-8': 'msc', 'cse-9': 'msc'}
HEADER = {
    'en': {
        'y1': ('CSE 1st Year', '1st year courses in full: computers, C, discrete math, calculus and circuits.'),
        'y2': ('CSE 2nd Year', '2nd year courses in full: OOP, data structures, logic, algorithms and the machine.'),
        'y3': ('CSE 3rd Year', '3rd year courses in full: OS, databases, networks, software and real apps.'),
        'y4': ('CSE 4th Year', '4th year courses in full: ML, security, distributed systems and your project.'),
        'msc': ('CSE MSc', 'MSc courses in full: advanced algorithms, AI, data, cloud and future tech.'),
    },
    'bn': {
        'y1': ('সিএসই ১ম বছর', '১ম বছরের কোর্সগুলো পুরোটা: কম্পিউটার, C, ডিসক্রিট ম্যাথ, ক্যালকুলাস আর সার্কিট।'),
        'y2': ('সিএসই ২য় বছর', '২য় বছরের কোর্সগুলো পুরোটা: OOP, ডেটা স্ট্রাকচার, লজিক, অ্যালগরিদম আর মেশিনের ভেতর।'),
        'y3': ('সিএসই ৩য় বছর', '৩য় বছরের কোর্সগুলো পুরোটা: OS, ডেটাবেস, নেটওয়ার্ক, সফটওয়্যার আর আসল অ্যাপ।'),
        'y4': ('সিএসই ৪র্থ বছর', '৪র্থ বছরের কোর্সগুলো পুরোটা: ML, সিকিউরিটি, ডিস্ট্রিবিউটেড সিস্টেম আর তোমার প্রজেক্ট।'),
        'msc': ('সিএসই MSc', 'MSc-র কোর্সগুলো পুরোটা: অ্যাডভান্সড অ্যালগরিদম, AI, ডেটা, ক্লাউড আর ভবিষ্যতের টেক।'),
    },
}
MESSAGES = {
    'en': {'welcome': "This is the full course, one topic per lesson. Take one lesson a day and you'll finish a course in about a month.",
           'comeback': 'Your next topic is waiting. Read just the first few paragraphs today.',
           'pass': 'Nice! One more topic you really understand.',
           'fail': 'No problem. Read the explanations, go through the lesson again and retry.',
           'finished': 'You finished every course here. Go build something with it!'},
    'bn': {'welcome': 'এখানে পুরো কোর্স, প্রতিটা লেসনে একটা টপিক। দিনে একটা করে লেসন পড়লে মাসখানেকে একটা কোর্স শেষ।',
           'comeback': 'তোমার পরের টপিকটা বসে আছে। আজকে শুধু প্রথম কয়েকটা প্যারা পড়ো।',
           'pass': 'জোস! আরেকটা টপিক এখন তুমি আসলেই বোঝো।',
           'fail': 'সমস্যা নাই। ব্যাখ্যাগুলো পড়ো, লেসনটা আরেকবার দেখো, তারপর আবার ট্রাই করো।',
           'finished': 'এখানের সব কোর্স শেষ! এবার এগুলো দিয়ে কিছু একটা বানাও।'},
}
ORDER = ['y1', 'y2', 'y3', 'y4', 'msc']

overview = {lang: json.load(open(f'{content}{lang}/cse.json', encoding='utf-8')) for lang in ('en', 'bn')}
courses = {lang: [(l['id'], s) for l in overview[lang]['levels'] for s in l['lessons']] for lang in overview}
n = [s['id'] for _, s in courses['en']].index(cid)
level_of, course_en = courses['en'][n]
year = YEAR[level_of]
cat_id = f'cse-{year}'

lessons = {}
for lang in ('en', 'bn'):
    files = sorted(glob.glob(f'{here}/parts/deep_{cid}_part*_{lang}.json'), key=lambda f: int(re.search(r'part(\d+)', f).group(1)))
    assert files, f'no parts for course {cid}'
    lessons[lang] = [s for f in files for s in json.load(open(f, encoding='utf-8'))]
shape = lambda ls: [(s['id'], [q['answer'] for q in s['quiz']]) for s in ls]
assert shape(lessons['en']) == shape(lessons['bn']), 'en/bn mismatch'
for s in lessons['en'] + lessons['bn']:
    assert len(s['quiz']) == 5 and all(len(q['options']) == 4 for q in s['quiz']), s['id']

for lang in ('en', 'bn'):
    course = courses[lang][n][1]
    level = {'id': f"deep-{course['id']}", 'title': course['title'], 'lessons': lessons[lang]}
    path = f'{content}{lang}/{cat_id}.json'
    if os.path.exists(path):
        cat = json.load(open(path, encoding='utf-8'))
    else:
        name, desc = HEADER[lang][year]
        cat = {'id': cat_id, 'name': name, 'mentor': overview[lang]['mentor'], 'tagline': desc, 'description': desc,
               'image': 'assets/images/cse.jpg', 'color': '#3F6E8C', 'messages': MESSAGES[lang], 'levels': []}
    cat['levels'] = [l for l in cat['levels'] if l['id'] != level['id']] + [level]
    # keep levels in course order
    rank = {f"deep-{s['id']}": i for i, (_, s) in enumerate(courses[lang])}
    cat['levels'].sort(key=lambda l: rank[l['id']])
    open(path, 'w', encoding='utf-8').write(json.dumps(cat, ensure_ascii=False, indent=2) + '\n')

index = json.load(open(content + 'index.json'))
if cat_id not in index['categories']:
    index['categories'].append(cat_id)
    deep = [c for c in index['categories'] if c.startswith('cse-')]
    rest = [c for c in index['categories'] if not c.startswith('cse-')]
    index['categories'] = rest + sorted(deep, key=lambda c: ORDER.index(c[4:]))
index['content_version'] += 1
open(content + 'index.json', 'w').write(json.dumps(index, indent=2) + '\n')

tracker = open(repo + 'CSE_PROGRESS.md', encoding='utf-8').read()
tracker = re.sub(rf'^(\| \d+ \| {cid} \| .*) \| [a-z ]+ \|$', r'\1 | done |', tracker, count=1, flags=re.M)
open(repo + 'CSE_PROGRESS.md', 'w', encoding='utf-8').write(tracker)

words = [len(s['content'].split()) for s in lessons['en']]
print(f'course {cid} {course_en["title"]} -> {cat_id}: {len(words)} lessons, {sum(words)} en words '
      f'(~{sum(words) // 500} A4 pages), content_version {index["content_version"]}')
