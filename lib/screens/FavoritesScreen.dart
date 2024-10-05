import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ResultScreen.dart'; // Import the ResultScreen

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  // Method to retrieve favorite plants for the current user
  Future<List<String>> _getFavoritePlants() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch the document for the current user
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('favplants')
          .doc(user.uid)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        // Extract the plant names list
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> plants = data['favplantname'] ?? [];
        return List<String>.from(plants); // Convert dynamic list to List<String>
      }
    }

    return []; // Return an empty list if no favorites are found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<List<String>>(
            future: _getFavoritePlants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching favorites.'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No favorite plants found.'));
              }

              final favoritePlants = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.8, // Adjusted aspect ratio
                  ),
                  itemCount: favoritePlants.length,
                  itemBuilder: (context, index) {
                    final plantName = favoritePlants[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the ResultScreen when a favorite plant is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              classificationResult: plantName,
                              imagePath: 'images/plant_images/$plantName.jpg', // Assuming image path structure
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                              child: Image.asset(
                                'images/plant_images/$plantName.jpg', // Placeholder image path
                                fit: BoxFit.cover,
                                height: 180,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 10), // Space between image and name
                            Text(
                              plantName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
