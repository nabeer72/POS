import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent, // Keep background white as requested
        foregroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Full width with minimal padding
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        minimumSize: Size(screenWidth * 0.9, 0), // Full width minus padding
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}