import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Screens/button_bar.dart';
import 'package:pos/widgets/custom_loader.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(BottomNavigation());
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
         color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(  'assets/loader.png', width: 250, height: 250),
              const Text(
                'POS App',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),
              const LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}