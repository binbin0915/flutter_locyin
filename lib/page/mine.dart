import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/widgets/wechat_voice.dart';
import 'package:get/get.dart';
import '../widgets/voice_animation_image.dart';

///类似微信语音播放动画
class MinePage extends StatefulWidget {
  MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
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
    return Scaffold(
        body: ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index){
              return _itemBuilder(index);
            })

    );
  }
  Widget _itemBuilder(int index){
    return GetBuilder<MessageController>(
        init: MessageController(),
        id: "message_chat",
        builder: (controller) {
          GlobalKey<WeChatVoiceWidgetState> voiceKey = GlobalKey();
          return InkWell(
            onTap: (){
              voiceKey.currentState!.toggle();
            },
            child: index%2 ==0?
            WeChatVoiceWidget(
              key: voiceKey,
            ):RotatedBox(quarterTurns: 6,child: WeChatVoiceWidget(
              key: voiceKey,
            ),),
          );
        });
  }
}
