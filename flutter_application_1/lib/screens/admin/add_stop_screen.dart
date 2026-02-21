import 'package:flutter/material.dart';
import 'services/admin_api_service.dart';

class AddStopScreen extends StatefulWidget {
  const AddStopScreen({super.key});

  @override
  State<AddStopScreen> createState() => _AddStopScreenState();
}

class _AddStopScreenState extends State<AddStopScreen> {
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  Future<void> submitStop() async {
    final success = await AdminApiService.addStop({
      "name": nameController.text,
      "lat": double.parse(latController.text),
      "lng": double.parse(lngController.text),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Stop Added" : "Failed to Add Stop")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Bus Stop")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Stop Name"),
            ),
            TextField(
              controller: latController,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            TextField(
              controller: lngController,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitStop,
              child: const Text("Add Stop"),
            ),
          ],
        ),
      ),
    );
  }
}
