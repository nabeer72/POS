import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for SystemChrome
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pos/Services/Controllers/report_controller.dart';
import 'dart:math' show max; // Added for reduce(max)

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.deepOrangeAccent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final ReportController controller = Get.put(ReportController());

    final screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final isTablet = screenWidth > 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sales Reports',
          style: TextStyle(
            fontSize: (isLargeScreen ? 24.0 : screenWidth * 0.05).clamp(16.0, 26.0),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: controller.fetchReportData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.salesData.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return Container(
          color: Colors.grey[100],
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (constraints.maxWidth * 0.05).toDouble(),
                  vertical: (constraints.maxHeight * 0.02).toDouble(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPeriodSelector(controller, screenWidth),
                    SizedBox(height: (constraints.maxHeight * 0.02).toDouble()),
                    _buildSummaryCards(controller, screenWidth),
                    SizedBox(height: (constraints.maxHeight * 0.02).toDouble()),
                    _buildSalesChart(controller, constraints.maxWidth, constraints.maxHeight),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPeriodSelector(ReportController controller, double screenWidth) {
    final periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final isSelected = controller.selectedPeriod.value == periods[index];
          return Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: GestureDetector(
              onTap: () => controller.changePeriod(periods[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepOrangeAccent : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepOrangeAccent),
                ),
                child: Text(
                  periods[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(ReportController controller, double screenWidth) {
    final summary = controller.summary;
    final cardSize = (screenWidth * 0.4).clamp(120.0, 180.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryCard(
          'Total Sales',
          '\$${summary['totalAmount']?.toStringAsFixed(2) ?? '0.00'}',
          Icons.trending_up,
          cardSize,
        ),
        _buildSummaryCard(
          'Transactions',
          '${summary['totalCount'] ?? 0}',
          Icons.receipt,
          cardSize,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, double size) {
    return Container(
      width: size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.deepOrangeAccent, size: 32),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSalesChart(ReportController controller, double screenWidth, double screenHeight) {
    final data = controller.salesData;
    if (data.isEmpty) {
      return Container(
        height: (screenHeight * 0.4).clamp(200.0, 300.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
        ),
        child: const Center(child: Text('No chart data available')),
      );
    }

    // Calculate maxY safely
    double maxY = 1000.0; // Fallback value
    if (data.isNotEmpty) {
      maxY = (data.map((d) => (d['amount'] as num?)?.toDouble() ?? 0.0).reduce(max) * 1.1);
    }

    return Container(
      height: (screenHeight * 0.4).clamp(200.0, 300.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(
            '${controller.selectedPeriod.value} Sales',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[index]['date']?.toString() ?? '',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (item['amount'] as num?)?.toDouble() ?? 0.0,
                        color: Colors.deepOrangeAccent,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}