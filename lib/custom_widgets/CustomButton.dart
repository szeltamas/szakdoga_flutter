import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    this.text,
    this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0), // Remove padding to center text/icon
        backgroundColor: Colors.white.withOpacity(0.85),
        fixedSize: Size(300, 200),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Rounded corners
        ),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, size: 60, color: Colors.black) // Use icon if provided
            : Text(
          text ?? '',
          style: TextStyle(fontSize: 36, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}