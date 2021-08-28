import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/toast.dart';

class DynamicAppBarWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DynamicAppBarWidget({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            child: Icon(Icons.menu_outlined),
          ),
          Text(
            "首页",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              ToastUtils.toast("跳转到检索页");
              //_scaffoldKey.currentState.openDrawer();
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
