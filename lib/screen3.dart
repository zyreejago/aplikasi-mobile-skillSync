// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Screen3 extends StatefulWidget {
  final String mentorName;
  final String mentorImageUrl;

  Screen3({super.key, 
    required this.mentorName,
    required this.mentorImageUrl,
  });

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  final TextEditingController _messageController = TextEditingController();
  late CollectionReference<Map<String, dynamic>> _chatsCollection;

  @override
  void initState() {
    super.initState();
    _chatsCollection = FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.mentorName)
        .collection('chats');
  }

  void _sendMessage(String messageText) {
    _chatsCollection.add({
      'text': messageText,
      'createdAt': Timestamp.now(),
      'sender':
          'pengguna', // Simulasi sender, ganti sesuai dengan logika aplikasi
    }).then((value) {
      print("Message sent successfully!");
      _messageController.clear();
    }).catchError((error) {
      print("Failed to send message: $error");
    });
  }

  void _finishMentor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda yakin ingin menyelesaikan mentor ini?'),
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
                // Reset chat atau tambahkan logika sesuai kebutuhan Anda
                _messageController.clear();
                // Contoh logika untuk reset chat
                _chatsCollection.get().then((snapshot) {
                  for (DocumentSnapshot doc in snapshot.docs) {
                    doc.reference.delete();
                  }
                }).catchError((error) {
                  print("Failed to delete messages: $error");
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan ${widget.mentorName}'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke Screen sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              _finishMentor();
              // Tambahkan logika untuk menyelesaikan mentor di sini
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatsCollection.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        docs[index].data() as Map<String, dynamic>;

                    // Tentukan apakah pesan dari pengguna atau mentor
                    bool isOwnMessage = data['sender'] ==
                        'pengguna'; // Ganti dengan logika aplikasi

                    // Tampilkan waktu dalam format yang sesuai
                    DateTime createdAt = data['createdAt'].toDate();
                    String time = '${createdAt.hour}:${createdAt.minute}';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Align(
                        alignment: isOwnMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.orange, // Ubah warna menjadi oranye
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['text'],
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                time,
                                style: const TextStyle(
                                    fontSize: 12.0, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
