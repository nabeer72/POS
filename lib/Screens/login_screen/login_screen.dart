import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Services/Controllers/login_controller.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/custom_loader.dart';
import 'package:pos/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final loginController = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF455A64)], // Sober dark blue to gray gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White for strong contrast
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70, // Slightly muted white for subtitle
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                CustomTextField(
                  controller: loginController.emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: screenHeight * 0.02),
                Obx(() => CustomTextField(
                      controller: loginController.passwordController,
                      hintText: 'Password',
                      icon: Icons.lock,
                      obscureText: !loginController.isPasswordVisible.value,
                      showEyeIcon: true,
                      onEyeTap: loginController.togglePasswordVisibility,
                    )),
                SizedBox(height: screenHeight * 0.04),
                Obx(() => loginController.isLoading.value
                    ? const LoadingWidget()
                    : CustomButton(
                        text: 'Login',
                        onPressed: loginController.login,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}