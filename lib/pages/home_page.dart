import 'package:flutter/material.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/pages/drawer/settings.dart';
import 'package:namer_app/pages/notifications_page.dart';
import 'package:namer_app/widgets/batery_level.dart';
import 'package:namer_app/widgets/humidity_level.dart';
import 'package:namer_app/widgets/watering_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SettingsDrawer(),

      // Bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.appTitle, style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
             Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),

      // Background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Image
        child: Center(
          child: ListView(
            children: [
              Image.asset(AppConstants.plantImage,
                width: 400,
                height: 400,
              ),

              // Watering button
              WateringButton(
                onPressed: () {
                  // Implement watering logic
                },
              ),

              // Battery and Humidity levels
              Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Expanded(
                     child: HumidityLevel(),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                    child: BateryLevel(),
                    ),
                  ],
                  ),
              ),
            ],
          ),
        ),

      ),


    );
  }
}