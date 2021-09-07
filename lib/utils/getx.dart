import 'dart:async';
import 'package:dio/dio.dart' as dio;
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
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'auxiliaries.dart';
import 'date.dart';
import 'dart:io';

import 'notification_service.dart';

// APP状态控制器
class ConstantController extends GetxController{

  String? _token;

  String? get  token => _token;

  int _counter = 5;

  int get counter => _counter;

  //是否已经同意使用协议
  bool _hasAgreedPrivacy = false;

  bool get hasAgreedPrivacy => _hasAgreedPrivacy;

  //App是否已经初始化完成
  bool _appIsRunning = false;

  bool get appIsRunning => _appIsRunning;

  AppLifecycleState _appState = AppLifecycleState.inactive;

  AppLifecycleState get appState => _appState;

  void changeAppState(AppLifecycleState state){
    _appState = state;
  }

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
  Future<void> setToken(String token) async {
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
      print("更新游记列表视图");
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

  //聊天会话窗口列表
  MessageListEntity? _messageList;

  MessageListEntity? get messageList => _messageList;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _listRunning  = false;

  bool get listRunning => _listRunning;

  //所有聊天消息的键值对映射
  Map<int,ChatMessageEntity> _allMessageData = {};

  Map<int,ChatMessageEntity> get allMessageData => _allMessageData;

  //用于判断是否正在异步请求数据，避免多次请求
  bool _chatRunning  = false;

  bool get chatRunning => _chatRunning;

  //用户状态初始值
  int _messageStatusCode = Get.find<UserController>().user!.data.status;

  int get messageStatusCode  => _messageStatusCode ;

  //当前会话 ID
  int _windowID = 0;

  int get windowID => _windowID;

  //记录用户聊天状态，默认为普通聊天
  int _chatingStatus = 0;

  int get chatingStatus => _chatingStatus;

  Map<String,dynamic> _initChatRecord = {
    "data": [],
    "links": {
      "first": "",
      "last": "",
      "prev": null,
      "next": null
    },
    "meta": {
      "current_page": 0,
      "from": null,
      "last_page": 1,
      "links": [
        {
          "url": null,
          "label": "",
          "active": false
        },
        {
          "url": "",
          "label": "1",
          "active": true
        },
        {
          "url": null,
          "label": "",
          "active": false
        }
      ],
      "path": "",
      "per_page": "",
      "to": null,
      "total": 0
    }
  };
  //消息类型枚举到字符串映射
  /*final Map<MessageType,String> _messageTypeMap = {
    MessageType.text:"text",
    MessageType.audio:"audio",
    MessageType.image:"image",
    MessageType.video:"video",
    MessageType.speech:"speech",
    MessageType.file:"file",
  };
  Map<MessageType,String> get messageTypeMap => _messageTypeMap;*/
  List<TempAsset> _tempAssetList  = [];

  List<TempAsset> get  tempAssetList  => _tempAssetList;

  //聊天时间计时器
  int _counter = 0;

  int get counter => _counter;

  void initChatRecord(int _id){
    _allMessageData[_id] =  ChatMessageEntity().fromJson(_initChatRecord);
  }
  Future getMessageList () async{
    _listRunning = true;
    await apiService.messageList((MessageListEntity model) {
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
    _messageList!.data.firstWhere( (element) => element.id == id).stranger.status = status;
    update(['message_list']);
  }

  Future getChatMessageList (int id,int page) async{
    _chatRunning = true;
    await apiService.messageRecord((ChatMessageEntity model) {
      /*Map<String,dynamic>  map = {
        "from_id": model.data.last.fromId ,
        "to_id": model.data.last.toId,
        "content": "",
        "push": 0,
        "read": 0,
        "status": 1,
        "type": "date",
        "created_at": DateTime.parse(model.data.last.createdAt).toString().substring(0, 16),
        "updated_at": model.data.last.updatedAt
      };*/
      //ChatMessageData _dateItem = model.data.last;
      //model.data.add(ChatMessageData().fromJson(map));
      if(page==1){
        _allMessageData[id] = model;
      }
      else{
        _allMessageData[id]!.data.addAll(model.data);
        _allMessageData[id] !.meta = model.meta;
        _allMessageData[id] !.links = model.links;
      }

      print("更新聊天界面视图");
      _chatRunning = false;
      update(['message_chat']);
    }, (error) {
      _chatRunning = false;
      print(error);
    },id,page);
  }
  void setCurrentWindow(int id){
    _windowID = id;
  }
  Future<void> handleUploadSpeech (int _window_id,String path,double _length)async {
    //生产消息的UUID
    String _uuid = Uuid().v1();
    //检查是否需要添加时间戳
    bool _needTimeStamp = checkNeedTimeStamp(_window_id);
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    Map<String,dynamic>  _tempAssetMap = {
      "from_id" : Get.find<UserController>().user!.data.id ,
      "to_id": _window_id,
      "content": path.toString(),
      "push": 0,
      "read": 0,
      "status": 1,
      "type": "tempSpeech",
      "uuid": _uuid,
      "thumbnail":null,
      "length": _length,
      "progress": 1.0,
      "created_at": DateTime.now(),
      "updated_at": DateTime.now()
    };
    allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(_tempAssetMap)));
    update(['message_chat']);
    _messageList!.data.firstWhere( (element) => element.id == _window_id).excerpt = "[语音消息]";
    _messageList!.data.firstWhere( (element) => element.id == _window_id).updatedAt = DateUtil.now();
    update(['message_list']);

    apiService.uploadFile((dio.Response response) async {
      print(response.data);
      String src = response.data["src"];
      print("上传成功: ");
      apiService.sendMessage((dio.Response response) {
        print("消息上传成功: ");
      }, (error) {
        print("消息发送成功: ");
        print(error);
      },_window_id,src,"speech",_needTimeStamp?1:0,_uuid,null,_length);

    }, (error) async {
      print("上传失败: ");
      print(error);
    },await dio.MultipartFile.fromFile(path, filename:name),(var sent ,var total){
      _allMessageData[_window_id]!.data.firstWhere( (element) => element.uuid == _uuid).progress=sent/total;
      update(['message_chat']);
    });

  }
  Future handleUploadAssets (int _window_id,AssetEntity entity,Function onResult) async{
      String _uuid = Uuid().v1();
      bool _needTimeStamp = checkNeedTimeStamp(_window_id);
      String _type = Auxiliaries.AssetTypeToString(entity.type);
      File? file = await entity.file;
      String path = file!.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      File  thumbnailFile;
      String? thumbnail;
      if(entity.type == AssetType.video) {
        thumbnailFile = await VideoCompress.getFileThumbnail(
            path,
            quality: 50, // default(100)
            position: -1 // default(-1)
        );
        print("获取到视频缩略图：");
        print(thumbnailFile.path);
        String path2= thumbnailFile.path;
        var name2 = path2.substring(path2.lastIndexOf("/") + 1, path2.length);
        await apiService.uploadFile((dio.Response response) async {
          print("缩略图上传成功");
          print(response.data);
          thumbnail = response.data["src"];
        }, (error) async {
          print("缩略图上传失败");
          print(error);
          ToastUtils.error("图片上传失败,请稍后重试.");
        },await dio.MultipartFile.fromFile(path2, filename:name2),(var sent ,var total){
          //_allMessageData[_window_id]!.data.firstWhere( (element) => element.uuid == _uuid).progress=sent/total;
          print(sent/total);
          //update(['message_chat']);
        });
        await VideoCompress.deleteAllCache();
      }
      if(entity.type == AssetType.video && thumbnail ==null){
        return;
      }
      Map<String,dynamic>  _tempAssetMap = {
        "from_id" : Get.find<UserController>().user!.data.id ,
        "to_id": _window_id,
        "content": path.toString(),
        "push": 0,
        "read": 0,
        "status": 1,
        "type": "tempAsset",
        "uuid": _uuid,
        "progress": 1.0,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      };
      allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(_tempAssetMap)));
      _tempAssetList.add(new TempAsset(_uuid, entity));
      update(['message_chat']);
      _messageList!.data.firstWhere( (element) => element.id == _window_id).excerpt = "[图片]";
      _messageList!.data.firstWhere( (element) => element.id == _window_id).updatedAt = DateUtil.now();
      update(['message_list']);

