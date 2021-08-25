import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/data/model/dynamic_comment_entity.dart';
import 'package:flutter_locyin/data/model/dynamic_detail_entity.dart';
import 'package:flutter_locyin/data/model/dynamic_list_entity.dart';
import 'package:flutter_locyin/data/model/user_entity.dart';
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
    }, (DioError error) {
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
}
//语言
class LocaleController extends GetxController {

  Locale? _locale;

  Locale? get  locale => _locale;

  void init(){
    print("正在初始化语言模块...");
    var _localeString = SPUtils.getLocale();
    if(_localeString != null){
      _locale = Locale(_localeString);
      print("设置系统语言为："+ _locale.toString());
    }else{
      print("设置系统语言为："+ Get.deviceLocale.toString());
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

  //游记列表
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
    }, (DioError error) {
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
    }, (DioError error) {
      _dynamic_running = false;
      print(error);
    }, id);
  }
  Future thumb(int id) async {
    //print(_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed);
    _dynamicList!.data.firstWhere( (element) => element.id == id).thumbed = (_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed-1).abs();
    apiService.thumbDynamic((){
      update(['thumb']);
    }, (DioError error) {
      print(error);
    },id);
  }
  Future collect(int id) async {
    //print(_dynamicList!.data.firstWhere( (element) => element.id == id).thumbed);
    _dynamicList!.data.firstWhere( (element) => element.id == id).collected = (_dynamicList!.data.firstWhere( (element) => element.id == id).collected-1).abs();
    apiService.thumbDynamic((){
      update(['collect']);
    }, (DioError error) {
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
      print("更新 Comment 视图");
      _comment_running = false;
      update(['comment']);
    }, (DioError error) {
      _comment_running = false;
      print(error.response);
    },id,page);
  }
  void clearDynamicDetailAndComments(){
    _dynamicDetail = null;
    _commentList = null;
  }
}
