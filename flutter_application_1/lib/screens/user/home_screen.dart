import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final searchController = TextEditingController();

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget featureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void onSearch() {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter bus name or route")));
      return;
    }

    // TODO: Connect with your search API
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Searching for: $query")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kathmandu Bus Tracker"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search bus, route, or destination...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onSubmitted: (_) => onSearch(),
              ),
            ),

            const SizedBox(height: 20),

            // 🚌 Feature Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  featureCard(
                    icon: Icons.directions_bus,
                    title: "View All Buses",
                    color: Colors.blue,
                    onTap: () {
                      // TODO: Navigate to Bus List Screen
                    },
                  ),
                  featureCard(
                    icon: Icons.route,
                    title: "Bus Routes",
                    color: Colors.green,
                    onTap: () {
                      // TODO: Navigate to Route List Screen
                    },
                  ),
                  featureCard(
                    icon: Icons.access_time,
                    title: "Bus Timings",
                    color: Colors.orange,
                    onTap: () {},
                  ),
                  featureCard(
                    icon: Icons.location_on,
                    title: "Track Bus",
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//AIzaSyB08Hop5V4hbRAQMKznGeScekYrqkkcBE8