import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user
  {
    return _auth.authStateChanges();
  }

  //Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async
  {
    try
    {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user  = result.user;
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  //Login with email and password
  Future<User?> signinWithEmailAndPassword(String email, String password) async
  {
    try
    {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user  = result.user;
      return user;
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future signOut() async
  {
    try
    {
      return await _auth.signOut();
    }
    catch(e)
    {
      return null;
    }
  }

}
