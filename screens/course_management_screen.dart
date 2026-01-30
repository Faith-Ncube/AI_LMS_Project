import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class CourseManagementScreen extends StatefulWidget {
  final Map<String, dynamic> course;


  const CourseManagementScreen({super.key, required this.course});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<File> uploadedMaterials = [];

Future<void> _pickPdf() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    setState(() {
      uploadedMaterials.add(File(result.files.single.path!));
    });
  }
}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course['title']),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Content'),
            Tab(text: 'Students'),
            Tab(text: 'AI Setup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildContentTab(),
          _buildStudentsTab(),
          _buildAISetupTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoTile('Course Title', widget.course['title']),
          _infoTile('Course Key', widget.course['key']),
          _infoTile('Students Enrolled', widget.course['students'].toString()),
          const SizedBox(height: 24),
          const Text(
            'Course Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This course content will be used by the AI tutor to personalize learning experiences for enrolled students.',
          ),
        ],
      ),
    );
  }

 Widget _buildContentTab() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _pickPdf,
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload PDF Material'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Uploaded Materials',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: uploadedMaterials.isEmpty
              ? const Center(
                  child: Text('No materials uploaded yet'),
                )
              : ListView.builder(
                  itemCount: uploadedMaterials.length,
                  itemBuilder: (context, index) {
                    final file = uploadedMaterials[index];
                    return ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text(file.path.split('/').last),
                      subtitle: const Text('Stored locally'),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}


  Widget _buildStudentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Student A'),
          subtitle: Text('Progress: 60%'),
        ),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Student B'),
          subtitle: Text('Progress: 30%'),
        ),
      ],
    );
  }

  Widget _buildAISetupTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI Teaching Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: const Text('Use uploaded content for tutoring'),
          ),
          const SizedBox(height: 8),
          const Text('Adaptation Level'),
          DropdownButtonFormField(
            items: const [
              DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
              DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
              DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
            ],
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
