import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/data/model/chat_message_entity.dart';
import 'package:flutter_locyin/data/model/dynamic_comment_entity.dart';
import 'package:flutter_locyin/data/model/dynamic_detail_entity.dart';
import 'package:flutter_locyin/data/model/dynamic_list_entity.dart';
import 'package:flutter_locyin/data/model/message_list_entity.dart';
import 'package:flutter_locyin/data/model/user_entity.dart';
import 'package:flutter_locyin/page/Message/message.dart';
import 'package:flutter_locyin/utils/sputils.dart';
import 'package:get/get.dart';

// APP状态控制器
class ConstantController extends GetxController{

  String? _token;

  String _baseUrl = kDebugMode?"http://192.168.10.10/api/v1/":"https://locyin.com/api/v1/";
  //接口基础 Url
  //String _baseUrl = "https://api.locyin.com/api/v1/";

  //广告页点击跳转网址
  String _advantageUrl = "https://flutter.dev";

  //广告页图片
  String _advantageImageUrl = "https://locyin.oss-cn-beijing.aliyuncs.com/apps/luoxun_flutter/images/splash.png";

  String? get  token => _token;

  String get  baseUrl => _baseUrl;

  String get  advantageUrl => _advantageUrl;

  String get  advantageImageUrl => _advantageImageUrl;

  int _counter = 5;

  int get counter => _counter;

  //是否已经同意使用协议
  bool _hasAgreedPrivacy = false;

  bool get hasAgreedPrivacy => _hasAgreedPrivacy;

  //App是否已经初始化完成
  bool _appIsRunning = false;

  bool get appIsRunning => _appIsRunning;

  void init(){
    initToken();
    initPrivacy();
  }
  void initToken(){
    print("正在初始化 Token 设置...");
    String? token =  SPUtils.getToken();
    if(token != null){
      _token = token;
      print("Token值：$token");
    }else{
      print("Token 不存在");
    }
  }

  void initPrivacy(){
    print("正在初始化隐私设置...");
    bool? _hasAgreed = SPUtils.getPrivacy();
    if(_hasAgreed==true){
      _hasAgreedPrivacy = true;
    }
    print("初始化隐私设置完成");
  }
  void setToken(String token) {

    _token = token;
    //语言的持久化存储
    SPUtils.saveToken(token);

  }
  void clearToken(){
    print("正在清空Token状态...");
    _token = null;
    //清除 Token 的持久化存储
    SPUtils.clearToken();
  }

  void decrement(){
    _counter--;
    update();
  }
  void agreePrivacy() {
    _hasAgreedPrivacy = true;
    //隐私的持久化存储
    SPUtils.savePrivacy();
  }

  void setAppRunningStatus(){
    _appIsRunning = true;
  }

}
// 用户信息状态控制器
class UserController extends GetxController{

  UserEntity? _user;

  UserEntity? get  user => _user;

  Map<String, Object>? _location;

  Map<String, Object>? get location => _location;

  Future<void> init() async{
    print("正在初始化用户状态...");
    String? token = Get.find<ConstantController>().token;
    print(token);
    if(token != null){
      await getUserInfo();
    }else{
      print("用户没有登录！");
    }
  }
  Future<void> getUserInfo() async{
    print("开始获取用户信息...");
    await apiService.getUserInfo((UserEntity model) {
      print("获取用户信息成功！");
      _user = model;
      update();
    }, (dio.DioError error) {
      print("获取用户信息失败！");
      //handleLaravelErrors(error);
    },);
  }
  void setUser(UserEntity user) {
    _user = user;
    //语言的持久化存储
  }
  void clearUser(){
    _user = null;
  }
  void updateLocation(Map<String, Object>? loc){
    _location= loc;
    print("更新位置视图");
    update(['location']);
  }
}
//语言
class LocaleController extends GetxController {

  Locale? _locale;

  Locale? get  locale => _locale;

  void init(){
    print("正在初始化语言模块...");
    print("系统语言为：${Get.deviceLocale}");
    var _localeString = SPUtils.getLocale();
    if(_localeString != null){
      _locale = Locale(_localeString);
      print("设置系统语言为："+ _locale.toString());
    }else{
      print("设置系统语言为："+ Get.deviceLocale.toString());
      _locale = Locale(Get.deviceLocale.toString());
    }
  }

  void setLocale(String l) {

    _locale = Locale(l);
    //语言的持久化存储
    SPUtils.saveLocale(l);
    Get.updateLocale(_locale!);
    //update();

  }
  void clearLocale(){
    print("正在清空语言设置...");
    print("当前设备语言:"+Get.deviceLocale.toString());
    //清空_locale
    _locale = null;
    //清除语言的持久化存储
    SPUtils.clearLocale();
    Get.updateLocale(Get.deviceLocale!);
    //update();
  }
}

