import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodTrendsChart extends StatelessWidget {
  const MoodTrendsChart({
    required this.userMoodSpots,
    required this.sentimentScoreSpots,
    required this.dayLabels,
    super.key,
  });

  final List<FlSpot> userMoodSpots;
  final List<FlSpot> sentimentScoreSpots;
  final List<String> dayLabels; // Labels like ['Mon', 'Tue', 'Wed']

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// **Mood & Sentiment Graph**
        SizedBox(
          height: 225,
          child: LineChart(
            LineChartData(
              minY: -1,
              maxY: 5,
              minX: 0,
              maxX: 6,
              lineBarsData: [
                /// 🔵 **Mood Line (User Selected)**
                LineChartBarData(
                  spots: userMoodSpots,
                  isCurved: true,
                  color: Colors.blue,
                  // barWidth: 3,
                  // belowBarData: BarAreaData(show: true),
                  dotData: const FlDotData(show: true),
                ),

                /// 🔴 **Sentiment Line (AI Generated)**
                LineChartBarData(
                  spots: sentimentScoreSpots,
                  isCurved: true,
                  color: Colors.red,
                  // barWidth: 3,
                  // belowBarData: BarAreaData(show: true),
                  dotData: const FlDotData(show: true),
                ),
              ],

              /// 🏷 **Axis Titles**
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameSize: 6,
                  sideTitles: SideTitles(
                    reservedSize: 75,
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      return _leftAxisLabels(value.toInt());
                    },
                  ),
                ),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),

                /// **Bottom X-Axis Labels (Days)**
                bottomTitles: AxisTitles(
                  drawBelowEverything: false,
                  sideTitles: SideTitles(
                    reservedSize: 35,
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      int index = value.toInt();
                      if (index >= 0 && index < dayLabels.length) {
                        return Column(
                          children: [
                            Text(
                              index == dayLabels.length - 1
                                  ? '\t\t\t${dayLabels[index]}\n(today)\t'
                                  : '${dayLabels[index]}', // Label with day name
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),

        ///  **Legend for Colors**
        _buildLegend(),
      ],
    );
  }

  /// **Mood & Sentiment Labels (Y-Axis)**
  Widget _leftAxisLabels(int value) {
    switch (value) {
      case 6:
        return const Text(
          '',
          style: TextStyle(fontSize: 10, color: Colors.red),
        );
      case 5:
        return const Text(
          '😊 Happy',
          style: TextStyle(fontSize: 10),
        );
      case 4:
        return const Text(
          '😐 Neutral',
          style: TextStyle(fontSize: 10),
        );
      case 3:
        return const Text(
          '😢 Sad',
          style: TextStyle(fontSize: 10),
        );
      case 2:
        return const Text(
          '😠 Angry',
          style: TextStyle(fontSize: 10),
        );
      case 1:
        return const Text(
          '🟢 AI Positive',
          style: TextStyle(fontSize: 10, color: Colors.green),
        );
      case 0:
        return const Text(
          '🟡 AI Neutral',
          style: TextStyle(
            fontSize: 10,
            color: Colors.orange,
          ),
        );
      case -1:
        return const Text(
          '🔴 AI Negative',
          style: TextStyle(
            fontSize: 10,
            color: Colors.red,
          ),
        );
      case -2:
        return const Text(
          '',
          style: TextStyle(
            fontSize: 10,
            color: Colors.red,
          ),
        );

      default:
        return const Text('');
    }
  }

  /// **Chart Legend**
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.blue, 'Mood'),
        const SizedBox(width: 16),
        _legendItem(Colors.red, 'Sentiment (AI)'),
      ],
    );
  }

  /// **Legend Item (Color + Label)**
  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
