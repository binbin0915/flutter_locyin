import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/page/menu/menu.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/banner.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);


  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  late EasyRefreshController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _count = 5;
  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: MenuDrawer(),
        body:SafeArea(
            child: Stack(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: [
                      getAppBar(),
                      Flexible(
                        child: EasyRefresh(
                          enableControlFinishRefresh: false,
                          enableControlFinishLoad: true,
                          controller: _controller,
                          header: ClassicalHeader(),
                          footer: ClassicalFooter(),

                          onRefresh: () async {
                            await Future.delayed(Duration(seconds: 2), () {
                              print("正在刷新数据...");
                            });
                          },
                          onLoad: () async {
                            await Future.delayed(Duration(seconds: 2), () {
                              print('onLoad');
                              setState(() {
                                _count += 10;
                              });
                              print("count: $_count");
                              _controller.finishLoad(noMore: _count >= 30);
                            });
                          },

                          child:CustomScrollView(
                            slivers: <Widget>[
                              //=====轮播图=====//
                              SliverToBoxAdapter(child: bannerWidget()),
                              //=====列表=====//
                              Container(
                                  child: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        return getDynamicListView(index);
                                      },
                                      childCount: _count,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        );
  }
  Widget getAppBar(){
    return Container(
      child:
      Container(
        height: 48,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
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
      ),
    );
  }

  Widget getDynamicListView(int index) {
          List<BoxShadow> shadowList = [
            BoxShadow(color: Colors.grey[300]!, blurRadius: 30, offset: Offset(0, 10))
          ];
          return Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                //样式一
                /*Expanded(
                  child: SkeletonAnimation(
                    shimmerColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    shimmerDuration: 1000,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: shadowList,
                      ),
                      margin: EdgeInsets.only(top: 40),
                    ),
                  ),
                ),*/
                //样式二
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      boxShadow: shadowList,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                          child: SkeletonAnimation(
                            borderRadius: BorderRadius.circular(10.0),
                            shimmerColor: index % 2 != 0 ? Colors.grey : Colors.white54,
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: SkeletonAnimation(
                              borderRadius: BorderRadius.circular(10.0),
                              shimmerColor: index % 2 != 0 ? Colors.grey : Colors.white54,
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
