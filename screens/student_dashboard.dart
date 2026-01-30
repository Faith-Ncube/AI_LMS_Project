import 'package:flutter/material.dart';
import '/features/learning/ai/learning_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/features/auth/presentation/auth_screen.dart';
import '/screens/student_analytics_screen.dart';
import '/features/storage/local/progress_repository.dart';
import '/features/storage/sync/sync_service.dart';
import '/services/ai_service.dart';
import '/data/activity_repository.dart';


class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  bool isOffline = false; // simulated for now
  final LearningEngine _learningEngine = LearningEngine();
  final ProgressRepository _repo = ProgressRepository();
  final SyncService _syncService = SyncService();
  late List<LearningRecommendation> recommendations;

 Future<void> _logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const AuthScreen()),
    (route) => false,
  );
}
 

  double progress = 0.35;

  @override
  void initState() {
    super.initState();

    // MOCK AI DATA
    recommendations = _learningEngine.generatePathway(
      currentProgress: progress,
      completedTopics: ['Variables', 'Loops'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text('Student Dashboard'),
  actions: [
    ElevatedButton(
  onPressed: () async {
    try {
      final result = await AIService.getFeedback(0.8);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['feedback'])),  
      );
      await ActivityRepository.saveActivity(0.6,
      result['feedback'],
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("AI connection failed")),
      );
    }
  },
  child: const Text("Get AI Feedback"),
),

    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings coming soon')),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => _logout(context),
    ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card repalced with profile card
            Card(
  elevation: 3,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 30,
          child: Icon(Icons.person, size: 34),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Faith Ncube',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text('Role: Student'),
            ],
          ),
        ),
        Column(
          children: [
            Icon(
              isOffline ? Icons.cloud_off : Icons.cloud_done,
              color: isOffline ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 4),
            Text(
              isOffline ? 'Offline' : 'Online',
              style: TextStyle(
                fontSize: 12,
                color: isOffline ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),


            const SizedBox(height: 24),

            // Progress Section
      
            const Text(
              'Your Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _ProgressCard(
                  title: 'Courses',
                  value: '3',
                  icon: Icons.menu_book,
                ),
                const SizedBox(width: 12),
                _ProgressCard(
                  title: 'Completed',
                  value: '${(progress * 100).toInt()}%',
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 24),
            // AI Recommendations
        
            const Text(
              'Recommended for You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...recommendations.map(
              (rec) => Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(rec.reason),
                      const SizedBox(height: 6),
                      Chip(label: Text(rec.difficulty)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
          
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.play_arrow,
                  label: 'Continue Lesson',
                  onTap: () {
                    final feedback =
                        _learningEngine.generateFeedback(progress);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(feedback)),
                    );
                  },
                ),
                _ActionButton(
  icon: Icons.save,
  label: 'Save Offline',
  onTap: () async {
    await _repo.saveProgressOffline(
      course: 'Introduction to AI',
      progress: 0.6,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress saved offline')),
    );
  },
),
_ActionButton(
  icon: Icons.sync,
  label: 'Sync',
  onTap: () async {
    await _syncService.syncIfOnline();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync complete')),
    );
  },
),


                _ActionButton(
                  icon: Icons.assignment,
                  label: 'Assessments',
                  onTap: () {},
                ),
                _ActionButton(
  icon: Icons.analytics_outlined,
  label: 'Analytics',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StudentAnalyticsScreen(),
      ),
    );
  },
),
                _ActionButton(
  icon: Icons.offline_bolt,
  label: 'Offline Content',
  onTap: () {
    setState(() {
      isOffline = !isOffline;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isOffline
              ? 'Switched to Offline Mode'
              : 'Back Online',
        ),
      ),
    );
  },
),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

//REUSABLE UI WIDGETS

class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
