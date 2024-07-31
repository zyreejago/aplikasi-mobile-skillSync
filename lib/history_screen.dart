// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:rezzy_pemob/MentorHistory.dart';
import 'screen3.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final mentorHistory = MentorHistory().mentorHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Mentor'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus semua riwayat mentor?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Ya'),
                        onPressed: () {
                          MentorHistory().resetMentorHistory();
                          setState(() {}); // Memperbarui state setelah reset
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: mentorHistory.length,
        itemBuilder: (context, index) {
          final mentor = mentorHistory[index];
          return MentorCard(
            mentor: mentor,
            onMessagePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Screen3(
                    mentorName: mentor['name']!,
                    mentorImageUrl: mentor['imageUrl']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MentorCard extends StatelessWidget {
  final Map<String, String> mentor;
  final VoidCallback? onMessagePressed;

  const MentorCard({super.key, 
    required this.mentor,
    this.onMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(mentor['imageUrl']!),
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                mentor['name']!,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                mentor['description']!,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: onMessagePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
