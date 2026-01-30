import 'package:flutter/material.dart';

class CourseContentScreen extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseContentScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  final List<Map<String, String>> materials = [];

  void _addMockMaterial() {
    setState(() {
      materials.add({
        'title': 'Lecture ${materials.length + 1}',
        'type': 'PDF',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course['title']} Content'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMockMaterial,
        child: const Icon(Icons.upload_file),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: materials.isEmpty
            ? const Center(
                child: Text('No content uploaded yet'),
              )
            : ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  final item = materials[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(item['title']!),
                      subtitle: Text(item['type']!),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
