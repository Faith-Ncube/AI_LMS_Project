import 'package:flutter/material.dart';
import '/features/learning/ai/learning_engine.dart';

class StudentAnalyticsScreen extends StatefulWidget {
  const StudentAnalyticsScreen({super.key});

  @override
  State<StudentAnalyticsScreen> createState() =>
      _StudentAnalyticsScreenState();
}

class _StudentAnalyticsScreenState extends State<StudentAnalyticsScreen> {
  final LearningEngine _learningEngine = LearningEngine();

  double currentScore = 0.65;
  late double predictedScore;

  @override
  void initState() {
    super.initState();
    predictedScore = _learningEngine.predictNextPerformance(currentScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnalyticsCard(
              title: 'Current Performance',
              value: '${(currentScore * 100).toInt()}%',
              icon: Icons.trending_up,
            ),

            const SizedBox(height: 16),

            _AnalyticsCard(
              title: 'AI Predicted Performance',
              value: '${(predictedScore * 100).toInt()}%',
              icon: Icons.auto_graph,
            ),

            const SizedBox(height: 16),

            _AnalyticsCard(
              title: 'Engagement Level',
              value: 'High',
              icon: Icons.insights,
            ),

            const SizedBox(height: 24),

            const Text(
              'AI Insight',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  predictedScore > currentScore
                      ? 'AI predicts improvement based on your recent activity.'
                      : 'AI suggests more practice to improve performance.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
