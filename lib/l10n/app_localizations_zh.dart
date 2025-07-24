// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Neverr';

  @override
  String get slogan => '不止是戒掉，而是变更好。';

  @override
  String get home => '首页';

  @override
  String get data => '数据';

  @override
  String get settings => '设置';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get lateNight => '深夜了，早点休息';

  @override
  String get motivationalMessage1 => '每一次重复，都是改变的开始';

  @override
  String get motivationalMessage2 => '你的声音，就是改变的力量';

  @override
  String get motivationalMessage3 => '坚持下去，你会感谢今天的自己';

  @override
  String get motivationalMessage4 => '改变从现在开始，从这一刻开始';

  @override
  String get motivationalMessage5 => '相信自己，你比想象中更强大';

  @override
  String get myHabits => '我的习惯';

  @override
  String totalHabits(int count) {
    return '共$count个';
  }

  @override
  String get noHabitsYet => '还没有习惯项目';

  @override
  String get noHabitsDescription => '点击右下角的 + 按钮\n开始创建你的第一个习惯改变项目';

  @override
  String get startCreating => '开始创建';

  @override
  String get startChange => '开始改变';

  @override
  String get createGoal => '创建目标';

  @override
  String get whatToChange => '你想改变什么？';

  @override
  String get selectCategoryDescription => '选择一个习惯分类，或者输入自定义习惯';

  @override
  String get presetCategories => '预设分类';

  @override
  String get custom => '自定义';

  @override
  String get enterHabitName => '输入习惯名称';

  @override
  String get habitNamePlaceholder => '例如：熬夜、暴饮暴食、拖延等';

  @override
  String get breakBadHabits => '戒除坏习惯';

  @override
  String get buildGoodHabits => '培养好习惯';

  @override
  String get generatedStatement => '生成的语句';

  @override
  String get statementPlaceholder => '请输入自我对话语句，或选择预设分类自动填入';

  @override
  String get selfDialogueFramework => '自我对话脚本框架';

  @override
  String get frameworkStructure => '自我陈述 + 加个理由 + 情绪标签';

  @override
  String get continueRecording => '继续录制';

  @override
  String get pleaseEnterStatement => '请先输入或生成语句';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get enableNotificationsDescription => '接收每日提醒通知';

  @override
  String get reminderTimeRange => '提醒时间区间';

  @override
  String get reminderTimeRangeDescription => '设置提醒的开始和结束时间';

  @override
  String get reminderInterval => '提醒间隔';

  @override
  String get reminderIntervalDescription => '设置提醒的频率';

  @override
  String get startTime => '开始时间';

  @override
  String get endTime => '结束时间';

  @override
  String get every15Minutes => '每15分钟';

  @override
  String get every30Minutes => '每30分钟';

  @override
  String get every1Hour => '每1小时';

  @override
  String get every2Hours => '每2小时';

  @override
  String get every3Hours => '每3小时';

  @override
  String get every4Hours => '每4小时';

  @override
  String get languageSettings => '语言设置';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择应用语言';

  @override
  String get about => '关于';

  @override
  String get aboutNeverr => '关于 Neverr';

  @override
  String get aboutNeverrDescription => '不止是戒掉，而是变更好。';

  @override
  String get versionInfo => '版本信息';

  @override
  String get version => 'v1.0.0';

  @override
  String get dangerZone => '危险操作';

  @override
  String get resetAllSettings => '重置所有设置';

  @override
  String get resetToDefault => '恢复到默认设置';

  @override
  String get resetSettings => '重置设置';

  @override
  String get resetConfirmation => '确定要重置所有设置吗？此操作不可恢复。';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get settingsReset => '设置已重置';

  @override
  String get aboutDialogVersion => '版本: v1.0.0';

  @override
  String get aboutDialogDescription =>
      'Neverr 是一款帮助你改变习惯的应用，通过录制和重复播放自己的声音来重塑潜意识。';

  @override
  String get aboutDialogInspiration => '基于潜意识和习惯改变的研究，灵感来自李笑来的经验分享文章。';

  @override
  String get footer => '© 2025 Neverr\nMade with ❤️ for better habits';

  @override
  String get dataStatistics => '数据统计';

  @override
  String get checkInCalendar => '打卡日历';

  @override
  String get dailyRepeatCount => '显示所有习惯的每日重复次数';

  @override
  String recordingSuccess(int count) {
    return '很棒！已记录第 $count 次朗读';
  }

  @override
  String get recordingFailed => '录音启动失败，请重试';

  @override
  String streakDays(int days) {
    return '连续 $days 天';
  }

  @override
  String todayRepeat(int count) {
    return '今日 $count 次';
  }

  @override
  String completionRate(int rate) {
    return '完成率 $rate%';
  }

  @override
  String get habitDetails => '习惯详情';

  @override
  String get selfTalk => '自我对话';

  @override
  String get editStatement => '编辑语句';

  @override
  String get saveStatement => '保存语句';

  @override
  String get playRecording => '播放录音';

  @override
  String get stopPlaying => '停止播放';

  @override
  String get loopPlayback => '循环播放';

  @override
  String get loopCount => '循环次数';

  @override
  String get startLoop => '开始循环';

  @override
  String stopLoop(int current, int total) {
    return '停止 ($current/$total)';
  }

  @override
  String get selfReading => '自我朗读';

  @override
  String get progress => '进度';

  @override
  String get currentStreak => '当前连击';

  @override
  String get totalCompletions => '总完成次数';

  @override
  String get firstCompletion => '首次完成';

  @override
  String get lastCompletion => '最近完成';

  @override
  String get never => '从未';

  @override
  String get recordStatement => '录制语句';

  @override
  String get recordingInstructions => '请大声、清晰地朗读你的自我对话语句。录制完成后，这段音频将用于循环播放。';

  @override
  String get tapToRecord => '点击录制';

  @override
  String get recording => '录制中';

  @override
  String get tapToStop => '点击停止';

  @override
  String get recordingComplete => '录制完成';

  @override
  String get playback => '播放录音';

  @override
  String get reRecord => '重录';

  @override
  String get saveAndContinue => '保存并继续';

  @override
  String get recordingTip => '💡 录制技巧：选择安静的环境，用坚定的语调朗读，让你的声音充满力量！';

  @override
  String get permissionRequired => '需要麦克风权限';

  @override
  String get permissionDescription => '录制音频需要访问麦克风权限，请在设置中允许。';

  @override
  String get openSettings => '打开设置';

  @override
  String get smoking => '吸烟';

  @override
  String get shortVideos => '刷短视频';

  @override
  String get procrastination => '拖延';

  @override
  String get drinking => '饮酒';

  @override
  String get overeating => '暴饮暴食';

  @override
  String get lateSleeping => '熬夜';

  @override
  String get gaming => '游戏成瘾';

  @override
  String get socialMedia => '社交媒体';

  @override
  String get exercise => '运动';

  @override
  String get reading => '阅读';

  @override
  String get meditation => '冥想';

  @override
  String get earlyRising => '早起';

  @override
  String get habitCreatedSuccessfully => '习惯创建成功！';

  @override
  String get failedToCreateHabit => '创建习惯失败';

  @override
  String get delete => '删除';

  @override
  String get statementContent => '语句内容';

  @override
  String get enterStatement => '输入你的语句...';

  @override
  String get practiceMethod => '练习方式';

  @override
  String get selfReadingRecommended => '自己朗读（推荐）';

  @override
  String get selfReadingDescription => '对着句子自己朗读，每读一次点击按钮记录';

  @override
  String get iReadOnce => '我读了一遍';

  @override
  String get audioPlayback => '播放录音（适合公共场合）';

  @override
  String get audioPlaybackDescription => '播放之前录制的语音，可选择循环次数';

  @override
  String get loopCountLabel => '循环次数:';

  @override
  String get todayProgress => '今日进度';

  @override
  String get completed => '已完成';

  @override
  String get repeatCount => '重复次数';

  @override
  String get incomplete => '未完成';

  @override
  String get excellent => '优秀';

  @override
  String get good => '良好';

  @override
  String get needsImprovement => '待改进';

  @override
  String get perfect => '完美';

  @override
  String get keepGoing => '加油';

  @override
  String get perfectMessage => '🎉 今天表现完美！继续保持这个节奏！';

  @override
  String get excellentMessage => '👏 做得很好！再努力一点就能达到完美！';

  @override
  String get goodMessage => '💪 不错的开始！继续加油完成剩余任务！';

  @override
  String get encouragementMessage => '🌟 每一步都是进步！现在开始也不晚！';

  @override
  String get firstHabitMessage => '🚀 创建你的第一个习惯，开始改变之旅！';

  @override
  String get save => '保存';

  @override
  String get playOnce => '播放一次';

  @override
  String get playing => '播放中...';

  @override
  String get loopPlay => '循环播放';

  @override
  String get noRecordingFile => '暂无录音文件';

  @override
  String get statisticsData => '统计数据';

  @override
  String get currentStreakLabel => '当前连续';

  @override
  String get totalCompletedLabel => '总完成';

  @override
  String get todayRepeatLabel => '今日重复';

  @override
  String get daysUnit => '天';

  @override
  String get timesUnit => '次';

  @override
  String get loopTimesUnit => '次';

  @override
  String get deleteConfirmTitle => '删除确认';

  @override
  String get deleteConfirmMessage => '确定要删除这个习惯吗？此操作不可恢复。';

  @override
  String get saveSuccess => '保存成功';

  @override
  String saveFailed(String error) {
    return '保存失败: $error';
  }

  @override
  String deleteFailed(String error) {
    return '删除失败: $error';
  }

  @override
  String playFailed(String error) {
    return '播放失败: $error';
  }

  @override
  String recordingError(String error) {
    return '录音出错: $error';
  }

  @override
  String get speakSlowly => '说慢一点，说满5秒以上';

  @override
  String get isRecording => '正在录音...';

  @override
  String get recordingCompleted => '录音完成';

  @override
  String get tapToStartRecording => '点击开始录音';

  @override
  String get stop => '停止';

  @override
  String get play => '播放';

  @override
  String get pleaseRecordFirst => '请先录制语音';

  @override
  String get microphonePermissionNeeded => '需要麦克风权限';

  @override
  String get permissionInstructions =>
      '为了录制您的习惯语句，需要访问麦克风权限。\\n\\n请按照以下步骤操作：\\n1. 点击\\\"去设置\\\"按钮\\n2. 找到\\\"麦克风\\\"选项\\n3. 打开麦克风权限\\n4. 返回App重试';

  @override
  String get goToSettings => '去设置';

  @override
  String dateFormat(int year, int month, int day) {
    return '$year年$month月$day日';
  }

  @override
  String get noRecordsForDate => '该日期没有练习记录';

  @override
  String totalRepeats(int count) {
    return '总共重复 $count 次';
  }

  @override
  String habitRepeats(String habit, int count) {
    return '$habit: $count次';
  }

  @override
  String get initializing => '正在初始化...';

  @override
  String get onboardingTitle1 => '你不是\"戒掉\"';

  @override
  String get onboardingSubtitle1 => '你是\"从来不做\"';

  @override
  String get onboardingDescription1 =>
      '不要说\"我要戒烟\"，而是告诉自己\"我从来不吸烟\"。这种心理暗示会让改变变得更容易。';

  @override
  String get onboardingTitle2 => '用自己的声音';

  @override
  String get onboardingSubtitle2 => '向大脑\"明示\"';

  @override
  String get onboardingDescription2 => '录制自己的声音，大声说出改变的宣言。你的潜意识最信任你自己的声音。';

  @override
  String get onboardingTitle3 => '每天听几遍';

  @override
  String get onboardingSubtitle3 => '改变从此刻开始';

  @override
  String get onboardingDescription3 => '每天朗读或播放数遍你的宣言。重复的力量会帮你重塑潜意识。';

  @override
  String get continueButton => '继续';

  @override
  String get getStarted => '开始使用';

  @override
  String get skip => '跳过';
}
