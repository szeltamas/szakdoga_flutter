import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  Future<List<String>> _loadImagePaths() async {
    // Load the AssetManifest.json to get the list of assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter the assets to only include those in the plant_images directory
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/plant_images/'))
        .toList();

    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"), // Background image
                fit: BoxFit.cover, // Cover the entire screen
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
                      return GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1, // Make containers square
                        ),
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          final imagePath = imagePaths[index];
                          final fileName = imagePath.split('/').last.split('.').first;

                          return GestureDetector(
                            onTap: () {
                              // Handle image tap here if needed
                            },
                            child: Container(
                              width: 150, // Fixed width for uniformity
                              height: 180, // Adjusted height for better fit
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85), // Background color
                                borderRadius: BorderRadius.circular(25.0), // Rounded corners
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover, // Ensure image fills the container
                                      width: double.infinity,
                                      height: 130, // Fixed height for the image
                                    ),
                                  ),
                                  Container(
                                    height: 50, // Adjusted height for the text
                                    padding: EdgeInsets.symmetric(vertical: 5.0), // Reduced padding
                                    child: Center(
                                      child: Text(
                                        fileName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
                                        maxLines: 1, // Limit to one line
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
                ),
              ),
            ],
          ),
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
