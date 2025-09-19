import 'package:flutter/material.dart';

class SalesAndTransactionsWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Map<String, dynamic> salesData;

  const SalesAndTransactionsWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.salesData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSalesSummary(context),
      ],
    );
  }

  Widget _buildSalesSummary(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFB3E5FC).withOpacity(0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all((screenWidth * 0.04).toDouble()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Sales',
                    style: Theme.of(context).textTheme.headlineMedium ??
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${salesData['amount'] is num ? (salesData['amount'] as num).toDouble().toStringAsFixed(2) : '0.00'}',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.06).toDouble().clamp(16, 24),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.bodyMedium ??
                        const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${salesData['transactionCount'] ?? '0'}',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.05).toDouble().clamp(14, 20),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}