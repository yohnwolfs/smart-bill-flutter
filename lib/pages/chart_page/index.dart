import 'package:account_book/pages/chart_page/bar_chart.dart';
import 'package:account_book/pages/chart_page/rank_chart.dart';
import 'package:account_book/state/finance_statistics.dart';
import 'package:account_book/utils/time_machine_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String type = 'pay';
  int rangeIndex = 1;
  int exactlyRangeIndex = 1;

  bool get wantKeepAlive => true;

  late final TabController tabController =
      new TabController(initialIndex: 1, length: 2, vsync: this);

  @override
  void initState() {
    super.initState();

    Provider.of<FinanceStatisticsState>(context, listen: false).fetchStatistics(
        dateTabs[rangeIndex][exactlyRangeIndex].startStamp,
        dateTabs[rangeIndex][exactlyRangeIndex].endStamp);
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Consumer<FinanceStatisticsState>(
        builder: (ctx, financeStatisticState, c) => DefaultTabController(
            length: 3,
            child: Container(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              FlutterToggleTab(
                  labels: ['周', '月', '年'],
                  selectedIndex: rangeIndex,
                  borderRadius: 4,
                  width: 66,
                  height: 36,
                  selectedLabelIndex: (index) {
                    setState(() {
                      rangeIndex = index;
                      exactlyRangeIndex = 1;
                      tabController.animateTo(1);
                      Provider.of<FinanceStatisticsState>(context,
                              listen: false)
                          .fetchStatistics(
                              dateTabs[rangeIndex][exactlyRangeIndex]
                                  .startStamp,
                              dateTabs[rangeIndex][exactlyRangeIndex].endStamp);
                    });
                  },
                  selectedTextStyle:
                      TextStyle(color: Colors.white, fontSize: 18),
                  unSelectedTextStyle:
                      TextStyle(fontSize: 18, color: Colors.black),
                  selectedBackgroundColors: [Colors.black],
                  unSelectedBackgroundColors: [Theme.of(context).primaryColor]),
              TabBar(
                  controller: tabController,
                  unselectedLabelColor: Colors.grey[400],
                  indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.fromLTRB(82, -4, 82, -4),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  tabs: dateTabs[rangeIndex]
                      .map<Widget>((item) => item.widget)
                      .toList(),
                  onTap: (index) {
                    setState(() {
                      exactlyRangeIndex = index;
                      Provider.of<FinanceStatisticsState>(context,
                              listen: false)
                          .fetchStatistics(
                              dateTabs[rangeIndex][exactlyRangeIndex]
                                  .startStamp,
                              dateTabs[rangeIndex][exactlyRangeIndex].endStamp);
                    });
                  }),
              Expanded(
                  child: ListView(children: [
                Stack(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey[900]),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 18.0, left: 22.0, top: 24, bottom: 12),
                            child: CustomBarChart(
                              statisticData:
                                  financeStatisticState.statisticData,
                              type: rangeIndex == 0
                                  ? 'week'
                                  : rangeIndex == 1
                                      ? 'month'
                                      : rangeIndex == 2
                                          ? 'year'
                                          : '',
                            )),
                      ),
                    ),
                  ],
                ),
                RankChart(tags: financeStatisticState.statisticData?.tags)
              ]))
            ]))));
  }
}

List<TabObj> weekTabs = [
  TabObj(
      TimeMachineUtil.getWeeksDate(-1).monDayStamp,
      TimeMachineUtil.getWeeksDate(-1).sunDayStamp,
      Tab(child: Text('上周', style: TextStyle(fontSize: 16)))),
  TabObj(
      TimeMachineUtil.getWeeksDate(0).monDayStamp,
      TimeMachineUtil.getWeeksDate(0).sunDayStamp,
      Tab(child: Text('本周', style: TextStyle(fontSize: 16))))
];

List<TabObj> monthTabs = [
  TabObj(
      TimeMachineUtil.getMonthDate(-1).startDateStamp,
      TimeMachineUtil.getMonthDate(-1).endDateStamp,
      Tab(child: Text('上月', style: TextStyle(fontSize: 16)))),
  TabObj(
      TimeMachineUtil.getMonthDate(0).startDateStamp,
      TimeMachineUtil.getMonthDate(0).endDateStamp,
      Tab(child: Text('本月', style: TextStyle(fontSize: 16))))
];

List<TabObj> yearTabs = [
  TabObj(
      TimeMachineUtil.getStartEndYearDate(-1).startStamp,
      TimeMachineUtil.getStartEndYearDate(-1).endStamp,
      Tab(child: Text('去年', style: TextStyle(fontSize: 16)))),
  TabObj(
      TimeMachineUtil.getStartEndYearDate(0).startStamp,
      TimeMachineUtil.getStartEndYearDate(0).endStamp,
      Tab(child: Text('今年', style: TextStyle(fontSize: 16))))
];

List<List<TabObj>> dateTabs = [weekTabs, monthTabs, yearTabs];

class TabObj {
  const TabObj(this.startStamp, this.endStamp, this.widget);

  final int startStamp;
  final int endStamp;
  final Widget widget;
}
