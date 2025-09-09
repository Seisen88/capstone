import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'track_screen.dart';
import 'request_screen.dart';
import 'settings_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: Colors.blue),
            SizedBox(width: 8),
            Text('Support Center'),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Chip(
                  label: Text('Online', style: TextStyle(color: Colors.green)),
                  backgroundColor: Colors.green[50],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  isUser: false,
                  time: '10:00 AM',
                  text: "Hello! I'm your AI assistant. I can help you with seed allocation queries, subsidy information, and general support. How can I assist you today?",
                ),
                _buildChatBubble(
                  isUser: true,
                  time: '10:02 AM',
                  text: "I need help with my seed allocation request REQ-2025-001. It's been in transit for 3 days.",
                ),
                _buildChatBubble(
                  isUser: false,
                  time: '10:03 AM',
                  text: "I can help you track that request. Let me connect you with a support agent who can provide real-time updates.",
                ),
                _buildChatBubble(
                  isUser: false,
                  isSupport: true,
                  time: '10:05 AM',
                  text: "Hi! I'm Sarah from the support team. I can see your request REQ-2025-001 for 50kg Rice IR64. It's currently in transit with tracking ID TRK123456. Expected delivery is tomorrow morning.",
                  attachment: 'delivery_tracking.pdf',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                _quickAction('Check my allocation status'),
                _quickAction('Track my delivery'),
                _quickAction('Subsidy payment status'),
                _quickAction('Technical support'),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildChatBubble({
    required bool isUser,
    bool isSupport = false,
    required String time,
    required String text,
    String? attachment,
  }) {
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser
        ? Colors.blue[700]
        : isSupport
            ? Colors.green[50]
            : Colors.grey[200];
    final textColor = isUser ? Colors.white : Colors.black87;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(text, style: TextStyle(color: textColor)),
              if (attachment != null)
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file, color: Colors.blue, size: 18),
                      SizedBox(width: 4),
                      Text(attachment, style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Text(time, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _quickAction(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
      child: Text(label, style: TextStyle(fontSize: 13)),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3, // Support tab
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => TrackScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => RequestScreen()));
            break;
          case 3:
            // Already on Support
            break;
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Track'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Request'),
        BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
