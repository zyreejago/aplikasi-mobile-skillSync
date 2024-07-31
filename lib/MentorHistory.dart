// ignore_for_file: file_names

class MentorHistory {
  // Singleton pattern
  static final MentorHistory _instance = MentorHistory._internal();

  factory MentorHistory() {
    return _instance;
  }

  MentorHistory._internal();

  final List<Map<String, String>> _mentorHistory = [];

  List<Map<String, String>> get mentorHistory => _mentorHistory;

  void addMentor(Map<String, String> mentor) {
    _mentorHistory.add(mentor);
  }

  void resetMentorHistory() {
    _mentorHistory.clear();
  }

  void removeMentor(String mentorName) {
    _mentorHistory.removeWhere((mentor) => mentor['name'] == mentorName);
  }
}
