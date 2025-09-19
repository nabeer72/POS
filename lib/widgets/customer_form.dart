import 'package:flutter/material.dart';
import 'package:pos/Services/Controllers/add_customer_controller.dart';
import 'package:pos/widgets/custom_textfield.dart';

class AddCustomerForm extends StatefulWidget {
  final CustomerController controller;
  final VoidCallback onCustomerAdded; // Callback to refresh the parent screen

  const AddCustomerForm({
    super.key,
    required this.controller,
    required this.onCustomerAdded,
  });

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cellNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  CustomerType _selectedType = CustomerType.regular;

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

    return Card(
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
              decoration: InputDecoration(
                labelText: 'Customer Type',
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
                  widget.controller.addCustomer(
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
                    _selectedType = CustomerType.regular;
                  });
                  widget.onCustomerAdded(); // Trigger refresh in parent
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
    );
  }
}