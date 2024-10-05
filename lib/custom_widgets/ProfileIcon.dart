import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../screens/FavoritesScreen.dart';

class ProfileIcon extends StatelessWidget {
  final User? user; // Current user info

  const ProfileIcon({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.user, color: Colors.black), // Profile icon
      onPressed: () {
        _showUserPopup(context, user);
      },
    );
  }

  void _showUserPopup(BuildContext context, User? user) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000.0, 60.0, 0.0, 0.0), // Position it in the top right corner
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),),
      items: [
        PopupMenuItem(
          child: Container(
            width: 300, // Increased width for the popup
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
                    child: Text(
                      'Favorites',
                      style: TextStyle(color: Colors.black), // Set text color to black
                    ),
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
                      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
                      Navigator.pop(context); // Close the popup
                      // The Wrapper will handle navigating back to the Authanticate screen
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.black), // Set text color to black
                    ),
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
