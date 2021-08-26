import 'dart:ui';
import 'package:flutter_locyin/common/lang/zh_CN.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';
import 'en_US.dart';

class Messages extends Translations {

  static Locale? get locale => Get.find<LocaleController>().locale == null?Get.deviceLocale:Get.find<LocaleController>().locale;
  static final fallbackLocale = Locale('en_US');
  @override


  Map<String, Map<String, String>> get keys => {
    'en_US': en_US,
    'zh_CN': zh_CN,
  };
}