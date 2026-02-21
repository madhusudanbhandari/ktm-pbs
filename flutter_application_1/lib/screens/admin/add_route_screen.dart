import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/admin_api_service.dart';

class AddRouteScreen extends StatefulWidget {
  const AddRouteScreen({super.key});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();

  Future<void> submitRoute() async {
    try {
      final coords = jsonDecode(coordinatesController.text);

      final success = await AdminApiService.addRoute({
        "name": nameController.text,
        "coordinates": coords,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "Route Added" : "Failed to Add Route"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid JSON Coordinates")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Route (Polyline Data)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Route Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: coordinatesController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Coordinates JSON',
                hintText: '[{"lat":27.7,"lng":85.3}]',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitRoute,
              child: const Text("Upload Route"),
            ),
          ],
        ),
      ),
    );
  }
}