//昼夜模式控制器
class DarkThemeController extends GetxController{

  bool _isDartTheme = false;
  bool get  isDarkTheme => _isDartTheme;

  void changeDarkTheme(){
    if(_isDartTheme == true){
      clearDarkTheme();
    }else{
      setDarkTheme();
    }
  }
  void setDarkTheme(){
    print("正在保存黑夜主题设置...");
    _isDartTheme = true;
    SPUtils.saveDarkTheme();
    Get.changeTheme(ThemeData.dark());
    print("已设置为黑夜主题");
  }
  void clearDarkTheme(){
    print("正在清空黑夜主题设置...");
    _isDartTheme = false;
    SPUtils.clearDarkTheme();
    Get.changeTheme(ThemeData.light());
    print("已设置为白天主题");
  }

  void init(){
    print("正在初始化主题设置...");
    if(SPUtils.getDarkTheme() != null){
      _isDartTheme = true;
      print("主题设置为：黑夜模式");
    }else{
      print("主题设置为：白天模式");
    }

  }
}
// 游记列表状态控制器
class DynamicController extends GetxController{

  //游记列表
  DynamicListEntity? _dynamicList;
  DynamicListEntity? get dynamicList => _dynamicList;

  //游记评论列表
  DynamicCommentEntity? _commentList;
  DynamicCommentEntity? get commentList => _commentList;

  //游记详情
  DynamicDetailEntity? _dynamicDetail;
  DynamicDetailEntity? get dynamicDetail => _dynamicDetail;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _dynamic_running  = false;
  bool get dynamic_running => _dynamic_running;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _comment_running  = false;
  bool get comment_running => _comment_running;

  Future getDynamicList (int page) async{

    _dynamic_running = true;
    apiService.getDynamicList((DynamicListEntity model) {
      if(_dynamicList == null || page==1){
        _dynamicList = model;
      }
      else{
        if(_dynamicList!.meta.currentPage == model.meta.currentPage){
          return;
        }
        _dynamicList!.data.addAll(model.data);
        _dynamicList!.meta = model.meta;
        _dynamicList!.links = model.links;
      }
      print("更新视图");
      _dynamic_running = false;
      update(['list']);
    }, (dio.DioError error) {
      _dynamic_running = false;
      print(error.response);
    },page);
  }

  Future getDynamicDetail(int id) async {
    _dynamicDetail = null;
    //update(['detail']);
    _dynamic_running = true;
    apiService.getDynamicDetail((DynamicDetailEntity data) {
      _dynamicDetail = data;
      _dynamic_running = false;
      update(['detail']);
    }, (dio.DioError error) {
      _dynamic_running = false;
      print(error);
    }, id);
  }
  Future thumb(int id) async {
    //print(_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed);
    _dynamicList!.data.firstWhere( (element) => element.id == id).thumbed = (_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed-1).abs();
    apiService.thumbDynamic((){
      update(['thumb']);
    }, (dio.DioError error) {
      print(error);
    },id);
  }
  Future collect(int id) async {
    //print(_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed);
    _dynamicList!.data.firstWhere( (element) => element.id == id).collected = (_dynamicList!.data.firstWhere( (element) => element.id == id).collected-1).abs();
    apiService.thumbDynamic((){
      update(['collect']);
    }, (dio.DioError error) {
      print(error);
    },id);
  }
  Future getDynamicCommentList (int id,int page) async{

    _comment_running = true;
    apiService.getDynamicCommentList((DynamicCommentEntity model) {
      if(_commentList == null || page==1){
        _commentList = model;
      }
      else{
        if(_commentList!.meta.currentPage == model.meta.currentPage){
          return;
        }
        _commentList!.data.addAll(model.data);
        _commentList!.meta = model.meta;
        _commentList!.links = model.links;
      }
      print("更新评论视图");
      _comment_running = false;
      update(['comment']);
    }, (dio.DioError error) {
      _comment_running = false;
      print(error.response);
    },id,page);
  }
  void clearDynamicDetailAndComments(){
    _dynamicDetail = null;
    _commentList = null;
  }
}
class MessageController extends GetxController{

  final List<StatusEntity> _iconsList  = [
    StatusEntity("在线", "online", Icon(Icons.online_prediction_rounded,color: Colors.green)),
    StatusEntity("隐身", "hide", Icon(Icons.view_headline_rounded,color: Colors.orange)),
    StatusEntity("离线", "offline", Icon(Icons.logout,color: Colors.grey)),
    StatusEntity("忙碌", "busy", Icon(Icons.event_busy,color: Colors.red)),
    StatusEntity("搬砖", "working", Icon(Icons.file_copy_sharp,color: Colors.cyan)),
  ];
  List<StatusEntity> get iconsList => _iconsList;
  //聊天总体列表
  MessageListEntity? _messageList;
  MessageListEntity? get messageList => _messageList;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _listRunning  = false;

