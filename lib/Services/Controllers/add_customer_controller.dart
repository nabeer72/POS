import 'package:flutter/material.dart';

enum CustomerType { regular, vip, wholesale }

class Customer {
  final String name;
  final String? address;
  final String? cellNumber;
  final String? email;
  final CustomerType type;
  bool isActive;

  Customer({
    required this.name,
    this.address,
    this.cellNumber,
    this.email,
    required this.type,
    this.isActive = true,
  });
}

class CustomerController {
  List<Customer> customers = [];

  void addCustomer(
    BuildContext context,
    String name,
    String address,
    String cellNumber,
    String email,
    CustomerType type,
  ) {
    customers.add(Customer(
      name: name,
      address: address.isEmpty ? null : address,
      cellNumber: cellNumber.isEmpty ? null : cellNumber,
      email: email.isEmpty ? null : email,
      type: type,
    ));
  }

  void toggleCustomerStatus(int index) {
    if (index >= 0 && index < customers.length) {
      customers[index].isActive = !customers[index].isActive;
    }
  }
}