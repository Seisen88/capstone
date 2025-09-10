import 'support_screen.dart';
import 'settings_screen.dart';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'track_screen.dart';

class RequestScreen extends StatefulWidget {
  final String username;
  final bool isVerified;
  const RequestScreen({
    super.key,
    required this.username,
    required this.isVerified,
  });

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String? selectedSoilType;
  final List<String> soilTypes = [
    'Sandy',
    'Clay',
    'Silt',
    'Peat',
    'Chalk',
    'Loam',
  ];

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
        title: Text(
          'Request Seeds',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stepper progress bar
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.25,
                      backgroundColor: Color(0xFFe5e7eb),
                      color: Color(0xFF2563eb),
                      minHeight: 5,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Step 1 of 4',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563eb),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              // Required fields notice
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFf1f5f9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF2563eb)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please fill out all required fields marked with *',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              // Personal & Farm Information card
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
                    Text(
                      'Personal & Farm Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    _formField('Full Name *', 'Enter your full name'),
                    SizedBox(height: 12),
                    _formField('Farmer ID *', 'FRM0001', enabled: false),
                    SizedBox(height: 12),
                    _formField('Land Size (acres) *', 'Enter land size'),
                    SizedBox(height: 12),
                    _formField('Farm Location *', 'Village, District'),
                    SizedBox(height: 12),
                    _dropdownField('Soil Type', 'Select soil type'),
                    SizedBox(height: 12),
                    _formField(
                      'Previous Year Yield (quintals)',
                      'Enter previous yield',
                    ),
                  ],
                ),
              ),
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

  Widget _formField(String label, String hint, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(height: 6),
        TextField(
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFf1f5f9),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _dropdownField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: selectedSoilType,
          items: soilTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (val) => setState(() => selectedSoilType = val),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFf1f5f9),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  Widget _footerNavItem(IconData icon, String label, int index) {
    final isSelected = index == 2; // Request tab selected
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
