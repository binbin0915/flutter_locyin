import 'dart:async';
import 'dart:io';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class LocationBasedService {

  static final _instance = LocationBasedService._internal();

  //借助工厂模式实现单例模式
  factory LocationBasedService() {
    return _instance;
  }
  LocationBasedService._internal(){
    _init();
  }

  Map<String, Object>? _locationResult;

  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  _init(){
    /// 动态申请定位权限
    _requestPermission();

    ///设置Android和iOS的apiKey<br>
    ///
    /// 定位Flutter插件提供了单独的设置ApiKey的接口，
    /// 使用接口的优先级高于通过Native配置ApiKey的优先级（通过Api接口配置后，通过Native配置文件设置的key将不生效），
    /// 使用时可根据实际情况决定使用哪种方式
    ///
    ///key的申请请参考高德开放平台官网说明<br>
    ///
    ///Android: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
    ///
    ///iOS: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
    //AMapFlutterLocation.setApiKey("617d99f861823395679068efa584d09a", "");

    ///iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }

    ///注册定位结果监听
   _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
        print("获取到定位信息：");
        print(result);
        _locationResult = result;
        if(_locationResult!=null){
          Get.find<UserController>().updateLocation(_locationResult);
        }
    });
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///开始定位
  void startLocation() {
    _setLocationOption();
    _locationPlugin.startLocation();
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }
  ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
    await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }

  /// 动态申请定位权限
  void _requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await _requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> _requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
