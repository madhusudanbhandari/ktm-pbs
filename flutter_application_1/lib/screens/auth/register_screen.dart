import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth/login_screen.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  String role = "user";
  bool loading = false;

  void register() async {
    setState(() => loading = true);

    final success = await AuthService.register(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
      address: addressController.text,
      role: role,
    );

    setState(() => loading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Successful")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            CustomTextField(controller: nameController, hint: "Full Name"),
            const SizedBox(height: 15),
            CustomTextField(controller: emailController, hint: "Email"),
            const SizedBox(height: 15),
            CustomTextField(controller: phoneController, hint: "Phone Number"),
            const SizedBox(height: 15),
            CustomTextField(controller: addressController, hint: "Address"),
            const SizedBox(height: 10),
            CustomTextField(
              controller: passwordController,
              hint: "Password",
              isPassword: true,
            ),
            const SizedBox(height: 20),

            const Text("Register As"),
            RadioListTile(
              title: const Text("User"),
              value: "user",
              groupValue: role,
              onChanged: (v) => setState(() => role = v!),
            ),
            RadioListTile(
              title: const Text("Admin"),
              value: "admin",
              groupValue: role,
              onChanged: (v) => setState(() => role = v!),
            ),

            const SizedBox(height: 20),
            loading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(text: "Register", onPressed: register),
          ],
        ),
      ),
    );
  }
}
