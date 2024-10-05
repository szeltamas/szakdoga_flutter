import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../screens/FavoritesScreen.dart';

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
            ),
          ),
        ],
      ),
      backgroundColor: Colors.lightGreen,
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.user, color: Colors.black), // Profile icon
          onPressed: () {
            _showUserPopup(context, user);
          },
        ),
      ],
    );
  }

  void _showUserPopup(BuildContext context, User? user) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000.0, 60.0, 0.0, 0.0), // Position it in the top right corner
      items: [
        PopupMenuItem(
          child: Container(
            width: 200, // Increased width for the popup
            padding: EdgeInsets.all(10), // Add padding around the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null ? user.email ?? 'No email' : 'Not signed in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Increased font size
                ),
                SizedBox(height: 5), // Add some spacing
                // Favorites Button
                Container(
                  width: double.infinity, // Stretch to full width
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesScreen()), // Navigate to FavoritesScreen
                      );
                    },
                    child: Text('Favorites'),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1), // Gray border
                      padding: EdgeInsets.symmetric(vertical: 10), // Increased padding for the button
                      backgroundColor: Colors.transparent, // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Square corners for the border
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5), // Add some spacing
                // Log out Button
                Container(
                  width: double.infinity, // Stretch to full width
                  child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pop(context); // Close the popup
                    },
                    child: Text('Log out'),
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.grey, width: 1), // Gray border
                      padding: EdgeInsets.symmetric(vertical: 10), // Increased padding for the button
                      backgroundColor: Colors.transparent, // Transparent background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Square corners for the border
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
