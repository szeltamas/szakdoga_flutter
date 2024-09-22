import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String classificationResult;

  const ResultScreen({Key? key, required this.classificationResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classification Result'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(
        child: Text(
          'This plant is a: $classificationResult',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
