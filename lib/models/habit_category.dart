class HabitCategory {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<String> suggestions;

  const HabitCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.suggestions,
  });

  static const List<HabitCategory> predefinedCategories = [
    HabitCategory(
      id: 'smoking',
      name: '吸烟',
      icon: '🚭',
      description: '戒除吸烟习惯',
      suggestions: [
        '我从不抽烟，因为烟很臭，抽烟我就不开心。',
        '我从不抽烟，因为会影响健康，生病让我很焦虑。',
        '我从不抽烟，因为浪费金钱，花冤枉钱我很心疼。',
        '我从不抽烟，因为影响他人，害人害己让我愧疚。',
      ],
    ),
    HabitCategory(
      id: 'short_videos',
      name: '刷短视频',
      icon: '📱',
      description: '减少短视频使用时间',
      suggestions: [
        '我从不刷短视频，因为浪费时间，虚度光阴让我后悔。',
        '我从不刷短视频，因为影响专注，分心走神让我烦躁。',
        '我从不刷短视频，因为内容无聊，看垃圾信息让我空虚。',
        '我从不刷短视频，因为容易上瘾，失去自控让我恐慌。',
      ],
    ),
    HabitCategory(
      id: 'procrastination',
      name: '拖延',
      icon: '⏰',
      description: '克服拖延症',
      suggestions: [
        '我从不拖延，因为时间宝贵，浪费时间让我着急。',
        '我从不拖延，因为影响效率，完不成任务让我沮丧。',
        '我从不拖延，因为增加压力，最后赶工让我紧张。',
        '我从不拖延，因为失去机会，错过良机让我遗憾。',
      ],
    ),
    HabitCategory(
      id: 'drinking',
      name: '饮酒',
      icon: '🍺',
      description: '戒除饮酒习惯',
      suggestions: [
        '我从不喝酒，因为伤害身体，损害健康让我担忧。',
        '我从不喝酒，因为影响判断，做错决定让我后悔。',
        '我从不喝酒，因为花费过多，浪费金钱让我心疼。',
        '我从不喝酒，因为容易依赖，失去控制让我恐惧。',
      ],
    ),
    HabitCategory(
      id: 'overeating',
      name: '暴饮暴食',
      icon: '🍔',
      description: '控制饮食习惯',
      suggestions: [
        '我从不暴饮暴食，因为伤害肠胃，消化不良让我难受。',
        '我从不暴饮暴食，因为身材走样，变胖变丑让我自卑。',
        '我从不暴饮暴食，因为浪费食物，铺张浪费让我愧疚。',
        '我从不暴饮暴食，因为失去自控，放纵自己让我失望。',
      ],
    ),
    HabitCategory(
      id: 'late_sleeping',
      name: '熬夜',
      icon: '🌙',
      description: '改善睡眠习惯',
      suggestions: [
        '我从不熬夜，因为伤害身体，睡眠不足让我疲惫。',
        '我从不熬夜，因为影响工作，没有精神让我烦躁。',
        '我从不熬夜，因为皮肤变差，容颜憔悴让我沮丧。',
        '我从不熬夜，因为生物钟乱，作息混乱让我焦虑。',
      ],
    ),
    HabitCategory(
      id: 'gaming',
      name: '游戏成瘾',
      icon: '🎮',
      description: '控制游戏时间',
      suggestions: [
        '我从不沉迷游戏，因为浪费青春，虚度年华让我后悔。',
        '我从不沉迷游戏，因为影响学习，成绩下降让我担心。',
        '我从不沉迷游戏，因为伤害眼睛，视力下降让我害怕。',
        '我从不沉迷游戏，因为脱离现实，逃避生活让我空虚。',
      ],
    ),
    HabitCategory(
      id: 'social_media',
      name: '社交媒体',
      icon: '📲',
      description: '减少社交媒体使用',
      suggestions: [
        '我从不沉迷社交媒体，因为浪费时间，无意义刷屏让我空虚。',
        '我从不沉迷社交媒体，因为引发比较，看别人炫耀让我嫉妒。',
        '我从不沉迷社交媒体，因为信息垃圾，负面内容让我烦躁。',
        '我从不沉迷社交媒体，因为影响专注，分心走神让我焦虑。',
      ],
    ),
  ];

  static const List<HabitCategory> positiveHabits = [
    HabitCategory(
      id: 'exercise',
      name: '运动',
      icon: '🏃',
      description: '养成运动习惯',
      suggestions: [
        '我每天都运动，因为强身健体，身体强壮让我自信。',
        '我每天都运动，因为释放压力，挥汗如雨让我舒畅。',
        '我每天都运动，因为保持身材，体态优美让我开心。',
        '我每天都运动，因为精神充沛，活力满满让我兴奋。',
      ],
    ),
    HabitCategory(
      id: 'reading',
      name: '阅读',
      icon: '📖',
      description: '养成阅读习惯',
      suggestions: [
        '我每天都阅读，因为增长知识，学到新东西让我充实。',
        '我每天都阅读，因为开拓视野，了解世界让我兴奋。',
        '我每天都阅读，因为提升智慧，变得聪明让我骄傲。',
        '我每天都阅读，因为陶冶情操，内心平静让我愉悦。',
      ],
    ),
    HabitCategory(
      id: 'meditation',
      name: '冥想',
      icon: '🧘',
      description: '养成冥想习惯',
      suggestions: [
        '我每天都冥想，因为内心平静，心灵安宁让我放松。',
        '我每天都冥想，因为缓解压力，释放焦虑让我舒适。',
        '我每天都冥想，因为专注当下，活在此刻让我满足。',
        '我每天都冥想，因为自我觉察，了解内心让我清明。',
      ],
    ),
    HabitCategory(
      id: 'early_rising',
      name: '早起',
      icon: '🌅',
      description: '养成早起习惯',
      suggestions: [
        '我每天都早起，因为精神饱满，清晨状态让我神清气爽。',
        '我每天都早起，因为时间充裕，从容不迫让我安心。',
        '我每天都早起，因为空气清新，呼吸顺畅让我舒服。',
        '我每天都早起，因为高效工作，事半功倍让我满意。',
      ],
    ),
  ];

  static List<HabitCategory> get allCategories => [
    ...predefinedCategories,
    ...positiveHabits,
  ];

  @override
  String toString() => 'HabitCategory(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}