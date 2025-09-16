import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Screens/dashboard/inventory/inventory_screen.dart';
import 'package:pos/Screens/newSales/new_sales_screen.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final double? price; // Changed to double? to match product prices
  final IconData icon;
  final Color color;
  final double cardSize;
  final Function()? onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    this.price,
    required this.icon,
    required this.color,
    required this.cardSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFB3E5FC).withOpacity(0.4), // Light blue border
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white, // White background for the card
        ),
        child: InkWell(
          onTap: onTap ??
              () {
                // Default navigation logic if onTap is not provided
                switch (title) {
                  case 'New Sale':
                    Get.to(() => const NewSaleScreen());
                    break;
                  case 'Inventory':
                    Get.to(InventoryScreen());
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
              Icon(icon, size: cardSize * 0.3, color: color), // Use provided color for icon
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              if (price != null) ...[
                const SizedBox(height: 4),
                Text(
                  '\$${price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: cardSize * 0.1,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}