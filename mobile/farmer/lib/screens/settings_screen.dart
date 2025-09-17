import 'support_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'track_screen.dart';
import 'request_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String username;
  final bool isVerified;
  const SettingsScreen({
    super.key,
    required this.username,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF2ca58d),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.person_outline),
                label: Text('Go to Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2563eb),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(username: username),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            _settingsCard(
              context,
              Icons.notifications_none,
              'Notifications',
              'Manage alerts and messages',
              NotificationsScreen(),
            ),
            SizedBox(height: 16),
            _settingsCard(
              context,
              Icons.chat_bubble_outline,
              'Help & Support',
              'Get help and contact support',
              HelpSupportScreen(),
            ),
          ],
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
            _footerNavItem(context, Icons.home, 'Home', 0),
            _footerNavItem(context, Icons.track_changes, 'Track', 1),
            _footerNavItem(context, Icons.add_circle_outline, 'Request', 2),
            _footerNavItem(context, Icons.settings, 'Settings', 3),
            _footerNavItem(context, Icons.support_agent, 'Support', 4),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget? page,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, size: 32, color: Color(0xFF2563eb)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          }
        },
      ),
    );
  }

  Widget _footerNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = index == 3; // Settings tab selected
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(username: username, isVerified: isVerified),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TrackScreen(username: username, isVerified: isVerified),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RequestScreen(username: username, isVerified: isVerified),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SettingsScreen(username: username, isVerified: isVerified),
            ),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SupportScreen(username: username, isVerified: isVerified),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Color(0xFF2563eb) : Color(0xFF6B7280)),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF2563eb) : Color(0xFF6B7280),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Profile Settings Page

// Notifications Page
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool seedUpdates = true;
  bool subsidyUpdates = true;
  bool meetingReminders = true;
  bool supportMessages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF2ca58d),
        elevation: 0,
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _toggleCard(
              'Seed Allocation Updates',
              'Status changes and delivery notifications',
              seedUpdates,
              (val) => setState(() => seedUpdates = val),
            ),
            SizedBox(height: 12),
            _toggleCard(
              'Subsidy Notifications',
              'Payment updates and application status',
              subsidyUpdates,
              (val) => setState(() => subsidyUpdates = val),
            ),
            SizedBox(height: 12),
            _toggleCard(
              'Meeting Reminders',
              'Cooperative meetings and announcements',
              meetingReminders,
              (val) => setState(() => meetingReminders = val),
            ),
            SizedBox(height: 12),
            _toggleCard(
              'Support Messages',
              'Messages from support team',
              supportMessages,
              (val) => setState(() => supportMessages = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleCard(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Color(0xFF2563eb),
        ),
      ),
    );
  }
}

// Help & Support Page
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF2ca58d),
        elevation: 0,
        title: Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Support',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('Get help with your queries 24/7'),
                    SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Live Chat Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Help Documentation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Version:'), Text('1.0.0')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Last Updated:'), Text('Jan 29, 2025')],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
