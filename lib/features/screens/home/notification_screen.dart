import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  List<_NotificationItem> get _notifications => const [
        _NotificationItem(
          title: 'Order Shipped',
          description: 'Your #2451 order left the warehouse and is on the way.',
          timestamp: '2m ago',
          icon: Iconsax.truck_fast,
          color: Color(0xFF10B981),
        ),
        _NotificationItem(
          title: 'Limited Drop',
          description: 'New city inspired tees just landed. Check them out before they sell out.',
          timestamp: '1h ago',
          icon: Iconsax.flash,
          color: Color(0xFFF59E0B),
        ),
        _NotificationItem(
          title: 'Delivery Reminder',
          description: 'Confirm your delivery address for tomorrow’s scheduled drop-off.',
          timestamp: 'Yesterday',
          icon: Iconsax.location,
          color: Color(0xFF3B82F6),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(defaultPadding),
          itemCount: _notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: defaultPadding),
          itemBuilder: (context, index) {
            final item = _notifications[index];
            return _NotificationCard(item: item, theme: theme);
          },
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.theme});

  final _NotificationItem item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      item.timestamp,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String description;
  final String timestamp;
  final IconData icon;
  final Color color;

  const _NotificationItem({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.color,
  });
}
