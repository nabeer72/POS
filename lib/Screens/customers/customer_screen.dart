import 'package:flutter/material.dart';
import 'package:pos/Services/Controllers/add_customer_controller.dart';
import 'package:pos/widgets/custom_textfield.dart'; // Import CustomTextField

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  late CustomerController _controller;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cellNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  CustomerType _selectedType = CustomerType.regular;

  @override
  void initState() {
    super.initState();
    _controller = CustomerController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cellNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Customer',
          style: TextStyle(
            fontSize: isLargeScreen ? 24 : screenWidth * 0.05,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
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
              Card(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Customer',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Customer Name',
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _addressController,
                        hintText: 'Address',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _cellNumberController,
                        hintText: 'Cell Number',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<CustomerType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Customer Type',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white, // Match CustomTextField for consistency
                        ),
                        items: CustomerType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.addCustomer(
                              context,
                              _nameController.text,
                              _addressController.text,
                              _cellNumberController.text,
                              _emailController.text,
                              _selectedType,
                            );
                            setState(() {
                              _nameController.clear();
                              _addressController.clear();
                              _cellNumberController.clear();
                              _emailController.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Add Customer',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
