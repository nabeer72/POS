import 'package:flutter/material.dart';

class SalesAndTransactionsWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final Map<String, dynamic> salesData; // Required sales data

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
      elevation: 0, // Removed elevation for a flat look with gradient
      color: Colors.transparent, // Make card transparent to show gradient
      child: Container(
        decoration: BoxDecoration(
           border: Border.all(
            color: Color(0xFFB3E5FC).withOpacity(0.4), // Light blue border
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white, // White background for the card
         
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Sales',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${salesData['amount'] ?? '0.00'}', // Dynamic sales amount
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${salesData['transactionCount'] ?? '0'}', // Dynamic transaction count
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
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