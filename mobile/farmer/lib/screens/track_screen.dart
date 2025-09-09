import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'request_screen.dart';
import 'settings_screen.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  int expandedIndex = -1;

  final List<Map<String, dynamic>> requests = [
    {
      'id': 'REQ-2025-001',
      'priority': 'HIGH',
      'priorityColor': Color(0xFFc4b5fd),
      'status': 'IN TRANSIT',
      'statusColor': Color(0xFFa5b4fc),
      'name': 'Rajesh Kumar',
      'seed': 'Rice (IR64)',
      'quantity': '50 kg',
      'date': '2025-01-20',
      'location': 'Village Khurwa, Dist. Fatehpur',
      'timeline': [
        {
          'title': 'Request Submitted',
          'desc': 'Seed allocation request submitted',
          'date': '2025-01-20 10:30 AM',
          'icon': Icons.check_circle_outline,
          'color': Color(0xFF22c55e),
        },
        {
          'title': 'Under Review',
          'desc': 'Request being reviewed by officer',
          'date': '2025-01-21 09:15 AM',
          'icon': Icons.search,
          'color': Color(0xFF2563eb),
        },
        {
          'title': 'Approved',
          'desc': 'Request approved and scheduled',
          'date': '2025-01-22 02:45 PM',
          'icon': Icons.check,
          'color': Color(0xFF22c55e),
        },
        {
          'title': 'In Transit',
          'desc': 'Seeds dispatched - TRK123456',
          'date': '2025-01-25 08:00 AM',
          'icon': Icons.local_shipping,
          'color': Color(0xFFa5b4fc),
        },
        {
          'title': 'Expected Delivery',
          'desc': 'Expected delivery tomorrow',
          'date': '2025-01-26 (Expected)',
          'icon': Icons.event,
          'color': Color(0xFFfde68a),
        },
      ],
    },
    {
      'id': 'REQ-2025-002',
      'priority': 'MEDIUM',
      'priorityColor': Color(0xFFfde68a),
      'status': 'PENDING',
      'statusColor': Color(0xFFfde68a),
      'name': 'Priya Sharma',
      'seed': 'Wheat (HD2967)',
      'quantity': '25 kg',
      'date': '2025-01-26',
      'location': 'Village Rampur, Dist. Kanpur',
      'timeline': [],
    },
    {
      'id': 'REQ-2025-003',
      'priority': 'LOW',
      'priorityColor': Color(0xFFbbf7d0),
      'status': 'DELIVERED',
      'statusColor': Color(0xFFbbf7d0),
      'name': 'Suresh Patel',
      'seed': 'Corn (NK6240)',
      'quantity': '30 kg',
      'date': '2025-01-15',
      'location': 'Village Belgaum, Dist. Karnataka',
      'timeline': [],
    },
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
        title: Text('Track Allocations', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Track Allocations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Row(
                  children: [
                    Text('3 requests', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4F4F4),
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      icon: Icon(Icons.filter_alt_outlined, size: 18),
                      label: Text('Filters'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400]),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search requests...',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];
                  final isExpanded = expandedIndex == index;
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
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
                                Text(req['id'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: req['priorityColor'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(req['priority'], style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12)),
                                ),
                                SizedBox(width: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: req['statusColor'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(req['status'], style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 12)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(req['name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Seed:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                      Text(req['seed'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Quantity:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                      Text(req['quantity'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Requested:', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                      Text(req['date'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, color: Color(0xFF2563eb), size: 18),
                                SizedBox(width: 4),
                                Expanded(child: Text(req['location'], style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
                              ],
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedIndex = isExpanded ? -1 : index;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(isExpanded ? 'Hide Timeline' : 'View Timeline', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563eb))),
                                    Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Color(0xFF2563eb)),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded && req['timeline'].isNotEmpty) ...[
                              SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Color(0xFFf1f5f9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Progress Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    SizedBox(height: 12),
                                    ...req['timeline'].map<Widget>((step) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: step['color'].withOpacity(0.15),
                                            radius: 16,
                                            child: Icon(step['icon'], color: step['color'], size: 18),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(step['title'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                                SizedBox(height: 2),
                                                Text(step['desc'], style: TextStyle(fontSize: 12, color: Colors.black54)),
                                                SizedBox(height: 2),
                                                Text(step['date'], style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
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

  Widget _footerNavItem(IconData icon, String label, int index) {
    final isSelected = index == 1; // Track tab selected
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrackScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
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
}
