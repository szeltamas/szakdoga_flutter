import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:szakdoga/screens/FavoritesScreen.dart'; // Import the new FavoritesScreen

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        color: Colors.lightGreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the items
          children: [
            IconButton(
              icon: const Icon(
                Icons.star_border,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                // Navigate to the FavoritesScreen when the icon is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                );
              },
              tooltip: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
