import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/server/server.dart';
import 'package:shop/util/Cookies.dart'; // For saving user and token

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await useServer.post(
          '/user/login', // Assuming your login endpoint is /login
          data: {
            'email': _emailController.text,
            'password': _passwordController.text,
          },
        );
        // print("Login Response data: ${response.data}");

        if (!mounted) return;

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Assuming the server returns user data and a token
          // Adjust keys ('user', 'token', 'message') based on your API response
          final responseData = response.data;
          // if (responseData != null && responseData['token'] != null && responseData['user'] != null) {
          //   await saveUserAndToken(jsonEncode(responseData['user']), responseData['token']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data?['message'] ?? 'ເຂົ້າສູ່ລະບົບສຳເລັດ!',
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
          ); // Navigate to home or dashboard
          // } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData?['message'] ?? 'ຂໍ້ມູນການຕອບກັບບໍ່ຖືກຕ້ອງ.',
              ),
            ),
          );
          // }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response.data?['message'] ?? 'ການເຂົ້າສູ່ລະບົບລົ້ມເຫລວ.',
              ),
            ),
          );
        }
      } on DioException catch (e) {
        if (!mounted) return;
        String errorMessage = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່.';
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
          SnackBar(content: Text('ມີບາງຢ່າງຜິດພາດ: ${e.toString()}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the main Column with SingleChildScrollView
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
                      onPressed: _isLoading
                          ? null
                          : () {
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ຍິນດີຕ້ອນຮັບ",
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress, // Changed
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
                          if (!RegExp(
                            r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value)) {
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
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
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
                          // You might want to add a minimum length validator here too
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                    context,
                                    '/forgotPassword',
                                  );
                                },
                          child: Text(
                            'ລືມລະຫັດຜ່ານ ?',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _loginUser,
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
                                "ເຂົ້າສູ່ລະບົບ",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/register');
                                },
                          child: Text.rich(
                            TextSpan(
                              text: "ບໍ່ມີບັນຊີ? ",
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: "ລົງທະບຽນ",
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
                      SizedBox(height: 30),
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
