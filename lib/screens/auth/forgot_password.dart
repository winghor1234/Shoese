
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        title: Text('ລືມລະຫັດຜ່ານ', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ອິເມວ', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              
              keyboardType: TextInputType.emailAddress , 
              
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'ອິເມວຂອງທ່ານ',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.email, color: Colors.white),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/verifyOTP');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('ສົ່ງ OTP', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
