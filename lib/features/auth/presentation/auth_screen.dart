import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '/screens/teacher_dashboard.dart';
import '/screens/student_dashboard.dart';



class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isStudent = true;
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.school, size: 60, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'EduAI',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              // Student / Teacher Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Student'),
                    selected: isStudent,
                    onSelected: (_) {
                      setState(() => isStudent = true);
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text('Teacher'),
                    selected: !isStudent,
                    onSelected: (_) {
                      setState(() => isStudent = false);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              TextField(controller: _emailController,
  decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
               controller: _passwordController,
  decoration: const InputDecoration(labelText: 'Password'),
  obscureText: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
onPressed: _loading
    ? null
    : () async {
        if (_emailController.text.trim().isEmpty ||
            _passwordController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email and password required')),
          );
          return;
        }

        setState(() => _loading = true);

        try {
          if (isLogin) {
            await _authService.login(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
          } else {
            await _authService.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              role: isStudent ? 'student' : 'teacher',
            );
          }
          final role =
    await _authService.getUserRole(_emailController.text.trim());

if (!mounted) return;

if (role == 'teacher') {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const TeacherDashboardScreen(),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const StudentDashboardScreen(),
    ),
  );
}

          
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        } finally {
          setState(() => _loading = false);
        }
      },


  child: _loading
      ? const CircularProgressIndicator(color: Colors.white)
      : Text(isLogin ? 'Log In' : 'Sign Up'),
),

              ),

              TextButton(
  onPressed: () {
    setState(() => isLogin = !isLogin);
  },
  child: Text(
    isLogin
        ? "Don't have an account? Sign Up"
        : "Already have an account? Log In",
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
