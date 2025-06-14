// drawer.dart
import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/pages/language_page.dart';
import 'package:namer_app/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsDrawer extends ConsumerWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [

          // Header
          DrawerHeader(child: 
            Center(
              child: Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Light/Dark Mode Toggle
          ListTile(
            leading: Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.onPrimary),
            title: Text(
              AppLocalizations.of(context)!.lightDarkMode,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            onTap: () {
              final themeNotifier = ref.read(themeProvider.notifier);
              themeNotifier.toggleTheme();
            },
          ),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language, color: Theme.of(context).colorScheme.onPrimary),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => LanguagePage()),
              );
            },
          ),

        ],

      )
    );
  }
}