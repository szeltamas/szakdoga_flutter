import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:szakdoga/services/Auth.dart';
import '../custom_widgets/CustomFooter.dart'; // Import your footer widget

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
            Text('Register', style: TextStyle(color: Colors.black)), // Title text in black
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
                          validator: (val) => val!.isEmpty ? null : null,
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
                          validator: (val) => val!.length < 6 ? null : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 40),

                        // Register button with primary color
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
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                              if(result == null)
                                {
                                  setState(() => error = 'Please supply a valid email');
                                }
                              print("Registering with $email and password");
                            }
                          },
                          child: Text("Register", style: TextStyle(fontSize: 18)), // Larger text for better readability
                        ),
                        SizedBox(height: 12.0,),
                        Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0),)
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
