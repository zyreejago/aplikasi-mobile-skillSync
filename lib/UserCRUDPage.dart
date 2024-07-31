// ignore_for_file: unused_local_variable, file_names, library_private_types_in_public_api, avoid_print, deprecated_member_use, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCRUDPage extends StatefulWidget {
  const UserCRUDPage({super.key});

  @override
  _UserCRUDPageState createState() => _UserCRUDPageState();
}

class _UserCRUDPageState extends State<UserCRUDPage> {
  final CollectionReference meetings =
      FirebaseFirestore.instance.collection('meetings');

  final List<Map<String, dynamic>> zoomLinks = [];
  final TextEditingController _zoomLinkController = TextEditingController();
  final TextEditingController _meetingTitleController = TextEditingController();

  @override
  void dispose() {
    _zoomLinkController.dispose();
    _meetingTitleController.dispose();
    super.dispose();
  }

  void _addZoomLink(String meetingTitle) {
    if (_zoomLinkController.text.isNotEmpty) {
      meetings.add({
        'title': meetingTitle,
        'link': _zoomLinkController.text,
        'platform': 'Zoom',
      }).then((value) {
        setState(() {
          zoomLinks.insert(0, {
            'id': value.id,
            'title': meetingTitle,
            'link': _zoomLinkController.text,
            'platform': 'Zoom',
          });
          _zoomLinkController.clear();
          _meetingTitleController.clear();
        });
      }).catchError((error) {
        print('Error adding zoom link: $error');
      });
    }
  }

  void _editZoomLink(String docId, String currentTitle, String currentLink,
      String currentPlatform) {
    _zoomLinkController.text = currentLink;
    _meetingTitleController.text = currentTitle;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _zoomLinkController,
              decoration: const InputDecoration(hintText: 'Masukkan Link'),
            ),
            TextField(
              controller: _meetingTitleController,
              decoration: const InputDecoration(
                hintText: 'Masukkan Judul Pertemuan',
                labelText: 'Judul Pertemuan',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              meetings.doc(docId).update({
                'title': _meetingTitleController.text,
                'link': _zoomLinkController.text,
                'platform': 'Zoom',
              }).then((value) {
                _zoomLinkController.clear();
                _meetingTitleController.clear();
                Navigator.pop(context); // Close dialog
              }).catchError((error) {
                print('Error updating zoom link: $error');
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteZoomLink(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Link Pertemuan'),
        content: const Text('Apakah Anda yakin ingin menghapus link ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog konfirmasi hapus
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              meetings.doc(docId).delete().then((value) {
                setState(() {
                  zoomLinks.removeWhere((element) => element['id'] == docId);
                });
                Navigator.pop(context); // Tutup dialog konfirmasi hapus
              }).catchError((error) {
                print('Error deleting zoom link: $error');
              });
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _launchMeetingLink(String link) async {
    try {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
    } catch (e) {
      print('Error launching zoom link: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Gagal membuka tautan Zoom.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertemuan Virtual'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.video_call,
                          color: Colors.orange, size: 40),
                      title: const Text('Buat Pertemuan Baru',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      subtitle: const Text(
                          'Buat pertemuan virtual baru dengan anggota komunitas.'),
                      onTap: () {
                        _showAddLinkDialog();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.list_alt, color: Colors.orange, size: 40),
                      title: const Text('Daftar Pertemuan',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      subtitle:
                          const Text('Lihat daftar pertemuan yang telah dibuat.'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingList(
                                zoomLinks,
                                _editZoomLink,
                                _deleteZoomLink,
                                _launchMeetingLink),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLinkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Link Pertemuan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _zoomLinkController,
              decoration: const InputDecoration(hintText: 'Masukkan Link'),
            ),
            TextField(
              controller: _meetingTitleController,
              decoration: const InputDecoration(
                hintText: 'Masukkan Judul Pertemuan',
                labelText: 'Judul Pertemuan',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addZoomLink(_meetingTitleController.text);
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}

class MeetingList extends StatelessWidget {
  final List<Map<String, dynamic>> zoomLinks;
  final Function(String, String, String, String) editZoomLink;
  final Function(String) deleteZoomLink;
  final Function(String) launchMeetingLink;

  MeetingList(this.zoomLinks, this.editZoomLink, this.deleteZoomLink,
      this.launchMeetingLink, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pertemuan'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: zoomLinks.length,
        itemBuilder: (context, index) {
          String docId = zoomLinks[index]['id'];
          String link = zoomLinks[index]['link'];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.video_call, color: Colors.orange, size: 40),
              title: Text(
                zoomLinks[index]['title'],
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(link),
              onTap: () {
                launchMeetingLink(link);
              },
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
