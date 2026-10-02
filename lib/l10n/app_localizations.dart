import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MentorBox'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @savedLessons.
  ///
  /// In en, this message translates to:
  /// **'Saved lessons'**
  String get savedLessons;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Phone\'s language'**
  String get deviceLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @deviceTheme.
  ///
  /// In en, this message translates to:
  /// **'Phone\'s theme'**
  String get deviceTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @todaysMissions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s missions'**
  String get todaysMissions;

  /// No description provided for @defaultName.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get defaultName;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'The lessons could not be loaded. Check that assets/content/mentors.json is valid JSON and listed in pubspec.yaml.\n\n{error}'**
  String loadError(String error);

  /// No description provided for @exploreLabel.
  ///
  /// In en, this message translates to:
  /// **'Explore :'**
  String get exploreLabel;

  /// No description provided for @exploreTagline.
  ///
  /// In en, this message translates to:
  /// **'Pick a mentor,\ngrow one skill a day'**
  String get exploreTagline;

  /// No description provided for @heroBefore.
  ///
  /// In en, this message translates to:
  /// **'Your Personal\n'**
  String get heroBefore;

  /// No description provided for @heroHighlight.
  ///
  /// In en, this message translates to:
  /// **'Mentors'**
  String get heroHighlight;

  /// No description provided for @heroAfter.
  ///
  /// In en, this message translates to:
  /// **' For\nEvery Skill'**
  String get heroAfter;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} day streak} other{{count} day streak}}'**
  String streakDays(int count);

  /// No description provided for @noStreak.
  ///
  /// In en, this message translates to:
  /// **'No streak yet'**
  String get noStreak;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {mentor}'**
  String continueWith(String mentor);

  /// No description provided for @nameDialogFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi! What should your mentors call you?'**
  String get nameDialogFirstTitle;

  /// No description provided for @nameDialogChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Change your name'**
  String get nameDialogChangeTitle;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @saveName.
  ///
  /// In en, this message translates to:
  /// **'Save name'**
  String get saveName;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @percentDone.
  ///
  /// In en, this message translates to:
  /// **'{percent}% done'**
  String percentDone(int percent);

  /// No description provided for @cardStats.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} lessons, {levels} levels'**
  String cardStats(int done, int total, int levels);

  /// No description provided for @lockedLessonHint.
  ///
  /// In en, this message translates to:
  /// **'Finish the lesson before this one to unlock it.'**
  String get lockedLessonHint;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress : '**
  String get progressLabel;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @lessonsOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} lessons'**
  String lessonsOf(int done, int total);

  /// No description provided for @reviewFromFirst.
  ///
  /// In en, this message translates to:
  /// **'Review from the first lesson'**
  String get reviewFromFirst;

  /// No description provided for @startMentoring.
  ///
  /// In en, this message translates to:
  /// **'Start mentoring'**
  String get startMentoring;

  /// No description provided for @continueLesson.
  ///
  /// In en, this message translates to:
  /// **'Continue: {title}'**
  String continueLesson(String title);

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {number}'**
  String levelNumber(int number);

  /// No description provided for @fraction.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String fraction(int done, int total);

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutes(int minutes);

  /// No description provided for @minutesWithScore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min, best quiz score {score}'**
  String minutesWithScore(int minutes, int score);

  /// No description provided for @lessonSaved.
  ///
  /// In en, this message translates to:
  /// **'Lesson saved'**
  String get lessonSaved;

  /// No description provided for @lessonUnsaved.
  ///
  /// In en, this message translates to:
  /// **'Lesson removed from saved'**
  String get lessonUnsaved;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteSaved;

  /// No description provided for @lessonMissing.
  ///
  /// In en, this message translates to:
  /// **'This lesson is no longer available.'**
  String get lessonMissing;

  /// No description provided for @removeFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get removeFromSaved;

  /// No description provided for @saveLesson.
  ///
  /// In en, this message translates to:
  /// **'Save lesson'**
  String get saveLesson;

  /// No description provided for @minutesRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String minutesRead(int minutes);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @keyPoints.
  ///
  /// In en, this message translates to:
  /// **'Key points'**
  String get keyPoints;

  /// No description provided for @mentorTip.
  ///
  /// In en, this message translates to:
  /// **'Mentor tip'**
  String get mentorTip;

  /// No description provided for @yourTask.
  ///
  /// In en, this message translates to:
  /// **'Your task'**
  String get yourTask;

  /// No description provided for @iDidTask.
  ///
  /// In en, this message translates to:
  /// **'I did this task'**
  String get iDidTask;

  /// No description provided for @myNotes.
  ///
  /// In en, this message translates to:
  /// **'My notes'**
  String get myNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'What did you learn? Where will you use it this week?'**
  String get notesHint;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get saveNote;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark lesson as complete'**
  String get markComplete;

  /// No description provided for @takeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take the quiz'**
  String get takeQuiz;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake the quiz'**
  String get retakeQuiz;

  /// No description provided for @nextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next lesson: {title}'**
  String nextLesson(String title);

  /// No description provided for @backToMentor.
  ///
  /// In en, this message translates to:
  /// **'Back to your mentor'**
  String get backToMentor;

  /// No description provided for @practiceQuizAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice the quiz again'**
  String get practiceQuizAgain;

  /// No description provided for @noQuiz.
  ///
  /// In en, this message translates to:
  /// **'This lesson has no quiz.'**
  String get noQuiz;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {number} of {total}'**
  String questionProgress(int number, int total);

  /// No description provided for @answerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get answerCorrect;

  /// No description provided for @answerWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get answerWrong;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get checkAnswer;

  /// No description provided for @seeResult.
  ///
  /// In en, this message translates to:
  /// **'See my result'**
  String get seeResult;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next question'**
  String get nextQuestion;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total}'**
  String score(int correct, int total);

  /// No description provided for @youCompleted.
  ///
  /// In en, this message translates to:
  /// **'You completed \"{title}\"'**
  String youCompleted(String title);

  /// No description provided for @needToPass.
  ///
  /// In en, this message translates to:
  /// **'You need {required} right answers to pass'**
  String needToPass(int required);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @reviewLesson.
  ///
  /// In en, this message translates to:
  /// **'Review the lesson'**
  String get reviewLesson;

  /// No description provided for @tryQuizAgain.
  ///
  /// In en, this message translates to:
  /// **'Try the quiz again'**
  String get tryQuizAgain;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark on any lesson to keep it here for later.'**
  String get savedEmpty;

  /// No description provided for @yourNotes.
  ///
  /// In en, this message translates to:
  /// **'Your notes'**
  String get yourNotes;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Notes you write at the end of a lesson show up here.'**
  String get notesEmpty;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @noMissions.
  ///
  /// In en, this message translates to:
  /// **'You have no missions yet. Pick a mentor below or on the home screen and start the first lesson.'**
  String get noMissions;

  /// No description provided for @lessonsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} lessons done'**
  String lessonsDone(int done, int total);

  /// No description provided for @taskPrefix.
  ///
  /// In en, this message translates to:
  /// **'Task: {task}'**
  String taskPrefix(String task);

  /// No description provided for @tryNewMentor.
  ///
  /// In en, this message translates to:
  /// **'Try a new mentor'**
  String get tryNewMentor;

  /// No description provided for @todayDone.
  ///
  /// In en, this message translates to:
  /// **'You learned something today. See you tomorrow.'**
  String get todayDone;

  /// No description provided for @keepStreak.
  ///
  /// In en, this message translates to:
  /// **'Finish a task or a quiz today to keep your streak going.'**
  String get keepStreak;

  /// No description provided for @greetFinished.
  ///
  /// In en, this message translates to:
  /// **'You finished every lesson here. Explain one idea to a friend this week. Teaching it is the final test.'**
  String get greetFinished;

  /// No description provided for @greetWelcome.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start small. One short lesson, one small task. That is how every skill begins.'**
  String get greetWelcome;

  /// No description provided for @greetComeback.
  ///
  /// In en, this message translates to:
  /// **'Good to have you back. Skip the guilt and do one lesson today.'**
  String get greetComeback;

  /// No description provided for @greetProgress.
  ///
  /// In en, this message translates to:
  /// **'You are {done} of {total} lessons in. Next up is \"{title}\".'**
  String greetProgress(int done, int total, String title);

  /// No description provided for @quizPassShort.
  ///
  /// In en, this message translates to:
  /// **'Well done.'**
  String get quizPassShort;

  /// No description provided for @quizPerfect.
  ///
  /// In en, this message translates to:
  /// **'{message} And a perfect score.'**
  String quizPerfect(String message);

  /// No description provided for @quizPassed.
  ///
  /// In en, this message translates to:
  /// **'Well done, you passed this lesson.'**
  String get quizPassed;

  /// No description provided for @quizTricky.
  ///
  /// In en, this message translates to:
  /// **'This one is tricky, and that is normal. Read only the key points again, then try once more. Slow progress is still progress.'**
  String get quizTricky;

  /// No description provided for @quizFail.
  ///
  /// In en, this message translates to:
  /// **'Not yet. Read the explanations above, review the lesson, and try again.'**
  String get quizFail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
