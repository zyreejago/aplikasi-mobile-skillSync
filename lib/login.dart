// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rezzy_pemob/ResetPassword.dart';
import 'package:rezzy_pemob/dashboardAdmin.dart';
import 'package:rezzy_pemob/register.dart';
import 'dashboard.dart';
import 'mentordashboard.dart'; // Import halaman chat mentor

// Import yang diperlukan dan code sebelumnya

class LoginPage extends StatelessWidget {
  final TextEditingController _emailOrUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: const Color(0xFFFBE9E7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailOrUsernameController,
                decoration: const InputDecoration(
                  labelText: 'Email or Username',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String emailOrUsername =
                        _emailOrUsernameController.text.trim();
                    String password = _passwordController.text.trim();
                    UserCredential userCredential;

                    if (emailOrUsername.isEmpty || password.isEmpty) {
                      throw 'Please fill all fields';
                    }

                    if (emailOrUsername.contains('@')) {
                      userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailOrUsername,
                        password: password,
                      );
                    } else {
                      throw 'Username login not implemented';
                    }

                    // Ambil peran pengguna dari Firestore
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user?.uid)
                        .get();

                    if (userDoc.exists) {
                      String role = userDoc['role'];

                      // Navigasi berdasarkan peran pengguna
                      if (role == 'admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboardadmin()),
                        );
                      } else if (role == 'mentor') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MentorChatPage(
                                    mentorName: 'NamaMentor',
                                  )),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardApp()),
                        );
                      }
                    } else {
                      throw 'User data not found';
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('$e'),
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()),
                  );
                },
                child: const Text(
                  "Lupa password?",
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  "Belum punya akun? Daftar di sini",
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
