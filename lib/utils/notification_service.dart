import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_locyin/generated/json/base/json_convert_content.dart';
import 'package:flutter_locyin/generated/json/base/json_field.dart';
import 'package:get/get.dart';

import 'getx.dart';
class NotificationService {
  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    _init();
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<void> _init() async {
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> showNotification(
      String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('1', 'locyin', 'locyin notification',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      PayloadEntity pl =  PayloadEntity().fromJson(json.decode(payload));
      if(pl.type == 'chat'){
        Get.toNamed("/index/message/chat",arguments: {
          "id":pl.id,
          "nickname": Get.find<MessageController>().messageList!.data.firstWhere( (element) => element.id == pl.id).stranger.nickname,
        });
      }
    }
  }
}

class PayloadEntity with JsonConvert<PayloadEntity>{
  late String type;
  late int id;
}