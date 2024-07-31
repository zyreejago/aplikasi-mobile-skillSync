// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentorChatPage extends StatefulWidget {
  final String mentorName; // Parameter mentorName diperlukan

  const MentorChatPage(
      {super.key, required this.mentorName}); // Constructor dengan parameter wajib

  @override
  _MentorChatPageState createState() => _MentorChatPageState();
}

class _MentorChatPageState extends State<MentorChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late CollectionReference<Map<String, dynamic>> _chatsCollection;

  @override
  void initState() {
    super.initState();
    _chatsCollection = FirebaseFirestore.instance
        .collection('mentors')
        .doc(widget.mentorName) // Gunakan widget.mentorName di sini
        .collection('chats');
  }

  void _sendMessage(String messageText) {
    _chatsCollection.add({
      'text': messageText,
      'createdAt': Timestamp.now(),
      'sender': 'mentor', // Menandai sender sebagai mentor
    }).then((value) {
      print("Message sent successfully!");
      _messageController.clear();
    }).catchError((error) {
      print("Failed to send message: $error");
    });
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
            Navigator.pop(context); // Kembali ke layar sebelumnya
          },
        ),
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

                    // Tentukan apakah pesan dari mentor atau pelanggan
                    bool isOwnMessage = data['sender'] == 'mentor';

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
                            color: isOwnMessage
                                ? Colors.orange // Warna pesan mentor
                                : Colors.blue, // Warna pesan pelanggan
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isOwnMessage ? 'You' : widget.mentorName,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                data['text'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isOwnMessage
                                      ? Colors.white // Warna teks pesan mentor
                                      : Colors
                                          .black, // Warna teks pesan pelanggan
                                ),
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
