import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_locyin/common/config.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio;
import 'package:uuid/uuid.dart';
class VideoCallPage extends StatefulWidget {
  /// 服务器端返回的token
  final String token;
  /// non-modifiable channel name of the page
  final String channelName;

  final bool requester;

  /// 用户昵称
  final String nickname;

  /// 用户头像
  final String avatar;

  /// 会话 ID
  final int windowID;

  /// 用户 ID
  final int userID;

  /// Creates a call page with given channel name.
  const VideoCallPage({Key? key, required this.channelName,required this.token,required this.requester, required this.nickname, required this.avatar, required this.windowID, required this.userID}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;
  String? channelName ;
  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  bool muted = false;
  bool connected = false;
  Timer? _timer;
  var period = const Duration(seconds: 1);
  @override
  void initState() {
    super.initState();
    this._initEngine();

  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
    if(_timer != null){
      _timer!.cancel();
    }
    //_resetBusy();
    if(widget.requester){
      String content = '已取消';
      int sum = Get.find<MessageController>().counter;
      if( sum!=0){
        int minute = sum~/60;
        int second = sum%60;
        content = "聊天时长 "+ (minute>10?minute.toString():("0"+minute.toString()))+':'+(second>=10?second.toString():("0"+second.toString()));
      }
      Get.find<MessageController>().sendChatMessages(widget.windowID, content, 'videocall', Uuid().v1());
    }
    Get.find<MessageController>().setChattingStatus(0);
    Get.find<MessageController>().setCounter(0);
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(LocyinConfig.appId));
    this._addListeners();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    if(widget.requester){
      await _joinChannel();
    }
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined  $uid $elapsed');
        setState(() {
          _startCounter();
          remoteUid.add(uid);
          if(widget.requester){
            connected = true;
          }
        });
      },
      userOffline: (uid, reason) {
        print('userOffline  $uid $reason');
        /*setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });*/
        _onCallEnd();
      },
      leaveChannel: (stats) {
        print('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    //await _engine.joinChannel(null, channelId, null, config.uid);
    await _engine.joinChannel(widget.token, widget.channelName, null, 0);
  }

  _acceptRequest() async{
    await _joinChannel();
    setState(() {
      connected = true;
    });
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      log('switchCamera $err');
    });
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      //remoteUid = List.of(remoteUid.reversed);
    });
  }
  void _onCallEnd() {
    _videoCallback(0);
    Get.back();
  }
  void _onRect() {
    _videoCallback(2);
    Get.back();
  }
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }
/*  Future<void> _resetBusy() async {
    await apiService.resetBusy((dio.Response response) {
      print(response.data);
    }, (dio.DioError error) {
      print(error.response);
    },widget.windowID ,widget.userID);
  }*/
  Future<void> _videoCallback(int status) async {
    apiService.videoCallback((dio.Response response) {
      print(response.data);
    }, (dio.DioError error) {
      print(error.response);
    },widget.windowID ,status);
  }
  void _startCounter(){
    try {
      //定时器，period为周期
      _timer = Timer.periodic(period, (timer) {
        Get.find<MessageController>().increment();
        if (!connected) {
          timer.cancel();
        }
      });
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:WillPopScope(
          onWillPop: (){
            return Future.value(false);
          },
            child: connected? Stack(
              children: [
                _renderVideo(),
                _counter(),
                _toolbar(),
              ],
            ):_renderWaitingPage()
        ),
      )
    );
  }

  Widget _renderWaitingPage(){
    if(widget.requester){
      return Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              children:[
                SizedBox(
                  height: 80,
                  width:80,
                  child:CircleAvatar(
                        child: Image.network(widget.avatar)
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Text("正在等待${widget.nickname}接受邀请..."),
              ]
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic : Icons.mic_off,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed:_onRect,
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ),
          ),
        ],
      );
    }else{
      return Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child:Column(
              children: [
                SizedBox(
                  height: 80,
                  width:80,
                  child:CircleAvatar(
                      child: Image.network(widget.avatar)
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Text("${widget.nickname}请求视频通话..."),
              ],
            )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic : Icons.mic_off,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                RawMaterialButton(
                  onPressed: _onCallEnd,
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
                RawMaterialButton(
                  onPressed: () async {
                    await _acceptRequest();
                    print("接听");
                  },
                  child: Icon(
                    Icons.video_call_outlined,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.green,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: _onCallEnd,
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _switchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }
  Widget _counter(){
    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: GetBuilder<MessageController>(
        init: MessageController(),
    id:'message_counter',
    builder: (controller){
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              if((controller.counter~/60)<10)Text('0'),
              Text((controller.counter~/60).toString()),
              Text(':'),
              if(controller.counter<10)Text('0'),
              Text((controller.counter).toString()),
            ]
        );
    }),
    );
  }
  _renderVideo() {
    return Expanded(
      child: Stack(
        children: [
          switchRender? RtcLocalView.SurfaceView(): RtcRemoteView.SurfaceView(
            uid: remoteUid.first,
           ),
          Align(
            alignment: Alignment.topRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.of(remoteUid.map(
                      (e) => GestureDetector(
                    onTap: this._switchRender,
                    child: Container(
                      width: 120,
                      height: 200,
                      child: switchRender? RtcRemoteView.SurfaceView(
                        uid: e,
                      ):RtcLocalView.SurfaceView(),
                    ),
                  ),
                )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
