import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'track_screen.dart';
import 'request_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart'; // Import SupportScreen
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final bool isVerified;
  final String username; // Add username field
  const DashboardScreen({
    super.key,
    this.isVerified = true,
    required this.username,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? farmerId;

  Future<bool> checkFarmerInfo(int farmerId) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2/capstone/api/check_farmer_info.php?farmer_id=$farmerId',
      ),
    );
    final data = jsonDecode(response.body);
    return data['exists'] == true;
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'Verification',
          pageBuilder: (context, anim1, anim2) {
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                Center(
                  child: AlertDialog(
                    title: Text('Verification Pending'),
                    content: Text(
                      'Waiting to be verified. Please come back later.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Fetch farmerId using username
        final user = await fetchUser(widget.username);
        if (user != null && mounted) {
          setState(() {
            farmerId = user['id'];
          });
          // Check if farmer info exists
          final infoExists = await checkFarmerInfo(user['id']);
          if (!infoExists && mounted) {
            _showInformationModal();
          }
        }
      });
    }
  }

  Widget _summaryItem(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    String buttonText,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF4F4F4),
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            elevation: 0,
          ),
          onPressed: () {},
          child: Text(
            buttonText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _recentRequestCard(
    String title,
    String status,
    Color chipColor,
    String qty,
    String date, {
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      qty,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    SizedBox(width: 12),
                    Text(
                      date,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.remove_red_eye_outlined, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _quickActionGrid(String label, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  int _selectedTab = 0;
  final List<String> _tabs = ['Seed Allocations', 'Decisions', 'Subsidies'];

  Widget _footerNavItem(IconData icon, String label, int index) {
    final isSelected = index == _selectedTab;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                username: widget.username,
                isVerified: widget.isVerified,
              ),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackScreen(
                username: widget.username,
                isVerified: widget.isVerified,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RequestScreen(
                username: widget.username,
                isVerified: widget.isVerified,
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(
                username: widget.username,
                isVerified: widget.isVerified,
              ),
            ),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportScreen(
                username: widget.username,
                isVerified: widget.isVerified,
              ),
            ),
          );
        } else {
          setState(() {
            _selectedTab = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Color(0xFF2ca58d) : Color(0xFF6B7280)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF2ca58d) : Color(0xFF6B7280),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _showInformationModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Information',
      pageBuilder: (context, anim1, anim2) {
        int modalTab = 0;
        final provinceController = TextEditingController();
        final cityController = TextEditingController();
        final barangayController = TextEditingController();
        final streetController = TextEditingController();
        final landSizeController = TextEditingController();
        final otherInfoController = TextEditingController();
        File? pickedImage;
        final ImagePicker picker = ImagePicker();
        return StatefulBuilder(
          builder: (context, setState) {
            bool canGoNext =
                landSizeController.text.trim().isNotEmpty &&
                provinceController.text.trim().isNotEmpty &&
                cityController.text.trim().isNotEmpty &&
                barangayController.text.trim().isNotEmpty &&
                streetController.text.trim().isNotEmpty &&
                double.tryParse(landSizeController.text.trim()) != null;
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                Center(
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                        maxWidth: 350,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Farmer Information',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 18),
                              if (modalTab == 0) ...[
                                // Land Size field above location fields
                                TextFormField(
                                  controller: landSizeController,
                                  decoration: InputDecoration(
                                    labelText: 'Land Size (hectares)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // Only allow numbers and decimals
                                    if (value.isNotEmpty &&
                                        double.tryParse(value) == null) {
                                      landSizeController.text = value
                                          .replaceAll(RegExp(r'[^0-9.]'), '');
                                      landSizeController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: landSizeController
                                                  .text
                                                  .length,
                                            ),
                                          );
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 16),
                                // Location fill-up fields
                                TextFormField(
                                  controller: provinceController,
                                  decoration: InputDecoration(
                                    labelText: 'Province',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: cityController,
                                  decoration: InputDecoration(
                                    labelText: 'City/Municipality',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: barangayController,
                                  decoration: InputDecoration(
                                    labelText: 'Barangay',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  controller: streetController,
                                  decoration: InputDecoration(
                                    labelText: 'Street/Area',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: canGoNext
                                          ? () => setState(() => modalTab = 1)
                                          : null,
                                      child: Text('Next'),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                // Only show Other Info tab and Save button
                                TextFormField(
                                  controller: otherInfoController,
                                  decoration: InputDecoration(
                                    labelText: 'Other Information',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 16),
                                // Image upload button and preview
                                if (pickedImage != null)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: FileImage(pickedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.photo_library),
                                      label: Text('Gallery'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF2563eb),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final picked = await picker.pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            pickedImage = File(picked.path);
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(width: 12),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.camera_alt),
                                      label: Text('Camera'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF2563eb),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final picked = await picker.pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            pickedImage = File(picked.path);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Cancel'),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed:
                                          pickedImage != null &&
                                              farmerId != null
                                          ? () async {
                                              await saveFarmerInfo(
                                                farmerId: farmerId!,
                                                landSize: landSizeController
                                                    .text
                                                    .trim(),
                                                province: provinceController
                                                    .text
                                                    .trim(),
                                                city: cityController.text
                                                    .trim(),
                                                barangay: barangayController
                                                    .text
                                                    .trim(),
                                                street: streetController.text
                                                    .trim(),
                                                otherInfo: otherInfoController
                                                    .text
                                                    .trim(),
                                                imageFile: pickedImage,
                                              );
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: Text('Save'),
                                    ),
                                  ],
                                ),
                              ], // end else
                            ], // end children
                          ), // end Column
                        ), // end Padding
                      ), // end SingleChildScrollView
                    ), // end ConstrainedBox
                  ), // end Dialog
                ), // end Center
              ], // end children
            ); // end Stack
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>?> fetchUser(String username) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/capstone/api/get_user.php?username=$username'),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['user'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF2ca58d),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Farmer Cooperative Platform',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Color(0xFF2ca58d),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Rajesh!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Here's your farming overview",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // Removed 'Active' and 'This Month' dashboard cards
              SizedBox(height: 24),
              // Quick Actions Grid
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2ca58d),
                ),
              ),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _quickActionGrid('New Request', Icons.add, Color(0xFF2563eb)),
                  _quickActionGrid(
                    'Track Order',
                    Icons.local_shipping,
                    Color(0xFF10b981),
                  ),
                  _quickActionGrid(
                    'Chat Support',
                    Icons.chat,
                    Color(0xFF8b5cf6),
                  ),
                  _quickActionGrid(
                    'View Reports',
                    Icons.bar_chart,
                    Color(0xFFf59e42),
                  ),
                ],
              ),
              SizedBox(height: 28),
              // Recent Requests Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Requests',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF2563eb),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Column(
                children: [
                  _recentRequestCard(
                    'Rice IR64',
                    'APPROVED',
                    Color(0xFF22c55e),
                    '50 kg',
                    '2025-01-25',
                  ),
                  SizedBox(height: 10),
                  _recentRequestCard(
                    'Wheat HD2967',
                    'PENDING',
                    Color(0xFFfde68a),
                    '25 kg',
                    '2025-01-26',
                    textColor: Color(0xFFb45309),
                  ),
                  SizedBox(height: 10),
                  _recentRequestCard(
                    'Corn NK6240',
                    'DISTRIBUTED',
                    Color(0xFFdbeafe),
                    '30 kg',
                    '2025-01-20',
                    textColor: Color(0xFF2563eb),
                  ),
                ],
              ),
              SizedBox(height: 28),
              // Today's Summary Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _summaryItem(
                      Icons.notifications,
                      Color(0xFF2563eb),
                      'New notifications',
                      '3 unread messages',
                      'View',
                    ),
                    SizedBox(height: 12),
                    _summaryItem(
                      Icons.trending_up,
                      Color(0xFF22c55e),
                      'Delivery update',
                      'Seeds arriving tomorrow',
                      'Track',
                    ),
                    SizedBox(height: 12),
                    _summaryItem(
                      Icons.groups,
                      Color(0xFF8b5cf6),
                      'Cooperative meeting',
                      'Tomorrow at 10 AM',
                      'Details',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              // Need Help Chat Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFe0e7ff), Color(0xFFf1f5f9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFe0e7ff),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFF2563eb),
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need Help?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Chat with our 24/7 support team',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2563eb),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Chat Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ...existing code...
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _footerNavItem(Icons.home, 'Home', 0),
            _footerNavItem(Icons.track_changes, 'Track', 1),
            _footerNavItem(Icons.add_circle_outline, 'Request', 2),
            _footerNavItem(Icons.settings, 'Settings', 3),
            _footerNavItem(Icons.support_agent, 'Support', 4),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String value, String sub) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2ca58d),
            ),
          ),
          SizedBox(height: 4),
          Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _tabButton(int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          color: _selectedTab == index ? Color(0xFF2ca58d) : Color(0xFFF4F4F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Text(
          _tabs[index],
          style: TextStyle(
            color: _selectedTab == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _tabContent(int index) {
    switch (index) {
      case 0:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cooperative Decisions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              _decisionCard(
                'Proposal: New Seed Storage Facility',
                'Proposal to build a new climate-controlled seed storage facility to improve seed quality and reduce waste.',
                false,
              ),
              _decisionCard(
                'Decision: Organic Certification Program',
                'Approved: Cooperative will support farmers in obtaining organic certification with subsidized training and inspection costs.',
                true,
              ),
            ],
          ),
        );
      case 1:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Text('Decisions content goes here.'),
        );
      case 2:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Text('Subsidies content goes here.'),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _decisionCard(String title, String desc, bool approved) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 6),
          Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          if (approved)
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFEAF9F1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Approved',
                style: TextStyle(
                  color: Color(0xFF388e3c),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationCard(String text, String time, Color? bg, Color? fg) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: fg ?? Colors.black, fontSize: 14),
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _quickAction(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xFF2ca58d),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 13)),
      ],
    );
  }

  // Add this function to your file if not present:
  Future<void> saveFarmerInfo({
    required int farmerId,
    required String landSize,
    required String province,
    required String city,
    required String barangay,
    required String street,
    required String otherInfo,
    File? imageFile,
  }) async {
    var uri = Uri.parse('http://10.0.2.2/capstone/api/add_farmer_info.php');
    var request = http.MultipartRequest('POST', uri);

    request.fields['farmer_id'] = farmerId.toString();
    request.fields['land_size'] = landSize;
    request.fields['province'] = province;
    request.fields['city'] = city;
    request.fields['barangay'] = barangay;
    request.fields['street'] = street;
    request.fields['other_info'] = otherInfo;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      var result = jsonDecode(respStr);
      if (result['success'] == true) {
        // Success: show confirmation or navigate
      } else {
        // Error: show result['error']
      }
    } else {
      // Error: show response.statusCode
    }
  }
}
