import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Screens/customers/customer_screen.dart';
import 'package:pos/Screens/dashboard/inventory/inventory_screen.dart';
import 'package:pos/Screens/newSales/new_sales_screen.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final num? price; // Changed to num? to handle num from salesData
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

  static final Map<String, Function()> _navigationMap = {
    'New Sale': () => Get.to(() => const NewSaleScreen()),
    'Inventory': () => Get.to(() => const InventoryScreen()),
    'Reports': () => Get.toNamed('/reports'),
    'Settings': () => Get.toNamed('/settings'),
    'Customers': () => Get.to(() => const AddCustomerScreen()),
    'Analytics': () => Get.toNamed('/analytics'),
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFB3E5FC).withOpacity(0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: onTap ??
              () {
                final navigationAction = _navigationMap[title];
                if (navigationAction != null) {
                  navigationAction();
                } else {
                  Get.snackbar('Error', 'No route defined for $title');
                }
              },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: cardSize * 0.3,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ) ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              if (price != null) ...[
                const SizedBox(height: 4),
                Text(
                  '\$${price!.toDouble().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: cardSize * 0.1,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}