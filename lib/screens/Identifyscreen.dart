import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import '../custom_widgets/CustomButton.dart';
import '../custom_widgets/CutomAppBar.dart';
import 'dart:io'; // Needed to handle files

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
          // The dashboard-like footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              color: Colors.lightGreen,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 44),
                    onPressed: () {
                      Navigator.pop(context); // Go back to MainPage
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
