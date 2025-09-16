import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final double screenWidth;
  final Function(String)? onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.screenWidth,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search transactions or customers...',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onSearchChanged,
    );
  }
}