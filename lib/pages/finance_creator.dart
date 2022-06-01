import 'package:account_book/models/finance.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/state/finance_tag.dart';
import 'package:account_book/widgets/calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

enum PageMode { tagSelector, financeCreator }

class FinanceCreatorPage extends StatefulWidget {
  FinanceCreatorPage({Key? key}) : super(key: key);

  @override
  _FinanceCreatorPageState createState() => _FinanceCreatorPageState();
}

class _FinanceCreatorPageState extends State<FinanceCreatorPage> {
  int currentIndex = 0;

  PageMode mode = PageMode.financeCreator;

  PageController _controller = PageController(initialPage: 0, keepPage: true);

  FinanceTag? selectedTag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final PageParams? params =
        ModalRoute.of(context)?.settings.arguments as dynamic;
    mode = params?.mode ?? PageMode.financeCreator;
  }

  void onTabChange(int index) {
    _controller.jumpToPage(index);

    setState(() {
      currentIndex = index;
    });
  }

  void onListItemTap(FinanceTag tag) {
    if (mode == PageMode.tagSelector) NavigationUtil.getInstance().pop(tag);
    setState(() {
      selectedTag = tag;
    });
  }

  void onCreateFinance(FinanceTag tag, double n, DateTime date, String? desc) {
    NavigationUtil.getInstance().pop(CreateFinanceParams(tag, n, date, desc));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceTagState>(builder: (context, tagState, child) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                  shadowColor: Theme.of(context).shadowColor,
                  centerTitle: true,
                  actions: [Padding(padding: EdgeInsets.only(right: 46))],
                  title: TabBar(
                    onTap: onTabChange,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.fromLTRB(40, -4, 40, -4),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    tabs: [
                      Tab(child: Text('支出', style: TextStyle(fontSize: 20))),
                      Tab(child: Text('收入', style: TextStyle(fontSize: 20))),
                    ],
                  )
                  // automaticallyImplyLeading: false,
                  ),
              body: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    selectedTag = null;
                  });
                },
                children: [
                  TagListView(
                    selectedTag: currentIndex == 0 ? selectedTag : null,
                    tags: tagState.payTags,
                    isTagSelectorMode: mode == PageMode.tagSelector,
                    onListItemTap: onListItemTap,
                    onCreateFinance: onCreateFinance,
                  ),
                  TagListView(
                    selectedTag: currentIndex == 1 ? selectedTag : null,
                    tags: tagState.incomeTags,
                    isTagSelectorMode: mode == PageMode.tagSelector,
                    onListItemTap: onListItemTap,
                    onCreateFinance: onCreateFinance,
                  ),
                ],
              )));
    });
  }
}

// 标签展示
class TagListView extends StatefulWidget {
  TagListView(
      {required this.tags,
      this.isTagSelectorMode,
      this.onCreateFinance,
      this.onListItemTap,
      this.selectedTag,
      Key? key})
      : super(key: key);

  final bool? isTagSelectorMode;

  final List<FinanceTag>? tags;

  final void Function(FinanceTag)? onListItemTap;

  final FinanceTag? selectedTag;

  final void Function(FinanceTag tag, double n, DateTime date, String? desc)?
      onCreateFinance;

  @override
  _TagListViewState createState() => _TagListViewState();
}

class _TagListViewState extends State<TagListView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = (screenWidth - 4 * 28 * 2 - 32 * 2) / 3;

    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Container(
        padding: EdgeInsets.fromLTRB(32, 20, 32, 20),
        child: Wrap(
            spacing: padding,
            runSpacing: 20,
            alignment: WrapAlignment.start,
            children: widget.tags == null
                ? []
                : widget.tags!.map((tag) {
                    return GestureDetector(
                        onTap: () {
                          if (widget.onListItemTap != null)
                            widget.onListItemTap!(tag);
                        },
                        child: Column(children: [
                          CircleAvatar(
                              radius: 28,
                              backgroundColor: tag.id == widget.selectedTag?.id
                                  ? Colors.yellow[600]
                                  : Colors.grey[300],
                              child: tag.icon == null
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.all(8),
                                      child: Image.network(
                                          '${Config().server}${tag.icon}',
                                          width: 200))),
                          Padding(padding: EdgeInsets.only(bottom: 4)),
                          Text(tag.name)
                        ]));
                  }).toList()),
      ))),
      widget.selectedTag?.id == null || widget.isTagSelectorMode == true
          ? Container()
          : Calculator(
              onSubmit: (n, date, desc) {
                if (widget.onCreateFinance != null &&
                    widget.selectedTag != null)
                  widget.onCreateFinance!(widget.selectedTag!, n, date, desc);
              },
            )
    ]);
  }
}

// 页面传递参数
class PageParams {
  PageParams(this.mode);

  PageMode mode;
}

// 创建账单参数
class CreateFinanceParams {
  CreateFinanceParams(this.tag, this.amount, this.date, this.desc);

  FinanceTag? tag;
  double? amount;
  DateTime? date;
  String? desc;
}
