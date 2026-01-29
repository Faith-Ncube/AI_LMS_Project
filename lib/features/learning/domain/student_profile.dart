class StudentProfile {
  final String id;
  final String name;

  // Preferences
  final String preferredDifficulty; // easy, medium, hard
  final int dailyStudyMinutes;

  // Performance
  final Map<String, double> topicScores; // topicId → score %

  StudentProfile({
    required this.id,
    required this.name,
    required this.preferredDifficulty,
    required this.dailyStudyMinutes,
    required this.topicScores,
  });
}
