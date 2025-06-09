
import 'package:flutter/material.dart';
// import 'package:shop/server/api.dart'; // Import your ApiProvider
import 'package:dio/dio.dart';
import 'package:shop/server/server.dart'; // Import Dio for error handling
// If you plan to auto-login and save token after registration, import Cookies.dart

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  // bool _obscureConfirmPassword = true;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ກະລຸນາເລືອກເພດຂອງທ່ານ')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await useServer.post(
          '/user/register', 
          data: {
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'gender': _selectedGender,
          },
        );
        // print("Response data: ${response.data}");

        if (!mounted) return; // Check if the widget is still in the tree

        if (response.statusCode == 201 || response.statusCode == 200) { // 201 Created or 200 OK
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data?['message'] ?? 'ລົງທະບຽນສຳເລັດ! ກະລຸນາເຂົ້າສູ່ລະບົບ.')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          // This part assumes that if it's not 200/201, and not a DioException,
          // the server still provides a 'message' in the response.data
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.data?['message'] ?? 'ການລົງທະບຽນລົ້ມເຫລວ.')),
          );
        }
      } on DioException catch (e) {
        if (!mounted) return; // Check if the widget is still in the tree
        String errorMessage = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່.';
        if (e.response?.data != null) {
          final responseData = e.response!.data;
          if (responseData is Map && responseData.containsKey('message') && responseData['message'] is String) {
            errorMessage = responseData['message'];
          } else if (responseData is String && responseData.isNotEmpty) {
            // If the response data itself is a string error message
            errorMessage = responseData;
          }
          // You could add more specific checks here if your API returns errors in other formats
        } else if (e.message != null) {
          errorMessage = e.message!;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        if (!mounted) return; // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ມີບາງຢ່າງຜິດພາດ: ${e.toString()}')));
      } finally {
        // Ensure widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the main Column with SingleChildScrollView
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 28),
                      onPressed: _isLoading ? null : () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Image.asset('assets/shoes.png', height: 100, width: 300),
                Text(
                  'ເກີບມາຕະຖານ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('ບໍລິສັດ Shoes', style: TextStyle(fontSize: 12)),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ລົງທະບຽນ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "ກະລຸນາປ້ອນຂໍ້ມູນຂອງທ່ານ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _firstNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ຊື່',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນຊື່ແທ້';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ນາມສະກຸນ',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນນາມສະກຸນ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ອີເມວ',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນອີເມວ';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            return 'ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'ລະຫັດຜ່ານ',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນລະຫັດຜ່ານ';
                          }
                          if (value.length < 6) {
                            return 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      //  TextFormField( // Confirm Password Field
                      //   controller: _confirmPasswordController,
                      //   obscureText: _obscureConfirmPassword,
                      //   style: TextStyle(color: Colors.white),
                      //   keyboardType: TextInputType.visiblePassword,
                      //   decoration: InputDecoration(
                      //     hintText: 'ຢືນຢັນລະຫັດຜ່ານ',
                      //     hintStyle: TextStyle(color: Colors.grey),
                      //     prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                      //     suffixIcon: IconButton(
                      //       icon: Icon(
                      //         _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      //         color: Colors.white,
                      //       ),
                      //       onPressed: () {
                      //         setState(() {
                      //           _obscureConfirmPassword = !_obscureConfirmPassword;
                      //         });
                      //       },
                      //     ),
                      //     filled: true,
                      //     fillColor: Colors.grey.shade900,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'ກະລຸນາຢືນຢັນລະຫັດຜ່ານ';
                      //     }
                      //     if (value != _passwordController.text) {
                      //       return 'ລະຫັດຜ່ານບໍ່ຕົງກັນ';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(height: 16),
                      Text("ເພດ:", style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('ຊາຍ', style: TextStyle(color: Colors.white)),
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
                              title: const Text('ຍິງ', style: TextStyle(color: Colors.white)),
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
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "ລົງທະບຽນ",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: _isLoading ? null : () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "ມີບັນຊີແລ້ວ? ",
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: "ເຂົ້າສູ່ລະບົບ",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
