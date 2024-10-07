import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({ required this.uid });

  // Collection reference
  final CollectionReference favplantCollection = FirebaseFirestore.instance.collection('favplants');

  // Method to initialize user data with an empty list
  Future initializeUserData() async {
    return await favplantCollection.doc(uid).set({
      'favplantname': []
    });
  }

  // Add plant name to the favorites list
  Future addPlantToFavorites(String plantName) async {
    return await favplantCollection.doc(uid).set({
      'favplantname': FieldValue.arrayUnion([plantName]) // Add plant to array
    }, SetOptions(merge: true));
  }

  // Remove plant name from the favorites list
  Future removePlantFromFavorites(String plantName) async {
    return await favplantCollection.doc(uid).set({
      'favplantname': FieldValue.arrayRemove([plantName]) // Remove plant from array
    }, SetOptions(merge: true));
  }

  // Get the list of favorite plants
  Future<List<String>> getFavoritePlants() async {
    DocumentSnapshot snapshot = await favplantCollection.doc(uid).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> favPlants = data['favplantname'] ?? [];
      return List<String>.from(favPlants); // Return list of favorite plant names
    } else {
      return []; // Return empty list if no data exists
    }
  }
}
