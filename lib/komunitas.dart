// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:rezzy_pemob/CRUDPage.dart';
import 'dart:ui';
import 'package:rezzy_pemob/dashboard.dart';

class Komunitas extends StatelessWidget {
  // Daftar menu tambahan
  final List<String> additionalMenu = ['Diskusi', 'Pertemuan Virtual'];

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
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.account_circle), // Ubah ikon ke profil
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
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
          Expanded(
            child: ListView.builder(
              itemCount: additionalMenu.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      additionalMenu[index],
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.orange),
                    onTap: () {
                      if (additionalMenu[index] == 'Pertemuan Virtual') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CRUDPage()),
                        );
                      } else {
                        print('Menu ${additionalMenu[index]} dipilih');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
