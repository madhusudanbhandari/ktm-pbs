import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/services/admin_api_service.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  List buses = [];

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    final data = await AdminApiService.getBuses();
    setState(() {
      buses = data;
    });
  }

  Future<void> deleteBus(String id) async {
    await AdminApiService.deleteBus(id);
    fetchBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Buses")),
      body: ListView.builder(
        itemCount: buses.length,
        itemBuilder: (context, index) {
          final bus = buses[index];
          return ListTile(
            title: Text(bus["name"] ?? ""),
            subtitle: Text("Number: ${bus["number"]}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteBus(bus["_id"]),
            ),
          );
        },
      ),
    );
  }
}