      apiService.uploadFile((dio.Response response) async {
        print(response.data);
        String src = response.data["src"];
          apiService.sendMessage((dio.Response response) {

          }, (error) {
            print(error);
          },_window_id,src,_type,_needTimeStamp?1:0,_uuid,thumbnail,null);
        print("上传成功: ");
        onResult(entity.id);
      }, (error) async {
        print(error);
      },await dio.MultipartFile.fromFile(path, filename:name),(var sent ,var total){
        _allMessageData[_window_id]!.data.firstWhere( (element) => element.uuid == _uuid).progress=sent/total;
        update(['message_chat']);
      });
  }
  bool checkNeedTimeStamp(int _window_id){
    bool _needTimeStamp = false;
    if(allMessageData[_window_id]!.data.isNotEmpty){
      _needTimeStamp = DateTime.now().difference(DateTime.parse(allMessageData[_window_id]!.data.first.createdAt)).inMinutes>5;
    }else{
      _needTimeStamp = true;
    }
    if(_needTimeStamp){
      Map<String,dynamic>  _dateMap = {
        "from_id": Get.find<UserController>().user!.data.id ,
        "to_id": _window_id,
        "content": DateTime.now().toString(),
        "push": 0,
        "read": 1,
        "status": 1,
        "type": "date",
        "uuid":"0",
        "thumbnail":null,
        "length": null,
        "progress": 1.0,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      };
      allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(_dateMap)));
      return true;
    }else{
      return false;
    }
  }
  void preposeWindow(int window_id){
    int index = _messageList!.data.indexWhere( (element) => element.id == window_id);
    _messageList!.data.insert(0,_messageList!.data[index]);
    _messageList!.data.removeAt(index+1);
  }
  Future sendChatMessages (int _window_id,String _content,String _type,String _uuid) async{
    bool _needTimeStamp = checkNeedTimeStamp(_window_id);
    apiService.sendMessage((dio.Response response) {
      preposeWindow(_window_id);
      Map<String,dynamic>  map = {
        "from_id": Get.find<UserController>().user!.data.id ,
        "to_id": _window_id,
        "content": _content,
        "push": 0,
        "read": 0,
        "status": 1,
        "type": _type,
        "uuid": _uuid,
        "thumbnail":null,
        "length": null,
        "progress": 1.0,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      };
      allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(map)));
      update(['message_chat']);
      updateWindowInfo(_type, _window_id, _content,false);
    }, (error) {
      print(error);
    },_window_id,_content,_type,_needTimeStamp?1:0,_uuid,null,null);
  }
  void updateWindowInfo(String _type,int _window_id,String _content,bool notificatin){
    MessageListData target = _messageList!.data.firstWhere( (element) => element.id == _window_id);
    if(notificatin){
      target.count ++;
    }
    String excerpt = '';
    if(_type != "text"){
      excerpt= Auxiliaries.TranportTypeToPanelType(_type);
    }else{
      excerpt= _content;
    }
    target.excerpt = excerpt;
    target.updatedAt = DateUtil.now();
    preposeWindow(_window_id);
    print("ConstantController().appState");
    print(Get.find<ConstantController>().appState);
    if(Get.find<ConstantController>().appState == AppLifecycleState.paused && notificatin && _type!="videoCall" && _type!="voiceCall"){
      NotificationService().showNotification(target.stranger.nickname,excerpt , _window_id.toString());
    }
    preposeWindow(_window_id);
    print("更新会话列表视图");
    update(['message_list']);
  }
  Future<void> receiveMessage(String _type,int _window_id,String _content,String _uuid,String? _thumbnail,String? _length) async {
    if(!_allMessageData.containsKey(_window_id)){
      print("未初始化聊天页面窗口：$_window_id");
      initChatRecord(_window_id);
      getChatMessageList(_window_id,1);
    }
    if(_window_id == _windowID){
      readMessage(_window_id);
      print("用户在当前会话,直接添加");
      checkNeedTimeStamp(_window_id);
      Map<String,dynamic>  map = {
        "to_id": Get.find<UserController>().user!.data.id ,
        "from_id": _window_id,
        "content": _content,
        "push": 0,
        "read": 0,
        "status": 1,
        "type": _type,
        "uuid": _uuid,
        "thumbnail": _thumbnail,
        "length": _length,
        "progress": 1.0,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      };
      allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(map)));
      print("更新聊天页面视图");
      update(['message_chat']);
      updateWindowInfo(_type, _window_id, _content,true);
    }
    else{
      print("用户不在当前会话");
      if(_messageList == null){
        getMessageList();
      }else{
        bool _contain = false;
        _messageList!.data.forEach((element) {
          if(element.id == _window_id){
            _contain = true;
          }
        });
        if(_contain){
            print("已初始化聊天页面窗口：$_window_id");
            checkNeedTimeStamp(_window_id);
            Map<String,dynamic>  map = {
              "to_id": Get.find<UserController>().user!.data.id ,
              "from_id": _window_id,
              "content": _content,
              "push": 0,
              "read": 0,
              "status": 1,
              "type": _type,
              "uuid":_uuid,
              "thumbnail":_thumbnail,
              "length": _length,
              "progress": 1.0,
              "created_at": DateTime.now(),
              "updated_at": DateTime.now()
            };
            allMessageData[_window_id]!.data.insert(0,(ChatMessageData().fromJson(map)));
            print("更新聊天页面视图");
            update(['message_chat']);
            updateWindowInfo(_type, _window_id, _content,true);
        }else{
            getMessageList();
        }
      }
    }
  }
  Future<void> readMessage(int _window_id) async {
    apiService.readMessages((dio.Response response) {
      _messageList!.data.firstWhere( (element) => element.id == _window_id).count = 0;
      print("更新会话列表视图");
      update(['message_list']);
    }, (dio.DioError error) {
      print(error.response);
    },_window_id);
  }
  Future<bool> chatFromDetailPage(DynamicDetailDataUser _user) async {
    int _window_id = _user.id;
    print(_messageList!.data.contains(_window_id));
    bool _contain = false;
    _messageList!.data.forEach((element) { 
      if(element.id == _window_id){
        _contain = true;
      }
    });
    bool _result = false;
    if(_contain){
      _result = true;
    }else{
      await apiService.createWindow((dio.Response response) async {
        Map<String,dynamic> listMap = {
          "data":[{
            "id": _window_id,
            "stranger": _user.toJson(),
            "count": 0,
            "type": "text",
            "excerpt": "",
            "online": 1,
            "created_at": DateUtil.now(),
            "updated_at": DateUtil.now()
          }]
        };
        Map<String,dynamic>  itemMap = {
          "id": _window_id,
          "stranger": _user.toJson(),
          "count": 0,
          "type": "text",
          "excerpt": "",
          "online": 1,
          "created_at": DateUtil.now(),
          "updated_at": DateUtil.now()
        };
        if(_messageList == null){
          //获取列表
          MessageListEntity().fromJson(listMap);
        }else{
          _messageList!.data.insert(0,(MessageListData().fromJson(itemMap)));
        }
        print(_messageList!.data.length);
        update(['message_list']);
        print("成功创建窗口");
        _result = true;
      }, (error) {
        _result = false;
        print(error);
      },_window_id);
    }
    return _result;
    /*try {
      _messageList!.data.singleWhere((e) => e.id == _window_id);
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }*/
    //如果存在
  }
  void setChattingStatus(int status){
    _chatingStatus = status;
  }
  void setCounter(int count){
    _counter = count;
  }
  void increment(){
    _counter++;
    update(['message_counter']);
  }
  void online(int windowID){
    _messageList!.data.firstWhere( (element) => element.id == windowID).online = 1;
    print("更新会话列表视图");
    update(['message_list']);
  }
  void offline(int windowID){
    _messageList!.data.firstWhere( (element) => element.id == windowID).online = 0;
    print("更新会话列表视图");
    update(['message_list']);
  }
  void readCallback(int windowID){
    if(!_allMessageData.containsKey(windowID)){
      print("未初始化聊天页面窗口：$windowID");
      return;
    }
    _allMessageData[windowID]!.data.where((element) =>
      element.read == 0 && element.toId == windowID
    ).forEach((element) {
      element.read = 1;
    });
    update(['message_chat']);
  }
}
class TempAsset{
  String uuid;
  AssetEntity entity;
  TempAsset(this.uuid,this.entity);
}

