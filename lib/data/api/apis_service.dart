import 'package:dio/dio.dart';
import 'package:flutter_locyin/data/api/apis.dart';
import 'package:flutter_locyin/data/model/dynamic_list_entity.dart';
import 'package:flutter_locyin/data/model/user_entity.dart';
import 'package:flutter_locyin/utils/dio_manager.dart';

ApiService _apiService = new ApiService();

ApiService get apiService => _apiService;

class ApiService {

  /// 手机号登录发送短信验证码
  void sendCodes(Function callback, Function errorCallback,
      String _phone) async {
    FormData formData = new FormData.fromMap({
      "phone": _phone,
    });
    Map params = {
      "phone": _phone,
    };
    BaseNetWork.instance.dio.post(Apis.LOGIN_CODES, data: params).then((
        response) {
      callback(response);
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 手机号登录
  void loginBycodes(Function callback, Function errorCallback,
      String _verification_key, String _verification_code) async {
    FormData formData = new FormData.fromMap({
      "verification_key": _verification_key,
      "verification_code": _verification_code,
    });
    BaseNetWork.instance.dio.post(Apis.LOGIN_PHONE, data: formData).then((
        response) {
      callback(response);
    }).catchError((e) {
      errorCallback(e);
    });
  }
  /// 退出登录
  void logout(Function callback, Function errorCallback) async {
    BaseNetWork.instance.dio.get(Apis.USER_LOGOUT).then((response) {
      callback(response.data);
    }).catchError((e) {
      errorCallback(e);
    });
  }
  /// 获取用户个人信息
  Future<void> getUserInfo(Function callback, Function errorCallback) async {
    await BaseNetWork.instance.dio.get(Apis.USER_INFO).then((response) {
      print(response);
      callback(UserEntity().fromJson(response.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取广场列表数据
  Future<void> getDynamicList(Function callback, Function errorCallback , int page)async {
    BaseNetWork.instance.dio.get(Apis.DYNAMIC+ "?page="+page.toString()).then((response) {
      callback(
          DynamicListEntity().fromJson(response.data)
      );
    }).catchError((e) {
      errorCallback(e);
    });
  }
}