import 'package:flutter/material.dart';
import 'package:flutter_locyin/page/menu/menu.dart';
import 'package:flutter_locyin/router/router.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';
import 'package:flutter_locyin/utils/dio_manager.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _changeLocale(){
    setState(() {
      var locale = Locale('zh', 'Hans');
      //var locale = Locale('en','US');
      Get.updateLocale(locale);
    });
  }
  void _makeError(){
    print("抛出异常");
    Future.delayed(Duration(seconds: 1)).then((e) => Future.error("异步异常"));
    //throw new StateError('This is a Dart exception error.');
    //List<String> numList = ['1', '2']; print(numList[6]);
  }
  void _testCommonRouter() {
    Get.toNamed('/menu/settings');
  }
  void _changeTheme(){
    Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());
  }
  void _testWebRouter() {
    XRouter.goWeb("https://www.baidu.com/","百度一下","local");
  }

  void _testDioRequest(){
    BaseNetWork.instance.dio.get("api/v1/version").then((response) {
      print(response.data);
    }).catchError((e) {
      print(e);
    });
  }
  void _testLoginRegisterPage() => Get.toNamed('/login');


  void _logOut(){
    Get.find<UserController>().clearUser();
    Get.find<ConstantController>().clearToken();
    Get.offAllNamed("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appName'.tr,),
      ),
      drawer: MenuDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'pushLabel'.tr,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _testCommonRouter,
        onPressed: _testWebRouter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

    );
  }
}