import 'package:flutter/material.dart';
import 'package:flutter_locyin/widgets/wechat_voice_animation.dart';
import 'package:flutter_plugin_record/flutter_plugin_record.dart';
class RecordService {

  // 单例公开访问点
  factory RecordService() =>_sharedInstance();

  // 静态私有成员，没有初始化
  static RecordService _instance = RecordService._();

  // 私有构造函数
  RecordService._() {
    // 具体初始化代码
    _init();
  }

  // 静态、同步、私有访问点
  static RecordService _sharedInstance() {
    return _instance;
  }
 /* RecordService(){
    _init();
  }*/
  FlutterPluginRecord _recordPlugin = new FlutterPluginRecord();

  FlutterPluginRecord get  recordPlugin => _recordPlugin;

  GlobalKey<WeChatVoiceWidgetState>?  _currentVoiceKey;

  GlobalKey<WeChatVoiceWidgetState>?  get currentVoiceKey => _currentVoiceKey;

  void setCurrentVoiceKey(GlobalKey<WeChatVoiceWidgetState> key){
    _currentVoiceKey = key;
  }
  void clearCurrentVoiceKey(){
    _currentVoiceKey = null;
  }

  void _init(){
    ///初始化方法的监听
    _recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    _recordPlugin.responsePlayStateController.listen((data) {
      print("播放路径   " + data.playPath);
      print("播放状态   " + data.playState);
      print(_currentVoiceKey==null);
      print(data.playState == "complete");
      if(data.playState == "complete" && _currentVoiceKey!=null){
        _currentVoiceKey!.currentState!.stop();
        _currentVoiceKey=null;
      }
    });
  }
}