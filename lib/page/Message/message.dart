import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/data/model/message_list_entity.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/record_service.dart';
import 'package:flutter_locyin/utils/socket.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/lists/message_item.dart';
import 'package:flutter_locyin/widgets/skeleton_item.dart';
import 'package:get/get.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  //EasyRefresh控制器
  late EasyRefreshController _controller;

  final ScrollController _scroll_controller =
      ScrollController(keepScrollOffset: false);

  late Timer _timer;

  var period = const Duration(seconds: 30);

  //为了控制Stream 暂停。恢复。取消监听 新建
  late StreamSubscription _streamSubscription;

  _initTimer() {
    _streamSubscription = WebsocketManager().socketStatusController.stream.listen((event) {
        if(event == StatusEnum.connect){
          try {
            //定时器，period为周期
            _timer = Timer.periodic(period, (timer) {
              WebsocketManager().send("ping");
              if (event == StatusEnum.close) {
                timer.cancel();
              }
            });
          } catch (e) {
          }
        }
        print(event);
    });

  }
  @override
  void initState() {
    super.initState();
    //初始化控制器
    _controller = EasyRefreshController();
    WebsocketManager().connect();
    _initTimer();
  }
  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose(); // This will free the memory space allocated to the page
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            _getMessageAppBar(),
            GetBuilder<MessageController>(
                    init: MessageController(),
                    id: "message_list",
                    builder: (controller) {
                      return Flexible(
                        child: EasyRefresh(
                          enableControlFinishRefresh: false,
                          enableControlFinishLoad: true,
                          controller: _controller,
                          header: ClassicalHeader(),
                          footer: ClassicalFooter(),
                          /*firstRefresh: true,
          firstRefreshWidget: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Card(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 50.0,
                            child: SpinKitFadingCube(
                              color: Theme.of(context).primaryColor,
                              size: 25.0,
                            ),
                          ),
                          Container(
                            child: Text("加载中..."),
                          )
                        ],
                    ),
                  ),
                )),
          ),*/
                          emptyWidget: (controller.messageList!=null?controller.messageList!.data.length == 0:controller.messageList!=null)
                              ? Container(
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(),
                                  flex: 2,
                                ),
                                SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Image.asset('assets/images/nodata.png'),
                                ),
                                Text(
                                  "没有数据",
                                  style: TextStyle(fontSize: 16.0, color: Get.theme.cardColor),
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 3,
                                ),
                              ],
                            ),
                          )
                              : null,
                          //下拉刷新
                          onRefresh: () async {
                            await Future.delayed(Duration(seconds: 2), () {
                              print("正在刷新数据...");
                              if (!Get.find<MessageController>().listRunning) {
                                Get.find<MessageController>().getMessageList();
                              }
                              _controller.resetLoadState();
                            });
                          },
                          //上拉加载
                          onLoad: () async {},
                          child: CustomScrollView(
                            controller: _scroll_controller,
                            slivers: <Widget>[
                              /*//=====头部菜单=====//
                            SliverToBoxAdapter(child: bannerWidget()),*/
                              //=====列表=====//

                              Container(
                                child:
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                      return getMessageListView(index);
                                      //return getDynamicListView(index);
                                    },
                                    childCount: controller.messageList == null
                                        ? 10
                                        : controller.messageList!.data.length,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ),
                      );
                    }),
      
          ],
        )
      ),
    );
  }

  Widget getMessageListView(int index) {
    MessageListEntity? _messageList = Get.find<MessageController>().messageList;
    if (_messageList == null) {
      if (!Get.find<MessageController>().listRunning) {
        Get.find<MessageController>().getMessageList();
      }
      //print("正在请求列表数据...................................................................");
      /*if (!Get.find<DynamicController>().dynamic_running) {
        Get.find<DynamicController>().getDynamicList(1);
      }*/
      return SkeletonListItem();
    } else {
      return MessageListItem(
        strangerNickname: _messageList.data[index].stranger.nickname,
        strangerAvatar: _messageList.data[index].stranger.avatar,
        excerpt: _messageList.data[index].excerpt,
        time: _messageList.data[index].updatedAt,
        onPressed: () async {
          Get.toNamed("/index/message/chat",arguments: {
            "id":_messageList.data[index].id,
            "nickname":_messageList.data[index].stranger.nickname,
          });
        },
        count: _messageList.data[index].count,
        status: Get.find<MessageController>().iconsList[_messageList.data[index].stranger.status].icon,
        online: _messageList.data[index].online==1,
      );
    }
  }

  Widget _getMessageAppBar() {
    return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: [
            Positioned(
              left: 8,
              child: InkWell(
                onTap: () {
                  Get.bottomSheet(_statusPanel());
                },
                child: GetBuilder<MessageController>(
                    init: MessageController(),
                    id: "mine_status",
                    builder: (controller) {
                      return Row(
                        children: [
                          Text(
                            controller.iconsList[controller.messageStatusCode].label,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          controller.iconsList[controller.messageStatusCode].icon
                        ],
                      );
                    }),
              ),
            ),
            Center(
              child: Text(
                "聊天",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              right: 8,
              child:  PopupMenuButton(
                  offset: Offset(0,40),
                  child: Icon(Icons.add_circle_outline),
                  itemBuilder: (BuildContext context){
                    return [
                      PopupMenuItem(child: Row(
                        children: [
                          Icon(Icons.chat_bubble),
                          SizedBox(width: 8,),
                          Text("添加朋友"),
                        ],
                      ),value: "add",),
                      PopupMenuItem(child: Row(
                        children: [
                          Icon(Icons.view_sidebar_outlined),
                          SizedBox(width: 8,),
                          Text("扫一扫"),
                        ],
                      ),value: "add",),
                    ];
                  }),
            ),
          ],
        ),
      );
  }


  Widget _statusPanel() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "切换状态",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
                child: GetBuilder<MessageController>(
                    init: MessageController(),
                    id: "mine_status",
                    builder: (controller) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1),
                        itemCount: controller.iconsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _statusWidgetBuilder(
                              index);
                        },
                      );
                    })),
          ],
        ),
      ),
    );
  }
  Widget _statusWidgetBuilder(int index) {
    List<StatusEntity> _iconsList = Get.find<MessageController>().iconsList;
    bool currentStatus = Get.find<MessageController>().messageStatusCode == index;
    return InkWell(
      onTap: () { Get.find<MessageController>().updateMessageStatus(index); },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(2.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon: iconsList[index].,
            Badge(
              badgeColor: currentStatus?Colors.green:Colors.transparent,
              child:_iconsList[index].icon,
            ),
            Text(_iconsList[index].label),
          ],
        ),
      ),
    );
  }

}

class StatusEntity {
  String label;
  String type;
  Icon icon;

  StatusEntity(this.label, this.type, this.icon);
}
