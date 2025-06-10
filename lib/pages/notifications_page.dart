import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';

class NotificationsPage extends StatelessWidget{
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 122, 122, 122),
    
      // Bar
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsTitle, style: TextStyle(color: Colors.white,fontSize: 24),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 122, 122, 122),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Center(
          child: Text(
            AppLocalizations.of(context)!.noNotifications,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
      ),
    );
  }

}