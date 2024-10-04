import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'ResultScreen.dart'; // Import ResultScreen

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  Future<List<String>> _loadImagePaths() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/plant_images/'))
        .toList();

    return imagePaths;
  }

  Future<Map<String, String>> _loadPlantDescriptions() async {
    final jsonString = await rootBundle.loadString('custom_files/plants.json');
    final data = json.decode(jsonString);
    Map<String, String> plantDescriptions = {};
    for (var plant in data['plant_descriptions']) {
      plantDescriptions[plant['name'].toLowerCase()] = plant['description'];
    }
    return plantDescriptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: Text('Browse Plants'),
                backgroundColor: Colors.lightGreen,
              ),
              Expanded(
                child: FutureBuilder<List<String>>(
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
                      return FutureBuilder<Map<String, String>>(
                        future: _loadPlantDescriptions(),
                        builder: (context, descriptionSnapshot) {
                          if (descriptionSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (descriptionSnapshot.hasError) {
                            return Center(child: Text('Error loading descriptions'));
                          } else if (!descriptionSnapshot.hasData || descriptionSnapshot.data!.isEmpty) {
                            return Center(child: Text('No descriptions found'));
                          } else {
                            final plantDescriptions = descriptionSnapshot.data!;
                            return GridView.builder(
                              padding: EdgeInsets.all(10),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: imagePaths.length,
                              itemBuilder: (context, index) {
                                final imagePath = imagePaths[index];
                                final fileName = imagePath.split('/').last.split('.').first;
                                final plantName = fileName.toLowerCase();

                                return GestureDetector(
                                  onTap: () {
                                    final description = plantDescriptions[plantName] ?? 'No description available.';
                                    // Navigate to ResultScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                          classificationResult: fileName,
                                          imagePath: imagePath, // Pass imagePath for asset image
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                          child: Image.asset(
                                            imagePath,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 130,
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child: Center(
                                            child: Text(
                                              fileName,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
