// ignore_for_file: unused_import, duplicate_import, unnecessary_import, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import untuk StatusBarColor
import 'dart:ui';
import 'package:rezzy_pemob/dashboard.dart';
import 'package:rezzy_pemob/keterampilan1.dart';
import 'package:rezzy_pemob/keterampilan2.dart';
import 'package:rezzy_pemob/komunitas.dart';
import 'package:rezzy_pemob/screen1.dart'; // Impor Screen1 dari file screen1.dart
import 'package:rezzy_pemob/screen2.dart';
import 'package:rezzy_pemob/screen3.dart'; // Impor Screen2 dari file screen2.dart

import 'package:rezzy_pemob/dashboard.dart';
import 'package:rezzy_pemob/keterampilan2.dart'; // Impor untuk ImageFilter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: keterampilan1(),
    );
  }
}

class keterampilan1 extends StatelessWidget {
  const keterampilan1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: AppBar(
            title: const Text(
              'Budi Antara',
              style: TextStyle(fontSize: 18.0),
            ),
            leading: IconButton(
              icon: const Icon(Icons.account_circle), // Ubah ikon ke profil
              onPressed: () {
                // Tindakan ketika tombol profil ditekan
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardApp()),
                  );
                  // Tindakan ketika tombol menu ditekan
                },
              ),
            ],
            backgroundColor: Colors.orange,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent, // Latar belakang transparan
                child: Container(
                  color: Colors.orange.withOpacity(
                      0.5), // Warna latar belakang dengan efek blur
                  padding: const EdgeInsets.all(20.0),
                  child: const Text(
                    'Pelatihan Keterampilan',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Jumlah mentor
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title:
                      Text('Keterampilan ${index + 1}'), // Nama mentor dinamis
                  subtitle: const Text('Deskripsi Keterampilan'), // Deskripsi mentor
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Tindakan ketika tombol "Cek" ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => keterampilan2()),
                      );
                    },
                    child: const Text('Lihat'),
                  ),
                  onTap: () {
                    // Tindakan ketika mentor dipilih
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
