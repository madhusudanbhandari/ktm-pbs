import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/auth_service.dart';
import 'package:flutter_application_1/screens/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../user/home_screen.dart';
import '../admin/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final response = await AuthService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => loading = false);

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response['token']);
      await prefs.setString("role", response['role']);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));

      if (response['role'] == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserHomeScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Kathmandu Bus Tracker",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              /// EMAIL FIELD (individual validation)
              CustomTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Invalid email format";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// PASSWORD FIELD (individual validation)
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                obscureText: true,
                icon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// LOGIN BUTTON / LOADER
              loading
                  ? const CircularProgressIndicator()
                  : CustomButton(text: "Login", onPressed: login),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
