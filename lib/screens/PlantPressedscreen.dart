/*
import 'package:flutter/material.dart';

class PlantPressedScreen extends StatelessWidget {
  final String plantName;
  final String description;
  final String imagePath;  // Make sure imagePath is defined here

  const PlantPressedScreen({
    required this.plantName,
    required this.description,
    required this.imagePath,  // Add imagePath here
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plantName),
        backgroundColor: Colors.lightGreen,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePath,  // Ensure that imagePath is being used here
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 20),
              Text(
                plantName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/