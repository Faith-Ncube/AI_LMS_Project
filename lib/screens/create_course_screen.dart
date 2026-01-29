import 'package:flutter/material.dart';
import 'dart:math';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String courseKey = '';

  // Mock local storage
  final List<Map<String, String>> _myCourses = [];

  @override
  void initState() {
    super.initState();
    _generateCourseKey();
  }

  void _generateCourseKey() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final random = Random();

    String key = '';
    for (int i = 0; i < 2; i++) {
      key += letters[random.nextInt(letters.length)];
    }
    for (int i = 0; i < 3; i++) {
      key += numbers[random.nextInt(numbers.length)];
    }
    setState(() {
      courseKey = key;
    });
  }

  void _createCourse() {
    if (_formKey.currentState!.validate()) {
      final newCourse = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'key': courseKey,
        'students': '0', // initial student count
      };
      // Return the new course to previous screen
    Navigator.pop(context, newCourse);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course created successfully!')),
    );

      setState(() {
        _myCourses.add(newCourse);
        _titleController.clear();
        _descriptionController.clear();
        _generateCourseKey(); // new code for next course
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Course Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter course description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Course Key',
                        border: const OutlineInputBorder(),
                        hintText: courseKey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _createCourse,
                      child: const Text('Create Course'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'My Courses (Local State)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._myCourses.map((course) => Card(
                    child: ListTile(
                      title: Text(course['title']!),
                      subtitle: Text(
                          '${course['description']!}\nCode: ${course['code']}'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
