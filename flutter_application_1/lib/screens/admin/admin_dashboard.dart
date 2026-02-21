import 'package:flutter/material.dart';
import 'add_bus_screen.dart';
import 'add_route_screen.dart';
import 'add_stop_screen.dart';
import 'bus_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Tracking Admin Dashboard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, "Add Bus", const AddBusScreen()),
            _buildCard(context, "Add Route", const AddRouteScreen()),
            _buildCard(context, "Add Bus Stop", const AddStopScreen()),
            _buildCard(context, "View Buses", const BusListScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Card(
        elevation: 4,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
