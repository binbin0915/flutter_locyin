import 'package:flutter/material.dart';
import './voice_animation_image.dart';

///类似微信语音播放动画
class WeChatVoiceWidget extends StatefulWidget {
  WeChatVoiceWidget({required Key key}) : super(key: key);
  @override
  WeChatVoiceWidgetState createState() => WeChatVoiceWidgetState();
}

class WeChatVoiceWidgetState extends State<WeChatVoiceWidget> {
  List<String> _assetList = [];
  bool isStop = false;

  @override
  void initState() {
    super.initState();

    _assetList.add("assets/images/left_voice_1.png");
    _assetList.add("assets/images/left_voice_2.png");
    _assetList.add("assets/images/left_voice_3.png");
  }

  @override
  Widget build(BuildContext context) {
    return VoiceAnimationImage(
        _assetList,
        width: 100,
        height: 100,
        isStop: isStop,
      );
  }
  toggle(){
    setState(() {
      isStop = !isStop;
    });
  }
  stop(){
    setState(() {
      isStop = false;
    });
  }
  start(){
    setState(() {
      isStop = true;
    });
  }
  callBackO(bool stop) {
    print(stop);
  }
}