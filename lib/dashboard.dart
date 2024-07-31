// ignore_for_file: unnecessary_import, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rezzy_pemob/UserKomunitas.dart';
import 'package:rezzy_pemob/keterampilan1.dart';
import 'package:rezzy_pemob/login.dart';
import 'package:rezzy_pemob/screen1User.dart';
// Impor halaman login yang akan dituju setelah logout
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String username = "Loading...";
  String userDescription = "Pelajar";

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginPage()), // Ganti LoginPage dengan halaman login yang sesuai
      (route) =>
          false, // Hapus semua rute kecuali halaman login dari tumpukan rute
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/user_avatar.png'), // Ganti dengan path gambar yang sesuai
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  userDescription,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Spacer(), // Spacer untuk mengatur jarak antara elemen di AppBar
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _signOut(); // Panggil fungsi logout saat tombol logout ditekan
              },
            ),
          ],
        ),
        backgroundColor: Colors.orange, // Mengatur warna navbar menjadi orange
      ),
      backgroundColor:
          const Color(0xFFFBE9E7), // Mengatur warna latar belakang menjadi #FBE9E7
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ListView(
          children: [
            buildFeatureCard(
                Icons.home, 'Mencari mentor', context, const Screen1User()),
            const SizedBox(height: 20),
            buildFeatureCard(Icons.search, 'Pelatihan Keterampilan', context,
                const keterampilan1()),
            const SizedBox(height: 20),
            buildFeatureCard(Icons.notifications, 'Komunitas Belajar', context,
                Userkomunitas()),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.orange, // Mengatur warna bottom bar menjadi orange
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }

  Widget buildFeatureCard(
      IconData icon, String label, BuildContext context, Widget nextPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        elevation: 3,
        color: Colors.orange[100], // Mengatur warna shape menjadi #FFE0B2
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
