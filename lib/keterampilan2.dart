// ignore_for_file: unused_import, unnecessary_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

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

// ignore: camel_case_types
class keterampilan2 extends StatelessWidget {
  // Daftar kasus latihan
  final List<Map<String, String>> cases = [
    {
      'title': 'Kasus 1',
      'description': 'Deskripsi kasus 1',
    },
    {
      'title': 'Kasus 2',
      'description': 'Deskripsi kasus 2',
    },
    // Tambahkan lebih banyak kasus jika diperlukan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kasus Latihan'),
      ),
      body: ListView.builder(
        itemCount: cases.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(cases[index]['title']!),
            subtitle: Text(cases[index]['description']!),
            onTap: () {
              // Tindakan ketika kasus dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    title: cases[index]['title']!,
                    description: cases[index]['description']!,
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

class DetailScreen extends StatelessWidget {
  final String title;
  final String description;

  DetailScreen({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }
}
