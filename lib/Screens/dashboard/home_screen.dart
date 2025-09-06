
import 'package:flutter/material.dart';
import 'package:pos/widgets/action_card.dart';
import 'package:pos/widgets/transaction_card.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    // Polymorphic white-type background based on screen size
    final backgroundGradient = isLargeScreen
        ? LinearGradient(
            colors: [Colors.white, Colors.blueGrey[50]!],
            stops: [0.0, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : isTablet
            ? LinearGradient(
                colors: [Colors.white, Colors.grey[50]!],
                stops: [0.0, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'POS Dashboard',
          style: TextStyle(fontSize: isLargeScreen ? 24 : screenWidth * 0.05, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: CircleAvatar(
              radius: isLargeScreen ? 20 : screenWidth * 0.04,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: isLargeScreen ? 24 : screenWidth * 0.045, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
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
                  _buildSalesSummary(context, constraints.maxWidth, constraints.maxHeight),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildSearchBar(context, constraints.maxWidth),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildTransactionsSection(context, constraints.maxWidth, constraints.maxHeight),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  _buildCategoryFilter(context, constraints.maxWidth, constraints.maxHeight),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildQuickActionsSection(context, isTablet, isLargeScreen, constraints.maxWidth, constraints.maxHeight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSalesSummary(BuildContext context, double screenWidth, double screenHeight) {
    return Card(
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
                  '\$1,250.00',
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
                  '42',
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
    );
  }

  Widget _buildSearchBar(BuildContext context, double screenWidth) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search transactions or customers...',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Implement search logic here
      },
    );
  }

  Widget _buildCategoryFilter(BuildContext context, double screenWidth, double screenHeight) {
    final categories = ['All', 'Sales', 'Inventory', 'Reports', 'Settings'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: index == 0
                            ? const LinearGradient(
                                colors: [Colors.purple, Colors.deepPurpleAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: index == 0 ? null : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: index == 0 ? Colors.white : Colors.black87,
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

  Widget _buildQuickActionsSection(
      BuildContext context, bool isTablet, bool isLargeScreen, double screenWidth, double screenHeight) {
    final cardSize = screenWidth * (isLargeScreen ? 0.22 : isTablet ? 0.28 : 0.3);
    final crossAxisCount = isLargeScreen ? 4 : isTablet ? 3 : 3;
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
            QuickActionCard(title: 'New Sale', icon: Icons.add_shopping_cart, color: Colors.indigo[600]!, cardSize: cardSize),
            QuickActionCard(title: 'Inventory', icon: Icons.inventory, color: Colors.teal[400]!, cardSize: cardSize),
            QuickActionCard(title: 'Reports', icon: Icons.bar_chart, color: Colors.purple[400]!, cardSize: cardSize),
            QuickActionCard(title: 'Settings', icon: Icons.settings, color: Colors.deepOrange[400]!, cardSize: cardSize),
            QuickActionCard(title: 'Customers', icon: Icons.group, color: Colors.blue[400]!, cardSize: cardSize),
            QuickActionCard(title: 'Analytics', icon: Icons.analytics, color: Colors.green[400]!, cardSize: cardSize),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: screenHeight * 0.15,
          child: PageView(
            children: [
              TransactionCard(orderId: 'Order #1234', amount: '\$150.00', status: 'Completed', screenWidth: screenWidth),
              TransactionCard(orderId: 'Order #1235', amount: '\$89.50', status: 'Pending', screenWidth: screenWidth),
              TransactionCard(orderId: 'Order #1236', amount: '\$200.00', status: 'Completed', screenWidth: screenWidth),
            ],
          ),
        ),
      ],
    );
  }
}