import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:ui';
// ...existing code...

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Future<bool> sendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/capstone/api/send_otp.php'),
      body: {'mobile': mobile},
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return true;
    } else if (data['error'] != null) {
      try {
        final errorData = jsonDecode(data['error']);
        if (errorData['status'] == 'success' &&
            errorData['data'] != null &&
            errorData['data']['status'] == 'Delivered') {
          return true;
        }
      } catch (e) {
        // ignore parse error
      }
    }
    return false;
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/capstone/api/verify_otp.php'),
      body: {'mobile': mobile, 'otp': otp},
    );
    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  void _showOtpModal(String mobile) {
    final otpController = TextEditingController();
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'OTP',
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                Center(
                  child: AlertDialog(
                    title: Text('OTP Confirmation'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Enter the OTP sent to your mobile number.'),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: otpController,
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool verified = await verifyOtp(
                            mobile,
                            otpController.text.trim(),
                          );
                          if (verified) {
                            Navigator.of(context).pop();
                            await registerFarmer();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid OTP. Please try again.'),
                              ),
                            );
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> registerFarmer() async {
    final url = Uri.parse('http://10.0.2.2/capstone/api/register_farmer.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'mobile': mobile,
      }),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration successful!')));
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration failed: '
            '${data['error'] ?? 'Unknown error'}',
          ),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  String username = '';
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 370,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 32,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222B45),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildLabel('Username'),
                  _buildTextField(
                    hint: 'Enter Username',
                    onChanged: (val) => setState(() => username = val),
                  ),
                  SizedBox(height: 18),
                  _buildLabel('First Name'),
                  _buildTextField(
                    hint: 'First Name',
                    onChanged: (val) => setState(() => firstName = val),
                  ),
                  SizedBox(height: 18),
                  _buildLabel('Last Name'),
                  _buildTextField(
                    hint: 'Last Name',
                    onChanged: (val) => setState(() => lastName = val),
                  ),
                  SizedBox(height: 18),
                  _buildLabel('Password'),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF7F9FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(fontSize: 15),
                    onChanged: (val) => setState(() => password = val),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  _buildLabel('Mobile Number'),
                  _buildTextField(
                    hint: '+639XXXXXXXXX or 09XXXXXXXXX',
                    onChanged: (val) => setState(() => mobile = val),
                    keyboardType: TextInputType.phone,
                    // Allow + and digits
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Mobile number is required';
                      }
                      if (!RegExp(r'^\+?\d{9,}$').hasMatch(val)) {
                        return 'Mobile number must be at least 9 digits and may start with +';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2ca58d),
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Color(0xFF2ca58d).withOpacity(0.2),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool otpSent = await sendOtp(mobile);
                          if (otpSent) {
                            _showOtpModal(mobile);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to send OTP.')),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color(0xFF2ca58d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                          ),
                        ],
                      ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF222B45),
          fontSize: 15,
        ),
      ),
    );
  }

  final otpController = TextEditingController();
  Widget _buildTextField({
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: Color(0xFFF7F9FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(fontSize: 15),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator:
          validator ??
          (val) => val == null || val.isEmpty ? 'This field is required' : null,
      inputFormatters: inputFormatters,
    );
  }
}
