import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/l10n/l10n.dart';
import 'package:namer_app/pages/home_page.dart';
import 'package:namer_app/providers/locale_provider.dart';
import 'package:namer_app/providers/theme_provider.dart';
import 'package:namer_app/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: PlantCareApp()));
}

class PlantCareApp extends ConsumerWidget {
  const PlantCareApp({super.key});

  ThemeMode _getThemeMode(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(themeProvider); 
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: AppConstants.appName,
      home: HomePage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: _getThemeMode(currentTheme),
    );
  }
}