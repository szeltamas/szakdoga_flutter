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
    this.imageFile,
    this.imagePath,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? _plantDescription;
  String? uid;
  bool isFavorite = false; // To track if the plant is in favorites

  @override
  void initState() {
    super.initState();
    _loadPlantDescription();
    _getCurrentUser();
  }

  Future<void> _loadPlantDescription() async {
    final String response = await rootBundle.loadString('custom_files/plants.json');
    final data = json.decode(response);

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
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      await _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    if (uid != null) {
      List<String> favoritePlants = await DatabaseService(uid: uid!).getFavoritePlants();
      setState(() {
        isFavorite = favoritePlants.contains(widget.classificationResult);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (uid != null) {
      if (isFavorite) {
        await DatabaseService(uid: uid!).removePlantFromFavorites(widget.classificationResult);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${widget.classificationResult} removed from favorites!'),
        ));
      } else {
        await DatabaseService(uid: uid!).addPlantToFavorites(widget.classificationResult);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${widget.classificationResult} added to favorites!'),
        ));
      }

      setState(() {
        isFavorite = !isFavorite;
      });

      // Return true to indicate favorites were updated
      Navigator.pop(context, true);
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
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: widget.imageFile != null
                            ? Image.file(widget.imageFile!, fit: BoxFit.cover, height: 240, width: double.infinity)
                            : Image.asset(widget.imagePath!, fit: BoxFit.cover, height: 240, width: double.infinity),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.classificationResult,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_plantDescription != null)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _plantDescription!,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () async {
                await _toggleFavorite();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFavorite ? Colors.green : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                isFavorite ? "Remove from favorites" : "Add to favorites",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}

