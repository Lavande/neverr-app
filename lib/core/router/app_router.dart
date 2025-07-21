import 'package:flutter/material.dart';
import '../../screens/splash_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/create_goal_screen.dart';
import '../../screens/record_statement_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/habit_detail_screen.dart';
import '../../screens/settings_screen.dart';
import '../../models/habit_item.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String createGoal = '/create-goal';
  static const String recordStatement = '/record-statement';
  static const String dashboard = '/dashboard';
  static const String mainNavigation = '/main-navigation';
  static const String habitDetail = '/habit-detail';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case createGoal:
        return MaterialPageRoute(builder: (_) => const CreateGoalScreen());
      
      case recordStatement:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RecordStatementScreen(
            statement: args?['statement'] ?? '',
            habitId: args?['habitId'],
            habitTitle: args?['habitTitle'],
          ),
        );
      
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
      case mainNavigation:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      
      case habitDetail:
        final habit = routeSettings.arguments as HabitItem;
        return MaterialPageRoute(
          builder: (_) => HabitDetailScreen(habit: habit),
        );
      
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name ?? 'unknown'}'),
            ),
          ),
        );
    }
  }
}