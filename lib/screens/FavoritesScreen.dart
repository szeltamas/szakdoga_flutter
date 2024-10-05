import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:szakdoga/services/Database.dart';

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
      body: FutureBuilder<List<String>>(
        future: _getFavoritePlants(), // Get the favorite plants
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching favorites.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite plants found.'));
          }

          // If there are favorite plants, display them in a ListView
          List<String> favoritePlants = snapshot.data!;

          return ListView.builder(
            itemCount: favoritePlants.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favoritePlants[index]),
                trailing: const Icon(Icons.favorite, color: Colors.red),
              );
            },
          );
        },
      ),
    );
  }
}
