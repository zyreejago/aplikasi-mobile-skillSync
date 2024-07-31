// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen2.dart';
import 'history_screen.dart';

class Screen1User extends StatefulWidget {
  const Screen1User({super.key});

  @override
  _Screen1UserState createState() => _Screen1UserState();
}

class _Screen1UserState extends State<Screen1User> {
  CollectionReference mentors =
      FirebaseFirestore.instance.collection('mentors');
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        username = userDoc['username'] ?? 'Unknown User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: mentors.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['imageUrl']),
                  radius: 30,
                ),
                title: Text(data['name']),
                subtitle: Text(data['description']),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Screen2(
                          mentorName: data['name'],
                          mentorDescription: data['description'],
                          mentorImageUrl: data['imageUrl'],
                          mentorEducation: data['education'],
                          mentorMajor: data['major'],
                          mentorUniversity: data['university'],
                          mentorExpertise: data['expertise'],
                        ),
                      ),
                    );
                  },
                  child: const Text('Cek'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
