import 'package:flutter/material.dart';
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

  void login() {
    if (isAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UserHomeScreen()),
      );
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
          ],
        ),
      ),
    );
  }
}
