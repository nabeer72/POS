import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pos/Services/Controllers/report_controller.dart';
import 'package:pos/widgets/sales_card.dart'; // Import SalesAndTransactionsWidget
import 'dart:math' show max;

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
    final screenHeight = MediaQuery.of(context).size.height;
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
                    SalesAndTransactionsWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      salesData: {
                        'amount': controller.summary['totalAmount'] ?? 0.0,
                        'transactionCount': controller.summary['totalCount'] ?? 0,
                      },
                    ),
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

    double maxY = 1000.0;
    if (data.isNotEmpty) {
      maxY = (data.map((d) => (d['amount'] as num?)?.toDouble() ?? 0.0).reduce(max) * 1.2);
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
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipColor: (_) => Colors.deepOrangeAccent.withOpacity(0.8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = data[groupIndex];
                      return BarTooltipItem(
                        '\$${rod.toY.toStringAsFixed(2)}\n${item['date']}',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return SideTitleWidget(
                            meta: meta, // Required parameter
                            angle: 45 * 3.14159 / 180, // Rotate 45 degrees
                            space: 8.0,
                            child: Text(
                              data[index]['date']?.toString() ?? '',
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '\$${value.toInt()}',
                        style: const TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
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
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepOrangeAccent,
                            Colors.orangeAccent.shade100,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: (screenWidth / data.length / 2).clamp(10.0, 20.0),
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}