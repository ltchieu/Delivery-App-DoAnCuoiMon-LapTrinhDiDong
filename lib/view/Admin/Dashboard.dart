import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Static extends StatelessWidget {
  const Static({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đặt màu nền trắng
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("Tổng đơn hàng", "120", Colors.blue),
              _buildStatCard("Số phương tiện", "₫45,000,000", Colors.green),
              _buildStatCard("Số shipper", "8", Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Biểu đồ doanh thu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 200, child: RevenueChart()),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text(title, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ]),
        ),
      ),
    );
  }
}

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5000, color: Colors.blue)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 10000, color: Colors.blue)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15000, color: Colors.blue)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 20000, color: Colors.blue)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 25000, color: Colors.blue)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 30000, color: Colors.blue)]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5000, // Hiển thị giá trị cách nhau 5000
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white), // Đổi màu và kích thước
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return const Text('T1', style: TextStyle(fontSize: 12, color: Colors.white)); // Đổi màu và kích thước
                  case 2:
                    return const Text('T2', style: TextStyle(fontSize: 12, color: Colors.white));
                  case 3:
                    return const Text('T3', style: TextStyle(fontSize: 12, color: Colors.white));
                  case 4:
                    return const Text('T4', style: TextStyle(fontSize: 12, color: Colors.white));
                  case 5:
                    return const Text('T5', style: TextStyle(fontSize: 12, color: Colors.white));
                  case 6:
                    return const Text('T6', style: TextStyle(fontSize: 12, color: Colors.white));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true), // Hiển thị lưới
        borderData: FlBorderData(show: true), // Hiển thị viền
      ),
    );
  }
}