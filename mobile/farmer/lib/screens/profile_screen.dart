import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String username;
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFf1f5f9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _passwordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFf1f5f9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  void _savePassword() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both password fields.')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    // TODO: Implement password change API call here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password changed successfully!')),
    );
    setState(() {
      showPasswordFields = false;
      passwordController.clear();
      confirmPasswordController.clear();
    });
  }
  bool showPasswordFields = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String street = '';
  String barangay = '';
  String city = '';
  String province = '';
  String farmerId = '';
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      // Fetch user info
      final userRes = await http.get(
        Uri.parse(
          'http://127.0.0.1/capstone/api/get_user.php?username=${widget.username}',
        ),
      );
      final userJson = jsonDecode(userRes.body);
      if (userJson['success'] == true) {
        final user = userJson['user'];
        setState(() {
          firstName = user['first_name'] ?? '';
          lastName = user['last_name'] ?? '';
          phoneNumber = user['mobile'] ?? '';
          farmerId = user['id'].toString();
        });
        // Fetch address info
        final infoRes = await http.get(
          Uri.parse(
            'http://127.0.0.1/capstone/api/get_farmer_info.php?farmer_id=$farmerId',
          ),
        );
        final infoJson = jsonDecode(infoRes.body);
        if (infoJson['success'] == true) {
          final info = infoJson['info'];
          setState(() {
            street = info['street'] ?? '';
            barangay = info['barangay'] ?? '';
            city = info['city'] ?? '';
            province = info['province'] ?? '';
          });
        } else {
          setState(() {
            errorMessage = 'No address info found for this farmer.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'User not found.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading profile.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2ca58d),
        elevation: 0,
        title: const Text('Profile Settings'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Color(0xFFbbf7d0),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "$firstName $lastName",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Farmer ID: $farmerId',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                ),
