import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/habit_category.dart';

class HabitCategoryService {
  static List<HabitCategory> getLocalizedPredefinedCategories(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return [
      HabitCategory(
        id: 'smoking',
        name: localizations.smoking,
        icon: '🚭',
        description: 'Break smoking habit',
        suggestions: _getSmokingSuggestions(context),
      ),
      HabitCategory(
        id: 'short_videos',
        name: localizations.shortVideos,
        icon: '📱',
        description: 'Reduce short video usage time',
        suggestions: _getShortVideosSuggestions(context),
      ),
      HabitCategory(
        id: 'procrastination',
        name: localizations.procrastination,
        icon: '⏰',
        description: 'Overcome procrastination',
        suggestions: _getProcrastinationSuggestions(context),
      ),
      HabitCategory(
        id: 'drinking',
        name: localizations.drinking,
        icon: '🍺',
        description: 'Break drinking habit',
        suggestions: _getDrinkingSuggestions(context),
      ),
      HabitCategory(
        id: 'overeating',
        name: localizations.overeating,
        icon: '🍔',
        description: 'Control eating habits',
        suggestions: _getOvereatingSuggestions(context),
      ),
      HabitCategory(
        id: 'late_sleeping',
        name: localizations.lateSleeping,
        icon: '🌙',
        description: 'Improve sleep habits',
        suggestions: _getLateSleepingSuggestions(context),
      ),
      HabitCategory(
        id: 'gaming',
        name: localizations.gaming,
        icon: '🎮',
        description: 'Control gaming time',
        suggestions: _getGamingSuggestions(context),
      ),
      HabitCategory(
        id: 'social_media',
        name: localizations.socialMedia,
        icon: '📲',
        description: 'Reduce social media usage',
        suggestions: _getSocialMediaSuggestions(context),
      ),
    ];
  }

  static List<HabitCategory> getLocalizedPositiveHabits(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return [
      HabitCategory(
        id: 'exercise',
        name: localizations.exercise,
        icon: '🏃',
        description: 'Build exercise habit',
        suggestions: _getExerciseSuggestions(context),
      ),
      HabitCategory(
        id: 'reading',
        name: localizations.reading,
        icon: '📖',
        description: 'Build reading habit',
        suggestions: _getReadingSuggestions(context),
      ),
      HabitCategory(
        id: 'meditation',
        name: localizations.meditation,
        icon: '🧘',
        description: 'Build meditation habit',
        suggestions: _getMeditationSuggestions(context),
      ),
      HabitCategory(
        id: 'early_rising',
        name: localizations.earlyRising,
        icon: '🌅',
        description: 'Build early rising habit',
        suggestions: _getEarlyRisingSuggestions(context),
      ),
    ];
  }

  static List<HabitCategory> getAllLocalizedCategories(BuildContext context) {
    return [
      ...getLocalizedPredefinedCategories(context),
      ...getLocalizedPositiveHabits(context),
    ];
  }

