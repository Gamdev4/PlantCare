import 'package:flutter/material.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/pages/notifications_page.dart';

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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    // This is just a placeholder for the actual logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Watering the plants...')),
                    );
                  },	
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: const Center(
                    child: Text(
                      AppConstants.wateringButtonText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                )
              ),
              
            ],
          ),
        ),

      ),


    );
  }
}