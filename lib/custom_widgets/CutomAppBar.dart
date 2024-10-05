import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../screens/FavoritesScreen.dart';
import '../custom_widgets/ProfileIcon.dart'; // Import the ProfileIcon widget

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // Required to implement PreferredSizeWidget

  CustomAppBar({Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight), // Default height of AppBar
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Get the current user

    return AppBar(
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
              fontSize: 28, // Optional: Adjust font size if needed
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightGreen,
      actions: [
        ProfileIcon(user: user), // Use ProfileIcon here
      ],
    );
  }
}
