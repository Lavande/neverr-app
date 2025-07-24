// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Neverr';

  @override
  String get slogan => 'Not just quitting. Becoming better.';

  @override
  String get home => 'Home';

  @override
  String get data => 'Stats';

  @override
  String get settings => 'Settings';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get lateNight => 'It\'s getting late. Time to rest';

  @override
  String get motivationalMessage1 => 'Every repetition begins change';

  @override
  String get motivationalMessage2 => 'Your voice transforms you';

  @override
  String get motivationalMessage3 => 'Keep going, future you will thank you';

  @override
  String get motivationalMessage4 => 'Change starts now';

  @override
  String get motivationalMessage5 => 'Believe in yourself, you\'re stronger';

  @override
  String get myHabits => 'My Habits';

  @override
  String totalHabits(int count) {
    return '$count total';
  }

  @override
  String get noHabitsYet => 'No habits yet';

  @override
  String get noHabitsDescription =>
      'Tap the + button to create\nyour first habit transformation';

  @override
  String get startCreating => 'Start Creating';

  @override
  String get startChange => 'Practice';

  @override
  String get createGoal => 'Create Habit';

  @override
  String get whatToChange => 'What do you want to change?';

  @override
  String get selectCategoryDescription =>
      'Select a habit category or enter a custom habit';

  @override
  String get presetCategories => 'Preset Categories';

  @override
  String get custom => 'Custom';

  @override
  String get enterHabitName => 'Enter habit name';

  @override
  String get habitNamePlaceholder =>
      'e.g., late nights, overeating, procrastination, etc.';

  @override
  String get breakBadHabits => 'Break Bad Habits';

  @override
  String get buildGoodHabits => 'Build Good Habits';

  @override
  String get generatedStatement => 'Generated Statement';

  @override
  String get statementPlaceholder =>
      'Enter self-talk statement or select preset category to auto-fill';

  @override
  String get selfDialogueFramework => 'Self-Dialogue Script Framework';

  @override
  String get frameworkStructure => 'Statement + Reason + Emotion';

  @override
  String get continueRecording => 'Continue to Recording';

  @override
  String get pleaseEnterStatement =>
      'Please enter or generate a statement first';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsDescription =>
      'Receive daily reminder notifications';

  @override
  String get reminderTimeRange => 'Time Range';

  @override
  String get reminderTimeRangeDescription => 'Set reminder hours';

  @override
  String get reminderInterval => 'Frequency';

  @override
  String get reminderIntervalDescription => 'How often to remind';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get every15Minutes => 'Every 15 minutes';

  @override
  String get every30Minutes => 'Every 30 minutes';

  @override
  String get every1Hour => 'Every 1 hour';

  @override
  String get every2Hours => 'Every 2 hours';

  @override
  String get every3Hours => 'Every 3 hours';

  @override
  String get every4Hours => 'Every 4 hours';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select app language';

  @override
  String get about => 'About';

  @override
  String get aboutNeverr => 'About Neverr';

  @override
  String get aboutNeverrDescription => 'Not just quitting. Becoming better.';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get version => 'v1.0.0';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get resetAllSettings => 'Reset All Settings';

  @override
  String get resetToDefault => 'Restore to default settings';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetConfirmation =>
      'Are you sure you want to reset all settings? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get settingsReset => 'Settings have been reset';

  @override
  String get aboutDialogVersion => 'Version: v1.0.0';

  @override
  String get aboutDialogDescription =>
      'Neverr is an app that helps you change habits by recording and repeatedly playing your own voice to reshape your subconscious.';

  @override
  String get aboutDialogInspiration =>
      'Based on research in subconscious and habit change, inspired by Li Xiaolai\'s experience sharing articles.';

  @override
  String get footer => '© 2025 Neverr\nMade with ❤️ for better habits';

  @override
  String get dataStatistics => 'Statistics';

  @override
  String get checkInCalendar => 'Activity Calendar';

  @override
  String get dailyRepeatCount => 'Shows daily activity for all habits';

  @override
  String recordingSuccess(int count) {
    return 'Great! Practice #$count recorded';
  }

  @override
  String get recordingFailed => 'Recording failed, please try again';

  @override
  String streakDays(int days) {
    return '$days-day streak';
  }

  @override
  String todayRepeat(int count) {
    return '$count times today';
  }

  @override
  String completionRate(int rate) {
    return '$rate% completion rate';
  }

  @override
  String get habitDetails => 'Habit Details';

  @override
  String get selfTalk => 'Self-Talk';

  @override
  String get editStatement => 'Edit Statement';

  @override
  String get saveStatement => 'Save Statement';

  @override
  String get playRecording => 'Play Recording';

  @override
  String get stopPlaying => 'Stop Playing';

  @override
  String get loopPlayback => 'Loop Playback';

  @override
  String get loopCount => 'Loop Count';

  @override
  String get startLoop => 'Start Loop';

  @override
  String stopLoop(int current, int total) {
    return 'Stop ($current/$total)';
  }

  @override
  String get selfReading => 'Self Reading';

  @override
  String get progress => 'Progress';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get totalCompletions => 'Total Completions';

  @override
  String get firstCompletion => 'First Completion';

  @override
  String get lastCompletion => 'Last Completion';

  @override
  String get never => 'Never';

  @override
  String get recordStatement => 'Record Statement';

  @override
  String get recordingInstructions =>
      'Read your statement aloud, clearly and with conviction. This recording will be used for future practice.';

  @override
  String get tapToRecord => 'Tap to Record';

  @override
  String get recording => 'Recording';

  @override
  String get tapToStop => 'Tap to Stop';

  @override
  String get recordingComplete => 'Recording Complete';

  @override
  String get playback => 'Playback';

  @override
  String get reRecord => 'Re-record';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get recordingTip =>
      '💡 Recording Tips: Find a quiet space, speak with confidence, and let your voice carry conviction!';

  @override
  String get permissionRequired => 'Microphone Permission Required';

  @override
  String get permissionDescription =>
      'Audio recording requires microphone access. Please allow this in settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get smoking => 'Smoking';

  @override
  String get shortVideos => 'Short Videos';

  @override
  String get procrastination => 'Procrastination';

  @override
  String get drinking => 'Drinking';

  @override
  String get overeating => 'Overeating';

  @override
  String get lateSleeping => 'Staying Up Late';

  @override
  String get gaming => 'Excessive Gaming';

  @override
  String get socialMedia => 'Social Media';

  @override
  String get exercise => 'Exercise';

  @override
  String get reading => 'Reading';

  @override
  String get meditation => 'Meditation';

  @override
  String get earlyRising => 'Early Rising';

  @override
  String get habitCreatedSuccessfully => 'Habit created successfully!';

  @override
  String get failedToCreateHabit => 'Failed to create habit';

  @override
  String get delete => 'Delete';

  @override
  String get statementContent => 'Statement Content';

  @override
  String get enterStatement => 'Enter your statement...';

  @override
  String get practiceMethod => 'Practice Method';

  @override
  String get selfReadingRecommended => 'Self Reading (Recommended)';

  @override
  String get selfReadingDescription =>
      'Read the statement aloud, then tap the button to track each time';

  @override
  String get iReadOnce => 'Mark as Read';

  @override
  String get audioPlayback => 'Audio Playback (Silent Practice)';

  @override
  String get audioPlaybackDescription =>
      'Listen to your recorded statement with customizable repetitions';

  @override
  String get loopCountLabel => 'Loop Count:';

  @override
  String get todayProgress => 'Today\'s Progress';

  @override
  String get completed => 'Completed';

  @override
  String get repeatCount => 'Repeat Count';

  @override
  String get incomplete => 'Incomplete';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get needsImprovement => 'Needs Improvement';

  @override
  String get perfect => 'Perfect';

  @override
  String get keepGoing => 'Keep Going';

  @override
  String get perfectMessage =>
      '🎉 Perfect performance today! Keep up this rhythm!';

  @override
  String get excellentMessage =>
      '👏 Well done! A little more effort to reach perfection!';

  @override
  String get goodMessage =>
      '💪 Good start! Keep going to complete the remaining tasks!';

  @override
  String get encouragementMessage =>
      '🌟 Every step is progress! It\'s never too late to start!';

  @override
  String get firstHabitMessage =>
      '🚀 Create your first habit and start your transformation journey!';

  @override
  String get save => 'Save';

  @override
  String get playOnce => 'Play Once';

  @override
  String get playing => 'Playing...';

  @override
  String get loopPlay => 'Loop Play';

  @override
  String get noRecordingFile => 'No recording file';

  @override
  String get statisticsData => 'Statistics';

  @override
  String get currentStreakLabel => 'Current Streak';

  @override
  String get totalCompletedLabel => 'Total Completed';

  @override
  String get todayRepeatLabel => 'Today\'s Count';

  @override
  String get daysUnit => ' days';

  @override
  String get timesUnit => ' times';

  @override
  String get loopTimesUnit => 'x';

  @override
  String get deleteConfirmTitle => 'Delete Confirmation';

  @override
  String get deleteConfirmMessage =>
      'Are you sure you want to delete this habit? This action cannot be undone.';

  @override
  String get saveSuccess => 'Saved successfully';

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String deleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String playFailed(String error) {
    return 'Playback failed: $error';
  }

  @override
  String recordingError(String error) {
    return 'Recording error: $error';
  }

  @override
  String get speakSlowly => 'Speak slowly, for at least 5 seconds';

  @override
  String get isRecording => 'Recording...';

  @override
  String get recordingCompleted => 'Recording completed';

  @override
  String get tapToStartRecording => 'Tap to start recording';

  @override
  String get stop => 'Stop';

  @override
  String get play => 'Play';

  @override
  String get pleaseRecordFirst => 'Please record audio first';

  @override
  String get microphonePermissionNeeded => 'Microphone Permission Required';

  @override
  String get permissionInstructions =>
      'To record your habit statement, microphone access is required.\\n\\nPlease follow these steps:\\n1. Tap \\\"Go to Settings\\\" button\\n2. Find \\\"Microphone\\\" option\\n3. Enable microphone permission\\n4. Return to app and try again';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String dateFormat(int year, int month, int day) {
    return '$year/$month/$day';
  }

  @override
  String get noRecordsForDate => 'No activity on this date';

  @override
  String totalRepeats(int count) {
    return '$count total times';
  }

  @override
  String habitRepeats(String habit, int count) {
    return '$habit: $count times';
  }

  @override
  String get initializing => 'Initializing...';

  @override
  String get onboardingTitle1 => 'You Don\'t \"Quit\"';

  @override
  String get onboardingSubtitle1 => 'You \"Never Do\"';

  @override
  String get onboardingDescription1 =>
      'Don\'t say \"I want to quit smoking\" - tell yourself \"I never smoke\". This mindset makes change much easier.';

  @override
  String get onboardingTitle2 => 'Use Your Own Voice';

  @override
  String get onboardingSubtitle2 => 'Signal Your Brain';

  @override
  String get onboardingDescription2 =>
      'Record your voice declaring your change. Your subconscious trusts your own voice most.';

  @override
  String get onboardingTitle3 => 'Practice Daily';

  @override
  String get onboardingSubtitle3 => 'Change Starts Now';

  @override
  String get onboardingDescription3 =>
      'Repeat the magic sentence to yourself daily. Repetition will help reshape your subconscious.';

  @override
  String get continueButton => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';
}
