import 'package:flutter/material.dart';
import 'screens/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greenlike',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MainPage()

    );
  }
}
