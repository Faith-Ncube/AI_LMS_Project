import 'package:flutter/material.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/sync_service.dart';



void main() async {
  SyncService.start();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EduAIApp());
}


class EduAIApp extends StatelessWidget {
  const EduAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduAI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to EduAI',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
