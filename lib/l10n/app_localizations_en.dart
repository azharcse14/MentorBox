// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MentorBox';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get savedLessons => 'Saved lessons';

  @override
  String get language => 'Language';

  @override
  String get deviceLanguage => 'Phone\'s language';

  @override
  String get theme => 'Theme';

  @override
  String get deviceTheme => 'Phone\'s theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get todaysMissions => 'Today\'s missions';

  @override
  String get defaultName => 'Learner';

  @override
  String loadError(String error) {
    return 'The lessons could not be loaded. Check that the files in assets/content/ are valid JSON and listed in pubspec.yaml.\n\n$error';
  }

  @override
  String get exploreLabel => 'Explore :';

  @override
  String get exploreTagline => 'Pick a mentor,\ngrow one skill a day';

  @override
  String get heroBefore => 'Your Personal\n';

  @override
  String get heroHighlight => 'Mentors';

  @override
  String get heroAfter => ' For\nEvery Skill';

  @override
  String streakDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString day streak',
      one: '$countString day streak',
    );
    return '$_temp0';
  }

  @override
  String get noStreak => 'No streak yet';

  @override
  String continueWith(String mentor) {
    return 'Continue with $mentor';
  }

  @override
  String get nameDialogFirstTitle => 'Hi! What should your mentors call you?';

  @override
  String get nameDialogChangeTitle => 'Change your name';

  @override
  String get nameHint => 'Your name';

  @override
  String get saveName => 'Save name';

  @override
  String get finished => 'Finished';

  @override
  String percentDone(int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$percentString% done';
  }

  @override
  String get lockedLessonHint =>
      'Finish the lesson before this one to unlock it.';

  @override
  String get progressLabel => 'Progress : ';

  @override
  String percent(int value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString%';
  }

  @override
  String lessonsOf(int done, int total) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString of $totalString lessons';
  }

  @override
  String get reviewFromFirst => 'Review from the first lesson';

  @override
  String get startMentoring => 'Start mentoring';

  @override
  String continueLesson(String title) {
    return 'Continue: $title';
  }

  @override
  String levelNumber(int number) {
    final intl.NumberFormat numberNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Level $numberString';
  }

  @override
  String fraction(int done, int total) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString/$totalString';
  }

  @override
  String get locked => 'Locked';

  @override
  String minutes(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString min';
  }

  @override
  String minutesWithScore(int minutes, int score) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);
    final intl.NumberFormat scoreNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String scoreString = scoreNumberFormat.format(score);

    return '$minutesString min, best quiz score $scoreString';
  }

  @override
  String get lessonSaved => 'Lesson saved';

  @override
  String get lessonUnsaved => 'Lesson removed from saved';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get lessonMissing => 'This lesson is no longer available.';

  @override
  String get removeFromSaved => 'Remove from saved';

  @override
  String get saveLesson => 'Save lesson';

  @override
  String minutesRead(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString min read';
  }

  @override
  String get completed => 'Completed';

  @override
  String get keyPoints => 'Key points';

  @override
  String get mentorTip => 'Mentor tip';

  @override
  String get yourTask => 'Your task';

  @override
  String get iDidTask => 'I did this task';

  @override
  String get myNotes => 'My notes';

  @override
  String get notesHint =>
      'What did you learn? Where will you use it this week?';

  @override
  String get markComplete => 'Mark lesson as complete';

  @override
  String get takeQuiz => 'Take the quiz';

  @override
  String get retakeQuiz => 'Retake the quiz';

  @override
  String nextLesson(String title) {
    return 'Next lesson: $title';
  }

  @override
  String get backToMentor => 'Back to your mentor';

  @override
  String get practiceQuizAgain => 'Practice the quiz again';

  @override
  String get noQuiz => 'This lesson has no quiz.';

  @override
  String get quizTitle => 'Quiz';

  @override
  String questionProgress(int number, int total) {
    final intl.NumberFormat numberNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Question $numberString of $totalString';
  }

  @override
  String get answerCorrect => 'Correct';

  @override
  String get answerWrong => 'Not quite';

  @override
  String get checkAnswer => 'Check answer';

  @override
  String get seeResult => 'See my result';

  @override
  String get nextQuestion => 'Next question';

  @override
  String score(int correct, int total) {
    final intl.NumberFormat correctNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String correctString = correctNumberFormat.format(correct);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$correctString / $totalString';
  }

  @override
  String youCompleted(String title) {
    return 'You completed \"$title\"';
  }

  @override
  String needToPass(int required) {
    final intl.NumberFormat requiredNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String requiredString = requiredNumberFormat.format(required);

    return 'You need $requiredString right answers to pass';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get reviewLesson => 'Review the lesson';

  @override
  String get tryQuizAgain => 'Try the quiz again';

  @override
  String get savedTitle => 'Saved';

  @override
  String get savedEmpty =>
      'Tap the bookmark on any lesson to keep it here for later.';

  @override
  String get yourNotes => 'Your notes';

  @override
  String get notesEmpty =>
      'Notes you write at the end of a lesson show up here.';

  @override
  String get todayTitle => 'Today';

  @override
  String get noMissions =>
      'You have no missions yet. Pick a mentor below or on the home screen and start the first lesson.';

  @override
  String lessonsDone(int done, int total) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$doneString of $totalString lessons done';
  }

  @override
  String taskPrefix(String task) {
    return 'Task: $task';
  }

  @override
  String get tryNewMentor => 'Try a new mentor';

  @override
  String get todayDone => 'You learned something today. See you tomorrow.';

  @override
  String get keepStreak =>
      'Finish a task or a quiz today to keep your streak going.';

  @override
  String get greetFinished =>
      'You finished every lesson here. Explain one idea to a friend this week. Teaching it is the final test.';

  @override
  String get greetWelcome =>
      'Let\'s start small. One short lesson, one small task. That is how every skill begins.';

  @override
  String get greetComeback =>
      'Good to have you back. Skip the guilt and do one lesson today.';

  @override
  String greetProgress(int done, int total, String title) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'You are $doneString of $totalString lessons in. Next up is \"$title\".';
  }

  @override
  String get quizPassShort => 'Well done.';

  @override
  String quizPerfect(String message) {
    return '$message And a perfect score.';
  }

  @override
  String get quizPassed => 'Well done, you passed this lesson.';

  @override
  String get quizTricky =>
      'This one is tricky, and that is normal. Read only the key points again, then try once more. Slow progress is still progress.';

  @override
  String get quizFail =>
      'Not yet. Read the explanations above, review the lesson, and try again.';

  @override
  String get settings => 'Settings';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderHint => 'Only on days you haven\'t studied yet';

  @override
  String get retry => 'Try again';

  @override
  String get skip => 'Skip';

  @override
  String get undo => 'Undo';

  @override
  String get lessonCompleted => 'Lesson complete! Nice work.';

  @override
  String get leaveQuizTitle => 'Leave the quiz?';

  @override
  String get leaveQuizBody => 'Your answers so far will be lost.';

  @override
  String get leaveQuiz => 'Leave';

  @override
  String get stayInQuiz => 'Stay';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get notifPracticeTitle => 'Time for today\'s lesson';

  @override
  String notifPracticeBody(String mentor, String lesson, int minutes) {
    return '$mentor: \"$lesson\" is next. Just $minutes min.';
  }

  @override
  String get notifGenericBody => 'One short lesson a day adds up.';

  @override
  String notifStreakRiskTitle(int count) {
    return '🔥 Your $count-day streak is at risk';
  }

  @override
  String get notifStreakRiskBody => 'It ends at midnight. One lesson saves it.';

  @override
  String notifStreakLostTitle(int count) {
    return 'Your $count-day streak ended';
  }

  @override
  String get notifStreakLostBody =>
      'Every streak starts at day 1. Start a new one today.';

  @override
  String get notifComebackTitle => 'Your mentors miss you';

  @override
  String notifComebackBody(String mentor, String lesson) {
    return '$mentor saved your place: \"$lesson\"';
  }

  @override
  String get notifLastCallTitle => 'We\'ll pause your reminders';

  @override
  String get notifLastCallBody =>
      'These reminders don\'t seem to be working, so we\'ll stop for now. Come back any time!';
}
