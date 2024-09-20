import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  Future<List<String>> _loadImagePaths() async {
    // This assumes that the assets are declared in pubspec.yaml
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter out the images in the plant_images directory
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/plant_images/'))
        .toList();

    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Plants'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<String>>(
        future: _loadImagePaths(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading images'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found'));
          } else {
            final imagePaths = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = imagePaths[index];
                final fileName = imagePath.split('/').last.split('.').first;

                return GestureDetector(
                  onTap: () {
                    // Handle image tap here if needed
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        fileName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
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
    );
  }
}
