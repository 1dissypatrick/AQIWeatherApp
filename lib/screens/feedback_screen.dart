import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants/text_styles.dart';
import '/views/gradient_container.dart';

class FeedbackScreen extends StatefulWidget {
  final User? user;

  FeedbackScreen({super.key, this.user});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _reportController = TextEditingController();

  void _sendReport() async {
    if (_reportController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('reports').add({
        'userId': widget.user?.uid,
        'email': widget.user?.email,
        'report': _reportController.text,
        'timestamp': Timestamp.now(),
      });
      _reportController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: GradientContainer(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Feedback',
              style: TextStyles.h1,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _reportController,
                  maxLines: 5,
                  maxLength: 5000,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your feedback here...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _reportController.clear();
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _sendReport,
                      child: Text('Send'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
