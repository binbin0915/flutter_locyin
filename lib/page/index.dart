import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/page/Dynamic/Dynamic.dart';
import 'package:flutter_locyin/page/find.dart';
import 'package:flutter_locyin/page/mine.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart';

import 'Map/map.dart';
import 'Message/message.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with WidgetsBindingObserver {
  int _tabIndex = 0;

  List<BottomNavigationBarItem> getTabs(BuildContext context) => [
    /*BottomNavigationBarItem(label: S.of(context).navigationHome, icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: S.of(context).navigationFind, icon: Icon(Icons.find_in_page)),
        BottomNavigationBarItem(label: S.of(context).navigationMap, icon: Icon(Icons.map)),
        BottomNavigationBarItem(label: S.of(context).navigationMessage, icon: Icon(Icons.notifications)),
        BottomNavigationBarItem(label: S.of(context).navigationMine, icon: Icon(Icons.person)),*/
    BottomNavigationBarItem(
        label: 'navigationHome'.tr, icon: Icon(Icons.home)),
    BottomNavigationBarItem(
        label: 'navigationFind'.tr, icon: Icon(Icons.find_in_page)),
    BottomNavigationBarItem(
        label: 'navigationMap'.tr, icon: Icon(Icons.map)),
    BottomNavigationBarItem(
      label: 'navigationMessage'.tr,
      icon: GetBuilder<MessageController>(
          init: MessageController(),
          id: 'message_list',
          builder: (controller) {
            /*return   */
            int count = 0;
            if (controller.messageList != null) {
              controller.messageList!.data.forEach((element) {
                count += element.count;
              });
            }

            return count == 0
                ? Icon(Icons.notifications)
                : Badge(
                position: BadgePosition.topEnd(/*top: -4, end: -4*/),
                toAnimate: true,
                animationType: BadgeAnimationType.slide,
                badgeContent: Text(
                  count.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                //badgeColor: Colors.cyan,
                child: Icon(Icons.notifications));
          }),
    ),
    BottomNavigationBarItem(
        label: 'navigationMine'.tr, icon: Icon(Icons.person)),
  ];

  List<Widget> getTabWidget(BuildContext context) =>
      [DynamicPage(), FindPage(), MapPage(), MessagePage(), MinePage()];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // ?????????????????????????????????????????????????????????????????????????????????
        Get.find<ConstantController>()
            .changeAppState(AppLifecycleState.inactive);
        break;
      case AppLifecycleState.resumed: // ???????????????????????????
        Get.find<ConstantController>()
            .changeAppState(AppLifecycleState.resumed);
        break;
      case AppLifecycleState.paused: // ??????????????????????????????
        Get.find<ConstantController>().changeAppState(AppLifecycleState.paused);
        break; // ?????????????????????
      case AppLifecycleState.detached:
        Get.find<ConstantController>()
            .changeAppState(AppLifecycleState.detached);
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabs = getTabs(context);
    DateTime? lastPopTime;
    return WillPopScope(
      onWillPop: () {
        // ????????????????????????

        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime!) > Duration(seconds: 2)) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          lastPopTime = DateTime.now();
          ToastUtils.toast('exitBy2Click'.tr);
          return Future.value(false);
        } else {
          lastPopTime = DateTime.now();
          return Future.value(true);
          // ??????app

        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: _tabIndex,
          children: getTabWidget(context),
        ),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: BottomNavigationBar(
            items: tabs,
            //??????  ???????????????
            currentIndex: _tabIndex,
            //?????? ??????
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            fixedColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
