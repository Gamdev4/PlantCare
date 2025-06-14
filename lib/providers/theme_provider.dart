import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTheme { light, dark, system }

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.system);

  void toggleTheme() {
    state = state == AppTheme.light ? AppTheme.dark : AppTheme.light;
  }

  void setTheme(AppTheme theme) {
    state = theme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});