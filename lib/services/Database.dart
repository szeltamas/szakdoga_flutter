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
      'favplantname': FieldValue.arrayUnion([plantName])
    }, SetOptions(merge: true));
  }
}
