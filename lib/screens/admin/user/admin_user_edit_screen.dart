import 'package:flutter/material.dart';
import 'package:shop/screens/admin/user/admin_user_list_screen.dart'; // For AdminUser model

class AdminUserEditScreen extends StatefulWidget {
  final String? userId;

  const AdminUserEditScreen({super.key, required this.userId});

  @override
  State<AdminUserEditScreen> createState() => _AdminUserEditScreenState();
}

class _AdminUserEditScreenState extends State<AdminUserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _selectedRole;
  bool _isLoading = false;

  // Placeholder: In a real app, you'd fetch this from your backend
  AdminUser? _currentUser;
  final List<String> _availableRoles = [
    'admin',
    'customer',
    'editor',
  ]; // Example roles

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    if (widget.userId != null) {
      _fetchUserDetails(widget.userId!);
    } else {
      // Handle error: userId should not be null for editing
      // For simplicity, we'll assume it's always provided for an edit screen
    }
  }

  void _fetchUserDetails(String userId) {
    // TODO: Replace with actual API call to fetch user details
    // Simulating fetching user details
    setState(() {
      _isLoading = true;
      // Placeholder data
      _currentUser = AdminUser(
        id: userId,
        name: 'Fetched User Name',
        email: 'user@example.com',
        role: 'customer',
      );
      _nameController.text = _currentUser!.name;
      _emailController.text = _currentUser!.email;
      _selectedRole = _currentUser!.role;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveUserDetails() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a role for the user.')),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      // TODO: Implement API call to update user details (especially the role)
      print(
        'Saving user ${widget.userId} with role: $_selectedRole, Name: ${_nameController.text}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ${widget.userId} details updated (placeholder)'),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, true); // Pop and indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User: ${widget.userId ?? 'N/A'}'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading || _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      // readOnly: true, // Name might be read-only or editable
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true, // Email is typically not editable
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedRole,
                      items: _availableRoles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a role' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveUserDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
