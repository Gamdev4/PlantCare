import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:namer_app/constants/app_constants.dart';

void main() {
  runApp(const PlantCareApp());
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      home: HomePage(),
    );
  }
}