import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/common/config.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

//主页面与右上角跳过按钮通过 Getx 传输数据，右上角组件更新倒计时秒数

//类似广告启动页
class AdvantagePage extends StatefulWidget {
  @override
  _AdvantagePageState createState() => _AdvantagePageState();
}

class _AdvantagePageState extends State<AdvantagePage> {
  late Timer _timer;
  var period = const Duration(seconds: 1);
  GlobalKey<TextWidgetState> textKey = GlobalKey();

  //页面跳转
  void _goHomePage() {
    Get.offAllNamed("/index");
  }

  _launchURL() async {
    const url = LocyinConfig.advantageUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtils.toast("Could not launch" + url);
      throw 'Could not launch $url';
    }
  }

  _init() {
    try {
      //定时器，period为周期
      _timer = Timer.periodic(period, (timer) {
        Get.find<ConstantController>().decrement();
        if (Get.find<ConstantController>().counter <= 0) {
          timer.cancel();
          _goHomePage();
        }
      });
    } catch (e) {
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //启动页面的build函数
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill,
              )
          ),
          child: InkWell(
              onTap: () {
                _launchURL();
                _timer.cancel();
                _goHomePage();
              },
              child:GetBuilder<ConstantController>(
                init: ConstantController(),
                builder: (controller){
                  return Stack(
                    children: <Widget>[
                      FadeInImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: AssetImage("assets/images/background.png"), //占位图片（本地文件）
                        image: NetworkImage(LocyinConfig.advantageImageUrl), //网络图片
                      ),
                      Positioned(
                        //top: 30,
                        left: size.width - 100,
                        child: MaterialButton(
                            color: Get.theme.splashColor,
                            textColor: Get.theme.primaryColor,
                            onPressed: () {
                              _timer.cancel();
                              _goHomePage();
                            },
                            child: TextWidget(count: controller.counter,key: textKey,)
                        ),
                      )
                    ],
                  );
                },
              ),
          ),
        ),
      ),
    );
  }
}

//右上角倒计时按钮
class TextWidget extends StatefulWidget {
  int count;

  TextWidget({required Key key, required this.count}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TextWidgetState();
  }
}

class TextWidgetState extends State<TextWidget> {

  void initState() {
    super.initState();
    //监听MyEvent事件
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${widget.count} 跳过",
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}