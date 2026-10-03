# CSE full courses: progress

Goal: every CSE course as its own level of ~25 lessons (~100 A4 pages), English and Bangla.
Full courses live in the "Computer Science" category (`cse-courses`), grouped by year sections. The short overview lessons are
the "Computer Science Roadmap" category (`cse`). See tool/cse_content/README.md.

Status: `done` = in the app, `in progress` = lessons being written, `todo` = not started.
Regenerate with `python3 tool/cse_content/tracker.py`.

## Rules (follow these when asked to continue; no extra instructions needed)

1. Finish every `in progress` course first, then take `todo` courses from the top of the list down.
2. "Continue" with no number means one batch: the next 6 courses. Then stop, test, commit and report.
3. One agent per course, at most 6 running at once. Never start more courses than the batch. When told to stop, stop at once and start nothing new.
4. Do not add new courses, categories or app features unless the user asks for them.
5. Lessons follow `tool/cse_content/SPEC.md` (tone) and `DEEP_SPEC.md` (shape): ~25 lessons per course, 1,800-2,200 English words each,
   explained like to a curious 10-12 year old, Bangla in everyday spoken (cholito) style with Bangladesh examples, 5 quiz questions,
   same quiz answers in English and Bangla, accurate facts only (leave out anything unsure).
6. Per course: write `outlines/<id>.md`, then `parts/deep_<id>/NN_{en,bn}.json`, run `check_course.py <id>` until it prints OK,
   then `assemble_course.py <id>` (adds it to the Computer Science category under its year, bumps content_version, refreshes this file).
   A half-written course: keep the lessons already written, write only the missing ones from its outline.
7. After the batch: `flutter analyze`, `flutter test`, then commit the content, this file and `tool/cse_content/` together. Do not push.
8. Never change existing lesson ids (learner progress is stored by id).
9. Cost: one course is about 1.3-1.5M tokens and 45-50 minutes per agent. Say so before starting anything bigger than one batch.

## 1st Year

| # | Id | Course | Status |
|---|---|---|---|
| 1 | cse-1-1 | Introduction to Computer Systems | done |
| 2 | cse-1-2 | Structured Programming (C) | done |
| 3 | cse-1-3 | Discrete Mathematics | done |
| 4 | cse-1-4 | Calculus & Differential Equations | done |
| 5 | cse-1-5 | Electrical Circuits | done |

## 2nd Year

| # | Id | Course | Status |
|---|---|---|---|
| 6 | cse-2-1 | Object Oriented Programming | done |
| 7 | cse-2-2 | Data Structures | done |
| 8 | cse-2-3 | Digital Logic Design | done |
| 9 | cse-2-4 | Electronic Devices & Circuits | done |
| 10 | cse-2-5 | Linear Algebra | done |
| 11 | cse-2-6 | Probability & Statistics | done |
| 12 | cse-2-7 | Complex Variables, Fourier & Laplace Transforms (Math III) | done |
| 13 | cse-3-1 | Algorithms (Design & Analysis) | done |
| 14 | cse-3-2 | Computer Architecture & Organization | todo |
| 15 | cse-3-3 | Microprocessors & Assembly Language | todo |
| 16 | cse-3-4 | Numerical Methods | todo |
| 17 | cse-3-5 | Theory of Computation | todo |
| 18 | cse-3-6 | Data Communication | todo |
| 19 | cse-3-7 | Signals & Systems | todo |
| 20 | cse-3-8 | Computer Peripherals & Interfacing | todo |
| 21 | cse-3-9 | Graph Theory | todo |

## 3rd Year

| # | Id | Course | Status |
|---|---|---|---|
| 22 | cse-4-1 | Operating Systems | todo |
| 23 | cse-4-2 | Database Management Systems | todo |
| 24 | cse-4-3 | Computer Networks | todo |
| 25 | cse-4-4 | Software Engineering | todo |
| 26 | cse-4-5 | Compiler Design | todo |
| 27 | cse-4-6 | System Analysis & Design | todo |
| 28 | cse-4-7 | Management Information Systems | todo |
| 29 | cse-5-1 | Artificial Intelligence | todo |
| 30 | cse-5-2 | Computer Graphics | todo |
| 31 | cse-5-3 | Web Engineering | todo |
| 32 | cse-5-4 | Mobile Application Development | todo |
| 33 | cse-5-5 | Human Computer Interaction | todo |
| 34 | cse-5-6 | Embedded Systems | todo |
| 35 | cse-5-7 | Digital Signal Processing | todo |
| 36 | cse-5-8 | Software Testing & Quality Assurance | todo |
| 37 | cse-5-9 | Multimedia Systems | todo |
| 38 | cse-5-10 | Game Development | todo |

## 4th Year

| # | Id | Course | Status |
|---|---|---|---|
| 39 | cse-6-1 | Machine Learning | todo |
| 40 | cse-6-2 | Computer Security & Cryptography | todo |
| 41 | cse-6-3 | Distributed Systems | todo |
| 42 | cse-6-4 | Digital Image Processing | todo |
| 43 | cse-6-5 | Simulation & Modeling | todo |
| 44 | cse-6-6 | Professional Ethics & Cyber Law | todo |
| 45 | cse-6-8 | Technical Writing | todo |
| 46 | cse-6-9 | VLSI Design | todo |
| 47 | cse-6-10 | Operations Research | todo |
| 48 | cse-6-11 | Software Project Management | todo |
| 49 | cse-6-12 | Pattern Recognition | todo |
| 50 | cse-6-13 | System Design | todo |
| 51 | cse-6-14 | Data Science | todo |
| 52 | cse-6-7 | Final Year Project / Thesis | todo |

## MSc

| # | Id | Course | Status |
|---|---|---|---|
| 53 | cse-7-1 | Advanced Algorithms | todo |
| 54 | cse-7-2 | Advanced Database Systems & Big Data | todo |
| 55 | cse-7-3 | Cloud Computing | todo |
| 56 | cse-7-4 | Advanced Computer Networks & Wireless Networks | todo |
| 57 | cse-7-5 | Parallel & High Performance Computing | todo |
| 58 | cse-7-6 | Data Mining | todo |
| 59 | cse-7-7 | Research Methodology | todo |
| 60 | cse-7-8 | Neural Networks & Fuzzy Systems | todo |
| 61 | cse-7-9 | Information Retrieval | todo |
| 62 | cse-7-10 | Fault Tolerant Systems | todo |
| 63 | cse-7-11 | Data Engineering | todo |
| 64 | cse-8-1 | Deep Learning | todo |
| 65 | cse-8-2 | Natural Language Processing | todo |
| 66 | cse-8-3 | Computer Vision | todo |
| 67 | cse-8-4 | Reinforcement Learning | todo |
| 68 | cse-8-5 | Robotics | todo |
| 69 | cse-9-1 | Internet of Things (IoT) | todo |
| 70 | cse-9-2 | Blockchain | todo |
| 71 | cse-9-3 | Quantum Computing | todo |
| 72 | cse-9-4 | Bioinformatics | todo |
| 73 | cse-9-5 | Advanced Cyber Security | todo |
| 74 | cse-9-7 | Wireless Sensor Networks | todo |
| 75 | cse-9-6 | MSc Thesis | todo |
