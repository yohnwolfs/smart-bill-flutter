import 'package:account_book/dao/finance_dao.dart';
import 'package:account_book/models/finance.dart';
import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/state/finance_tag.dart';
import 'package:account_book/widgets/no_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class TagManagePage extends StatefulWidget {
  TagManagePage({Key? key}) : super(key: key);

  @override
  _TagManagePageState createState() => _TagManagePageState();
}

class _TagManagePageState extends State<TagManagePage> {
  int currentIndex = 0;

  PageController _controller = PageController(initialPage: 0, keepPage: true);

  void onTabChange(int index) {
    _controller.jumpToPage(index);

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceTagState>(builder: (cxt, financeTagState, c) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                  shadowColor: Theme.of(context).shadowColor,
                  centerTitle: true,
                  // actions: [Padding(padding: EdgeInsets.only(right: 46))],
                  actions: [
                    GestureDetector(
                      onTap: () async {
                        final res = await NavigationUtil.getInstance()
                            .pushNamed('tag_detail',
                                arguments: {'type': 'add'});
                        if (res == true)
                          Provider.of<FinanceTagState>(context, listen: false)
                              .fetchFinanceTags();
                      },
                      child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Center(
                              child:
                                  Text('添加', style: TextStyle(fontSize: 18)))),
                    )
                  ],
                  title: TabBar(
                    onTap: onTabChange,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.fromLTRB(40, -4, 40, -4),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    tabs: [
                      Tab(child: Text('支出', style: TextStyle(fontSize: 20))),
                      Tab(child: Text('收入', style: TextStyle(fontSize: 20))),
                    ],
                  )),
              body: PageView(
                  controller: _controller,
                  onPageChanged: (index) {},
                  children: [
                    TagListView(data: financeTagState.payTags),
                    TagListView(data: financeTagState.incomeTags)
                  ])));
    });
  }
}

class TagListView extends StatelessWidget {
  const TagListView({this.data, Key? key}) : super(key: key);

  final List<FinanceTag>? data;

  @override
  Widget build(BuildContext context) {
    if (data == null || data?.length == 0) return NoContent();

    return Container(
        child: ListView.builder(
            itemCount: data?.length,
            itemBuilder: (ctx, index) {
              final tag = data!.elementAt(index);
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: GestureDetector(
                    onLongPress: () async {
                      final res = await NavigationUtil.getInstance().pushNamed(
                          'tag_detail',
                          arguments: {'type': 'detail', 'data': tag});
                      if (res == true)
                        Provider.of<FinanceTagState>(context, listen: false)
                            .fetchFinanceTags();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: const Color(0xffe5e5e5)))),
                        child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: tag.icon == null
                                  ? Text(tag.name,
                                      style: TextStyle(fontSize: 12))
                                  : Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Image.network(
                                          '${Config().server}${tag.icon}')),
                              foregroundColor: Colors.white,
                            ),
                            title: Text(tag.name)))),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '删除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      await FinanceDao()
                          .deleteFinanceTags(tag.id != null ? [tag.id!] : []);
                      Provider.of<FinanceTagState>(context, listen: false)
                          .fetchFinanceTags();
                    },
                  ),
                ],
              );
            }));
  }
}
