import 'package:flutter_locyin/page/Dynamic/Dynamic.dart';
import 'package:flutter_locyin/page/Welcome/welcome.dart';
import 'package:flutter_locyin/page/User/login_code.dart';
import 'package:flutter_locyin/page/advantage.dart';
import 'package:flutter_locyin/page/menu/about.dart';
import 'package:flutter_locyin/page/menu/language.dart';
import 'package:flutter_locyin/page/menu/settings.dart';
import 'package:flutter_locyin/page/menu/theme.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';
import 'package:flutter_locyin/widgets/web_view_page.dart';


class RouteMap {
  static List<GetPage> getPages = [
    GetPage(name: '/', page: () => AdvantagePage()),
    GetPage(name: '/welcome', page: () =>WelcomePage()),
    GetPage(name: '/index', page: (){
      return Get.find<UserController>().user==null?LoginCodePage(): DynamicPage();
    }),
    GetPage(name: '/menu/settings', page: () => SettingsPage()),
    GetPage(name: '/menu/settings/theme', page: () => ThemePage()),
    GetPage(name: '/menu/settings/language', page: () => LanguagePage()),
    GetPage(name: '/menu/about', page: () => AboutPage()),
    GetPage(name: '/web', page: () => WebViewPage()),
    GetPage(name: '/login', page: () => LoginCodePage()),
  ];
}