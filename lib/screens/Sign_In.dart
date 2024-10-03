import 'package:flutter/material.dart';
import 'package:szakdoga/services/Auth.dart';
import '../custom_widgets/CustomButton.dart'; // Import your custom button widget
import '../custom_widgets/CustomFooter.dart'; // Import your footer widget
import 'Register.dart'; // Import the Register screen

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          children: [
            Icon(Icons.eco, color: Colors.black, size: 36), // Leaf icon
            SizedBox(width: 10), // Space between icon and text
            Text('Sign In', style: TextStyle(color: Colors.black)), // Title text in black
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/mobilebackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey, // Assign the form key
                    child: Column(
                      children: [
                        // Email field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black), // Change label text color to black
                            prefixIcon: Icon(Icons.email, color: Colors.black), // Icon color
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (val) => val!.isEmpty ? null : null, // Adjusted for no messages
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20),

                        // Password field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black), // Change label text color to black
                            prefixIcon: Icon(Icons.lock, color: Colors.black), // Icon color
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          obscureText: true,
                          validator: (val) => val!.length < 6 ? null : null, // Adjusted for no messages
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 40),

                        // Row for Sign In and Register buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons to opposite ends
                          children: [
                            // Sign In button with primary color
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Set background color
                                foregroundColor: Colors.white, // Set text color
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding for a larger touch target
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Perform sign-in logic here

                                  dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                                  if(result == null)
                                  {
                                    setState(() => error = 'Could not sign in with credentials');
                                  }


                                  print("Signing in with $email and password");
                                }
                              },
                              child: Text("Sign In", style: TextStyle(fontSize: 18)), // Larger text for better readability
                            ),

                            // Register button with primary color (filled)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Set background color
                                foregroundColor: Colors.white, // Set text color
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding for a larger touch target
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                              ),
                              onPressed: () {
                                // Navigate to the register screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Register(), // Navigate to Register screen
                                  ),
                                );
                              },
                              child: Text("Register", style: TextStyle(fontSize: 18)), // Larger text for better readability
                            ),
                            SizedBox(height: 12.0,),
                            Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const FooterWidget(), // Footer at the bottom
        ],
      ),
    );
  }
}
