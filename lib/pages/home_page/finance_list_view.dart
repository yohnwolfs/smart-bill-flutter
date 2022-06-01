import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/models/list.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/finance_creator.dart';
import 'package:account_book/widgets/no_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../constants.dart';

class FinanceListView extends StatefulWidget {
  FinanceListView(
      {required this.data,
      required this.onListItemAction,
      this.onPullDown,
      this.onPullUp,
      this.disablePullBehavior = false,
      Key? key})
      : super(key: key);

  final ListModel<Finance> data;

  final bool disablePullBehavior;

  final void Function(Finance, FinanceListItemAction) onListItemAction;

  final void Function()? onPullDown;

  final void Function()? onPullUp;

  @override
  _FinanceListViewState createState() => _FinanceListViewState();
}

class _FinanceListViewState extends State<FinanceListView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _handleRefresh() async {
    _refreshController.refreshCompleted();
    if (widget.onPullDown != null) widget.onPullDown!();
  }

  Future<void> _handleLoad() async {
    _refreshController.loadComplete();
    if (widget.onPullUp != null) widget.onPullUp!();
  }

  Widget renderListView() {
    if (widget.data.list.length == 0)
      return Center(
        child: NoContent(),
      );
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 32),
        itemCount: widget.data.list.length,
        itemBuilder: (context, index) {
          final pos = generateSeparatePos(widget.data);

          return FinanceListItem(
              index: index,
              data: widget.data.list[index],
              onAction: widget.onListItemAction,
              showItemTitle: pos['$index'] != null ? true : false,
              titleIncomeText:
                  pos['${index}I'] != null ? pos['${index}I'] : null,
              titlePayText: pos['${index}P'] != null ? pos['${index}P'] : null);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disablePullBehavior) {
      return Expanded(child: renderListView());
    }

    return Expanded(
        child: RefreshConfiguration(
            enableBallisticLoad: false,
            footerTriggerDistance: -80,
            maxUnderScrollExtent: 60,
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                onRefresh: _handleRefresh,
                onLoading: _handleLoad,
                header: ClassicHeader(
                    idleText: '上个月',
                    releaseText: '上个月',
                    refreshingText: '加载中',
                    completeText: '加载完成',
                    failedText: '加载失败'),
                footer: ClassicFooter(
                    idleText: '下个月',
                    canLoadingText: '下个月',
                    loadingText: '加载中',
                    noDataText: '没有数据',
                    failedText: '加载失败',
                    loadStyle: LoadStyle.ShowWhenLoading,
                    completeDuration: const Duration(milliseconds: 1000)),
                child: renderListView())));
  }
}

class FinanceListItem extends StatelessWidget {
  const FinanceListItem(
      {required this.data,
      required this.onAction,
      required this.showItemTitle,
      required this.index,
      this.titleIncomeText,
      this.titlePayText,
      Key? key})
      : super(key: key);

  final Finance data;

  final int index;

  final bool showItemTitle;

  final String? titleIncomeText;

  final String? titlePayText;

  final void Function(Finance, FinanceListItemAction) onAction;

  Widget getSlidableItem(bool hasTopBorder) {
    final FinanceTag? tag =
        (data.tags != null && data.tags!.isNotEmpty) ? data.tags!.first : null;
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
          onLongPress: () {
            onAction(data, FinanceListItemAction.detail);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: hasTopBorder
                    ? Border(
                        top: BorderSide(width: 1, color: Colors.grey[200]!),
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!))
                    : Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey[200]!))),
            child: ListTile(
              leading: GestureDetector(
                  onTap: () async {
                    final res = await NavigationUtil.getInstance().pushNamed(
                        'finance_creator',
                        arguments: PageParams(PageMode.tagSelector));

                    if (res == null) return;

                    await FinanceDao().updateFinance(data.id!, {
                      ...data.toJson(),
                      'tradingTime': int.parse(data.tradingTime!),
                      'tags': [res.id]
                    });

                    onAction(data, FinanceListItemAction.changeTag);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: tag?.icon == null
                        ? Text(tag?.name ?? '', style: TextStyle(fontSize: 12))
                        : Padding(
                            padding: EdgeInsets.all(4),
                            child: Image.network(
                                '${Config().server}${tag?.icon}')),
                    foregroundColor: Colors.white,
                  )),
              trailing: Text(
                '${data.tradingType == 'pay' ? '-' : ''}${data.amount.toString()}',
              ),
              title: Text(data.goods,
                  overflow: TextOverflow.ellipsis, maxLines: 1),
              // subtitle: Text('SlidableDrawerDelegate'),
            ),
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            onAction(data, FinanceListItemAction.delete);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String incomeText = titleIncomeText != null ? '收入: $titleIncomeText' : '';
    String payText = titlePayText != null ? '支出: $titlePayText' : '';

    return showItemTitle
        ? Column(children: [
            ListGroupTitle(
                DateFormat('MM月dd日').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(data.tradingTime ?? '')),
                ),
                '$incomeText${titlePayText != null ? ' ' + payText : ''}'),
            getSlidableItem(true)
          ])
        : getSlidableItem(false);
  }
}

// 列表组标题
class ListGroupTitle extends StatelessWidget {
  const ListGroupTitle(this.title, this.titleRightText, {Key? key})
      : super(key: key);

  final String title;
  final String? titleRightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
      // decoration: BoxDecoration(),
      child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            Text(titleRightText ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 14))
          ]),
    );
  }
}

// 操作类型
enum FinanceListItemAction {
  delete,
  detail,
  changeTag,
}

Map<String, String> generateSeparatePos(ListModel<Finance> listModel) {
  final list = listModel.list;
  var tempIndex;
  Map<String, String> res = {};

  // 排序
  list.sort((a, b) {
    if (int.parse(a.tradingTime!) - int.parse(b.tradingTime!) < 0)
      return -1;
    else
      return 1;
  });

  list.asMap().keys.forEach((index) {
    final date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(list[index].tradingTime ?? ''))
        .toString()
        .substring(0, 10);
    final amount = list[index].amount;
    final type = list[index].tradingType;

    if (res.containsValue(date)) {
      if (tempIndex != null) {
        if (type == 'income')
          res['${tempIndex}I'] =
              (double.parse(res['${tempIndex}I'] ?? '0') + amount)
                  .toStringAsFixed(2);
        else
          res['${tempIndex}P'] =
              (double.parse(res['${tempIndex}P'] ?? '0') + amount)
                  .toStringAsFixed(2);
      }
    } else {
      res['$index'] = date;
      if (type == 'income')
        res['${index}I'] = amount.toString();
      else
        res['${index}P'] = amount.toString();
      tempIndex = index;
    }
  });

  return res;
}
