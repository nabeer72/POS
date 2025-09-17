import 'package:flutter/material.dart';
import 'package:pos/Services/Controllers/new_sales_controller.dart';
import 'package:pos/widgets/action_card.dart'; // Import QuickActionCard
import 'package:pos/widgets/search_bar.dart'; // Import SearchBarWidget
import 'package:mobile_scanner/mobile_scanner.dart'; // Import MobileScanner

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  late NewSaleController _controller;
  double _scannerHeight = 150; // Default small height for QR scanner

  @override
  void initState() {
    super.initState();
    _controller = NewSaleController(context);
  }

  @override
  void dispose() {
    // mobile_scanner doesn't require explicit controller disposal
    super.dispose();
  }

  Widget _buildMainContent(BuildContext context, BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    // ignore: unused_local_variable
    final screenHeight = constraints.maxHeight;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: constraints.maxWidth * 0.05,
        vertical: constraints.maxHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarWidget(
            screenWidth: constraints.maxWidth,
            onSearchChanged: (value) {
              // Implement product search logic here
            },
          ),
          SizedBox(height: constraints.maxHeight * 0.02),
          // QR Scanner placed below SearchBar
          if (_controller.isScanning)
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _scannerHeight = (_scannerHeight - details.delta.dy).clamp(100, 400);
                });
              },
              child: Container(
                height: _scannerHeight,
                color: Colors.black,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: _controller.qrScannerService.handleScanResult,
                      fit: BoxFit.cover,
                    ),
                    CustomScannerOverlay(),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => setState(() => _controller.setIsScanning(false)),
                      ),
                    ),
                    // Drag handle for resizing
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white.withOpacity(0.3),
                        height: 20,
                        child: const Center(
                          child: Icon(Icons.drag_handle, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() => _controller.setIsScanning(true)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Open QR Scanner',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          SizedBox(height: constraints.maxHeight * 0.02),
          _buildProductGrid(context, isTablet, isLargeScreen, constraints.maxWidth),
          SizedBox(height: constraints.maxHeight * 0.03),
          _buildCartSummary(context, constraints.maxWidth, constraints.maxHeight),
          SizedBox(height: constraints.maxHeight * 0.02),
          _buildCheckoutButton(context, constraints.maxWidth),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Sale',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white10,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: LayoutBuilder(
          builder: (context, constraints) => _buildMainContent(context, constraints),
        ),
      ),
    );
  }

  // Custom overlay for QR scan guide
  Widget CustomScannerOverlay() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(50),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54, // Semi-transparent to show camera
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(
      BuildContext context, bool isTablet, bool isLargeScreen, double screenWidth) {
    final cardSize = screenWidth * 0.28;

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
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: _controller.products.length,
          itemBuilder: (context, index) {
            final product = _controller.products[index];
            return QuickActionCard(
              title: product['name'],
              price: product['price'],
              icon: product['icon'],
              color: product['color'],
              cardSize: cardSize,
              onTap: () => _controller.addToCart(product),
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
              height: _controller.cartItems.isEmpty ? 50 : screenHeight * 0.2,
              child: _controller.cartItems.isEmpty
                  ? const Center(child: Text('Cart is empty'))
                  : ListView.builder(
                      itemCount: _controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _controller.cartItems[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => setState(() => _controller.updateQuantity(index, -1)),
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => setState(() => _controller.updateQuantity(index, 1)),
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
                  '\$${_controller.totalAmount.toStringAsFixed(2)}',
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
        onPressed: _controller.cartItems.isEmpty ? null : () => _controller.processCheckout(context),
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