import 'dart:async';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/record_service.dart';
import 'package:flutter_locyin/widgets/photo_view.dart';
import 'package:flutter_locyin/widgets/video_view.dart';
import 'package:flutter_locyin/widgets/appbar.dart';
import 'package:flutter_locyin/widgets/message_asset_widget_builder.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_locyin/data/model/chat_message_entity.dart';
import 'package:flutter_locyin/data/model/message_list_entity.dart';
import 'package:flutter_locyin/data/model/user_entity.dart';
import 'package:flutter_locyin/page/Map/picker_method.dart';
import 'package:flutter_locyin/utils/date.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/widgets/bubble.dart';
import 'package:flutter_locyin/widgets/loading_dialog.dart';
import 'package:flutter_locyin/widgets/wechat_voice_animation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'call_screen.dart';
import 'record_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
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

  // 输入框
  late TextEditingController _textEditingController;

  // 滚动控制器
  late ScrollController _scrollController;

  // 响应空白处的焦点的Node
  FocusNode blankNode = FocusNode();

  //
  ///用来控制  TextField 焦点的获取与关闭
  FocusNode focusNode = new FocusNode();

  final double _initFabHeight =0.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 280;
  double _panelHeightClosed = 0;
  PanelController _functionPanelController = new PanelController();
  bool _showRecordButton = false;

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    _textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  _onBackspacePressed() {
    _textEditingController
      ..text = _textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }
  // 发送消息
  void _sendMsg(String msg,String type) {
    /*setState(() {
      _msgList.insert(0, MessageEntity(true, msg));
    });*/
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.linear);
    Get.find<MessageController>().sendChatMessages(_toId, msg, "text" ,Uuid().v1());

  }
  //关闭键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
  /*void _initPlayer(){
    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    recordPlugin.responsePlayStateController.listen((data) {
      print("播放路径   " + data.playPath);
      print("播放状态   " + data.playState);
      print(RecordService.currentVoiceKey==null);
      print(data.playState == "complete");
      if(data.playState == "complete" && RecordService.currentVoiceKey!=null){
        RecordService.currentVoiceKey!.currentState!.stop();
        RecordService.currentVoiceKey=null;
      }
    });
  }*/

  void readCallback(){

  }

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
    _textEditingController = TextEditingController(text: Get.find<MessageController>().messageList!.data.firstWhere((element) => element.id == _toId).draft);
    _textEditingController.addListener(() {
      setState(() {

      });
    });
    _scrollController = ScrollController();
    _fabHeight = _initFabHeight;

  }

  @override
  void dispose() {
    super.dispose();
    Get.find<MessageController>().messageList!.data.firstWhere((element) => element.id == _toId).draft=_textEditingController.text;
    //释放
    if(RecordService().currentVoiceKey!=null) {
      RecordService().recordPlugin.stopPlay();
      RecordService().clearCurrentVoiceKey();
    }
    focusNode.dispose();
    blankNode.dispose();
    print("重置聊天窗口id");
    Get.find<MessageController>().setCurrentWindow(0);
    _textEditingController.dispose();
    _scrollController.dispose();
    Get.find<MessageController>().readMessage(_toId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
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
      ),*/
      appBar: CustomAppBar(
        left: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
        title: _nickname,
        right: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.more_horiz_outlined),
        ),
      ),
      //backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: WillPopScope(
          onWillPop: (){
            closeKeyboard(context);
            if(_functionPanelController.isPanelOpen){
              _functionPanelController.close();
              return Future.value(false);
            }
            if(emojiShowing){
              setState(() {
                emojiShowing = false;
              });
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Column(
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
                            if (_hasData)
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
                            /*if (!overflow && _hasData)
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
                              ),*/
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
              Container(
                //color: Colors.grey[100],
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: (){
                          if (_showRecordButton) {
                            if(_functionPanelController.isPanelOpen){
                              _functionPanelController.close();
                            }
                            Future.delayed(Duration(milliseconds: 100), () {
                              FocusScope.of(context).requestFocus(focusNode);
                            });
                            setState(() {
                              emojiShowing = false;
                              _showRecordButton = false;
                            });
                          }else{
                            closeKeyboard(context);
                            setState(() {

                              _showRecordButton = true;
                            });
                          }
                        },
                        child:  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                            child:Icon(Icons.keyboard_voice_outlined)
                        ),
                    ),

                    Expanded(
                      flex: 1,
                      child: _showRecordButton?WeChatRecordScreen(windowID: _toId,): Container(
                        padding: EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(
                            4.0,
                          )),
                        ),
                        child: TextField(
                          onTap: (){
                            if(!focusNode.hasFocus){
                              focusNode.unfocus();
                              if(_functionPanelController.isPanelOpen){
                                  _functionPanelController.close();
                              }
                              emojiShowing = false;
                              //while(_functionPanelController.isPanelOpen){continue;};
                              //1秒后这个i行
                              Future.delayed(Duration(milliseconds: 300), () {
                                 FocusScope.of(context).requestFocus(focusNode);
                              });
                            }
                            //
                          },
                          focusNode: focusNode,
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
                    InkWell(
                        onTap: (){
                          closeKeyboard(context);
                          if(_functionPanelController.isPanelOpen){
                            _functionPanelController.close();
                          }
                          Future.delayed(Duration(milliseconds: 300), () {
                            setState(() {
                              emojiShowing = !emojiShowing;
                            });
                          });

                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                            child:Icon(Icons.emoji_emotions_outlined)
                        ),
                    ),

                    InkWell(
                      onTap: () {
                        if (_textEditingController.text.isNotEmpty) {
                          _sendMsg(_textEditingController.text,"text");
                          _textEditingController.text = '';
                        }
                      },
                      child: _textEditingController.text.isEmpty?
                      InkWell(
                          onTap: (){
                            setState(() {
                              emojiShowing = false;
                            });
                            closeKeyboard(context);
                            Future.delayed(Duration(milliseconds: 500), () {
                              _functionPanelController.open();
                            });

                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                              child:Icon(Icons.add_circle_outline)
                          )
                      )

                              :Container(
                        height: 30.0,
                        width: 60.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: 0,
                        ),
                        decoration: BoxDecoration(
                          color: _textEditingController.text.isEmpty
                              ? (Get.isDarkMode? Get.theme.accentColor:Get.theme.backgroundColor)
                              :  (Get.isDarkMode? Get.theme.accentColor:Get.theme.backgroundColor),
                          borderRadius: BorderRadius.all(Radius.circular(
                            4.0,
                          )),
                        ),
                        child: Text(
                          "发送",
                          style: TextStyle(
                            //0000000000000color: Colors.white,
                            color: Get.theme.cardColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SlidingUpPanel(
                controller: _functionPanelController,
                panel: Center(child: _bottomFunctions(functions)),
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                parallaxEnabled: true,
                parallaxOffset: .5,
                defaultPanelState:PanelState.CLOSED,
                isDraggable: false,
                boxShadow: null,
                /*onPanelSlide: (double pos) => setState(() {
                  FocusScope.of(context).requestFocus(blankNode);
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                      _initFabHeight;
                }),*/
              ),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: _panelHeightOpen,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Get.theme.cardColor,
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecentsText: 'No Recents',
                          noRecentsStyle: const TextStyle(
                              fontSize: 20, color: Colors.black26),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
            ],
          ),
        ),
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
                    //color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:4.0),
                      child: entity.progress!=1.0? new CircularPercentIndicator(
                          radius: 32.0,
                          lineWidth: 3,
                          percent: 0.615415156,
                          center: new Text("${entity.progress.toString().substring(2,4)}%",style: TextStyle(
                            fontSize: 10
                          ),),
                          progressColor: Colors.green,
                        ):Container(),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 4.0,
                      ),
                      //padding: EdgeInsets.all(10.0),
                      /*decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.all(Radius.circular(
                          4.0,
                        )),
                      ),*/
                      constraints: BoxConstraints(
                        maxWidth: 250.0,
                      ),
                      child: Badge(
                        position: BadgePosition.bottomStart(bottom: -6),
                        toAnimate: true,
                        animationType: BadgeAnimationType.slide,
                        //badgeColor: Colors.cyan,
                        child: _buildChatContent(entity.type, entity.content,entity.uuid,BubbleDirection.right,entity.thumbnail,entity.length),
                        badgeColor: Colors.green,
                        showBadge: entity.read ==1
                      )
                      //

                    ),
                  ],
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
                    //color: Colors.grey,
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
                    child: _buildChatContent(entity.type, entity.content,entity.uuid,BubbleDirection.left,entity.thumbnail,entity.length)
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
  List<AssetEntity> assets = <AssetEntity>[];

  int  maxAssetsCount = 9;

  /// These fields are for the keep scroll position feature.
  DefaultAssetPickerProvider keepScrollProvider = DefaultAssetPickerProvider();

  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        _upLoadAssets();
      }
    }
  }
  /*List<dio.MultipartFile> files = [];
  Future<void> _addFile(int i) async{
    File? file = await assets[i].file;
    String path = file!.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    //print(path);
    //print(name);
    files.add(await dio.MultipartFile.fromFile(path, filename:name));
  }
  Future<void> _control(int j) async {
    if(j<0){
      return ;
    }
    await _addFile(j).then((value) => _control(j-1));
  }*/

  Future<void> _upLoadAssets()async {
/*      int successTask = 0;
      int failedTask = 0;
      int sum = assets.length;
      files = [];
      await _control(sum-1);
      print(files.length);*/
      assets.forEach((element) {
        Get.find<MessageController>().handleUploadAssets(_toId, element,(String id){
          assets.removeAt(assets.indexWhere((element) => element.id==id));
        });
      });
      /*while((successTask+failedTask) != sum){

      }*/
      //print("成功上传文件个数：$successTask");
      //print("成功失败文件个数：$failedTask");
      //files = [];
  }
  List<Icon> popIcons = [
    Icon(Icons.picture_in_picture),
    Icon(Icons.camera_alt),
    Icon(Icons.mic_none_rounded),
    Icon(Icons.video_call)
  ];
  List<FunctionsEntity> functions  = [
    FunctionsEntity(Icon(Icons.picture_in_picture),"相册",0,PickMethod.cameraAndStay( maxAssetsCount: 9 ),videoChat),
    FunctionsEntity(Icon(Icons.camera_alt), "拍摄", 0,PickMethod.cameraAndStay( maxAssetsCount: 9 ),videoChat),
    FunctionsEntity(Icon(Icons.mic_none_rounded) ,"语音聊天",1,PickMethod.cameraAndStay( maxAssetsCount: 9 ),audioChat),
    FunctionsEntity(Icon(Icons.video_call), "视频通话", 1, PickMethod.cameraAndStay( maxAssetsCount: 9 ),videoChat),
    FunctionsEntity(Icon(Icons.location_on_outlined), "位置", 1, PickMethod.cameraAndStay( maxAssetsCount: 9 ),sendPosition),
    FunctionsEntity(Icon(Icons.folder_shared), "文件", 1, PickMethod.cameraAndStay( maxAssetsCount: 9 ),sendFile),
  ];
  /*List<Color> popColors = [
    Colors.deepOrangeAccent,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.blueAccent,
  ];*/
 /* List<Function> popFunctions = [
    PickMethod.cameraAndStay( maxAssetsCount: 9 ),
    PickMethod.cameraAndStay( maxAssetsCount: 9 ),
    audioChat,
    videoChat,
    ];*/
  Widget _selectedAssetWidget(BuildContext context, AssetEntity asset ,List<AssetEntity> tempAssets,int index) {
    return ValueListenableBuilder<bool>(
      valueListenable: ValueNotifier<bool>(true),
      builder: (_, bool value, __) => GestureDetector(
        onTap: () async {
          if (value) {
            final List<AssetEntity>? result =
            await AssetPickerViewer.pushToViewer(
              context,
              currentIndex: index,
              previewAssets: tempAssets,
              themeData: AssetPicker.themeData(Color(0xff00bc56)),
            );
          }
        },
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: MessageAssetWidgetBuilder(
              entity: asset,
              isDisplayingDetail: value,
            ),
          ),
        ),
      ),
    );
  }
  Widget _bottomFunctions( List<FunctionsEntity> list){
    return Scaffold(
      body: Container(
        height: 300,
        padding: EdgeInsets.only(top: 36),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              //crossAxisSpacing: 16,
              mainAxisSpacing: 12,
              childAspectRatio: 1),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return _functionWidgetBuilder(
                list[index]);
          },
        ),
      ),
    );
  }
  Widget _functionWidgetBuilder(FunctionsEntity entity) {
    return InkWell(
      onTap: () {
            if(entity.type==0){
               selectAssets(entity.pickfun);
            }else{
              entity.fun();
            }
      },
      child: Container(
        decoration: BoxDecoration(
            //color:  Colors.grey[200],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  //color:  Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: entity.icon,
            ),
            SizedBox(
              height: 4,
            ),
            Text(entity.label),
          ],
        ),
      ),
    );
  }
  static Future<void> audioChat()async {

  }
  static void sendFile() {

  }
  static void sendPosition() {

  }
  static Future<void> videoChat()async {
    String uuid = Uuid().v1();
    int windowID = Get.find<MessageController>().windowID;
    int userID = Get.find<UserController>().user!.data.id;
    MessageListDataStranger stranger = Get.find<MessageController>().messageList!.data.firstWhere( (element) => element.stranger.id == windowID).stranger;
    await apiService.requestVideoCall((dio.Response response) {
      Get.find<MessageController>().setChattingStatus(1);
      String token = response.data['token'];
      String channelName = response.data['channelName'];
      Get.to(() => VideoCallPage(token: token, channelName: channelName, nickname: stranger.nickname, avatar: stranger.avatar, requester: true, windowID: windowID, userID:userID,));
      print(response.data);
    }, (dio.DioError error) {
      Get.find<MessageController>().setChattingStatus(0);
      print(error.response);
    },windowID ,uuid);
  }
  Widget _buildChatContent(String type,String content,String uuid,BubbleDirection direction,String? thumbnail,double? length){
      switch(type){
        case"text":
          return Bubble(
            color: direction ==BubbleDirection.left? Get.theme.cardColor:Get.theme.backgroundColor ,
            direction: direction,
            child: Text(
              content,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          );
        case "image":
          print(Get.find<MessageController>().allMessageData[_toId] == null);
          List<ChatMessageData> images  = Get.find<MessageController>().allMessageData[_toId]!.data.where((element) => element.type == "image").toList();
          images.reversed;
          int initPage = images.indexWhere((element) => element.uuid == uuid);
          print(images.length);
          print(initPage);
          return Container(
            constraints: BoxConstraints(maxHeight: 160),
            child: InkWell(
              onTap: (){Get.to(PhotoViewPage(images: images, initPage: initPage));},
              child: ExtendedImage.network(
                images[initPage].content,
                //width:  ScreenUtil().setWidth(400),
                //height: 400,
                fit: BoxFit.contain,
                cache: true,
                //border: Border.all(color: Colors.red, width: 1.0),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //cancelToken: cancellationToken,
              ),
            )
          );
        case "video":
          return Container(
            constraints: BoxConstraints(maxHeight: 160),
            child: InkWell(
              onTap: (){Get.to(VideoViewPage(url:content));},
              child:Stack(
                alignment:Alignment.centerRight,
                children: <Widget>[
                  ExtendedImage.network(
                    thumbnail.toString(),
                    //width:  ScreenUtil().setWidth(400),
                    //height: 400,
                    fit: BoxFit.contain,
                    cache: true,
                    //border: Border.all(color: Colors.red, width: 1.0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //cancelToken: cancellationToken,
                  ),
                  Positioned.fill(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.video_library,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        case "audio":return Container();
        case "speech":return _SpeechBuilder(content,direction,false,length);
        case "videocall":
          return InkWell(
              onTap: videoChat,
              child: Bubble(
                color: direction ==BubbleDirection.left? Get.theme.cardColor:Get.theme.backgroundColor ,
                direction: direction,
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.video_call_outlined),
                        SizedBox(
                          width:4
                        ),
                        Text(
                          content
                        )
                      ],
                    ),
                ),
              )
          );
        case "voicecall":
          return InkWell(
              onTap: videoChat,
              child: Bubble(
                color: direction ==BubbleDirection.left? Get.theme.cardColor:Get.theme.backgroundColor ,
                direction: direction,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.voice_chat),
                      SizedBox(
                          width:4
                      ),
                      Text(
                          content
                      )
                    ],
                  ),
                ),
              )
          );
        case "tempAsset":
          List<TempAsset> tempAssets  = Get.find<MessageController>().tempAssetList;
          AssetEntity tempAsset = tempAssets.firstWhere((element) => element.uuid == uuid).entity;
          int index = tempAssets.indexWhere((element) => element.uuid == uuid);
          List<AssetEntity> assetsSum = [];
          tempAssets.forEach((element) {
            assetsSum.add(element.entity);
          });
          return _selectedAssetWidget(context,tempAsset,assetsSum,index);
        case "tempSpeech":
          return _SpeechBuilder(content,direction,false,length);
        default:return Container();
      }
  }
  Widget _SpeechBuilder(String path,BubbleDirection direction,bool isTemp, double? length){
    GlobalKey<WeChatVoiceWidgetState> voiceKey = GlobalKey();
    String type = isTemp?"file":"url";
    return Bubble(
      color: direction ==BubbleDirection.left? Get.theme.cardColor:Get.theme.backgroundColor ,
      direction: direction,
      child: InkWell(
        onTap: (){
          print(RecordService().currentVoiceKey!=null);
          if(RecordService().currentVoiceKey!=null){
            RecordService().recordPlugin.stopPlay();
            voiceKey.currentState!.stop();
            if(RecordService().currentVoiceKey == voiceKey){
              return;
            }else{
              Future.delayed(Duration(milliseconds: 500), () {
                RecordService().setCurrentVoiceKey(voiceKey);
                voiceKey.currentState!.start();
                RecordService().recordPlugin..playByPath(path,type);
              });
            }
          }else{
            if(voiceKey.currentState!.hasStart()){
              RecordService().clearCurrentVoiceKey();
              voiceKey.currentState!.stop();
              RecordService().recordPlugin.stopPlay();
            }else{
              RecordService().setCurrentVoiceKey(voiceKey);
              voiceKey.currentState!.start();
              RecordService().recordPlugin.playByPath(path,type);
            }
          }


        },
        child: Container(
          height:32,
          width: 138,
          child:
          direction ==BubbleDirection.left?
          Row(
            children: [
              WeChatVoiceWidget(
                key: voiceKey,
              ),
              Text(length.toString(),style: TextStyle(
                  fontSize: 15
              ),)
            ],
          ):Row(
            children: [
              Text(length.toString(),style: TextStyle(
                  fontSize: 15
              ),),
              RotatedBox(quarterTurns: 6,child: WeChatVoiceWidget(
                key: voiceKey,
              ),),
            ],
          ),
        ),
      ),
    );


  }
}
class FunctionsEntity{
  Icon icon;
  String label;
  int type;
  PickMethod pickfun;
  Function fun;
  FunctionsEntity(this.icon,this.label,this.type,this.pickfun,this.fun);
}
