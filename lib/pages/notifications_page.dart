import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';

class NotificationsPage extends StatelessWidget{
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    
      // Bar
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsTitle, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 24),),
        centerTitle: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),
      
      body: Center(
          child: Text(
            AppLocalizations.of(context)!.noNotifications,
            style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
          ),
      ),
    );
  }

}