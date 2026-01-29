import '../domain/student_profile.dart';
import '../domain/lesson.dart';

class LearningPathEngine {
  Lesson recommendNextLesson({
    required StudentProfile student,
    required List<Lesson> availableLessons,
  }) {
    // 1. Find weakest topic
    final weakestTopic = student.topicScores.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    // 2. Filter lessons by weakest topic
    final topicLessons = availableLessons
        .where((l) => l.topicId == weakestTopic)
        .toList();

    // 3. Match difficulty
    final matchingDifficulty = topicLessons.where(
      (l) => l.difficulty == student.preferredDifficulty,
    );

    // 4. Fallback logic
    return matchingDifficulty.isNotEmpty
        ? matchingDifficulty.first
        : topicLessons.first;
  }
}
