import 'package:flutter/material.dart';
import 'package:szakdoga/services/Auth.dart';
import '../custom_widgets/CustomButton.dart';
import 'IdentifyScreen.dart'; // Import the IdentifyScreen
import 'BrowseScreen.dart'; // Import the BrowseScreen
import '../custom_widgets/CustomFooter.dart';
import '../custom_widgets/CutomAppBar.dart'; // Import the CustomAppBar

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter, // Align the buttons to the top center
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0), // Add some top padding
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the column takes only as much space as needed
                  children: [
                    CustomButton(
                      text: "Identify",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdentifyScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30), // Space between the buttons
                    CustomButton(
                      text: "Browse",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrowseScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
