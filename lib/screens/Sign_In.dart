import 'package:flutter/material.dart';
import 'package:szakdoga/services/Auth.dart';
import '../custom_widgets/CustomButton.dart'; // Import your custom button widget
import '../custom_widgets/CustomFooter.dart'; // Import your footer widget
import 'Register.dart'; // Import the Register screen
import 'Loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget()
        : Scaffold(
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
                          validator: (val) => val!.isEmpty ? 'Enter an email' : null, // Adjusted for validation message
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
                          validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null, // Adjusted for validation message
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 40),

                        // Row for Sign In and Register buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                          children: [
                            // Sign In button with primary color
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Set background color
                                foregroundColor: Colors.white, // Set text color
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Keep the same padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Could not sign in with credentials';
                                      loading = false;
                                    });
                                  }

                                  print("Signing in with $email and password");
                                }
                              },
                              child: Text("Log In", style: TextStyle(fontSize: 18)), // Larger text for better readability
                            ),
                            SizedBox(width: 8), // Add a small gap between buttons (adjusted size)
                            // Register button with primary color (filled)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Set background color
                                foregroundColor: Colors.white, // Set text color
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Keep the same padding
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
                              child: Text("Sign Up", style: TextStyle(fontSize: 18)), // Larger text for better readability
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),

                        // Error message display with white background only when there is an error
                        if (error.isNotEmpty) // Conditionally render the error message
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85), // White background for the error message
                              borderRadius: BorderRadius.circular(12), // Rounded edges
                            ),
                            padding: EdgeInsets.all(10), // Padding for better appearance
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
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
