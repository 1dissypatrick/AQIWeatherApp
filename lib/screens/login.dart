import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/services/auth_service.dart';
import '/services/firestore_service.dart';
import '/screens/home_screen.dart';
import '/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Air quality icon
                Icon(
                  Icons.air, // You can choose a different icon
                  size: 24,
                  color: Colors.green, // Change color as needed
                ),
                const SizedBox(width: 8), // Spacing between icon and text
                Text(
                  'Air Quality Monitoring',
                  style: TextStyle(
                    fontSize: 24, // Increased font size
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // Change color as needed
                  ),
                ),
                const SizedBox(width: 8), // Additional spacing
                // Additional decorative icon
                Icon(
                  Icons.cloud, // You can choose a different icon
                  size: 24,
                  color: Colors.blue, // Change color as needed
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/55.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      setState(() {
                        _errorMessage = "Attempting to log in...";
                      });

                      User? user = await _auth.signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (user != null) {
                        setState(() {
                          _errorMessage = "Login successful: ${user.email}";
                        });

                        // Optionally get user data from Firestore
                        DocumentSnapshot userData = await _firestoreService.getUser(user.uid);
                        print("User data: ${userData.data()}");

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login Successful!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        setState(() {
                          _errorMessage = "Login failed: No user returned";
                        });
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = "Login failed: $e";
                      });
                    }
                  },
                  icon: Icon(Icons.login, size: 24),
                  label: Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInAnonymously();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } catch (e) {
                      setState(() {
                        _errorMessage = "Guest login failed: $e";
                      });
                    }
                  },
                  icon: Icon(Icons.person_outline, size: 24),
                  label: Text(
                    'Guest',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    " Sign up",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
