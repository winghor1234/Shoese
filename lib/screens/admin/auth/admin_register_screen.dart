import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/server/server.dart';
import 'package:shop/util/Cookies.dart';
import 'dart:convert';
import 'package:shop/route/app_route.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  _AdminRegisterScreenState createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerAdmin() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a gender')), // Or your preferred localization
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await useServer.post(
          '/admin/register', // <<<--- Admin specific register endpoint
          data: {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'role': 'admin', // Explicitly set role or handle on backend
            'gender': _selectedGender,
          },
        );

        if (!mounted) return;

        if (response.statusCode == 201 || response.statusCode == 200) {
          final responseData = response.data;
          // Assuming successful registration also returns user and token to auto-login
          if (responseData != null &&
              responseData['token'] != null &&
              responseData['user'] != null &&
              responseData['user']['role'] == 'admin') {
            await saveUserAndToken(
              jsonEncode(responseData['user']),
              responseData['token'],
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  responseData['message'] ?? 'Admin registration successful!',
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.adminDashboard,
              (route) => false,
            );
          } else {
            // If auto-login data isn't provided, just show success and navigate to login
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  responseData?['message'] ??
                      'Admin registration successful. Please login.',
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.adminLogin,
              (route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data?['message'] ?? 'Admin registration failed.',
              ),
            ),
          );
        }
      } on DioException catch (e) {
        if (!mounted) return;
        String errorMessage = 'Connection error.';
        if (e.response?.data != null && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.orange),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Register New Admin',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orange),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Admin Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildTextFormField(
                    _firstNameController,
                    'First Name',
                    Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter first name';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextFormField(
                    _lastNameController,
                    'Last Name',
                    Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter last name';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextFormField(
                    _emailController,
                    'Email',
                    Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter email';
                      if (!RegExp(
                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value))
                        return 'Invalid email format';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextFormField(
                    _passwordController,
                    'Password',
                    Icons.lock,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter password';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Text("Gender:", style: TextStyle(color: Colors.white, fontSize: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Male', style: TextStyle(color: Colors.white)),
                          value: 'male',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          activeColor: Colors.orange,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Female', style: TextStyle(color: Colors.white)),
                          value: 'female',
                          groupValue: _selectedGender,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          activeColor: Colors.orange,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _registerAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Register Admin",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.adminLogin,
                            );
                          },
                    child: Text(
                      "Already have an admin account? Login",
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
