import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/services.dart'; // Import for rootBundle
import '../custom_widgets/CustomFooter.dart'; // Import your FooterWidget

class ResultScreen extends StatefulWidget {
  final String classificationResult;
  final File image;

  const ResultScreen({
    Key? key,
    required this.classificationResult,
    required this.image,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String? _plantDescription;

  @override
  void initState() {
    super.initState();
    _loadPlantDescription();
  }

  Future<void> _loadPlantDescription() async {
    // Load JSON file
    final String response = await rootBundle.loadString('custom_files/plants.json');
    final data = json.decode(response);

    // Find the description based on classificationResult
    for (var plant in data['plant_descriptions']) {
      if (plant['name'] == widget.classificationResult) {
        setState(() {
          _plantDescription = plant['description'];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classification Result'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack( // Use Stack to position FooterWidget
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
                        child: Image.file(
                          widget.image,
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
          const FooterWidget(), // Add the FooterWidget at the bottom
        ],
      ),
    );
  }
}
