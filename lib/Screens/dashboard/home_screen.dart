import 'package:flutter/material.dart';
import 'package:pos/widgets/action_card.dart';
import 'package:pos/widgets/sales_card.dart';
import 'package:pos/widgets/search_bar.dart'; // Added import for SearchBarWidget

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Customizable dynamic data (add your own data here)
    final salesData = {
      'amount': 1800.75, // Your chosen sales amount
      'transactionCount': 60, // Your chosen transaction count
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POS Dashboard',
          style: TextStyle(
              fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
              color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.deepOrangeAccent, // White background for the AppBar
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {}),
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: CircleAvatar(
              radius: isLargeScreen ? 20 : screenWidth * 0.04,
              backgroundColor: Colors.white,
              child: Icon(Icons.person,
                  size: isLargeScreen ? 24 : screenWidth * 0.045,
                  color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100], // Set Colors.grey[100] as the background
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.05,
                vertical: constraints.maxHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar at the top with rounded corners
                  SearchBarWidget(
                    screenWidth: constraints.maxWidth,
                    onSearchChanged: (value) {
                      // Implement search logic here
                    },
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  // Today's Sales
                  SalesAndTransactionsWidget(
                    screenWidth: constraints.maxWidth,
                    screenHeight: constraints.maxHeight,
                    salesData: salesData,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  // Categories
                  _buildCategoryFilter(
                      context, constraints.maxWidth, constraints.maxHeight),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  // Quick Actions
                  _buildQuickActionsSection(context, isTablet, isLargeScreen,
                      constraints.maxWidth, constraints.maxHeight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(
      BuildContext context, double screenWidth, double screenHeight) {
    final categories = ['All', 'Sales', 'Inventory', 'Reports', 'Settings'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick links',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: screenHeight * 0.06,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: index == 0 ? Colors.black : Colors.black87,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, bool isTablet,
      bool isLargeScreen, double screenWidth, double screenHeight) {
    final cardSize = screenWidth *
        (isLargeScreen
            ? 0.22
            : isTablet
                ? 0.28
                : 0.3);
    final crossAxisCount = isLargeScreen
        ? 4
        : isTablet
            ? 3
            : 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            QuickActionCard(
                title: 'New Sale',
                icon: Icons.add_shopping_cart,
                color: Colors.indigo[600]!,
                cardSize: cardSize),
            QuickActionCard(
                title: 'Inventory',
                icon: Icons.inventory,
                color: Colors.teal[400]!,
                cardSize: cardSize),
            QuickActionCard(
                title: 'Reports',
                icon: Icons.bar_chart,
                color: Colors.purple[400]!,
                cardSize: cardSize),
            QuickActionCard(
                title: 'Settings',
                icon: Icons.settings,
                color: Colors.deepOrange[400]!,
                cardSize: cardSize),
            QuickActionCard(
                title: 'Customers',
                icon: Icons.group,
                color: Colors.blue[400]!,
                cardSize: cardSize),
            QuickActionCard(
                title: 'Analytics',
                icon: Icons.analytics,
                color: Colors.green[400]!,
                cardSize: cardSize),
          ],
        ),
      ],
    );
  }
}