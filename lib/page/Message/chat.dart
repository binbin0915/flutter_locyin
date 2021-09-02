import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/data/model/chat_message_entity.dart';
import 'package:flutter_locyin/data/model/message_list_entity.dart';
import 'package:flutter_locyin/data/model/user_entity.dart';
import 'package:flutter_locyin/utils/date.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/bubble.dart';
import 'package:flutter_locyin/widgets/loading_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

/// 聊天界面示例
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  //
  int _toId = Get.arguments['id'];

  String _nickname = Get.arguments['nickname'];

  // 信息列表
  late List<MessageEntity> _msgList;

  // 输入框
  late TextEditingController _textEditingController;

  // 滚动控制器
  late ScrollController _scrollController;


  @override
  void initState(){
    super.initState();
    print("设置聊天窗口id: $_toId");
    Get.find<MessageController>().setCurrentWindow(_toId);
    if(!Get
        .find<MessageController>()
        .allMessageData
        .containsKey(_toId) ){
          print("正在初始化聊天记录，窗口：$_toId ");
          Get.find<MessageController>().initChatRecord(_toId);
          Get.find<MessageController>().getChatMessageList(_toId,1);
    }/*else{
      //如果有新消息
      if(Get.find<MessageController>().messageList!.data.firstWhere( (element) => element.id == _toId).count>0){
        print("有新消息！");
        Get.find<MessageController>().getChatMessageList(_toId,1);
      }
    }*/
    Get.find<MessageController>().readMessage(_toId);

    /*_msgList = [
      MessageEntity(true, "It's good!"),
      MessageEntity(false, 'EasyRefresh'),
    ];*/
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      setState(() {});
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    print("重置聊天窗口id");
    Get.find<MessageController>().setCurrentWindow(0);
    _textEditingController.dispose();
    _scrollController.dispose();
    Get.find<MessageController>().readMessage(_toId);

  }

  //
  // 发送消息
  void _sendMsg(String msg,String type) {
    /*setState(() {
      _msgList.insert(0, MessageEntity(true, msg));
    });
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.linear);*/
    Get.find<MessageController>().sendChatMessages(_toId, msg, type );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //leading: InkWell(child: Icon(Icons.arrow_back),onTap: (){Get.back(result: _toId);}),
        title: Text( _nickname,style: TextStyle(),),
        centerTitle: false,
        backgroundColor: Get.theme.splashColor,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              ToastUtils.toast("跳转到用户信息页");
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Divider(
            height: 0.5,
          ),
        GetBuilder<MessageController>(
            init: MessageController(),
            id: "message_chat",
            builder: (controller) {
              bool _hasData = controller.allMessageData[_toId]!.meta.currentPage != 0;
              print("是否有数据：$_hasData ");
              return Expanded(
                flex: 1,
                child:
                LayoutBuilder(
                  builder: (context, constraints) {
                    // 判断列表内容是否大于展示区域
                    bool overflow = false;
                    double heightTmp = 0.0;
                    if (_hasData) {
                      for (ChatMessageData entity in Get
                          .find<MessageController>()
                          .allMessageData[_toId]!.data) {
                        heightTmp +=
                            _calculateMsgHeight(context, constraints, entity);
                        if (heightTmp > constraints.maxHeight) {
                          print("溢出了");
                          overflow = true;
                        }
                      }
                    }
                    if(!_hasData) {
                      return LoadingDialog(
                          showContent: false,
                          backgroundColor: Get.theme.dialogBackgroundColor,
                          loadingView: SpinKitCircle(color: Get.theme.accentColor),
                      );
                    }
                    return EasyRefresh.custom(
                      scrollController: _scrollController,
                      reverse: true,
                      footer: CustomFooter(
                          enableInfiniteLoad: false,
                          extent: 40.0,
                          triggerDistance: 50.0,
                          footerBuilder: (context,
                              loadState,
                              pulledExtent,
                              loadTriggerPullDistance,
                              loadIndicatorExtent,
                              axisDirection,
                              float,
                              completeDuration,
                              enableInfiniteLoad,
                              success,
                              noMore) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    child: SpinKitCircle(
                                      color: Colors.green,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                      emptyWidget: (_hasData?controller.allMessageData[_toId]!.data.length==0:!_hasData)
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
                              style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                            ),
                            Expanded(
                              child: SizedBox(),
                              flex: 3,
                            ),
                          ],
                        ),
                      )
                          : null,
                      slivers: <Widget>[
                        if (overflow && _hasData)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return _buildMsg(
                                          controller.allMessageData[_toId]!
                                              .data[index]);
                                },
                                childCount: controller.allMessageData[_toId]!.data.length
                            ),
                          ),
                        if (!overflow && _hasData)
                          SliverToBoxAdapter(
                            child: Container(
                              height: constraints.maxHeight,
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  for (ChatMessageData entity in controller
                                      .allMessageData[_toId]!.data
                                      .reversed)
                                    _buildMsg(entity),
                                ],
                              ),
                            ),
                          ),
                      ],
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 2), () {
                          if (mounted && _hasData) {
                            var meta = Get.find<MessageController>().allMessageData[_toId]!.meta;
                            if(meta.currentPage < meta.lastPage){
                              Get.find<MessageController>().getChatMessageList(_toId,meta.currentPage+1);
                            }
                          }
                        });
                      },
                    );
                  },
                ),
              );
            }),
          SafeArea(
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(
                          4.0,
                        )),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: null,
                        onSubmitted: (value) {
                          if (_textEditingController.text.isNotEmpty) {
                            _sendMsg(_textEditingController.text,"text");
                            _textEditingController.text = '';
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.emoji_emotions_outlined),
                  ),
                  InkWell(
                    onTap: () {
                      if (_textEditingController.text.isNotEmpty) {
                        _sendMsg(_textEditingController.text,"text");
                        _textEditingController.text = '';
                      }
                    },
                    child: Container(
                      height: 30.0,
                      width: 60.0,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        left: 0,
                      ),
                      decoration: BoxDecoration(
                        color: _textEditingController.text.isEmpty
                            ? Colors.grey
                            : Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(
                          4.0,
                        )),
                      ),
                      child: Text(
                        "发送",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
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

  // 构建消息视图
  Widget _buildMsg(ChatMessageData entity) {
    if(entity.type == 'date'){
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(DateUtil.parse(DateTime.parse(entity.createdAt).toLocal()),style: TextStyle(
              fontSize: 12
            ),),
          )
      ],
    );
    }
    UserEntity? _user = Get.find<UserController>().user;
    MessageListEntity? _message = Get.find<MessageController>().messageList;
    if(_user == null || _message ==null){
      return Container();
    }
    MessageListDataStranger _stranger = _message.data.firstWhere( (element) => element.id == _toId).stranger;
    if (entity.fromId==_user.data.id) {
      return
        Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  _user.data.nickname,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  //padding: EdgeInsets.all(10.0),
                  /*decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                  ),*/
                  constraints: BoxConstraints(
                    maxWidth: 200.0,
                  ),
                  child: Bubble(
                    color: Colors.white,
                    direction: BubbleDirection.right,
                    child: Text(
                      entity.content,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  )

                )

              ],
            ),
            Card(
              margin: EdgeInsets.only(
                left: 10.0,
              ),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0.0,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: ExtendedImage.network(
                  _user.data.avatar,
                  fit: BoxFit.fill,
                  cache: true,
                  //cancelToken: cancellationToken,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(
          10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(
                right: 10.0,
              ),
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              elevation: 0.0,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: ExtendedImage.network(
                  _stranger.avatar,
                  fit: BoxFit.fill,
                  cache: true,
                  //cancelToken: cancellationToken,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _stranger.nickname,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5.0,
                  ),
                  //padding: EdgeInsets.all(10.0),
                  /*decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                      4.0,
                    )),
                  ),*/
                  constraints: BoxConstraints(
                    maxWidth: 200.0,
                  ),
                    child: Bubble(
                      color: Colors.white,
                      direction: BubbleDirection.left,
                      child: Text(
                        entity.content,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  // 计算内容的高度
  double _calculateMsgHeight(
      BuildContext context, BoxConstraints constraints, ChatMessageData entity) {
    return 45.0 +
        _calculateTextHeight(
          context,
          constraints,
          text: '我',
          textStyle: TextStyle(
            fontSize: 13.0,
          ),
        ) +
        _calculateTextHeight(
          context,
          constraints.copyWith(
            maxWidth: 200.0,
          ),
          text: entity.content,
          textStyle: TextStyle(
            fontSize: 16.0,
          ),
        );
  }

  /// 计算Text的高度
  double _calculateTextHeight(
    BuildContext context,
    BoxConstraints constraints, {
    String text = '',
    required TextStyle textStyle,
    List<InlineSpan> children = const [],
  }) {
    final span = TextSpan(text: text, style: textStyle, children: children);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);
    return renderObject.computeMinIntrinsicHeight(constraints.maxWidth);
  }
}

/// 信息实体
class MessageEntity {
  bool own;
  String msg;

  MessageEntity(this.own, this.msg);
}
