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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.open_in_new,
                color: Colors.black,
                size: 30, // Increase the size of the icon
              ),
              onPressed: _launchURL, // Launch the URL when pressed
              tooltip: 'Go to GitHub',
            ),
          ],
        ),
      ),
    );
  }
}
