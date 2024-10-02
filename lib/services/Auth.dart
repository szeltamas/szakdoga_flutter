import 'package:firebase_auth/firebase_auth.dart';
import 'package:szakdoga/models/MyUser.dart';
import 'package:provider/provider.dart';


class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

/*
  //Creating custom user from FireBaseUser type
  My_user? _userFromFireBaseUser(User? user) {
    return user != null ? My_user(uid: user.uid) : null;
  }



  Stream<My_user?> get user
  {
    //return _auth.authStateChanges().map((User? user) => _userFromFireBaseUser(user));
    //return _auth.authStateChanges().map(_userFromFireBaseUser);

  }*/

  Stream<User?> get user
  {
    return _auth.authStateChanges();
  }

}