  bool get listRunning => _listRunning;

  //单个聊天列表
  ChatMessageEntity? _chatList;
  ChatMessageEntity? get chatList => _chatList;

  //所有列表的键值对映射
  Map<int,ChatMessageEntity> _allMessageData = {};

  Map<int,ChatMessageEntity> get allMessageData => _allMessageData;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _chatRunning  = false;

  bool get chatRunning => _chatRunning;

  //初始值默认为离线3
  int _messageStatusCode = Get.find<UserController>().user!.data.status;
  int get messageStatusCode  => _messageStatusCode ;

  int _windowID = 0;
  int get windowID => _windowID;

  Future getMessageList () async{
    _listRunning = true;
    apiService.messageList((MessageListEntity model) {
      _messageList = model;
      print("更新联系人列表视图");
      _listRunning = false;
      update(['message_list']);
    }, (dio.DioError error) {
      _listRunning = false;
      print(error.response);
    });
  }
  Future updateMessageStatus(int status) async{
    apiService.updateMessageStatus((dio.Response response) {
      _messageStatusCode = status;
      update(['mine_status']);
    }, (dio.DioError error) {
      print(error.response);
    },status);
  }
  Future updateSrangerStatus(int id,int status) async{
    _messageList!.data.firstWhere( (element) => element.stranger.id == id).stranger.status = status;
    update(['message_list']);
  }

  Future getChatMessageList (int id) async{
    _chatRunning = true;
    apiService.messageRecord((ChatMessageEntity model) {
      _chatList = model;
      _allMessageData[id] = _chatList!;
      print("更新聊天界面视图");
      _chatRunning = false;
      update(['message_chat']);
    }, (dio.DioError error) {
      _chatRunning = false;
      print(error.response);
    },id);
  }
  void setCurrentWindow(int id){
    _windowID = id;
  }
  Future sendChatMessages (int _toID,String _content,String _type) async{
    apiService.sendMessage((dio.Response response) {
      if(_chatList == null){
        /*Map  map={
            "from_id": Get.find<UserController>().user!.data.id ,
            "to_id": _toID,
            "content": _content,
            "push": 0,
            "read": 0,
            "status": 1,
            "type": _type,
            "created_at": "2021-08-31T11:14:34.000000Z",
            "updated_at": "2021-08-31T11:14:34.000000Z"
        };*/
        print("网络获取");
        getChatMessageList(_toID);
      }else{
        Map<String,dynamic>  map = {
            "from_id": Get.find<UserController>().user!.data.id ,
            "to_id": _toID,
            "content": _content,
            "push": 0,
            "read": 0,
            "status": 1,
            "type": _type,
            "created_at": "2021-08-31T11:14:34.000000Z",
            "updated_at": "2021-08-31T11:14:34.000000Z"
        };
        _chatList!.data.insert(0,(ChatMessageData().fromJson(map)));
        print(_chatList!.data.length);
      }
      print("更新聊天页面视图");
      update(['message_chat']);
    }, (dio.DioError error) {
      print(error.response);
    },_toID,_content,_type);
  }
  Future<void> receiveMessage(String _type,int _window_id,String _content) async {
    if(_window_id == _windowID){
      print("用户在当前会话");
      if(!allMessageData.containsKey(_window_id)){
        print("没有初始化数据");
        getChatMessageList(_window_id);
      }else{
        print("当前会话，直接添加");
        Map<String,dynamic>  map = {
          "to_id": Get.find<UserController>().user!.data.id ,
          "from_id": _window_id,
          "content": _content,
          "push": 0,
          "read": 1,
          "status": 1,
          "type": _type,
          "created_at": "2021-08-31T11:14:34.000000Z",
          "updated_at": "2021-08-31T11:14:34.000000Z"
        };
        allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(map)));
        print("更新聊天页面视图");
        update(['message_chat']);
      }

    }else{
      print("用户不在当前会话");
      _messageList!.data.firstWhere( (element) => element.stranger.id == _window_id).count ++;
      _messageList!.data.firstWhere( (element) => element.stranger.id == _window_id).excerpt = _content;
      print("更新聊天会话视图");
      update(['message_list']);
    }
  }
  Future<void> readMessage(int _toID) async {
    apiService.readMessages((dio.Response response) {
      _messageList!.data.firstWhere( (element) => element.stranger.id == _toID).count = 0;
      print("更新聊天会话视图");
      update(['message_list']);
    }, (dio.DioError error) {
      print(error.response);
    },_toID);
  }
}
