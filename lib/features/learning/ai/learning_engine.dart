import 'dart:math';

/// This is a MOCK AI engine.
/// It simulates how personalization and adaptive learning will work
/// before connecting to real ML/LLM services.

class LearningEngine {
  /// Generate personalized learning pathway
  List<LearningRecommendation> generatePathway({
    required double currentProgress,
    required List<String> completedTopics,
  }) {
    final recommendations = <LearningRecommendation>[];

    if (currentProgress < 0.4) {
      recommendations.add(
        LearningRecommendation(
          title: 'Fundamentals of Programming',
          reason: 'You need stronger foundations',
          difficulty: 'Beginner',
        ),
      );
    }

    if (!completedTopics.contains('AI Basics')) {
      recommendations.add(
        LearningRecommendation(
          title: 'Introduction to AI',
          reason: 'Recommended based on your interests',
          difficulty: 'Intermediate',
        ),
      );
    }

    recommendations.add(
      LearningRecommendation(
        title: 'Practice Quiz',
        reason: 'AI suggests revision for better retention',
        difficulty: 'Adaptive',
      ),
    );

    return recommendations;
  }

  /// Generate real-time feedback (mock)
  String generateFeedback(double score) {
    if (score >= 0.8) {
      return 'Excellent performance! You are ready for advanced content.';
    } else if (score >= 0.5) {
      return 'Good effort. AI suggests reviewing weak areas.';
    } else {
      return 'AI recommends revisiting fundamentals before proceeding.';
    }
  }

  /// Simulate AI analytics
  double predictNextPerformance(double currentScore) {
    final random = Random();
    return (currentScore + random.nextDouble() * 0.1).clamp(0.0, 1.0);
  }
}

class LearningRecommendation {
  final String title;
  final String reason;
  final String difficulty;

  LearningRecommendation({
    required this.title,
    required this.reason,
    required this.difficulty,
  });
}
