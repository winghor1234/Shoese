import 'package:flutter/material.dart';

class VerifyOTPScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  VerifyOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        title: Text('ຢືນຢັນ OTP', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ໃສ່ລະຫັດ OTP ທີ່ຖືກສົ່ງໄປຫາເບີຂອງທ່ານ', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'OTP',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.message, color: Colors.white),
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
                Navigator.pushNamed(context, '/resetPassword');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('ດຳເນີນການຕໍ່', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
