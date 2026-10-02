# Mentor

An offline mentoring app built with Flutter. There are no human mentors here: the app itself is the mentor. Each category (Programming, Career Growth, Communication, Productivity, Personal Finance, Mindset & Wellbeing) acts as its own mentor with its own voice, roadmap, lessons, tasks and quizzes.

Everything runs on the device. Lessons are bundled in the app and copied into a local SQLite database on first launch, and all progress is stored locally. No account, no server, no internet needed (fonts are bundled too).

## What the app does

- **Home**: greeting with your name, your daily streak, a "continue" card for the mentor you used last, and the swipeable mentor cards with your progress in each.
- **Mentor page**: the mentor greets you based on your situation (first visit, returning after a break, finished), shows your progress and the roadmap of levels and lessons.
- **Lesson page**: short reading, key points, a mentor tip, a practical task you can tick off, and your own notes.
- **Quiz**: one question at a time with an explanation after every answer. Options are shuffled each time. Pass with two thirds correct to complete the lesson and unlock the next one.
- **Saved** (heart icon): lessons you bookmarked and lessons where you wrote notes.
- **Today** (bell icon): your week at a glance and the next lesson from every mentor you have started.

## Mentoring rules

All the "mentor decisions" live in `lib/logic/mentor_engine.dart`:

- Lessons unlock one by one. Finishing the last lesson of a level opens the next level.
- A quiz is passed with at least two thirds correct (2 of 3). Failing never removes a lesson you already passed.
- After three failed attempts the mentor changes its advice.
- A day counts toward your streak when you finish a task or take a quiz. Missing today does not break the streak until the day is over.
- After 3 days away, the mentor welcomes you back instead of continuing as if nothing happened.

## Run it

```bash
flutter pub get
flutter run
flutter test
```

The database uses `sqflite`, which supports Android, iOS and macOS. Web, Windows and Linux would need `sqflite_common_ffi` (desktop) or a different storage package.

## Project structure

```
assets/content/mentors.json   all mentoring content (edit this to add lessons)
assets/fonts/                 bundled fonts (SIL Open Font License)
lib/
  main.dart
  theme.dart                  colors and text styles
  data/
    app_database.dart         SQLite schema
    content_seeder.dart       copies mentors.json into the database
    mentor_repository.dart    every database read and write
    models.dart               MentorCategory, Level, Lesson, QuizQuestion, LessonProgress
  logic/
    mentor_engine.dart        unlocking, grading, feedback, streaks
  components/                 app bar, mentor card, shared widgets
  pages/                      home, mentor, lesson, quiz, saved, today
test/mentor_engine_test.dart  tests for the mentor logic
```

## Adding or changing content

1. Open `assets/content/mentors.json`.
2. Add a category, a level or a lesson following the existing ones. Each lesson needs a unique `id`, a `title`, `minutes`, `content` (paragraphs separated by a blank line, written as `\n\n`), `key_points`, `tip`, `task` and a `quiz`. In each quiz question, `answer` is the position of the correct option, starting at 0.
3. Increase `content_version` by 1. On the next launch the app reloads the content.

Progress is stored by lesson `id`, so keep existing ids unchanged or learners will lose progress on those lessons. A new category needs an image in `assets/images/` and a `color` like `"#5E8C8A"`.

The lessons are general education. The finance and wellbeing categories say so in their descriptions; keep that if you edit them.
