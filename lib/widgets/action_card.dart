import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double cardSize;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.cardSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Use GetX for navigation based on title
          switch (title) {
            case 'New Sale':
              Get.toNamed('/new_sale');
              break;
            case 'Inventory':
              Get.toNamed('/inventory');
              break;
            case 'Reports':
              Get.toNamed('/reports');
              break;
            case 'Settings':
              Get.toNamed('/settings');
              break;
            case 'Customers':
              Get.toNamed('/customers');
              break;
            case 'Analytics':
              Get.toNamed('/analytics');
              break;
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: cardSize * 0.3, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}