import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
import 'package:pos/widgets/action_card.dart';
import 'package:pos/widgets/sales_card.dart';
import 'package:pos/widgets/search_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    final salesData = {
      'amount': 1800.75,
      'transactionCount': 60,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.deepOrangeAccent, // Match AppBar background
        statusBarIconBrightness: Brightness.dark, // Dark icons for light background
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'POS Dashboard',
            style: TextStyle(
              fontSize: (isLargeScreen ? 24.0 : screenWidth * 0.05).clamp(16.0, 26.0),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent, // Match InventoryScreen
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.deepOrangeAccent, // Match InventoryScreen
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(right: (screenWidth * 0.04).clamp(8.0, 16.0)),
              child: CircleAvatar(
                radius: (isLargeScreen ? 20.0 : screenWidth * 0.04).clamp(14.0, 22.0),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: (isLargeScreen ? 24.0 : screenWidth * 0.045).clamp(16.0, 26.0),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (constraints.maxWidth * 0.05).toDouble(),
                  vertical: (constraints.maxHeight * 0.02).toDouble(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchBarWidget(
                      screenWidth: constraints.maxWidth,
                      onSearchChanged: (value) {
                        // Implement search logic here
                      },
                    ),
                    SizedBox(height: (constraints.maxHeight * 0.02).toDouble()),
                    SalesAndTransactionsWidget(
                      screenWidth: constraints.maxWidth,
                      screenHeight: constraints.maxHeight,
                      salesData: salesData,
                    ),
                    SizedBox(height: (constraints.maxHeight * 0.02).toDouble()),
                    _buildCategoryFilter(
                      context,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    SizedBox(height: (constraints.maxHeight * 0.02).toDouble()),
                    _buildQuickActionsSection(
                      context,
                      isTablet,
                      isLargeScreen,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                  ],
                ),
              );
            },
          ),
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
          style: Theme.of(context).textTheme.headlineMedium ??
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: (screenHeight * 0.06).clamp(40.0, 60.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.03),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: index == 0 ? Colors.black : Colors.black87,
                            fontSize: (screenWidth * 0.04).clamp(12.0, 16.0),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
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
    final cardSize = (screenWidth *
            (isLargeScreen ? 0.22 : isTablet ? 0.28 : 0.3))
        .clamp(100.0, 200.0);
    final spacing = (screenWidth * 0.02).clamp(8.0, 16.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium ??
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: isLargeScreen ? 4 : isTablet ? 3 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          children: [
            QuickActionCard(
              title: 'New Sale',
              icon: Icons.add_shopping_cart,
              color: Colors.indigo[600]!,
              cardSize: cardSize,
            ),
            QuickActionCard(
              title: 'Inventory',
              icon: Icons.inventory,
              color: Colors.teal[400]!,
              cardSize: cardSize,
            ),
            QuickActionCard(
              title: 'Reports',
              icon: Icons.bar_chart,
              color: Colors.purple[400]!,
              cardSize: cardSize,
            ),
            QuickActionCard(
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.deepOrange[400]!,
              cardSize: cardSize,
            ),
            QuickActionCard(
              title: 'Customers',
              icon: Icons.group,
              color: Colors.blue[400]!,
              cardSize: cardSize,
            ),
            QuickActionCard(
              title: 'Analytics',
              icon: Icons.analytics,
              color: Colors.green[400]!,
              cardSize: cardSize,
            ),
          ],
        ),
      ],
    );
  }
}