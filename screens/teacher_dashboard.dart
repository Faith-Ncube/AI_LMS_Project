import 'package:flutter/material.dart';
import '/screens/create_course_screen.dart';
import '/screens/course_management_screen.dart';



class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  // Mock data (will come from backend later)
  final List<Map<String, dynamic>> courses = [
    {
      'title': 'AI Fundamentals',
      'key': 'DF101',
      'students': 40,
    },
    {
      'title': 'Data Structures',
      'key': 'CS202',
      'students': 55,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: logout logic
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final newCourse = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCourseScreen(),
      ),
    );

    if (newCourse != null) {
      setState(() {
        courses.add(newCourse);
      });
    }
  },
  child: const Icon(Icons.add),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            const Text(
              'My Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...courses.map(_buildCourseCard).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            CircleAvatar(
              radius: 28,
              child: Icon(Icons.school, size: 30),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Teacher 👋',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Manage your courses and content'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: const [
        _StatCard(
          label: 'Courses',
          value: '2',
          icon: Icons.menu_book,
        ),
        SizedBox(width: 12),
        _StatCard(
          label: 'Students',
          value: '95',
          icon: Icons.people_outline,
        ),
      ],
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'],
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Course Key: ${course['key']}'),
            const SizedBox(height: 4),
            Text('Students: ${course['students']}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               _CourseActionButton(
  icon: Icons.settings,
  label: 'Manage',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseManagementScreen(course: course),
      ),
    );
  },
),

                _CourseActionButton(
                  icon: Icons.upload_file,
                  label: 'Content',
                  onTap: () {},
                ),
                _CourseActionButton(
                  icon: Icons.analytics_outlined,
                  label: 'Analytics',
                  onTap: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
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
              Icon(icon, size: 30),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CourseActionButton({
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
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
