import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/data/model/message_list_entity.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/socket.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/lists/message_item.dart';
import 'package:flutter_locyin/widgets/skeleton.dart';
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

  /* final List<Icon> _iconssList = [
    Icon(Icons.online_prediction_rounded,color: Colors.green, size: 30.0),
    Icon(Icons.view_headline_rounded,color: Colors.orange, size: 30.0),
    Icon(Icons.logout,color: Colors.grey, size: 30.0),
    Icon(Icons.event_busy,color: Colors.red, size: 30.0),
    Icon(Icons.file_copy_sharp,color: Colors.cyan, size: 30.0)
  ];
  final List<Map<String ,String>> _typeList = [
    {
      "type":"online",
      "label":"在线"
    },
    {
      "type":"hide",
      "label":"隐身"
    },
    {
      "type": "offline",
      "label": "离线"
    },
    {
      "type":"busy",
      "label":"忙碌"
    },
    {
      "type":"working",
      "label":"搬砖"
    }
  ];*/

  @override
  void initState() {
    super.initState();
    //初始化控制器
    _controller = EasyRefreshController();
    WebsocketManager().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              _getMessageAppBar(),
              Container(
                child: GetBuilder<MessageController>(
                    init: MessageController(),
                    id: "message_list",
                    builder: (controller) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return getMessageListView(index);
                            //return getDynamicListView(index);
                          },
                          childCount: controller.messageList == null
                              ? 5
                              : controller.messageList!.data.length,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
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
      return SkeletonWidget();
    } else {
      return MessageListItem(
        strangerNickname: _messageList.data[index].stranger.nickname,
        strangerAvatar: _messageList.data[index].stranger.avatar,
        excerpt: _messageList.data[index].excerpt,
        time: _messageList.data[index].updatedAt,
        onPressed: () {
          Get.toNamed("/index/message/chat",arguments: {
            "id":_messageList.data[index].stranger.id,
            "new":_messageList.data[index].count>0,
            "nickname":_messageList.data[index].stranger.nickname,
          });
        },
        count: _messageList.data[index].count,
        status: Get.find<MessageController>().iconsList[_messageList.data[index].stranger.status].icon,
      );
    }
  }

  Widget _getMessageAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
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
              child: InkWell(
                onTap: () {
                  ToastUtils.toast("添加好友");
                  //_scaffoldKey.currentState.openDrawer();
                },
                child: Icon(Icons.add),
              ),
            )
          ],
        ),
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
