import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget _buildLanguageItem(String lan,String value) {

      return GetBuilder<LocaleController>(
        init: LocaleController(),
        builder: (controller){
          return ListTile(
            title: Text(
              lan,
              // 对APP当前语言进行高亮显示
              style: TextStyle(color: _currentLocale(controller.locale.toString(),value) ? color : null),
            ),
            trailing: _currentLocale(controller.locale.toString(),value) ? Icon(Icons.done, color: color) : null,
            onTap: () {
              // 此行代码会通知MaterialApp重新build
              if(value == "null"){
                controller.clearLocale();
              }else{
                controller.setLocale(value);
              }

            },
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text('menuLanguage'.tr)),
        body: ListView(
          children: <Widget>[
            _buildLanguageItem('languageEnglish'.tr, "en_US"),
            _buildLanguageItem('languageChinese'.tr, "zh_CN"),
            _buildLanguageItem('languageAuto'.tr, "null"),
          ],
        ));
  }
  bool _currentLocale(String? locale,String value){
    if(locale == null && value == "null"){
      return true;
    }else if(locale == value){
      return true;
    }
    else{
      return false;
    }
  }
}
