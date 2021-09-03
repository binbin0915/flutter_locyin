import 'package:flutter/material.dart';
import 'package:flutter_locyin/common/lang/translation_service.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/router/router_map.dart';
import 'package:flutter_locyin/utils/sputils.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
//默认App的启动
class DefaultApp {
  //运行app
  static void run() {
    print("正在启动应用程序...");

    Get.lazyPut(()=>ConstantController());
    Get.lazyPut(()=>UserController());
    Get.lazyPut(()=>LocaleController());
    Get.lazyPut(()=>DarkThemeController());
    Get.lazyPut(()=>MessageController());
    WidgetsFlutterBinding.ensureInitialized();
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    //ScreenUtil.init(context,designSize: Size(750, 1334), allowFontScaling: false);
    beforeInitApp().then((value) => initApp());

  }

  static Future<void> beforeInitApp() async{
    await SPUtils.init().then((value) => Get.find<ConstantController>().init());
    await Get.find<UserController>().init();
  }
  //程序初始化操作
  static void initApp(){
    print("正在初始化应用程序...");
    Get.find<LocaleController>().init();
    Get.find<DarkThemeController>().init();
    runApp(ToastUtils.init(MyApp()));
    Get.find<ConstantController>().setAppRunningStatus();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '骆寻',
      theme:Get.find<DarkThemeController>().isDarkTheme ? ThemeData.dark():ThemeData.light(),
      getPages: RouteMap.getPages,
      defaultTransition: Transition.rightToLeft,
      /*localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale('en', 'US'),                       //当前的语言
      localeListResolutionCallback: (locales, supportedLocales) {
        if (localeModel.getLocale() != null) {
          //如果已经选定语言，则不跟随系统
          return localeModel.getLocale();
        } else {
          //跟随系统
          if (I18n.delegate.isSupported(_locale)) {
            return _locale;
          }
          return supportedLocales.first;
        }
        print('当前系统语言环境$locales');
        return;
      },*/

      locale: Messages.locale,
      fallbackLocale: Messages.fallbackLocale,
      translations: Messages(),
      routingCallback: (Routing? route) {
      },
    );
  }
}