  // Private methods for suggestions - will return different content based on locale
  static List<String> _getSmokingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never smoke because it smells terrible, and smoking makes me unhappy.',
        'I never smoke because it affects my health, and getting sick makes me anxious.',
        'I never smoke because it wastes money, and spending unnecessary money makes me regret.',
        'I never smoke because it harms others, and hurting people makes me feel guilty.',
      ];
    } else {
      return [
        '我从不抽烟，因为烟很臭，抽烟我就不开心。',
        '我从不抽烟，因为会影响健康，生病让我很焦虑。',
        '我从不抽烟，因为浪费金钱，花冤枉钱我很心疼。',
        '我从不抽烟，因为影响他人，害人害己让我愧疚。',
      ];
    }
  }

  static List<String> _getShortVideosSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never watch short videos because it wastes time, and wasting time makes me regret.',
        'I never watch short videos because it affects focus, and being distracted makes me irritated.',
        'I never watch short videos because the content is boring, and consuming trash information makes me feel empty.',
        'I never watch short videos because it\'s addictive, and losing self-control makes me panic.',
      ];
    } else {
      return [
        '我从不刷短视频，因为浪费时间，虚度光阴让我后悔。',
        '我从不刷短视频，因为影响专注，分心走神让我烦躁。',
        '我从不刷短视频，因为内容无聊，看垃圾信息让我空虚。',
        '我从不刷短视频，因为容易上瘾，失去自控让我恐慌。',
      ];
    }
  }

  static List<String> _getProcrastinationSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never procrastinate because time is precious, and wasting time makes me anxious.',
        'I never procrastinate because it affects efficiency, and not completing tasks makes me frustrated.',
        'I never procrastinate because it increases pressure, and last-minute rushing makes me stressed.',
        'I never procrastinate because it causes me to miss opportunities, and missing good chances makes me regret.',
      ];
    } else {
      return [
        '我从不拖延，因为时间宝贵，浪费时间让我着急。',
        '我从不拖延，因为影响效率，完不成任务让我沮丧。',
        '我从不拖延，因为增加压力，最后赶工让我紧张。',
        '我从不拖延，因为失去机会，错过良机让我遗憾。',
      ];
    }
  }

  static List<String> _getDrinkingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never drink alcohol because it harms my body, and damaging my health makes me worried.',
        'I never drink alcohol because it affects judgment, and making wrong decisions makes me regret.',
        'I never drink alcohol because it costs too much, and wasting money makes me feel bad.',
        'I never drink alcohol because it\'s easy to become dependent, and losing control makes me afraid.',
      ];
    } else {
      return [
        '我从不喝酒，因为伤害身体，损害健康让我担忧。',
        '我从不喝酒，因为影响判断，做错决定让我后悔。',
        '我从不喝酒，因为花费过多，浪费金钱让我心疼。',
        '我从不喝酒，因为容易依赖，失去控制让我恐惧。',
      ];
    }
  }

  static List<String> _getOvereatingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never overeat because it hurts my stomach, and indigestion makes me uncomfortable.',
        'I never overeat because it ruins my figure, and becoming fat and ugly makes me insecure.',
        'I never overeat because it wastes food, and being wasteful makes me feel guilty.',
        'I never overeat because it shows lack of self-control, and being indulgent disappoints me.',
      ];
    } else {
      return [
        '我从不暴饮暴食，因为伤害肠胃，消化不良让我难受。',
        '我从不暴饮暴食，因为身材走样，变胖变丑让我自卑。',
        '我从不暴饮暴食，因为浪费食物，铺张浪费让我愧疚。',
        '我从不暴饮暴食，因为失去自控，放纵自己让我失望。',
      ];
    }
  }

  static List<String> _getLateSleepingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never stay up late because it harms my body, and lack of sleep makes me exhausted.',
        'I never stay up late because it affects my work, and having no energy makes me irritated.',
        'I never stay up late because it makes my skin worse, and looking haggard makes me depressed.',
        'I never stay up late because it disrupts my biological clock, and chaotic sleep schedule makes me anxious.',
      ];
    } else {
      return [
        '我从不熬夜，因为伤害身体，睡眠不足让我疲惫。',
        '我从不熬夜，因为影响工作，没有精神让我烦躁。',
        '我从不熬夜，因为皮肤变差，容颜憔悴让我沮丧。',
        '我从不熬夜，因为生物钟乱，作息混乱让我焦虑。',
      ];
    }
  }

  static List<String> _getGamingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never get addicted to games because it wastes my youth, and wasting years makes me regret.',
        'I never get addicted to games because it affects my studies, and declining grades make me worried.',
        'I never get addicted to games because it hurts my eyes, and vision problems make me scared.',
        'I never get addicted to games because it disconnects me from reality, and escaping life makes me feel empty.',
      ];
    } else {
      return [
        '我从不沉迷游戏，因为浪费青春，虚度年华让我后悔。',
        '我从不沉迷游戏，因为影响学习，成绩下降让我担心。',
        '我从不沉迷游戏，因为伤害眼睛，视力下降让我害怕。',
        '我从不沉迷游戏，因为脱离现实，逃避生活让我空虚。',
      ];
    }
  }

  static List<String> _getSocialMediaSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I never get addicted to social media because it wastes time, and meaningless scrolling makes me feel empty.',
        'I never get addicted to social media because it triggers comparisons, and seeing others show off makes me jealous.',
        'I never get addicted to social media because of information garbage, and negative content makes me irritated.',
        'I never get addicted to social media because it affects focus, and being distracted makes me anxious.',
      ];
    } else {
      return [
        '我从不沉迷社交媒体，因为浪费时间，无意义刷屏让我空虚。',
        '我从不沉迷社交媒体，因为引发比较，看别人炫耀让我嫉妒。',
        '我从不沉迷社交媒体，因为信息垃圾，负面内容让我烦躁。',
        '我从不沉迷社交媒体，因为影响专注，分心走神让我焦虑。',
      ];
    }
  }

  static List<String> _getExerciseSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I exercise every day because it strengthens my body, and being strong makes me confident.',
        'I exercise every day because it releases stress, and sweating makes me feel great.',
        'I exercise every day because it maintains my figure, and having a good body makes me happy.',
        'I exercise every day because it gives me energy, and being full of vitality makes me excited.',
      ];
    } else {
      return [
        '我每天都运动，因为强身健体，身体强壮让我自信。',
        '我每天都运动，因为释放压力，挥汗如雨让我舒畅。',
        '我每天都运动，因为保持身材，体态优美让我开心。',
        '我每天都运动，因为精神充沛，活力满满让我兴奋。',
      ];
    }
  }

  static List<String> _getReadingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I read every day because it increases knowledge, and learning new things makes me fulfilled.',
        'I read every day because it broadens my horizons, and understanding the world makes me excited.',
        'I read every day because it enhances wisdom, and becoming smarter makes me proud.',
        'I read every day because it cultivates character, and inner peace makes me joyful.',
      ];
    } else {
      return [
        '我每天都阅读，因为增长知识，学到新东西让我充实。',
        '我每天都阅读，因为开拓视野，了解世界让我兴奋。',
        '我每天都阅读，因为提升智慧，变得聪明让我骄傲。',
        '我每天都阅读，因为陶冶情操，内心平静让我愉悦。',
      ];
    }
  }

  static List<String> _getMeditationSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I meditate every day because it brings inner peace, and mental tranquility makes me relaxed.',
        'I meditate every day because it relieves stress, and releasing anxiety makes me comfortable.',
        'I meditate every day because it helps me focus on the present, and living in the moment makes me satisfied.',
        'I meditate every day because it increases self-awareness, and understanding my inner self makes me clear-minded.',
      ];
    } else {
      return [
        '我每天都冥想，因为内心平静，心灵安宁让我放松。',
        '我每天都冥想，因为缓解压力，释放焦虑让我舒适。',
        '我每天都冥想，因为专注当下，活在此刻让我满足。',
        '我每天都冥想，因为自我觉察，了解内心让我清明。',
      ];
    }
  }

  static List<String> _getEarlyRisingSuggestions(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    
    if (isEnglish) {
      return [
        'I wake up early every day because I feel energetic, and the morning state makes me refreshed.',
        'I wake up early every day because I have plenty of time, and being unhurried makes me peaceful.',
        'I wake up early every day because the air is fresh, and breathing smoothly makes me comfortable.',
        'I wake up early every day because I work efficiently, and being productive makes me satisfied.',
      ];
    } else {
      return [
        '我每天都早起，因为精神饱满，清晨状态让我神清气爽。',
        '我每天都早起，因为时间充裕，从容不迫让我安心。',
        '我每天都早起，因为空气清新，呼吸顺畅让我舒服。',
        '我每天都早起，因为高效工作，事半功倍让我满意。',
      ];
    }
  }
}