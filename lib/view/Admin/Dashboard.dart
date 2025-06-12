import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final Map<String, dynamic> data = {
    "tongDonHang": 1250,
    "tongShipper": 85,
    "tongKhach": 542,
    "tongPhuongTien": 37,
    "doanhThuTheoThang": {
      "01/2025": 102000000,
      "02/2025": 98000000,
      "03/2025": 120000000,
      "04/2025": 110500000,
      "05/2025": 130000000,
      "06/2025": 95000000,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("Tổng đơn hàng", "${data['tongDonHang']}", Colors.blue),
              _buildStatCard("Số phương tiện", "${data['tongPhuongTien']}", Colors.green),
              _buildStatCard("Số shipper", "${data['tongShipper']}", Colors.orange),
              _buildStatCard("Số khách hàng", "${data['tongKhach']}", Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Biểu đồ doanh thu theo tháng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          RevenueChart(data['doanhThuTheoThang']),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RevenueChart extends StatelessWidget {
  final Map<String, int> doanhThuTheoThang;

  const RevenueChart(this.doanhThuTheoThang, {super.key});

  @override
  Widget build(BuildContext context) {
    final barGroups = doanhThuTheoThang.entries.map((entry) {
      final month = entry.key.split('/')[0]; // Lấy tháng
      final revenue = entry.value / 1000000; // Chuyển doanh thu sang triệu
      return BarChartGroupData(
        x: int.parse(month),
        barRods: [
          BarChartRodData(
            toY: revenue,
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10, // Hiển thị doanh thu cách nhau 10 triệu
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}M',
                    style: const TextStyle(fontSize: 12, color: Colors.black),
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
                      return const Text('T1', style: TextStyle(fontSize: 12, color: Colors.black));
                    case 2:
                      return const Text('T2', style: TextStyle(fontSize: 12, color: Colors.black));
                    case 3:
                      return const Text('T3', style: TextStyle(fontSize: 12, color: Colors.black));
                    case 4:
                      return const Text('T4', style: TextStyle(fontSize: 12, color: Colors.black));
                    case 5:
                      return const Text('T5', style: TextStyle(fontSize: 12, color: Colors.black));
                    case 6:
                      return const Text('T6', style: TextStyle(fontSize: 12, color: Colors.black));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}