import 'package:flutter/material.dart';
import 'package:shop/route/app_route.dart';

// Placeholder User Model for Admin
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class AdminUserListScreen extends StatefulWidget {
  const AdminUserListScreen({super.key});

  @override
  State<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends State<AdminUserListScreen> {
  // Placeholder data - replace with actual data fetching
  final List<AdminUser> _users = List.generate(
    3,
    (index) => AdminUser(
      id: 'user${index + 1}',
      name: 'User Name ${index + 1}',
      email: 'user${index + 1}@example.com',
      role: index % 2 == 0 ? 'Admin' : 'Customer',
    ),
  );

  Future<void> _navigateToEditUser(String userId) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.adminUserEdit,
      arguments: userId,
    );
    if (result == true && mounted) {
      // Optionally, refresh the list if changes were made
      // _fetchUsers(); // You would call your actual data fetching method here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User details might have been updated.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(child: Text(user.name[0])),
              title: Text(user.name),
              subtitle: Text('${user.email} - Role: ${user.role}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit_attributes, color: Colors.blue),
                onPressed: () => _navigateToEditUser(user.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
