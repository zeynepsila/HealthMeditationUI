import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  final List<int> meditationData;
  final List<int> exerciseData;

  const WeeklyChart({
    super.key,
    required this.meditationData,
    required this.exerciseData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          barGroups: List.generate(7, (index) {
            return BarChartGroupData(x: index, barRods: [
              BarChartRodData(
                toY: meditationData[index].toDouble(),
                color: Colors.teal,
                width: 8,
              ),
              BarChartRodData(
                toY: exerciseData[index].toDouble(),
                color: Colors.orange,
                width: 8,
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
