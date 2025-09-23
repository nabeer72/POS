import 'package:flutter/material.dart';
import 'package:pos/Services/Controllers/add_customer_controller.dart';
import 'package:pos/widgets/customer_form.dart'; // Import the new form widget

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});
  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late CustomerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomerController();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Add Customer',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white10,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Form
              AddCustomerForm(
                controller: _controller,
                onCustomerAdded: () {
                  setState(() {}); // Refresh the customer list
                },
              ),
              const SizedBox(height: 24),
              // Customer List
              Text(
                'Customers',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              _controller.customers.isEmpty
                  ? const Center(child: Text('No customers added'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _controller.customers.length,
                      itemBuilder: (context, index) {
                        final customer = _controller.customers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(customer.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type: ${customer.type.toString().split('.').last}'),
                                if (customer.address != null) Text('Address: ${customer.address}'),
                                if (customer.cellNumber != null) Text('Cell: ${customer.cellNumber}'),
                                if (customer.email != null) Text('Email: ${customer.email}'),
                                Text('Status: ${customer.isActive ? 'Active' : 'Deactive'}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                customer.isActive ? Icons.toggle_on : Icons.toggle_off,
                                color: customer.isActive ? Colors.green : Colors.grey,
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  _controller.toggleCustomerStatus(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}