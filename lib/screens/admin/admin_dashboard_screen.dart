import 'package:flutter/material.dart';
import 'package:shop/route/app_route.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Manage Products'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.adminProductList);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text('Manage Users'),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.adminUserList);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
              // Add more admin functionalities here
            ],
          ),
        ),
      ),
    );
  }
}