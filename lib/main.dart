import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'providers/habit_provider.dart';
import 'providers/app_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await NotificationService.initialize();
  await StorageService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Neverr',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.splash,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}