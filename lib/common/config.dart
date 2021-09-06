import 'package:flutter/foundation.dart';

class LocyinConfig {

  //接口基础 Url
  //static const String  baseUrl = kDebugMode?"http://192.168.10.10/api/v1/":"https://api.locyin.com/api/v1/";
  static const String  baseUrl = "https://api.locyin.com/api/v1/";

  //Socket 地址
  //static const String  socketUrl = "ws://192.168.10.10:8282";
  static const String  socketUrl = "wss://api.locyin.com/wss";


  //广告页点击跳转网址
  static const String  advantageUrl = "https://flutter.dev";

  //广告页图片
  static const String advantageImageUrl = "https://locyin.oss-cn-beijing.aliyuncs.com/apps/luoxun_flutter/images/splash.png";

  /// Get your own App ID at https://dashboard.agora.io/
  static const appId = "04ac2a2957c24c95bf9a49e8c9c9229e";

}