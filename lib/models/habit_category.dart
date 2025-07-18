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
        '我从不吸烟',
        '我从不吸烟。香烟很臭，不能解决任何问题',
        '我从不吸烟。二手烟很恶心',
        '我从不吸烟。香烟对我没有吸引力',
      ],
    ),
    HabitCategory(
      id: 'short_videos',
      name: '刷短视频',
      icon: '📱',
      description: '减少短视频使用时间',
      suggestions: [
        '我从不刷短视频',
        '我从不刷短视频。短视频剥夺我的专注力',
        '我从不刷短视频。我的时间很宝贵',
        '我从不刷短视频。我专注于更有意义的事情',
      ],
    ),
    HabitCategory(
      id: 'procrastination',
      name: '拖延',
      icon: '⏰',
      description: '克服拖延症',
      suggestions: [
        '我从不拖延',
        '我从不拖延。我立即行动',
        '我从不拖延。我高效完成任务',
        '我从不拖延。我珍惜每一分钟',
      ],
    ),
    HabitCategory(
      id: 'drinking',
      name: '饮酒',
      icon: '🍺',
      description: '戒除饮酒习惯',
      suggestions: [
        '我从不喝酒',
        '我从不喝酒。酒精对我没有吸引力',
        '我从不喝酒。我保持清醒和健康',
        '我从不喝酒。我有更好的放松方式',
      ],
    ),
    HabitCategory(
      id: 'overeating',
      name: '暴饮暴食',
      icon: '🍔',
      description: '控制饮食习惯',
      suggestions: [
        '我从不暴饮暴食',
        '我从不暴饮暴食。我控制我的食欲',
        '我从不暴饮暴食。我珍惜我的健康',
        '我从不暴饮暴食。我吃得适量和健康',
      ],
    ),
    HabitCategory(
      id: 'late_sleeping',
      name: '熬夜',
      icon: '🌙',
      description: '改善睡眠习惯',
      suggestions: [
        '我从不熬夜',
        '我从不熬夜。我早睡早起',
        '我从不熬夜。睡眠对我很重要',
        '我从不熬夜。我保持规律的作息',
      ],
    ),
    HabitCategory(
      id: 'gaming',
      name: '游戏成瘾',
      icon: '🎮',
      description: '控制游戏时间',
      suggestions: [
        '我从不沉迷游戏',
        '我从不沉迷游戏。我有节制地娱乐',
        '我从不沉迷游戏。我专注于现实生活',
        '我从不沉迷游戏。我合理安排时间',
      ],
    ),
    HabitCategory(
      id: 'social_media',
      name: '社交媒体',
      icon: '📲',
      description: '减少社交媒体使用',
      suggestions: [
        '我从不过度使用社交媒体',
        '我从不过度使用社交媒体。我专注于真实的生活',
        '我从不过度使用社交媒体。我珍惜面对面的交流',
        '我从不过度使用社交媒体。我有更重要的事情要做',
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
        '我每天都运动',
        '我每天都运动。运动让我充满活力',
        '我每天都运动。我热爱健康的生活方式',
        '我每天都运动。我享受运动的快乐',
      ],
    ),
    HabitCategory(
      id: 'reading',
      name: '阅读',
      icon: '📖',
      description: '养成阅读习惯',
      suggestions: [
        '我每天都阅读',
        '我每天都阅读。阅读让我成长',
        '我每天都阅读。我热爱学习新知识',
        '我每天都阅读。书籍是我的朋友',
      ],
    ),
    HabitCategory(
      id: 'meditation',
      name: '冥想',
      icon: '🧘',
      description: '养成冥想习惯',
      suggestions: [
        '我每天都冥想',
        '我每天都冥想。冥想让我内心平静',
        '我每天都冥想。我专注于当下',
        '我每天都冥想。我保持心灵的宁静',
      ],
    ),
    HabitCategory(
      id: 'early_rising',
      name: '早起',
      icon: '🌅',
      description: '养成早起习惯',
      suggestions: [
        '我每天都早起',
        '我每天都早起。早起让我精力充沛',
        '我每天都早起。我享受清晨的美好',
        '我每天都早起。我有更多时间做重要的事',
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