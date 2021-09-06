import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_locyin/common/config.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

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

  /// Creates a call page with given channel name.
  const VideoCallPage({Key? key, required this.channelName,required this.token,required this.requester, required this.nickname, required this.avatar}) : super(key: key);

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
  @override
  void initState() {
    super.initState();
    this._initEngine();

  }

  @override
  void dispose() {
    super.dispose();
    _engine.destroy();
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
          remoteUid.add(uid);
          if(widget.requester){
            connected = true;
          }
        });
      },
      userOffline: (uid, reason) {
        print('userOffline  $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
        _onCallEnd(context);
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
  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: connected? Stack(
          children: [
            _renderVideo(),
            _toolbar(),
          ],
        ):_renderWaitingPage(),
      )
    );
  }

  Widget _renderWaitingPage(){
    if(widget.requester){
      return Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
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
                  onPressed: () {
                    _onCallEnd(context);
                    print("挂断");
                  },
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
                  onPressed: () {
                    _onCallEnd(context);
                    print("拒绝");
                  },
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
            onPressed: () {
              print("挂断");
            },
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
