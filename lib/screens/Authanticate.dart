import 'package:flutter/material.dart';
import 'package:szakdoga/screens/Sign_In.dart';

class Authanticate extends StatefulWidget {
  const Authanticate({super.key});

  @override
  State<Authanticate> createState() => _AuthanticateState();
}

class _AuthanticateState extends State<Authanticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}
