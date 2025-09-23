import 'package:get/get.dart';
import 'dart:math'; // For mock data generation

class ReportController extends GetxController {
  var selectedPeriod = 'Daily'.obs; // Reactive period selection
  var isLoading = true.obs;
  var salesData = <Map<String, dynamic>>[].obs; // List of {date: '2025-09-23', amount: 1800.75, count: 60}
  var summary = {'totalAmount': 0.0, 'totalCount': 0}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportData();
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    isLoading.value = true;
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock data generation (replace with real API, e.g., daily_sales table query)
    final now = DateTime.now();
    final random = Random();
    salesData.clear();
    double totalAmount = 0;
    int totalCount = 0;

    switch (selectedPeriod.value) {
      case 'Daily':
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final amount = (random.nextDouble() * 1000 + 500).toDouble(); // Random sales 500-1500
          final count = random.nextInt(50) + 20; // 20-70 transactions
          salesData.add({
            'date': '${date.day}/${date.month}',
            'amount': amount,
            'count': count,
          });
          totalAmount += amount;
          totalCount += count;
        }
        break;
      case 'Weekly':
        for (int i = 3; i >= 0; i--) {
          final weekStart = now.subtract(Duration(days: i * 7));
          final amount = (random.nextDouble() * 5000 + 2000).toDouble();
          final count = random.nextInt(200) + 100;
          salesData.add({
            'date': 'Week ${weekStart.weekday}',
            'amount': amount,
            'count': count,
          });
          totalAmount += amount;
          totalCount += count;
        }
        break;
      case 'Monthly':
        for (int i = 5; i >= 0; i--) {
          final month = now.subtract(Duration(days: i * 30));
          final amount = (random.nextDouble() * 20000 + 10000).toDouble();
          final count = random.nextInt(800) + 400;
          salesData.add({
            'date': 'Month ${month.month}',
            'amount': amount,
            'count': count,
          });
          totalAmount += amount;
          totalCount += count;
        }
        break;
      case 'Yearly':
        for (int i = 4; i >= 0; i--) {
          final year = now.subtract(Duration(days: i * 365));
          final amount = (random.nextDouble() * 100000 + 50000).toDouble();
          final count = random.nextInt(5000) + 2000;
          salesData.add({
            'date': 'Year ${year.year}',
            'amount': amount,
            'count': count,
          });
          totalAmount += amount;
          totalCount += count;
        }
        break;
    }

    summary.value = {'totalAmount': totalAmount, 'totalCount': totalCount};
    isLoading.value = false;
  }
}