import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/page/menu/about.dart';
import 'package:flutter_locyin/page/menu/settings.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart';

class MenuDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GetBuilder<UserController>(
                    init: UserController(),
                    builder: (controller) {
                      return GestureDetector(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.only(top: 40, bottom: 16),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                child: ClipOval(
                                  // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                                    child: SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: ExtendedImage.network(
                                          controller.user!.data.avatar,
                                          fit: BoxFit.fill,
                                          cache: true,
                                          //border: Border.all(color: Colors.red, width: 1.0),
                                          //shape: boxShape,
                                          //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          //cancelToken: cancellationToken,
                                        )
                                      //CachedNetworkImage(fit: BoxFit.fill, imageUrl: "https://locyin.oss-cn-beijing.aliyuncs.com/apps/luoxun_flutter/images/avatar/logo_512x512.png",),
                                    )
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "小寻",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "我们都是骆驼,长途跋涉,寻找生命中的绿洲.",
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white,fontSize: 16),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          ToastUtils.toast("点击头像");
                        },
                      );
                    }
                ),

                MediaQuery.removePadding(
                  context: context,
                  // DrawerHeader consumes top MediaQuery padding.
                  removeTop: true,
                  child: ListView(
                    shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                    physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                    scrollDirection: Axis.vertical, // 水平listView
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("设置"),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SettingsPage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Text("关于"),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new AboutPage()));
                        },
                      ),
                      //退出
                      Divider(height: 1.0, color: Colors.grey),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("登出"),
                        onTap: () {
                          _logOut();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
  }
  void _logOut(){
    Get.find<UserController>().clearUser();
    Get.find<ConstantController>().clearToken();
    Get.offAllNamed("/index");
  }
}

