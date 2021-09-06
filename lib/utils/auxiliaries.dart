import 'package:dio/dio.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:io';
class Auxiliaries{

  static String AssetTypeToString(AssetType assetType){
    String _type = "other";
    switch (assetType){
      case AssetType.other:
      // TODO: Handle this case.
        _type = "other";
        break;
      case AssetType.image:
      // TODO: Handle this case.
        _type = "image";
        break;
      case AssetType.video:
      // TODO: Handle this case.
        _type = "video";
        break;
      case AssetType.audio:
      // TODO: Handle this case.
        _type = "audio";
        break;
    }
    return _type;
  }
  static String TranportTypeToPanelType(String transportType){
    String panelType = "[文本消息]";
    switch (transportType){
      case 'image':
      // TODO: Handle this case.
        panelType = "[图片]";
        break;
      case 'video':
      // TODO: Handle this case.
        panelType = "[视频]";
        break;
      case 'audio':
      // TODO: Handle this case.
        panelType = "[音频]";
        break;
      case 'speech':
      // TODO: Handle this case.
        panelType = "[语音消息]";
        break;
      case 'videocall':
      // TODO: Handle this case.
        panelType = "[视频通话]";
        break;
      case 'voicecall':
      // TODO: Handle this case.
        panelType = "[语音通话]";
        break;
      default:break;
    }
    return panelType;
  }
  static Future<void> saveFile(String type,String url)async {
    print(url);
    if(!url.contains('.')){
      ToastUtils.toast("保存失败");
      return;
    }
    if(await Permission.storage.request().isGranted) {

      String mime =  url.substring(url.lastIndexOf("."), url.length);
      String directoryPath = "";
      if (Platform.isAndroid) {
        switch(type){
          case"assets":
            directoryPath =  "/sdcard/Pictures/LoCyin/";
            break;
          default:  directoryPath = "/sdcard/download/LoCyin/";
        }
      } else {
        directoryPath = (await getApplicationDocumentsDirectory()).path;
      }
      String savePath = directoryPath+Uuid().v4()+mime;
      print("保存位置:0$savePath");
      apiService.downloadFile((Response response){
          ToastUtils.toast("骆寻: 文件已保存至$directoryPath");
      },(DioError error){
        ToastUtils.error("保存失败");
        print(error);
      }, url, savePath);
    }
  }
}