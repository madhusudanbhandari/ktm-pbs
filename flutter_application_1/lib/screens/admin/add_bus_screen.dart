import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/admin_api_service.dart';

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController driverController = TextEditingController();

  Future<void> submitBus() async {
    final success = await AdminApiService.addBus({
      "name": nameController.text,
      "number": numberController.text,
      "driverName": driverController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Bus Added Successfully" : "Failed to Add Bus"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Bus")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Bus Name"),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: "Bus Number"),
            ),
            TextField(
              controller: driverController,
              decoration: const InputDecoration(labelText: "Driver Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submitBus, child: const Text("Add Bus")),
          ],
        ),
      ),
    );
  }
}
