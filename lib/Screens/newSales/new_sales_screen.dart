import 'package:flutter/material.dart';
import 'package:pos/Services/Controllers/add_customer_controller.dart';
import 'package:pos/Services/Controllers/new_sales_controller.dart';
import 'package:pos/widgets/action_card.dart';
import 'package:pos/widgets/customer_form.dart';
import 'package:pos/widgets/search_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  late NewSaleController _controller;
  late CustomerController _customerController;
  double _scannerHeight = 150;

  @override
  void initState() {
    super.initState();
    _controller = NewSaleController(context);
    _customerController = CustomerController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Popup for adding a new customer via FAB
  void _showAddCustomerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Customer'),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95, // Increased width
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: AddCustomerForm(
                controller: _customerController,
                onCustomerAdded: () {
                  setState(() {}); // Refresh main screen
                  Navigator.of(dialogContext).pop(); // Close dialog after adding
                },
              ),
            ),
          ),
        );
      },
    );
  }


void _showCustomerSelectionDialog(BuildContext context) {
  String? selectedCustomer;
  // Dummy customer data
  final List<Map<String, String>> _dummyCustomers = [
    {'name': 'John Doe'},
    {'name': 'Jane Smith'},
    {'name': 'Alex Johnson'},
    {'name': 'Emily Brown'},
  ];

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            titlePadding: const EdgeInsets.only(left: 24, top: 24, right: 8, bottom: 0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Customer'),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCustomer,
                      decoration: InputDecoration(
                        labelText: 'Select Customer',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _dummyCustomers
                          .map((customer) => DropdownMenuItem(
                                value: customer['name'],
                                child: Text(customer['name']!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        dialogSetState(() {
                          selectedCustomer = value;
                        });
                      },
                      hint: _dummyCustomers.isEmpty
                          ? const Text('No customers available')
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: selectedCustomer != null
                    ? () {
                        // Assuming _controller.processCheckout is defined elsewhere
                        _controller.processCheckout(context, selectedCustomer);
                        Navigator.of(dialogContext).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Checkout processed for $selectedCustomer'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomerDialog(context),
        backgroundColor: Colors.deepOrangeAccent,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

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
            color: Colors.black54,
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
              onTap: () {
                setState(() {
                  _controller.addToCart(product);
                });
              
              },
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
        onPressed: _controller.cartItems.isEmpty
            ? null
            : () => _showCustomerSelectionDialog(context),
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