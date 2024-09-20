import 'package:flutter/material.dart';

class PlantPressedScreen extends StatelessWidget {
  final String plantName;
  final String description;

  const PlantPressedScreen({
    required this.plantName,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plantName),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
