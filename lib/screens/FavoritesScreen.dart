import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:szakdoga/custom_widgets/CustomFooter.dart';
import 'ResultScreen.dart'; // Import the ResultScreen

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<String>>? favoritePlantsFuture;

  @override
  void initState() {
    super.initState();
    favoritePlantsFuture = _getFavoritePlants(); // Load the favorites when the screen initializes
  }

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

  // Method to refresh the favorites when changes are detected
  void _refreshFavorites() {
    setState(() {
      favoritePlantsFuture = _getFavoritePlants(); // Reload the favorite plants
    });
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
            future: favoritePlantsFuture,
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
                        // Navigate to the ResultScreen and check for changes when returning
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              classificationResult: plantName,
                              imagePath: 'images/plant_images/$plantName.jpg', // Assuming image path structure
                            ),
                          ),
                        ).then((result) {
                          if (result == true) {
                            // Refresh the favorites list if changes were made
                            _refreshFavorites();
                          }
                        });
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
          //const FooterWidget(),
        ],
      ),
    );
  }
}
