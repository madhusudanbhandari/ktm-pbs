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
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "user";
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final result = await AuthService.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
      address: addressController.text.trim(),
      role: role,
    );

    setState(() => loading = false);

    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
      Navigator.pop(context); // back to login
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              /// FULL NAME
              CustomTextField(
                hint: "Full Name",
                icon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Full name is required";
                  }
                  if (value.length < 3) {
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
              ),

              /// EMAIL
              CustomTextField(
                hint: "Email",
                icon: Icons.email,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),

              /// PHONE
              CustomTextField(
                hint: "Phone Number",
                icon: Icons.phone,
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),

              /// ADDRESS
              CustomTextField(
                hint: "Address",
                icon: Icons.location_on,
                controller: addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Address is required";
                  }
                  if (value.length < 5) {
                    return "Address is too short";
                  }
                  return null;
                },
              ),

              /// PASSWORD
              CustomTextField(
                hint: "Password",
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// ROLE SELECTION
              const Text(
                "Register As",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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

              /// REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: register,
                        child: const Text("Register"),
                      ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
