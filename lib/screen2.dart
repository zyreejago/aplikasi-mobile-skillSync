// ignore_for_file: prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rezzy_pemob/MentorHistory.dart';
import 'package:rezzy_pemob/screen3.dart';
import 'package:rezzy_pemob/history_screen.dart';

class Screen2 extends StatelessWidget {
  final String mentorName;
  final String mentorDescription;
  final String mentorImageUrl;
  final String mentorEducation;
  final String mentorMajor;
  final String mentorUniversity;
  final String mentorExpertise;

  Screen2({super.key, 
    required this.mentorName,
    required this.mentorDescription,
    required this.mentorImageUrl,
    required this.mentorEducation,
    required this.mentorMajor,
    required this.mentorUniversity,
    required this.mentorExpertise,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mentorName), // Ganti judul dengan nama mentor
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(mentorImageUrl),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    mentorName,
                    style:
                        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    mentorDescription,
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Text(
                    'Pendidikan Terakhir: $mentorEducation',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Jurusan: $mentorMajor',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Universitas: $mentorUniversity',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Keahlian: $mentorExpertise',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                                'Apakah Anda yakin ingin memilih mentor ini?'),
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
                                  MentorHistory().addMentor({
                                    'name': mentorName,
                                    'description': mentorDescription,
                                    'imageUrl': mentorImageUrl,
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Screen3(
                                        mentorName: mentorName,
                                        mentorImageUrl: mentorImageUrl,
                                      ),
                                    ),
                                  );

                                  // Tampilkan notifikasi bahwa mentor berhasil dipilih
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Berhasil menjadikan $mentorName sebagai mentor.'),
                                    ),
                                  );

                                  Navigator.of(context)
                                      .pop(); // Tutup dialog konfirmasi
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.orange.withOpacity(0.5)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Pilih Mentor',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
