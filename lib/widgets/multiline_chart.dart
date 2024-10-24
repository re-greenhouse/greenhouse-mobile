import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
        lineChartBarData1_4,
        lineChartBarData1_5,
        lineChartBarData1_6,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
        lineChartBarData2_3,
        lineChartBarData2_4,
        lineChartBarData2_5,
        lineChartBarData2_6,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '35';
        break;
      case 2:
        text = '40';
        break;
      case 3:
        text = '45';
        break;
      case 4:
        text = '50';
        break;
      case 5:
        text = '55';
        break;
      case 6:
        text = '60';
        break;
      case 7:
        text = '65';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('12', style: style);
        break;
      case 3:
        text = const Text('24', style: style);
        break;
      case 5:
        text = const Text('36', style: style);
        break;
      case 7:
        text = const Text('48', style: style);
        break;
      case 9:
        text = const Text('60', style: style);
        break;
      case 11:
        text = const Text('72', style: style);
        break;
      case 13:
        text = const Text('84', style: style);
        break;
      case 15:
        text = const Text('96', style: style);
        break;
      case 17:
        text = const Text('108', style: style);
        break;
      case 19:
        text = const Text('120', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color.fromARGB(255, 168, 243, 170),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 1.5),
          FlSpot(5, 1.4),
          FlSpot(7, 3.4),
          FlSpot(10, 2),
          FlSpot(12, 1.5),
          FlSpot(13, 1),
          FlSpot(14, 0.5),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Color.fromARGB(255, 227, 255, 18),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Color.fromARGB(255, 227, 255, 18).withOpacity(0),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.0),
          FlSpot(13, 1.5),
          FlSpot(14, 1),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Color.fromRGBO(84, 235, 255, 1),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(12, 1.0),
          FlSpot(13, 0.8),
          FlSpot(14, 0.5),
        ],
      );

  LineChartBarData get lineChartBarData1_4 => LineChartBarData(
        isCurved: true,
        color: Color.fromRGBO(255, 0, 0, 1),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2),
          FlSpot(3, 2.5),
          FlSpot(5, 3.2),
          FlSpot(7, 2.8),
          FlSpot(10, 1.5),
          FlSpot(12, 1.2),
          FlSpot(13, 0.8),
        ],
      );

  LineChartBarData get lineChartBarData1_5 => LineChartBarData(
        isCurved: true,
        color: Color.fromRGBO(0, 0, 255, 1),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3),
          FlSpot(3, 3.2),
          FlSpot(5, 2.2),
          FlSpot(7, 3.6),
          FlSpot(10, 1.8),
          FlSpot(12, 1.4),
          FlSpot(13, 1),
        ],
      );

  LineChartBarData get lineChartBarData1_6 => LineChartBarData(
        isCurved: true,
        color: Color.fromRGBO(255, 165, 0, 1),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.3),
          FlSpot(3, 2.7),
          FlSpot(5, 3.1),
          FlSpot(7, 2.9),
          FlSpot(10, 2.0),
          FlSpot(12, 1.5),
          FlSpot(13, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.green.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 1.8),
          FlSpot(12, 1.4),
          FlSpot(13, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: Color.fromARGB(255, 227, 255, 18).withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color.fromARGB(255, 227, 255, 18).withOpacity(0.2),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 1.5),
          FlSpot(13, 1),
          FlSpot(14, 0.5),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.cyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 1.4),
          FlSpot(12, 1),
          FlSpot(13, 0.5),
        ],
      );

  LineChartBarData get lineChartBarData2_4 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Color.fromRGBO(255, 0, 0, 0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2),
          FlSpot(3, 2.5),
          FlSpot(5, 3.2),
          FlSpot(7, 2.8),
          FlSpot(10, 1.4),
          FlSpot(12, 1.0),
          FlSpot(13, 0.5),
        ],
      );

  LineChartBarData get lineChartBarData2_5 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Color.fromRGBO(0, 0, 255, 0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3),
          FlSpot(3, 3.2),
          FlSpot(5, 2.2),
          FlSpot(7, 3.6),
          FlSpot(10, 1.8),
          FlSpot(12, 1.4),
          FlSpot(13, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_6 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Color.fromRGBO(255, 165, 0, 0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.3),
          FlSpot(3, 2.7),
          FlSpot(5, 2.9),
          FlSpot(7, 2.9),
          FlSpot(10, 2.0),
          FlSpot(12, 1.5),
          FlSpot(13, 1),
        ],
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(isShowingMainData: isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
