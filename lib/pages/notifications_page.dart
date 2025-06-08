import 'package:flutter/material.dart';
import 'package:namer_app/constants/app_constants.dart';

class NotificationsPage extends StatelessWidget{
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 122, 122, 122),
      
      appBar: AppBar(
        title: const Text(AppConstants.notificationsTitle, style: TextStyle(color: Colors.white,fontSize: 24),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 122, 122, 122),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Center(
          child: Text(
            AppConstants.noNotifications,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
      ),
    );
  }

}