import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Screens/Loader/loader.dart';
import 'package:pos/Services/Controllers/favourites_screen_controller.dart';

// Constants for styling
const _primaryColor = Color(0xFF1A237E);
const _cardColor = Colors.white;

void main() {
    Get.put(FavoritesController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'POS Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold, color: _primaryColor),
          headlineMedium: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.w600, color: _primaryColor),
          bodyMedium: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.black87),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: _cardColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
