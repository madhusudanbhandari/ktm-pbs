import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/auth_service.dart';
import 'package:flutter_application_1/screens/auth/register_screen.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isAdmin = false;

  void login() async {
    final result = await AuthService.login(
      emailController.text,
      passwordController.text,
    );

    if (result != null) {
      final role = result['role'];

      if (role == "admin") {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Kathmandu Bus Tracker",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            CustomTextField(controller: emailController, hint: "Email"),
            const SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              hint: "Password",
              isPassword: true,
            ),
            Row(
              children: [
                Checkbox(
                  value: isAdmin,
                  onChanged: (v) => setState(() => isAdmin = v!),
                ),
                const Text("Login as Admin"),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(text: "Login", onPressed: login),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                SizedBox(width: 5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
