import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:szakdoga/screens/Authanticate.dart';
import 'package:szakdoga/screens/MainPage.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    debugPrint(user.toString());
    //return Home or Auth widge

    if (user == null)
      {
        return Authanticate();
      }
    else
      {
        return MainPage();
      }

  }
}

