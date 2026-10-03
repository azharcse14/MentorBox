// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'মেন্টরবক্স';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String get savedLessons => 'সেভ করা লেসন';

  @override
  String get language => 'ভাষা';

  @override
  String get deviceLanguage => 'ফোনের ভাষা';

  @override
  String get theme => 'থিম';

  @override
  String get deviceTheme => 'ফোনের থিম';

  @override
  String get lightTheme => 'লাইট';

  @override
  String get darkTheme => 'ডার্ক';

  @override
  String get todaysMissions => 'আজকের মিশন';

  @override
  String get defaultName => 'শিক্ষার্থী';

  @override
  String loadError(String error) {
    return 'লেসনগুলো লোড করা যায়নি। assets/content/-এর ফাইলগুলো ঠিকঠাক JSON কিনা আর pubspec.yaml-এ আছে কিনা দেখো।\n\n$error';
  }

  @override
  String get exploreLabel => 'ঘুরে দেখো :';

  @override
  String get exploreTagline => 'একজন মেন্টর বেছে নাও,\nরোজ একটু করে শেখো';

  @override
  String get heroBefore => 'প্রতিটি দক্ষতার জন্য\nতোমার নিজের ';

  @override
  String get heroHighlight => 'মেন্টর';

  @override
  String get heroAfter => '';

  @override
  String streakDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString দিনের স্ট্রিক',
    );
    return '$_temp0';
  }

  @override
  String get noStreak => 'এখনো কোনো স্ট্রিক নেই';

  @override
  String continueWith(String mentor) {
    return '$mentor-এর সাথে চালিয়ে যাও';
  }

  @override
  String get nameDialogFirstTitle =>
      'হাই! তোমার মেন্টররা তোমাকে কী নামে ডাকবে?';

  @override
  String get nameDialogChangeTitle => 'নাম বদলাও';

  @override
  String get nameHint => 'তোমার নাম';

  @override
  String get saveName => 'নাম সেভ করো';

  @override
  String get finished => 'শেষ';

  @override
  String percentDone(int percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$percentString% শেষ';
  }

  @override
  String get lockedLessonHint => 'এটা খুলতে আগের লেসনটা শেষ করো।';

  @override
  String get progressLabel => 'অগ্রগতি : ';

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

    return '$totalStringটির মধ্যে $doneStringটি লেসন';
  }

  @override
  String get reviewFromFirst => 'প্রথম লেসন থেকে আবার দেখো';

  @override
  String get startMentoring => 'শেখা শুরু করো';

  @override
  String continueLesson(String title) {
    return 'চালিয়ে যাও: $title';
  }

  @override
  String levelNumber(int number) {
    final intl.NumberFormat numberNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'লেভেল $numberString';
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
  String get locked => 'লক করা';

  @override
  String minutes(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString মিনিট';
  }

  @override
  String minutesWithScore(int minutes, int score) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);
    final intl.NumberFormat scoreNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String scoreString = scoreNumberFormat.format(score);

    return '$minutesString মিনিট, কুইজে সেরা স্কোর $scoreString';
  }

  @override
  String get lessonSaved => 'লেসন সেভ হয়েছে';

  @override
  String get lessonUnsaved => 'সেভ থেকে লেসন সরানো হয়েছে';

  @override
  String get noteSaved => 'নোট সেভ হয়েছে';

  @override
  String get lessonMissing => 'এই লেসনটি আর পাওয়া যাচ্ছে না।';

  @override
  String get removeFromSaved => 'সেভ থেকে সরাও';

  @override
  String get saveLesson => 'লেসন সেভ করো';

  @override
  String minutesRead(int minutes) {
    final intl.NumberFormat minutesNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$minutesString মিনিটের পড়া';
  }

  @override
  String get completed => 'সম্পন্ন';

  @override
  String get keyPoints => 'মূল কথা';

  @override
  String get mentorTip => 'মেন্টরের টিপস';

  @override
  String get yourTask => 'তোমার কাজ';

  @override
  String get iDidTask => 'আমি কাজটা করেছি';

  @override
  String get myNotes => 'আমার নোট';

  @override
  String get notesHint => 'কী শিখলে? এই সপ্তাহে কোথায় কাজে লাগাবে?';

  @override
  String get markComplete => 'লেসন সম্পন্ন করো';

  @override
  String get takeQuiz => 'কুইজ দাও';

  @override
  String get retakeQuiz => 'আবার কুইজ দাও';

  @override
  String nextLesson(String title) {
    return 'পরের লেসন: $title';
  }

  @override
  String get backToMentor => 'মেন্টরের কাছে ফিরে যাও';

  @override
  String get practiceQuizAgain => 'কুইজটা আবার অনুশীলন করো';

  @override
  String get noQuiz => 'এই লেসনে কোনো কুইজ নেই।';

  @override
  String get quizTitle => 'কুইজ';

  @override
  String questionProgress(int number, int total) {
    final intl.NumberFormat numberNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'প্রশ্ন $numberString / $totalString';
  }

  @override
  String get answerCorrect => 'সঠিক';

  @override
  String get answerWrong => 'ঠিক হয়নি';

  @override
  String get checkAnswer => 'উত্তর যাচাই করো';

  @override
  String get seeResult => 'ফলাফল দেখো';

  @override
  String get nextQuestion => 'পরের প্রশ্ন';

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
    return 'তুমি \"$title\" শেষ করেছ';
  }

  @override
  String needToPass(int required) {
    final intl.NumberFormat requiredNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String requiredString = requiredNumberFormat.format(required);

    return 'পাস করতে $requiredStringটি সঠিক উত্তর লাগবে';
  }

  @override
  String get continueButton => 'চালিয়ে যাও';

  @override
  String get reviewLesson => 'লেসনটা আবার দেখো';

  @override
  String get tryQuizAgain => 'আবার কুইজ দাও';

  @override
  String get savedTitle => 'সেভ করা';

  @override
  String get savedEmpty =>
      'যেকোনো লেসনের বুকমার্কে চাপ দাও, পরে পড়ার জন্য এখানে থেকে যাবে।';

  @override
  String get yourNotes => 'তোমার নোট';

  @override
  String get notesEmpty => 'লেসনের শেষে যে নোট লেখো, সেগুলো এখানে দেখা যাবে।';

  @override
  String get todayTitle => 'আজ';

  @override
  String get noMissions =>
      'তোমার এখনো কোনো মিশন নেই। নিচে বা হোম স্ক্রিনে একজন মেন্টর বেছে নিয়ে প্রথম লেসন শুরু করো।';

  @override
  String lessonsDone(int done, int total) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalStringটির মধ্যে $doneStringটি লেসন শেষ';
  }

  @override
  String taskPrefix(String task) {
    return 'কাজ: $task';
  }

  @override
  String get tryNewMentor => 'নতুন মেন্টর চেষ্টা করো';

  @override
  String get todayDone => 'আজ তুমি কিছু শিখেছ। কাল দেখা হবে।';

  @override
  String get keepStreak => 'স্ট্রিক ধরে রাখতে আজ একটা কাজ বা কুইজ শেষ করো।';

  @override
  String get greetFinished =>
      'এখানকার সব লেসন তুমি শেষ করেছ। এই সপ্তাহে একজন বন্ধুকে একটা আইডিয়া বুঝিয়ে বলো। শেখানোই আসল পরীক্ষা।';

  @override
  String get greetWelcome =>
      'ছোট করে শুরু করি। একটা ছোট লেসন, একটা ছোট কাজ। সব দক্ষতা এভাবেই শুরু হয়।';

  @override
  String get greetComeback =>
      'ফিরে এসেছ, ভালো লাগলো। অপরাধবোধ বাদ দাও, আজ একটা লেসন করো।';

  @override
  String greetProgress(int done, int total, String title) {
    final intl.NumberFormat doneNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String doneString = doneNumberFormat.format(done);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$totalStringটির মধ্যে $doneStringটি লেসন হয়ে গেছে। এরপর \"$title\"।';
  }

  @override
  String get quizPassShort => 'দারুণ।';

  @override
  String quizPerfect(String message) {
    return '$message আর একদম পুরো নম্বর!';
  }

  @override
  String get quizPassed => 'দারুণ, তুমি এই লেসনে পাস করেছ।';

  @override
  String get quizTricky =>
      'এটা একটু কঠিন, আর এটা স্বাভাবিক। শুধু মূল কথাগুলো আবার পড়ো, তারপর আরেকবার চেষ্টা করো। ধীরে এগোনোও এগোনো।';

  @override
  String get quizFail =>
      'এখনো হয়নি। উপরের ব্যাখ্যাগুলো পড়ো, লেসনটা আবার দেখো, তারপর আবার চেষ্টা করো।';

  @override
  String get settings => 'সেটিংস';

  @override
  String get dailyReminder => 'রোজকার রিমাইন্ডার';

  @override
  String get dailyReminderHint => 'শুধু যেদিন এখনো পড়োনি';

  @override
  String get retry => 'আবার চেষ্টা করো';

  @override
  String get skip => 'এখন না';

  @override
  String get undo => 'ফিরিয়ে আনো';

  @override
  String get lessonCompleted => 'লেসন শেষ! দারুণ।';

  @override
  String get leaveQuizTitle => 'কুইজ ছেড়ে যাবে?';

  @override
  String get leaveQuizBody => 'এ পর্যন্ত দেওয়া উত্তরগুলো হারিয়ে যাবে।';

  @override
  String get leaveQuiz => 'ছেড়ে যাও';

  @override
  String get stayInQuiz => 'থাকো';

  @override
  String get reminderTime => 'রিমাইন্ডারের সময়';

  @override
  String get notifPracticeTitle => 'আজকের লেসনের সময় হয়েছে';

  @override
  String notifPracticeBody(String mentor, String lesson, int minutes) {
    return '$mentor: এবার \"$lesson\"। মাত্র $minutes মিনিট।';
  }

  @override
  String get notifGenericBody => 'রোজ একটা ছোট লেসন, ধীরে ধীরে অনেক দূর।';

  @override
  String notifStreakRiskTitle(int count) {
    return '🔥 তোমার $count দিনের স্ট্রিক বিপদে';
  }

  @override
  String get notifStreakRiskBody =>
      'রাত ১২টায় শেষ হয়ে যাবে। একটা লেসনেই বাঁচবে।';

  @override
  String notifStreakLostTitle(int count) {
    return 'তোমার $count দিনের স্ট্রিক শেষ হয়ে গেছে';
  }

  @override
  String get notifStreakLostBody =>
      'সব স্ট্রিকই ১ম দিন থেকে শুরু হয়। আজই নতুন করে শুরু করো।';

  @override
  String get notifComebackTitle => 'তোমার মেন্টররা তোমাকে মিস করছে';

  @override
  String notifComebackBody(String mentor, String lesson) {
    return '$mentor তোমার জায়গা রেখে দিয়েছে: \"$lesson\"';
  }

  @override
  String get notifLastCallTitle => 'রিমাইন্ডার আপাতত বন্ধ রাখছি';

  @override
  String get notifLastCallBody =>
      'মনে হচ্ছে রিমাইন্ডারগুলো কাজে আসছে না, তাই আপাতত থামছি। যখন খুশি ফিরে এসো!';

  @override
  String get layoutGrid => 'গ্রিড';

  @override
  String get layoutCarousel => 'ক্যারোসেল';

  @override
  String get layoutList => 'লিস্ট';
}
