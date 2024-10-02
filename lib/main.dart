import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:szakdoga/screens/Wrapper.dart';
import 'package:szakdoga/services/Auth.dart';
import 'screens/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

//void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase before app starts
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Greenlike',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      
      ),
    );
  }
}
