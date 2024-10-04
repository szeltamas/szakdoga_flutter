import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  // Method to launch the URL
  void _launchURL() async {
    const url = 'https://github.com/szeltamas';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between items
          children: [
            // GitHub Icon on the left side
            IconButton(
              icon: Icon(
                Icons.open_in_new,
                color: Colors.black,
                size: 30, // Increase the size of the icon
              ),
              onPressed: _launchURL, // Launch the URL when pressed
              tooltip: 'Go to GitHub',
            ),
            // Hollow Star Icon in the center
            IconButton(
              icon: Icon(
                Icons.star_border,
                color: Colors.black, // Color of the hollow star icon
                size: 30, // Increase the size of the icon
              ),
              onPressed: () {
                // Define what happens when the star icon is pressed
              },
              tooltip: 'Favorites',
            ),
            // Placeholder for the right side if needed, or remove it if only two icons are used
            SizedBox(width: 30), // Adjust this or replace with another button if needed
          ],
        ),
      ),
    );
  }
}
