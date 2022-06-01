import 'dart:math';

import 'package:account_book/dao/finance_dao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final Color rightBarColor = Colors.lightGreen[400]!;
final Color leftBarColor = const Color(0xffff5182);
final double width = 3;

class CustomBarChart extends StatefulWidget {
  CustomBarChart({this.statisticData, this.type = '', Key? key})
      : super(key: key);

  final StatisticsData? statisticData;

  final String type;

  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final finances = widget.statisticData?.finances ?? [];
    final groupData = finances.asMap().entries.map((entry) {
      int index = entry.key;
      return makeGroupData(
          index, double.parse(entry.value[1]), double.parse(entry.value[2]));
    }).toList();
    final dates = finances.asMap().entries.map((entry) {
      return entry.value
          .elementAt(0)
          .split('-')
          .skip(widget.type == 'month' ? 2 : 1)
          .join('-');
    }).toList();

    final maxPayValue = finances.isEmpty
        ? 50.toDouble()
        : finances
            .map((item) {
              return double.parse(item[1]);
            })
            .toList()
            .reduce(max);
    final maxIncomeValue = finances.isEmpty
        ? 50.toDouble()
        : finances
            .map((item) {
              return double.parse(item[2]);
            })
            .toList()
            .reduce(max);
    final maxValue = max<double>(maxPayValue, maxIncomeValue);
    final valueInterval = (maxValue / 6).round();
    final maxValueLength = '$valueInterval'.length;

    return BarChart(
      BarChartData(
        maxY: maxValue,

        // barTouchData: BarTouchData(
        //   enabled: false,
        //   touchTooltipData: BarTouchTooltipData(
        //     tooltipBgColor: Colors.transparent,
        //     tooltipPadding: const EdgeInsets.all(0),
        //     tooltipMargin: 8,
        //     getTooltipItem: (
        //       BarChartGroupData group,
        //       int groupIndex,
        //       BarChartRodData rod,
        //       int rodIndex,
        //     ) {
        //       if (rod.y.round() == 0) return null;
        //       return BarTooltipItem(
        //         rod.y.round().toString(),
        //         TextStyle(color: Colors.white, fontSize: 9),
        //       );
        //     },
        //   ),
        // ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 20,
            getTitles: (double value) {
              try {
                dates.elementAt(value.toInt());
              } catch (e) {
                return '';
              }
              return value.toInt().isEven && dates.isNotEmpty
                  ? dates.elementAt(value.toInt())
                  : '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 32,
            interval: maxValue == 0
                ? 5
                : (valueInterval / pow(10, maxValueLength - 1))
                        .floorToDouble() *
                    pow(10, maxValueLength - 1),
            reservedSize: 14,
            getTitles: (value) {
              return value.toInt().toString();
            },
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border(
                left: BorderSide(color: Colors.grey[800]!, width: 1),
                bottom: BorderSide(color: Colors.grey[800]!, width: 1))
            // border: Border.all(color: Colors.grey[500]!, width: 1)
            ),
        barGroups: groupData,
      ),
      swapAnimationDuration: const Duration(milliseconds: 0),
    );
  }
}

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 2,
    x: x,
    barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ],
    // showingTooltipIndicators: [
    //   0,
    //   1
    // ]
  );
}
