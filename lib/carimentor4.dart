// ignore_for_file: camel_case_types, sort_child_properties_last

import 'package:flutter/material.dart';

class carimentor4 extends StatelessWidget {
  const carimentor4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('carimentor4'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Isi chat dengan mentor',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20), // Spacer
            ElevatedButton(
              onPressed: () {
                // Ketika tombol ditekan, navigasi ke carimentor4 dilakukan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const carimentor4()),
                );
              },
              child: const Text('Berhenti Mengikuti'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
