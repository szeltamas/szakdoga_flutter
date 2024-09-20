import 'package:flutter/material.dart';
import '../custom_widgets/CutomAppBar.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Use the custom AppBar
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80, // Height of the dashboard-like footer
              color: Colors.lightGreen, // Light green color for the footer
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 44), // Back icon
                    onPressed: () {
                      Navigator.pop(context); // Go back to MainPage
                    },
                  ),
                  Spacer(), // Pushes the icon to the left
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
