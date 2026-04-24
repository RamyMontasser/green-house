import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:green_house/feature/data/models/sensor_model.dart';

class SensorChart extends StatelessWidget {
  final List<SensorModel> data;

  const SensorChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        
        borderData: FlBorderData(show: false),

        lineBarsData: [
          // Temperature
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.temp);
            }).toList(),
            isCurved: true,
            barWidth: 3,
          ),

          // Humidity
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.humidity);
            }).toList(),
            isCurved: true,
            barWidth: 3,
          ),
        ],
      ),
    );
  }
}
