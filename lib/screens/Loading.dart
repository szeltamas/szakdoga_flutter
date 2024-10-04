import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8), // Semi-transparent background
      child: Center(
        child: SpinKitFadingCircle( // Flutter Spinkit widget
          color: Colors.lightGreen,
          size: 50.0,
        ),
      ),
    );
  }
}
