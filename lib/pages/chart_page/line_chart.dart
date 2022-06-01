import 'package:account_book/dao/finance_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

class CustomLineChart extends StatefulWidget {
  CustomLineChart({this.statisticData, this.type = '', Key? key})
      : super(key: key);

  final StatisticsData? statisticData;

  final String type;

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
        chartData(statisticData: widget.statisticData, type: widget.type));
  }
}

LineChartData chartData({StatisticsData? statisticData, String type = 'week'}) {
  final finances = statisticData?.finances ?? [];
  final spotData = finances.asMap().entries.map((entry) {
    int index = entry.key;
    return FlSpot(double.parse('$index'), double.parse(entry.value[1]));
  }).toList();
  final maxValue = finances.isEmpty
      ? 50.toDouble()
      : finances
          .map((item) {
            return double.parse(item[1]);
          })
          .toList()
          .reduce(max);
  final dates = finances.asMap().entries.map((entry) {
    return entry.value
        .elementAt(0)
        .split('-')
        .skip(type == 'year' ? 1 : 2)
        .join('-');
  }).toList();

  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey[500],
          strokeWidth: 0,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.grey[500],
          strokeWidth: 0,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (value) {
          try {
            dates.elementAt(value.toInt());
          } catch (e) {
            return '';
          }
          return value.toInt().isEven && dates.isNotEmpty
              ? dates.elementAt(value.toInt())
              : '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff67727d),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          return ((value.toInt() %
                      (maxValue == 0 ? 10 : (maxValue / 100).ceil() * 10)) ==
                  0)
              ? value.toInt().toString()
              : '';
          // return '';
        },
        reservedSize: 28,
        margin: 12,
      ),
    ),
    borderData: FlBorderData(
        show: true,
        border: Border(
            left: BorderSide(color: Colors.grey[500]!, width: 1),
            bottom: BorderSide(color: Colors.grey[500]!, width: 1))
        // border: Border.all(color: Colors.grey[500]!, width: 1)
        ),
    minX: 0,
    maxX: finances.length.toDouble(),
    minY: 0,
    maxY: maxValue,
    lineBarsData: [
      LineChartBarData(
        spots: spotData,
        isCurved: true,
        curveSmoothness: 0,
        colors: gradientColors,
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    ],
  );
}
