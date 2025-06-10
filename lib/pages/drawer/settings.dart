// drawer.dart
import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/pages/language_page.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: Column(
        children: [
          // Header

          DrawerHeader(child: 
            Center(
              child: Text(
                AppLocalizations.of(context)!.settingsTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Light/Dark Mode Toggle
          ListTile(
            leading: Icon(Icons.brightness_6, color: Colors.white),
            title: Text(
              AppLocalizations.of(context)!.lightDarkMode,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Implement light/dark mode toggle functionality
            },
          ),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language, color: Colors.white),
            title: Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(color: Colors.white),
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