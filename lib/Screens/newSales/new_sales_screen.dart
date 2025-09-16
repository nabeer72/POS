import 'package:flutter/material.dart';
import 'package:pos/widgets/action_card.dart'; // Import QuickActionCard
import 'package:pos/widgets/search_bar.dart'; // Import SearchBarWidget

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  final List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;

  // Sample product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Product A',
      'price': 29.99,
      'category': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.indigo[600]!
    },
    {
      'name': 'Product B',
      'price': 19.99,
      'category': 'Clothing',
      'icon': Icons.checkroom,
      'color': Colors.teal[400]!
    },
    {
      'name': 'Product C',
      'price': 49.99,
      'category': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.purple[400]!
    },
    {
      'name': 'Product D',
      'price': 9.99,
      'category': 'Accessories',
      'icon': Icons.watch,
      'color': Colors.deepOrange[400]!
    },
    {
      'name': 'Product E',
      'price': 39.99,
      'category': 'Clothing',
      'icon': Icons.checkroom,
      'color': Colors.blue[400]!
    },
    {
      'name': 'Product F',
      'price': 24.99,
      'category': 'Accessories',
      'icon': Icons.watch,
      'color': Colors.green[400]!
    },
  ];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add({...product, 'quantity': 1});
      _totalAmount += product['price'];
    });
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = (_cartItems[index]['quantity'] as int) + change;
      if (newQuantity > 0) {
        _totalAmount += change * _cartItems[index]['price'];
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        _totalAmount -= _cartItems[index]['price'] * _cartItems[index]['quantity'];
        _cartItems.removeAt(index);
      }
    });
  }

  void _processCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checkout processed successfully!')),
    );
    setState(() {
      _cartItems.clear();
      _totalAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Sale',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.deepOrangeAccent, // Green background for the AppBar
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
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
                  // Search bar at the top
                  SearchBarWidget(
                    screenWidth: constraints.maxWidth,
                    onSearchChanged: (value) {
                      // Implement product search logic here
                    },
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildProductGrid(
                      context, isTablet, isLargeScreen, constraints.maxWidth),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  _buildCartSummary(context, constraints.maxWidth, constraints.maxHeight),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildCheckoutButton(context, constraints.maxWidth),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(
      BuildContext context, bool isTablet, bool isLargeScreen, double screenWidth) {
    final cardSize = screenWidth * 0.28; // Adjusted for 3 cards per row

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Fixed to 3 cards per row
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return QuickActionCard(
              title: product['name'],
              price: product['price'], // Pass price as double
              icon: product['icon'],
              color: product['color'],
              cardSize: cardSize,
              onTap: () => _addToCart(product),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCartSummary(
      BuildContext context, double screenWidth, double screenHeight) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart Summary',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: _cartItems.isEmpty ? 50 : screenHeight * 0.2,
              child: _cartItems.isEmpty
                  ? const Center(child: Text('Cart is empty'))
                  : ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => _updateQuantity(index, -1),
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _updateQuantity(index, 1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _cartItems.isEmpty ? null : _processCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Proceed to Checkout',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}