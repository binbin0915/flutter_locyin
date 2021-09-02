import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/data/model/dynamic_list_entity.dart';
import 'package:flutter_locyin/page/Dynamic/app_bar.dart';
import 'package:flutter_locyin/page/menu/menu.dart';
import 'package:flutter_locyin/utils/back_to_top.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/widgets/lists/dynamic_item.dart';
import 'package:flutter_locyin/widgets/skeleton_item.dart';
import 'package:get/get.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  //EasyRefresh控制器
  late EasyRefreshController _controller;

  //主要用于打开抽屉
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ScrollController _scroll_controller = ScrollController(keepScrollOffset: false);

  @override
  void initState() {
    super.initState();
    //初始化控制器
    _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //抽屉
      drawer: MenuDrawer(),
      body: SafeArea(
        child: Stack(
            children: [
          Flex(
            direction: Axis.vertical,
            children: [
              //自定义AppBar
              DynamicAppBarWidget(
                scaffoldKey: _scaffoldKey,
              ),
              Flexible(
                //上拉加载、下拉刷新
                child: EasyRefresh(
                  enableControlFinishRefresh: false,
                  enableControlFinishLoad: true,
                  controller: _controller,
                  header: ClassicalHeader(),
                  footer: ClassicalFooter(),
                  //下拉刷新
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 2), () {
                      print("正在刷新数据...");
                      if (!Get.find<DynamicController>().dynamic_running) {
                        Get.find<DynamicController>().getDynamicList(1);
                      }
                      _controller.resetLoadState();
                    });
                  },
                  //上拉加载
                  onLoad: () async {
                    await Future.delayed(Duration(seconds: 2), () {
                      print('onLoad');
                      /*setState(() {
                            _count += 10;
                          });*/
                      if (!Get.find<DynamicController>().dynamic_running) {
                        Get.find<DynamicController>().getDynamicList(
                            Get.find<DynamicController>()
                                    .dynamicList!
                                    .meta
                                    .currentPage +
                                1);
                      }
                      //如果计数器大于 30 则显示没有更多了
                      _controller.finishLoad(
                          noMore: Get.find<DynamicController>()
                                  .dynamicList!
                                  .meta
                                  .currentPage >=
                              Get.find<DynamicController>()
                                  .dynamicList!
                                  .meta
                                  .lastPage);
                    });
                  },
                  child: CustomScrollView(
                    controller: _scroll_controller,
                    slivers: <Widget>[
                      /*//=====轮播图=====//
                          SliverToBoxAdapter(child: bannerWidget()),*/
                      //=====列表=====//
                      Container(
                        child: GetBuilder<DynamicController>(
                            init: DynamicController(),
                            id: "list",
                            builder: (controller) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return getDynamicListView(index);
                                    //return getDynamicListView(index);
                                  },
                                  childCount: controller.dynamicList == null
                                      ? 10
                                      : controller.dynamicList!.data.length,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ///返回顶部按钮，传入控制器
          BackToTop(_scroll_controller),
        ]),
      ),
    );
  }

  Widget getDynamicListView(int index) {
    DynamicListEntity? _dynamic_list =
        Get.find<DynamicController>().dynamicList;
    if (_dynamic_list == null) {
      print(
          "正在请求列表数据...................................................................");
      if (!Get.find<DynamicController>().dynamic_running) {
        Get.find<DynamicController>().getDynamicList(1);
      }
      return SkeletonListItem();
    } else {
      return DynamicListItem(
          id: _dynamic_list.data[index].id,
          avatar: _dynamic_list.data[index].user.avatar,
          nickname: _dynamic_list.data[index].user.nickname,
          imageUrl: _dynamic_list.data[index].images.length>0?_dynamic_list.data[index].images[0].path:null,
          content: _dynamic_list.data[index].content,
          like: _dynamic_list.data[index].thumbCount,
          comment: _dynamic_list.data[index].commentCount,
          time: _dynamic_list.data[index].updatedAt,
          thumbed: _dynamic_list.data[index].thumbed == 1 ? true : false);
    }
  }
}
