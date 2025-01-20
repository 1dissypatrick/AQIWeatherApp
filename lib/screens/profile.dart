import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/views/gradient_container.dart';
import '/constants/text_styles.dart';
import '/screens/login.dart';
import '/screens/edit_profile.dart'; // Import the EditProfileScreen
import '/screens/feedback_screen.dart'; // Import the FeedbackScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      if (currentUser.isAnonymous) {
        setState(() {
          user = currentUser;
          userData = {'email': 'Guest'};
        });
      } else {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        setState(() {
          user = currentUser;
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      children: [
        // Page Title
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Profile',
            style: TextStyles.h1,
          ),
        ),

        const SizedBox(height: 20),

        // Profile Picture
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/icons/profile_placeholder.png'),
          ),
        ),

        const SizedBox(height: 10),

        // User Information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  userData?['email'] ?? 'Loading...',
                  style: TextStyles.h2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Edit Profile Button
        Center(
          child: SizedBox(
            width: 200, // Set a consistent width
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Sign Out Button
        Center(
          child: SizedBox(
            width: 200, // Set a consistent width
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text('Sign Out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Feedback Button
        Center(
          child: SizedBox(
            width: 200, // Set a consistent width
            child: ElevatedButton.icon(
              icon: Icon(Icons.feedback),
              label: Text('Feedback'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen(user: user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
