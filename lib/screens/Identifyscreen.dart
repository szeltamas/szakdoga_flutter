import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import '../custom_widgets/CustomButton.dart';
import 'dart:io'; // Needed to handle files
import 'NewTestScreen.dart'; // Import the new test screen

class IdentifyScreen extends StatefulWidget {
  const IdentifyScreen({super.key});

  @override
  _IdentifyScreenState createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  final ImagePicker _picker = ImagePicker(); // Initialize the image picker
  File? _selectedImage; // To hold the selected image

  // Method to open camera
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method to open gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method to navigate to NewTestScreen
  void _navigateToNewTestScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewTestScreen()), // Navigate to NewTestScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identify Plant'),  // Title of the screen
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context); // Go back to MainPage
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Camera Button
                    CustomButton(
                      text: "Snap a picture",
                      icon: Icons.add_a_photo,
                      onPressed: _pickImageFromCamera, // Open camera
                    ),
                    SizedBox(height: 30), // Space between buttons

                    // Gallery Button
                    CustomButton(
                      text: "Select from local device",
                      icon: Icons.folder,
                      onPressed: _pickImageFromGallery, // Open gallery
                    ),
                    SizedBox(height: 30),

                    // Navigate to NewTestScreen Button
                    CustomButton(
                      text: "Go to New Test Screen",
                      icon: Icons.navigate_next,
                      onPressed: _navigateToNewTestScreen, // Navigate to NewTestScreen
                    ),
                    SizedBox(height: 30),

                    // Display the selected image
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60, // Height of the dashboard-like footer
              color: Colors.lightGreen, // Light green color for the footer
            ),
          ),
        ],
      ),
    );
  }
}
