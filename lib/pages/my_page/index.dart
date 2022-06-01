import 'package:account_book/navigator/navigation_util.dart';
import 'package:account_book/pages/my_page/functional_module_container.dart';
import 'package:account_book/state/auth_state.dart';
import 'package:account_book/state/finance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [TopUserStatus(), UserFunctionalModules()],
    ));
  }
}

// 头部用户信息区
class TopUserStatus extends StatelessWidget {
  const TopUserStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceState>(builder: (ctx, financeState, c) {
      return Consumer<AuthState>(builder: (context, auth, child) {
        // 用户名
        String? userName = auth.userInfo?.displayName != ''
            ? auth.userInfo?.displayName
            : auth.userInfo?.name;
        return Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xffbbbbbb),
                          foregroundColor: Colors.black,
                          backgroundImage: auth.userInfo?.avatar != null
                              ? NetworkImage(Config().server +
                                  (auth.userInfo?.avatar ?? ''))
                              : null,
                        )),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(userName ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23))
                  ]),
                  GestureDetector(
                      onTap: () {
                        NavigationUtil.getInstance().pushNamed('notification');
                      },
                      child: Icon(Icons.notifications_none, size: 32))
                ],
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatisticInfoItem(
                          financeState.thisMonthTotalIncome, '本月收入'),
                      StatisticInfoItem(financeState.thisMonthTotalPay, '本月支出'),
                      StatisticInfoItem('0', '本月剩余预算')
                    ],
                  ))
            ]));
      });
    });
  }
}

// 统计数据块
class StatisticInfoItem extends StatelessWidget {
  final String data;
  final String desc;
  const StatisticInfoItem(this.data, this.desc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(data,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
          ),
          Text(desc, style: TextStyle(color: Colors.grey[550], fontSize: 12))
        ],
      ),
    );
  }
}

// 功能模块区
class UserFunctionalModules extends StatelessWidget {
  int get month => new DateTime.now().month;

  const UserFunctionalModules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        // direction: Axis.vertical,
        children: [
          FunctionalModuleContainer(
            title: Text('预算(未开发)'),
            prefix: Icon(Icons.monetization_on,
                color: Colors.yellow[600], size: 28),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: const Color(0xffe5e5e5)),
                    bottom: BorderSide(color: const Color(0xffe5e5e5)))),
            onTap: () => print('sdf'),
          ),
          // FunctionalModuleContainer(
          //   title: Text('$month月总预算'),
          //   rightText: '查看',
          //   prefix: Icon(Icons.monetization_on,
          //       color: Colors.yellow[600], size: 28),
          //   onTap: () => print('onTap'),
          //   content: Text('测试'),
          // ),
          FunctionalModuleContainer(
            title: Text('标签管理'),
            prefix: Icon(Icons.tag, color: Colors.lime[500], size: 28),
            onTap: () => {NavigationUtil.getInstance().pushNamed('tag_manage')},
          ),
          FunctionalModuleContainer(
            title: Text('设置'),
            prefix: Icon(Icons.settings, color: Colors.grey[500], size: 28),
            onTap: () => {NavigationUtil.getInstance().pushNamed('setting')},
          ),
          Padding(padding: EdgeInsets.only(bottom: 12)),
          FunctionalModuleContainer(
              title: Text('退出登录'),
              prefix: Icon(Icons.logout, color: Colors.red[300], size: 28),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: const Color(0xffe5e5e5)),
                      bottom: BorderSide(color: const Color(0xffe5e5e5)))),
              onTap: () =>
                  Provider.of<AuthState>(context, listen: false).logout()),
        ],
      ),
    );
  }
}
