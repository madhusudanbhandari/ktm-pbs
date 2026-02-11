import 'package:flutter/material.dart';
//import 'route_list_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Dashboard")),
      body: Center(
        child: ElevatedButton(
          child: const Text("View Bus Routes"),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (_) => const RouteListScreen()),
            // );
          },
        ),
      ),
    );
  }
}
