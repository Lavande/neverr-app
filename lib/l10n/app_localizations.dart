import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In zh, this message translates to:
  /// **'Neverr'**
  String get appTitle;

  /// Application slogan
  ///
  /// In zh, this message translates to:
  /// **'不止是戒掉，而是变更好。'**
  String get slogan;

  /// Home tab label
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// Data tab label
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get data;

  /// Settings tab label
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// Morning greeting
  ///
  /// In zh, this message translates to:
  /// **'早上好'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In zh, this message translates to:
  /// **'下午好'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In zh, this message translates to:
  /// **'晚上好'**
  String get goodEvening;

  /// Late night greeting
  ///
  /// In zh, this message translates to:
  /// **'深夜了，早点休息'**
  String get lateNight;

  /// Motivational message 1
  ///
  /// In zh, this message translates to:
  /// **'每一次重复，都是改变的开始'**
  String get motivationalMessage1;

  /// Motivational message 2
  ///
  /// In zh, this message translates to:
  /// **'你的声音，就是改变的力量'**
  String get motivationalMessage2;

  /// Motivational message 3
  ///
  /// In zh, this message translates to:
  /// **'坚持下去，你会感谢今天的自己'**
  String get motivationalMessage3;

  /// Motivational message 4
  ///
  /// In zh, this message translates to:
  /// **'改变从现在开始，从这一刻开始'**
  String get motivationalMessage4;

  /// Motivational message 5
  ///
  /// In zh, this message translates to:
  /// **'相信自己，你比想象中更强大'**
  String get motivationalMessage5;

  /// My habits section title
  ///
  /// In zh, this message translates to:
  /// **'我的习惯'**
  String get myHabits;

  /// Total habits count
  ///
  /// In zh, this message translates to:
  /// **'共{count}个'**
  String totalHabits(int count);

  /// No habits message
  ///
  /// In zh, this message translates to:
  /// **'还没有习惯项目'**
  String get noHabitsYet;

  /// No habits description
  ///
  /// In zh, this message translates to:
  /// **'点击右下角的 + 按钮\n开始创建你的第一个习惯改变项目'**
  String get noHabitsDescription;

  /// Start creating button
  ///
  /// In zh, this message translates to:
  /// **'开始创建'**
  String get startCreating;

  /// Start change button
  ///
  /// In zh, this message translates to:
  /// **'开始改变'**
  String get startChange;

  /// Create goal screen title
  ///
  /// In zh, this message translates to:
  /// **'创建目标'**
  String get createGoal;

  /// What to change question
  ///
  /// In zh, this message translates to:
  /// **'你想改变什么？'**
  String get whatToChange;

  /// Select category description
  ///
  /// In zh, this message translates to:
  /// **'选择一个习惯分类，或者输入自定义习惯'**
  String get selectCategoryDescription;

  /// Preset categories
  ///
  /// In zh, this message translates to:
  /// **'预设分类'**
  String get presetCategories;

  /// Custom option
  ///
  /// In zh, this message translates to:
  /// **'自定义'**
  String get custom;

  /// Enter habit name
  ///
  /// In zh, this message translates to:
  /// **'输入习惯名称'**
  String get enterHabitName;

  /// Habit name placeholder
  ///
  /// In zh, this message translates to:
  /// **'例如：熬夜、暴饮暴食、拖延等'**
  String get habitNamePlaceholder;

  /// Break bad habits
  ///
  /// In zh, this message translates to:
  /// **'戒除坏习惯'**
  String get breakBadHabits;

  /// Build good habits
  ///
  /// In zh, this message translates to:
  /// **'培养好习惯'**
  String get buildGoodHabits;

  /// Generated statement
  ///
  /// In zh, this message translates to:
  /// **'生成的语句'**
  String get generatedStatement;

  /// Statement placeholder
  ///
  /// In zh, this message translates to:
  /// **'请输入自我对话语句，或选择预设分类自动填入'**
  String get statementPlaceholder;

  /// Self dialogue framework
  ///
  /// In zh, this message translates to:
  /// **'自我对话脚本框架'**
  String get selfDialogueFramework;

  /// Framework structure
  ///
  /// In zh, this message translates to:
  /// **'自我陈述 + 加个理由 + 情绪标签'**
  String get frameworkStructure;

  /// Continue recording button
  ///
  /// In zh, this message translates to:
  /// **'继续录制'**
  String get continueRecording;

  /// Please enter statement message
  ///
  /// In zh, this message translates to:
  /// **'请先输入或生成语句'**
  String get pleaseEnterStatement;

  /// Notification settings
  ///
  /// In zh, this message translates to:
  /// **'通知设置'**
  String get notificationSettings;

  /// Enable notifications
  ///
  /// In zh, this message translates to:
  /// **'启用通知'**
  String get enableNotifications;

  /// Enable notifications description
  ///
  /// In zh, this message translates to:
  /// **'接收每日提醒通知'**
  String get enableNotificationsDescription;

  /// Reminder time range
  ///
  /// In zh, this message translates to:
  /// **'提醒时间区间'**
  String get reminderTimeRange;

  /// Reminder time range description
  ///
  /// In zh, this message translates to:
  /// **'设置提醒的开始和结束时间'**
  String get reminderTimeRangeDescription;

  /// Reminder interval
  ///
  /// In zh, this message translates to:
  /// **'提醒间隔'**
  String get reminderInterval;

  /// Reminder interval description
  ///
  /// In zh, this message translates to:
  /// **'设置提醒的频率'**
  String get reminderIntervalDescription;

  /// Start time
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get startTime;

  /// End time
  ///
  /// In zh, this message translates to:
  /// **'结束时间'**
  String get endTime;

  /// Every 15 minutes
  ///
  /// In zh, this message translates to:
  /// **'每15分钟'**
  String get every15Minutes;

  /// Every 30 minutes
  ///
  /// In zh, this message translates to:
  /// **'每30分钟'**
  String get every30Minutes;

  /// Every 1 hour
  ///
  /// In zh, this message translates to:
  /// **'每1小时'**
  String get every1Hour;

  /// Every 2 hours
  ///
  /// In zh, this message translates to:
  /// **'每2小时'**
  String get every2Hours;

  /// Every 3 hours
  ///
  /// In zh, this message translates to:
  /// **'每3小时'**
  String get every3Hours;

  /// Every 4 hours
  ///
  /// In zh, this message translates to:
  /// **'每4小时'**
  String get every4Hours;

  /// Language settings
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSettings;

  /// Language
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// Select app language
  ///
  /// In zh, this message translates to:
  /// **'选择应用语言'**
  String get selectLanguage;

  /// About section
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// About Neverr
  ///
  /// In zh, this message translates to:
  /// **'关于 Neverr'**
  String get aboutNeverr;

  /// About Neverr description
  ///
  /// In zh, this message translates to:
  /// **'不止是戒掉，而是变更好。'**
  String get aboutNeverrDescription;

  /// Version info
  ///
  /// In zh, this message translates to:
  /// **'版本信息'**
  String get versionInfo;

  /// Version number
  ///
  /// In zh, this message translates to:
  /// **'v1.0.0'**
  String get version;

  /// Danger zone
  ///
  /// In zh, this message translates to:
  /// **'危险操作'**
  String get dangerZone;

  /// Reset all settings
  ///
  /// In zh, this message translates to:
  /// **'重置所有设置'**
  String get resetAllSettings;

  /// Reset to default
  ///
  /// In zh, this message translates to:
  /// **'恢复到默认设置'**
  String get resetToDefault;

  /// Reset settings dialog title
  ///
  /// In zh, this message translates to:
  /// **'重置设置'**
  String get resetSettings;

  /// Reset confirmation message
  ///
  /// In zh, this message translates to:
  /// **'确定要重置所有设置吗？此操作不可恢复。'**
  String get resetConfirmation;

  /// Cancel button
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// Confirm button
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// Settings reset message
  ///
  /// In zh, this message translates to:
  /// **'设置已重置'**
  String get settingsReset;

  /// About dialog version
  ///
  /// In zh, this message translates to:
  /// **'版本: v1.0.0'**
  String get aboutDialogVersion;

  /// About dialog description
  ///
  /// In zh, this message translates to:
  /// **'Neverr 是一款帮助你改变习惯的应用，通过录制和重复播放自己的声音来重塑潜意识。'**
  String get aboutDialogDescription;

  /// About dialog inspiration
  ///
  /// In zh, this message translates to:
  /// **'基于潜意识和习惯改变的研究，灵感来自李笑来的经验分享文章。'**
  String get aboutDialogInspiration;

  /// App footer
  ///
  /// In zh, this message translates to:
  /// **'© 2025 Neverr\nMade with ❤️ for better habits'**
  String get footer;

  /// Data statistics
  ///
  /// In zh, this message translates to:
  /// **'数据统计'**
  String get dataStatistics;

  /// Check-in calendar
  ///
  /// In zh, this message translates to:
  /// **'打卡日历'**
  String get checkInCalendar;

  /// Daily repeat count description
  ///
  /// In zh, this message translates to:
  /// **'显示所有习惯的每日重复次数'**
  String get dailyRepeatCount;

  /// Recording success message
  ///
  /// In zh, this message translates to:
  /// **'很棒！已记录第 {count} 次朗读'**
  String recordingSuccess(int count);

  /// Recording failed message
  ///
  /// In zh, this message translates to:
  /// **'录音启动失败，请重试'**
  String get recordingFailed;

  /// Streak days display
  ///
  /// In zh, this message translates to:
  /// **'连续 {days} 天'**
  String streakDays(int days);

  /// Today repeat count
  ///
  /// In zh, this message translates to:
  /// **'今日 {count} 次'**
  String todayRepeat(int count);

  /// Completion rate
  ///
  /// In zh, this message translates to:
  /// **'完成率 {rate}%'**
  String completionRate(int rate);

  /// Habit details title
  ///
  /// In zh, this message translates to:
  /// **'习惯详情'**
  String get habitDetails;

  /// Self talk section
  ///
  /// In zh, this message translates to:
  /// **'自我对话'**
  String get selfTalk;

  /// Edit statement button
  ///
  /// In zh, this message translates to:
  /// **'编辑语句'**
  String get editStatement;

  /// Save statement button
  ///
  /// In zh, this message translates to:
  /// **'保存语句'**
  String get saveStatement;

  /// Play recording button
  ///
  /// In zh, this message translates to:
  /// **'播放录音'**
  String get playRecording;

  /// Stop playing button
  ///
  /// In zh, this message translates to:
  /// **'停止播放'**
  String get stopPlaying;

  /// Loop playback section
  ///
  /// In zh, this message translates to:
  /// **'循环播放'**
  String get loopPlayback;

  /// Loop count
  ///
  /// In zh, this message translates to:
  /// **'循环次数'**
  String get loopCount;

  /// Start loop button
  ///
  /// In zh, this message translates to:
  /// **'开始循环'**
  String get startLoop;

  /// Stop loop button with progress
  ///
  /// In zh, this message translates to:
  /// **'停止 ({current}/{total})'**
  String stopLoop(int current, int total);

  /// Self reading button
  ///
  /// In zh, this message translates to:
  /// **'自我朗读'**
  String get selfReading;

  /// Progress section
  ///
  /// In zh, this message translates to:
  /// **'进度'**
  String get progress;

  /// Current streak
  ///
  /// In zh, this message translates to:
  /// **'当前连击'**
  String get currentStreak;

  /// Total completions
  ///
  /// In zh, this message translates to:
  /// **'总完成次数'**
  String get totalCompletions;

  /// First completion
  ///
  /// In zh, this message translates to:
  /// **'首次完成'**
  String get firstCompletion;

  /// Last completion
  ///
  /// In zh, this message translates to:
  /// **'最近完成'**
  String get lastCompletion;

  /// Never
  ///
  /// In zh, this message translates to:
  /// **'从未'**
  String get never;

  /// Record statement title
  ///
  /// In zh, this message translates to:
  /// **'录制语句'**
  String get recordStatement;

  /// Recording instructions
  ///
  /// In zh, this message translates to:
  /// **'请大声、清晰地朗读你的自我对话语句。录制完成后，这段音频将用于循环播放。'**
  String get recordingInstructions;

  /// Tap to record
  ///
  /// In zh, this message translates to:
  /// **'点击录制'**
  String get tapToRecord;

  /// Recording
  ///
  /// In zh, this message translates to:
  /// **'录制中'**
  String get recording;

  /// Tap to stop
  ///
  /// In zh, this message translates to:
  /// **'点击停止'**
  String get tapToStop;

  /// Recording complete
  ///
  /// In zh, this message translates to:
  /// **'录制完成'**
  String get recordingComplete;

  /// Playback
  ///
  /// In zh, this message translates to:
  /// **'播放录音'**
  String get playback;

  /// Re-record button
  ///
  /// In zh, this message translates to:
  /// **'重录'**
  String get reRecord;

  /// Save and continue
  ///
  /// In zh, this message translates to:
  /// **'保存并继续'**
  String get saveAndContinue;

  /// Recording tip
  ///
  /// In zh, this message translates to:
  /// **'💡 录制技巧：选择安静的环境，用坚定的语调朗读，让你的声音充满力量！'**
  String get recordingTip;

  /// Permission required
  ///
  /// In zh, this message translates to:
  /// **'需要麦克风权限'**
  String get permissionRequired;

  /// Permission description
  ///
  /// In zh, this message translates to:
  /// **'录制音频需要访问麦克风权限，请在设置中允许。'**
  String get permissionDescription;

  /// Open settings
  ///
  /// In zh, this message translates to:
  /// **'打开设置'**
  String get openSettings;

  /// Smoking habit
  ///
  /// In zh, this message translates to:
  /// **'吸烟'**
  String get smoking;

  /// Short videos habit
  ///
  /// In zh, this message translates to:
  /// **'刷短视频'**
  String get shortVideos;

  /// Procrastination habit
  ///
  /// In zh, this message translates to:
  /// **'拖延'**
  String get procrastination;

  /// Drinking habit
  ///
  /// In zh, this message translates to:
  /// **'饮酒'**
  String get drinking;

  /// Overeating habit
  ///
  /// In zh, this message translates to:
  /// **'暴饮暴食'**
  String get overeating;

  /// Late sleeping habit
  ///
  /// In zh, this message translates to:
  /// **'熬夜'**
  String get lateSleeping;

  /// Gaming addiction
  ///
  /// In zh, this message translates to:
  /// **'游戏成瘾'**
  String get gaming;

  /// Social media habit
  ///
  /// In zh, this message translates to:
  /// **'社交媒体'**
  String get socialMedia;

  /// Exercise habit
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get exercise;

  /// Reading habit
  ///
  /// In zh, this message translates to:
  /// **'阅读'**
  String get reading;

  /// Meditation habit
  ///
  /// In zh, this message translates to:
  /// **'冥想'**
  String get meditation;

  /// Early rising habit
  ///
  /// In zh, this message translates to:
  /// **'早起'**
  String get earlyRising;

  /// Habit created successfully message
  ///
  /// In zh, this message translates to:
  /// **'习惯创建成功！'**
  String get habitCreatedSuccessfully;

  /// Failed to create habit message
  ///
  /// In zh, this message translates to:
  /// **'创建习惯失败'**
  String get failedToCreateHabit;

  /// Delete button
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// Statement content title
  ///
  /// In zh, this message translates to:
  /// **'语句内容'**
  String get statementContent;

  /// Enter statement placeholder
  ///
  /// In zh, this message translates to:
  /// **'输入你的语句...'**
  String get enterStatement;

  /// Practice method title
  ///
  /// In zh, this message translates to:
  /// **'练习方式'**
  String get practiceMethod;

  /// Self reading recommended
  ///
  /// In zh, this message translates to:
  /// **'自己朗读（推荐）'**
  String get selfReadingRecommended;

  /// Self reading description
  ///
  /// In zh, this message translates to:
  /// **'对着句子自己朗读，每读一次点击按钮记录'**
  String get selfReadingDescription;

  /// I read once button
  ///
  /// In zh, this message translates to:
  /// **'我读了一遍'**
  String get iReadOnce;

  /// Audio playback title
  ///
  /// In zh, this message translates to:
  /// **'播放录音（适合公共场合）'**
  String get audioPlayback;

  /// Audio playback description
  ///
  /// In zh, this message translates to:
  /// **'播放之前录制的语音，可选择循环次数'**
  String get audioPlaybackDescription;

  /// Loop count label
  ///
  /// In zh, this message translates to:
  /// **'循环次数:'**
  String get loopCountLabel;

  /// Today's progress
  ///
  /// In zh, this message translates to:
  /// **'今日进度'**
  String get todayProgress;

  /// Completed
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completed;

  /// Repeat count
  ///
  /// In zh, this message translates to:
  /// **'重复次数'**
  String get repeatCount;

  /// Incomplete
  ///
  /// In zh, this message translates to:
  /// **'未完成'**
  String get incomplete;

  /// Excellent
  ///
  /// In zh, this message translates to:
  /// **'优秀'**
  String get excellent;

  /// Good
  ///
  /// In zh, this message translates to:
  /// **'良好'**
  String get good;

  /// Needs improvement
  ///
  /// In zh, this message translates to:
  /// **'待改进'**
  String get needsImprovement;

  /// Perfect
  ///
  /// In zh, this message translates to:
  /// **'完美'**
  String get perfect;

  /// Keep going
  ///
  /// In zh, this message translates to:
  /// **'加油'**
  String get keepGoing;

  /// Perfect completion message
  ///
  /// In zh, this message translates to:
  /// **'🎉 今天表现完美！继续保持这个节奏！'**
  String get perfectMessage;

  /// Excellent completion message
  ///
  /// In zh, this message translates to:
  /// **'👏 做得很好！再努力一点就能达到完美！'**
  String get excellentMessage;

  /// Good completion message
  ///
  /// In zh, this message translates to:
  /// **'💪 不错的开始！继续加油完成剩余任务！'**
  String get goodMessage;

  /// Encouragement message
  ///
  /// In zh, this message translates to:
  /// **'🌟 每一步都是进步！现在开始也不晚！'**
  String get encouragementMessage;

  /// First habit creation message
  ///
  /// In zh, this message translates to:
  /// **'🚀 创建你的第一个习惯，开始改变之旅！'**
  String get firstHabitMessage;

  /// Save button
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// Play once button
  ///
  /// In zh, this message translates to:
  /// **'播放一次'**
  String get playOnce;

  /// Playing indicator
  ///
  /// In zh, this message translates to:
  /// **'播放中...'**
  String get playing;

  /// Loop play button
  ///
  /// In zh, this message translates to:
  /// **'循环播放'**
  String get loopPlay;

  /// No recording file message
  ///
  /// In zh, this message translates to:
  /// **'暂无录音文件'**
  String get noRecordingFile;

  /// Statistics data section title
  ///
  /// In zh, this message translates to:
  /// **'统计数据'**
  String get statisticsData;

  /// Current streak label
  ///
  /// In zh, this message translates to:
  /// **'当前连续'**
  String get currentStreakLabel;

  /// Total completed label
  ///
  /// In zh, this message translates to:
  /// **'总完成'**
  String get totalCompletedLabel;

  /// Today repeat label
  ///
  /// In zh, this message translates to:
  /// **'今日重复'**
  String get todayRepeatLabel;

  /// Days unit
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get daysUnit;

  /// Times unit
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get timesUnit;

  /// Loop times unit
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get loopTimesUnit;

  /// Delete confirmation dialog title
  ///
  /// In zh, this message translates to:
  /// **'删除确认'**
  String get deleteConfirmTitle;

  /// Delete confirmation dialog message
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这个习惯吗？此操作不可恢复。'**
  String get deleteConfirmMessage;

  /// Save success message
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get saveSuccess;

  /// Save failed message
  ///
  /// In zh, this message translates to:
  /// **'保存失败: {error}'**
  String saveFailed(String error);

  /// Delete failed message
  ///
  /// In zh, this message translates to:
  /// **'删除失败: {error}'**
  String deleteFailed(String error);

  /// Play failed message
  ///
  /// In zh, this message translates to:
  /// **'播放失败: {error}'**
  String playFailed(String error);

  /// Recording error message
  ///
  /// In zh, this message translates to:
  /// **'录音出错: {error}'**
  String recordingError(String error);

  /// Recording instruction
  ///
  /// In zh, this message translates to:
  /// **'说慢一点，说满5秒以上'**
  String get speakSlowly;

  /// Recording in progress
  ///
  /// In zh, this message translates to:
  /// **'正在录音...'**
  String get isRecording;

  /// Recording completed
  ///
  /// In zh, this message translates to:
  /// **'录音完成'**
  String get recordingCompleted;

  /// Tap to start recording
  ///
  /// In zh, this message translates to:
  /// **'点击开始录音'**
  String get tapToStartRecording;

  /// Stop button
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stop;

  /// Play button
  ///
  /// In zh, this message translates to:
  /// **'播放'**
  String get play;

  /// Please record first message
  ///
  /// In zh, this message translates to:
  /// **'请先录制语音'**
  String get pleaseRecordFirst;

  /// Microphone permission needed title
  ///
  /// In zh, this message translates to:
  /// **'需要麦克风权限'**
  String get microphonePermissionNeeded;

  /// Permission instructions
  ///
  /// In zh, this message translates to:
  /// **'为了录制您的习惯语句，需要访问麦克风权限。\\n\\n请按照以下步骤操作：\\n1. 点击\\\"去设置\\\"按钮\\n2. 找到\\\"麦克风\\\"选项\\n3. 打开麦克风权限\\n4. 返回App重试'**
  String get permissionInstructions;

  /// Go to settings button
  ///
  /// In zh, this message translates to:
  /// **'去设置'**
  String get goToSettings;

  /// Date format
  ///
  /// In zh, this message translates to:
  /// **'{year}年{month}月{day}日'**
  String dateFormat(int year, int month, int day);

  /// No records for selected date
  ///
  /// In zh, this message translates to:
  /// **'该日期没有练习记录'**
  String get noRecordsForDate;

  /// Total repeat count
  ///
  /// In zh, this message translates to:
  /// **'总共重复 {count} 次'**
  String totalRepeats(int count);

  /// Habit repeat count
  ///
  /// In zh, this message translates to:
  /// **'{habit}: {count}次'**
  String habitRepeats(String habit, int count);

  /// Initializing message on splash screen
  ///
  /// In zh, this message translates to:
  /// **'正在初始化...'**
  String get initializing;

  /// Onboarding page 1 title
  ///
  /// In zh, this message translates to:
  /// **'你不是\"戒掉\"'**
  String get onboardingTitle1;

  /// Onboarding page 1 subtitle
  ///
  /// In zh, this message translates to:
  /// **'你是\"从来不做\"'**
  String get onboardingSubtitle1;

  /// Onboarding page 1 description
  ///
  /// In zh, this message translates to:
  /// **'不要说\"我要戒烟\"，而是告诉自己\"我从来不吸烟\"。这种心理暗示会让改变变得更容易。'**
  String get onboardingDescription1;

  /// Onboarding page 2 title
  ///
  /// In zh, this message translates to:
  /// **'用自己的声音'**
  String get onboardingTitle2;

  /// Onboarding page 2 subtitle
  ///
  /// In zh, this message translates to:
  /// **'向大脑\"明示\"'**
  String get onboardingSubtitle2;

  /// Onboarding page 2 description
  ///
  /// In zh, this message translates to:
  /// **'录制自己的声音，大声说出改变的宣言。你的潜意识最信任你自己的声音。'**
  String get onboardingDescription2;

  /// Onboarding page 3 title
  ///
  /// In zh, this message translates to:
  /// **'每天听几遍'**
  String get onboardingTitle3;

  /// Onboarding page 3 subtitle
  ///
  /// In zh, this message translates to:
  /// **'改变从此刻开始'**
  String get onboardingSubtitle3;

  /// Onboarding page 3 description
  ///
  /// In zh, this message translates to:
  /// **'每天朗读或播放数遍你的宣言。重复的力量会帮你重塑潜意识。'**
  String get onboardingDescription3;

  /// Continue button
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get continueButton;

  /// Get started button
  ///
  /// In zh, this message translates to:
  /// **'开始使用'**
  String get getStarted;

  /// Skip button
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get skip;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
