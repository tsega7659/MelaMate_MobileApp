import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      ActivityItem(
        type: 'Received',
        amount: '\$500.00',
        icon: Icons.call_received,
        color: AppTheme.success,
        time: '2 hours ago',
      ),
      ActivityItem(
        type: 'Sent',
        amount: '\$150.25',
        icon: Icons.send,
        color: AppTheme.error,
        time: '1 day ago',
      ),
      ActivityItem(
        type: 'Received',
        amount: '\$75.00',
        icon: Icons.call_received,
        color: AppTheme.success,
        time: '3 days ago',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  activity.time,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.amount,
            style: TextStyle(
              color: activity.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String type;
  final String amount;
  final IconData icon;
  final Color color;
  final String time;

  ActivityItem({
    required this.type,
    required this.amount,
    required this.icon,
    required this.color,
    required this.time,
  });
}
