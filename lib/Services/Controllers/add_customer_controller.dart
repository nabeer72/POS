import 'package:flutter/material.dart';

enum CustomerType { regular, walkIn }

class Customer {
  final String name;
  final String? address;
  final String? cellNumber;
  final String? email;
  final CustomerType type;
  bool isActive; // Non-nullable bool

  Customer({
    required this.name,
    this.address,
    this.cellNumber,
    this.email,
    required this.type,
    this.isActive = true, // Default to true, ensuring non-null
  });
}

class CustomerController {
  final List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  void addCustomer(
    BuildContext context,
    String name,
    String? address,
    String? cellNumber,
    String? email,
    CustomerType type,
  ) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer name cannot be empty')),
      );
      return;
    }
    _customers.add(Customer(
      name: name,
      address: address != null && address.isEmpty ? null : address,
      cellNumber: cellNumber != null && cellNumber.isEmpty ? null : cellNumber,
      email: email != null && email.isEmpty ? null : email,
      type: type,
      isActive: true, // Explicitly non-nullable
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${type.toString().split('.').last} customer: $name')),
    );
  }

  void toggleCustomerStatus(int index) {
    // No null check needed since isActive is non-nullable
    _customers[index].isActive = !_customers[index].isActive;
  }
}