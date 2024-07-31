// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screen2.dart';
import 'history_screen.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  CollectionReference mentors =
      FirebaseFirestore.instance.collection('mentors');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // Icon untuk menuju ke HistoryScreen
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
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
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showMentorDialog(
                          context,
                          document.id,
                          data['name'],
                          data['description'],
                          data['imageUrl'],
                          data['education'],
                          data['major'],
                          data['university'],
                          data['expertise'],
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteMentor(document.id);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMentorDialog(
            context,
            null,
            '',
            '',
            '',
            '',
            '',
            '',
            '',
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void addMentor(
    String name,
    String description,
    String imageUrl,
    String education,
    String major,
    String university,
    String expertise,
  ) {
    mentors.add({
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'education': education,
      'major': major,
      'university': university,
      'expertise': expertise,
    });
  }

  void deleteMentor(String id) {
    mentors.doc(id).delete();
  }

  void updateMentor(
    String id,
    String name,
    String description,
    String imageUrl,
    String education,
    String major,
    String university,
    String expertise,
  ) {
    mentors.doc(id).update({
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'education': education,
      'major': major,
      'university': university,
      'expertise': expertise,
    });
  }

  void _showMentorDialog(
    BuildContext context,
    String? id,
    String name,
    String description,
    String imageUrl,
    String education,
    String major,
    String university,
    String expertise,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nameValue = name;
        String descriptionValue = description;
        String imageUrlValue = imageUrl;
        String educationValue = education;
        String majorValue = major;
        String universityValue = university;
        String expertiseValue = expertise;

        return AlertDialog(
          title: Text(id == null ? 'Tambah Mentor' : 'Edit Mentor'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    nameValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Nama Mentor'),
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  onChanged: (value) {
                    descriptionValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Deskripsi Mentor'),
                  controller: TextEditingController(text: description),
                ),
                TextField(
                  onChanged: (value) {
                    imageUrlValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'URL Foto Mentor'),
                  controller: TextEditingController(text: imageUrl),
                ),
                TextField(
                  onChanged: (value) {
                    educationValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Pendidikan Terakhir'),
                  controller: TextEditingController(text: education),
                ),
                TextField(
                  onChanged: (value) {
                    majorValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Jurusan'),
                  controller: TextEditingController(text: major),
                ),
                TextField(
                  onChanged: (value) {
                    universityValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Universitas'),
                  controller: TextEditingController(text: university),
                ),
                TextField(
                  onChanged: (value) {
                    expertiseValue = value;
                  },
                  decoration: const InputDecoration(labelText: 'Keahlian'),
                  controller: TextEditingController(text: expertise),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (id == null) {
                  addMentor(
                    nameValue,
                    descriptionValue,
                    imageUrlValue,
                    educationValue,
                    majorValue,
                    universityValue,
                    expertiseValue,
                  );
                } else {
                  updateMentor(
                    id,
                    nameValue,
                    descriptionValue,
                    imageUrlValue,
                    educationValue,
                    majorValue,
                    universityValue,
                    expertiseValue,
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
