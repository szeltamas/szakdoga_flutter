import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/services.dart'; // Import for rootBundle
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../custom_widgets/CustomFooter.dart'; // Import your FooterWidget
import '../services/Database.dart'; // Import the DatabaseService

class ResultScreen extends StatefulWidget {
  final String classificationResult;
  final File? imageFile; // File for image from the classifier (optional)
  final String? imagePath; // String for image asset from the browse screen (optional)

  const ResultScreen({
    Key? key,
    required this.classificationResult,
    this.imageFile, // File image from classification
    this.imagePath, // Asset image from BrowseScreen
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? _plantDescription;
  String? uid; // For storing the user's UID

  @override
  void initState() {
    super.initState();
    _loadPlantDescription();
    _getCurrentUser(); // Fetch the current user's UID
  }

  Future<void> _loadPlantDescription() async {
    // Load JSON file
    final String response = await rootBundle.loadString('custom_files/plants.json');
    final data = json.decode(response);

    // Find the description based on classificationResult
    for (var plant in data['plant_descriptions']) {
      if (plant['name'].toLowerCase() == widget.classificationResult.toLowerCase()) {
        setState(() {
          _plantDescription = plant['description'];
        });
        break;
      }
    }
  }

  Future<void> _getCurrentUser() async {
    // Get the current user's UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid; // Store the user's UID
      });
    }
  }

  Future<void> _addPlantToFavorites() async {
    if (uid != null) {
      // Use the DatabaseService to add the plant name to favorites
      await DatabaseService(uid: uid!).addPlantToFavorites(widget.classificationResult);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${widget.classificationResult} added to favorites!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classificationResult),
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white, // Set a solid background color
            padding: const EdgeInsets.all(16.0), // Add some padding to the body
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the top
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: widget.imageFile != null
                            ? Image.file(
                          widget.imageFile!,
                          fit: BoxFit.cover,
                          height: 240,
                          width: double.infinity,
                        )
                            : Image.asset(
                          widget.imagePath!,
                          fit: BoxFit.cover,
                          height: 240,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: 10), // Space between image and name
                      Text(
                        widget.classificationResult,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Increased space between name and description
                if (_plantDescription != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // Solid background for the description
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _plantDescription!,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify, // Justified text
                    ),
                  ),
              ],
            ),
          ),
          // Positioned button above the footer
          Positioned(
            bottom: 70, // Position the button above the footer
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () async {
                await _addPlantToFavorites(); // Call the function to add plant to favorites
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Updated for background color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Add to favourites",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const FooterWidget(), // Add the FooterWidget at the bottom
        ],
      ),
    );
  }
}
