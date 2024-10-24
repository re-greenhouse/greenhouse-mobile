import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample4 extends StatelessWidget {
  LineChartSample4({
    super.key,
    Color? mainLineColor,
    Color? belowLineColor,
    Color? aboveLineColor,
  })  : mainLineColor = mainLineColor ?? Colors.red.withOpacity(1),
        belowLineColor = belowLineColor ?? Colors.black.withOpacity(1),
        aboveLineColor = aboveLineColor ?? Colors.black.withOpacity(0.7);

  final Color mainLineColor;
  final Color belowLineColor;
  final Color aboveLineColor;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '1';
        break;
      case 1:
        text = '12';
        break;
      case 2:
        text = '24';
        break;
      case 3:
        text = '36';
        break;
      case 4:
        text = '48';
        break;
      case 5:
        text = '60';
        break;
      case 6:
        text = '72';
        break;
      case 7:
        text = '84';
        break;
      case 8:
        text = '96';
        break;
      case 9:
        text = '108';
        break;
      case 10:
        text = '120';
        break;
      case 11:
        text = '132';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: belowLineColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value * 10}', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 28,
          top: 22,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 4),
                  FlSpot(1, 3.5),
                  FlSpot(2, 4.5),
                  FlSpot(3, 1),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                  FlSpot(6, 6.5),
                  FlSpot(7, 6),
                  FlSpot(8, 4),
                  FlSpot(9, 6),
                  FlSpot(10, 6),
                  FlSpot(11, 7),
                ],
                isCurved: true,
                barWidth: 8,
                color: mainLineColor,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Text(
                  'Time from mixing/filling bunker (hours)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4C6444),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 18,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 20,
                axisNameWidget: const Text(
                  'Temperature (°C)',
                  style: TextStyle(
                    color: Color(0xFF67864A),
                  ),
                ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 40,
                  getTitlesWidget: leftTitleWidgets,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.black,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}
