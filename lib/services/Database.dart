import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid});

  //Collection reference
  final CollectionReference favplantCollection = FirebaseFirestore.instance.collection('favplants');

  Future updateUserData(List<String> plantName) async
  {
    return await favplantCollection.doc(uid).set({
      'favplantname': plantName
    });
  }
}