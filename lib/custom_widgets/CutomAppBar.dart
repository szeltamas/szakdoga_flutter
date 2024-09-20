import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Required to implement PreferredSizeWidget

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight), // Default height of AppBar
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Adjust padding here
          child: Icon(FontAwesomeIcons.leaf, color: Colors.black),
        ),
        title: Row(
          children: [
            SizedBox(width: 0), // Adjust the space between icon and text
            Text(
              "Greenlike",
              style: TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontSize: 28, // Optional: Adjust font size if needed
              ),
            ),
          ],
        ),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
