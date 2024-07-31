// ignore_for_file: file_names

class Mentor {
  String name;
  String description;
  String imageUrl;
  String education;
  String major;
  String university;
  String expertise;

  Mentor({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.education,
    required this.major,
    required this.university,
    required this.expertise,
  });

  // Method to create a Mentor object from Firestore data
  factory Mentor.fromFirestore(Map<String, dynamic> data) {
    return Mentor(
      name: data['name'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      education: data['education'],
      major: data['major'],
      university: data['university'],
      expertise: data['expertise'],
    );
  }

  // Method to convert Mentor object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'education': education,
      'major': major,
      'university': university,
      'expertise': expertise,
    };
  }
}
