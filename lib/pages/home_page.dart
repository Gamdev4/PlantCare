import 'package:flutter/material.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/pages/notifications_page.dart';
import 'package:namer_app/widgets/batery_level.dart';
import 'package:namer_app/widgets/humidity_level.dart';
import 'package:namer_app/widgets/watering_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppConstants.appTitle, style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
            },
          ),
        ],
      ),

      // Background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 126, 126, 126),
              const Color.fromARGB(255, 80, 80, 80),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Image
        child: Center(
          child: ListView(
            children: [
              Image.asset('assets/images/plant.png',
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
                 padding: const EdgeInsets.symmetric(horizontal: 20), // Padding externo de 20
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Expanded(
                     child: HumidityLevel(),
                    ),
                    SizedBox(width: 10), // Reducimos la separación interna a 10
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