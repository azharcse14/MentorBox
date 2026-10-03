# Usage: python3 check_course.py <course id>
# Checks parts/deep_<id>/NN_{en,bn}.json against DEEP_SPEC.md and prints one line per problem.
# Last line: "OK <n> lessons" or "PROBLEMS <count>".
import glob, json, os, sys
here = os.path.dirname(os.path.abspath(__file__))
cid = sys.argv[1]
d = f'{here}/parts/deep_{cid}'
problems = []
nums = sorted({os.path.basename(f)[:2] for f in glob.glob(f'{d}/[0-9][0-9]_*.json')})
if len(nums) < 20:
    problems.append(f'only {len(nums)} lessons (want ~25)')
for n in nums:
    data = {}
    for lang in ('en', 'bn'):
        f = f'{d}/{n}_{lang}.json'
        try:
            data[lang] = json.load(open(f, encoding='utf-8'))
        except FileNotFoundError:
            problems.append(f'{n}: missing {lang}'); continue
        except json.JSONDecodeError as e:
            problems.append(f'{n}_{lang}: bad JSON {e}'); continue
        s = data[lang]
        missing = [k for k in ('id', 'title', 'minutes', 'content', 'key_points', 'tip', 'task', 'quiz') if not s.get(k)]
        if missing: problems.append(f'{n}_{lang}: missing {missing}'); continue
        if s['id'] != f'deep-{cid}-{n}': problems.append(f"{n}_{lang}: id {s['id']} should be deep-{cid}-{n}")
        words, paras = len(s['content'].split()), s['content'].count('\n\n') + 1
        low = 1800 if lang == 'en' else 1450
        if words < low: problems.append(f'{n}_{lang}: {words} words (min {low})')
        if paras < 15: problems.append(f'{n}_{lang}: {paras} paragraphs (min 15)')
        if len(s['quiz']) != 5 or any(len(q.get('options', [])) != 4 or q.get('answer') not in (0, 1, 2, 3) or not q.get('q') or not q.get('explain') for q in s['quiz']):
            problems.append(f'{n}_{lang}: quiz must be 5 questions, 4 options, answer 0-3, q and explain set')
    if len(data) == 2 and 'quiz' in data['en'] and 'quiz' in data['bn']:
        if [q.get('answer') for q in data['en']['quiz']] != [q.get('answer') for q in data['bn']['quiz']]:
            problems.append(f'{n}: en/bn quiz answers differ')
print('\n'.join(problems))
print(f'PROBLEMS {len(problems)}' if problems else f'OK {len(nums)} lessons')
