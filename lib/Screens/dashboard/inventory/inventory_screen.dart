import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/widgets/action_card.dart';
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Sample inventory data
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Product A',
      'price': 29.99,
      'quantity': 50,
      'category': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.indigo[600]!
    },
    {
      'name': 'Product B',
      'price': 19.99,
      'quantity': 30,
      'category': 'Clothing',
      'icon': Icons.checkroom,
      'color': Colors.teal[400]!
    },
    {
      'name': 'Product C',
      'price': 49.99,
      'quantity': 20,
      'category': 'Electronics',
      'icon': Icons.devices,
      'color': Colors.purple[400]!
    },
    {
      'name': 'Product D',
      'price': 9.99,
      'quantity': 100,
      'category': 'Accessories',
      'icon': Icons.watch,
      'color': Colors.deepOrange[400]!
    },
    {
      'name': 'Product E',
      'price': 39.99,
      'quantity': 15,
      'category': 'Clothing',
      'icon': Icons.checkroom,
      'color': Colors.blue[400]!
    },
    {
      'name': 'Product F',
      'price': 24.99,
      'quantity': 40,
      'category': 'Accessories',
      'icon': Icons.watch,
      'color': Colors.green[400]!
    },
  ];

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    String? selectedCategory;
    IconData selectedIcon = Icons.devices;
    Color selectedColor = Colors.indigo[600]!;

    // Dynamically get unique non-null categories from _inventoryItems
    final categories = _inventoryItems
        .where((item) => item['category'] != null)
        .map((item) => item['category'] as String)
        .toSet()
        .toList();
    
    final icons = {
      'Electronics': Icons.devices,
      'Clothing': Icons.checkroom,
      'Accessories': Icons.watch,
    };
    final colors = {
      'Electronics': Colors.indigo[600]!,
      'Clothing': Colors.teal[400]!,
      'Accessories': Colors.deepOrange[400]!,
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white, // Set dialog background to white
              title: const Text('Add New Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value;
                          selectedIcon = icons[value] ?? Icons.devices;
                          selectedColor = colors[value] ?? Colors.indigo[600]!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim());
                    final quantity = int.tryParse(quantityController.text.trim());

                    if (name.isEmpty || price == null || quantity == null || selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields correctly')),
                      );
                      return;
                    }

                    setState(() {
                      _inventoryItems.add({
                        'name': name,
                        'price': price,
                        'quantity': quantity,
                        'category': selectedCategory,
                        'icon': selectedIcon,
                        'color': selectedColor,
                      });
                    });

                    Navigator.pop(context); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$name added to inventory')),
                    );
                    Get.back(); // Navigate back to DashboardScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Add Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = (_inventoryItems[index]['quantity'] as int) + change;
      if (newQuantity >= 0) {
        _inventoryItems[index]['quantity'] = newQuantity;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot reduce quantity below 0 for ${_inventoryItems[index]['name']}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

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
          'Inventory',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
            color: Colors.white,
          ),
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Placeholder for refreshing inventory data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inventory refreshed')),
              );
            },
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
                  _buildInventorySearch(context, constraints.maxWidth),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildInventoryGrid(context, constraints.maxWidth),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  _buildAddInventoryButton(context, constraints.maxWidth),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildInventorySummary(context, constraints.maxWidth, constraints.maxHeight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInventorySearch(BuildContext context, double screenWidth) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search inventory items...',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        // Implement inventory search logic here
      },
    );
  }

  Widget _buildInventoryGrid(BuildContext context, double screenWidth) {
    final cardSize = screenWidth * 0.28; // Adjusted for 3 cards per row

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventory Items',
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
          itemCount: _inventoryItems.length,
          itemBuilder: (context, index) {
            final item = _inventoryItems[index];
            return QuickActionCard(
              title: item['name'],
              price: item['price'], // Pass price as double
              icon: item['icon'],
              color: item['color'],
              cardSize: cardSize,
              onTap: () {
                // Placeholder for item details or edit action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected ${item['name']}')),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddInventoryButton(BuildContext context, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showAddItemDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Add to Inventory',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInventorySummary(
      BuildContext context, double screenWidth, double screenHeight) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Summary',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: screenHeight * 0.2,
              child: ListView.builder(
                itemCount: _inventoryItems.length,
                itemBuilder: (context, index) {
                  final item = _inventoryItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Price: \$${item['price'].toStringAsFixed(2)}'),
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
          ],
        ),
      ),
    );
  }
}