import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/handle_laravel_errors.dart';
import 'package:flutter_locyin/widgets/bg_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter_locyin/widgets/privacy.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/loading_dialog.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_verification_box/verification_box.dart';


class LoginCodePage extends StatefulWidget {
  @override
  _LoginPage2State createState() => _LoginPage2State();
}
//枚举类型的 PageType 包含手机页面 phonePage 和验证码页面 codePage
enum PageType{
  phonePage,
  codePage,
}
class _LoginPage2State extends State<LoginCodePage> {
  // 响应空白处的焦点的Node
  FocusNode blankNode = FocusNode();

  TextEditingController _phoneController = TextEditingController();

  TapGestureRecognizer _tapGestureRecognizer  = TapGestureRecognizer();

  GlobalKey<ScaffoldState> _gk = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formGk = GlobalKey();

  PageType _pageType = PageType.phonePage;

  String? _verification_key;

  bool _hasReadPolicy = false;

  @override
  void initState() {
    super.initState();
    //_selectedMenu(PinEntryType.underline);
    _tapGestureRecognizer.onTap = myTap;
    //注册一个回调函数_showPrivacy
    WidgetsBinding.instance!.addPostFrameCallback((_) => _showPrivacy());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void myTap(){
    print("myTap run 。。。。");
  }
  void _showPrivacy(){
    if (!getx.Get.find<ConstantController>().hasAgreedPrivacy) {
      PrivacyUtils.showPrivacyDialog(context, onAgreeCallback: () {
        Navigator.of(context).pop();
        getx.Get.find<ConstantController>().agreePrivacy();
        ToastUtils.success("已同意使用协议和隐私声明");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _gk,
      body: Stack(
        children: <Widget>[
          CurveBgWidget(color: getx.Get.theme.backgroundColor,),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                  color: getx.Get.theme.cardColor,
                  shape: BoxShape.circle
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 96,left: 16,right: 16),
            margin: EdgeInsets.only(top: 180,left: 16,right: 16),
            decoration: BoxDecoration(
                color: getx.Get.theme.cardColor,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Form(
                onWillPop: _showHint,
                key: _formGk,
                child: _buildContentByType(context)
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 160),
            child: Column(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getx.Get.theme.primaryColor,
                    image: new DecorationImage(
                        image: new AssetImage("assets/images/icon.png"),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                SizedBox(height: 16,),
                _pageType == PageType.phonePage ?Text("手机号登录")
                    :Text("验证码已发送至：${_phoneController.text}")
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildContentByType(BuildContext context) {
    if (_pageType == PageType.phonePage ) {
      /// *********************************************************************
      /// ********************************* 手机号页面 ******************************
      /// *********************************************************************
      return SizedBox(
        height: 300,
        child: Column(
          children: <Widget>[
            TextFormField(
                onFieldSubmitted: (value) {
                  _next();
                },
                autofocus: false,
                controller: _phoneController,
                decoration: InputDecoration(

                    labelText: "手机号",
                    hintText: "请输入正确的手机号",
                    hintStyle: TextStyle(fontSize: 12),
                    icon: Icon(Icons.person)
                ),
                //校验用户名
                validator: (v) {
                  return v!.trim().length > 0
                      ? null
                      : "用户名不能为空！";
                },

                ),

            SizedBox(height: 16,),
            InkWell(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '发送验证码',
                  style: TextStyle(
                      fontSize: 20,color: getx.Get.theme.cardColor),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      getx.Get.theme.backgroundColor,
                      Colors.white,
                    ]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1.0, 5.0),
                        color: Color.fromRGBO(234, 61, 135, 0.4),
                        blurRadius: 5.0,
                      )
                    ]),
              ),
              onTap: () {
                _next();
              },
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Checkbox(
                  value: _hasReadPolicy,
                  onChanged: (v) {
                    _hasReadPolicy = v!;
                    setState(() {
                      print(_hasReadPolicy);
                    });
                  },
                ),

                Text.rich(
                    TextSpan(
                        text: '我已阅读并同意遵守',
                        style: TextStyle(
                            fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                              text: '《服务许可协议》',
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                              ),
                              recognizer: _tapGestureRecognizer
                          )
                        ]
                    )),
              ],
            )
          ],
        ),
      );
    }else{
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: VerificationBox(
            count: 4,
            showCursor: true,
            cursorWidth: 2,
            cursorColor: Colors.red,
            cursorIndent: 10,
            cursorEndIndent: 10,
            onSubmitted: (value){
              print('$value');
              _login(value);
            },
          ),
        );
    }
  }
  void _next() {
    if(!_hasReadPolicy){
      ToastUtils.error("请先勾选同意使用协议！");
      return;
    }
    _showDialog();
      apiService.sendCodes((Response response) {
        Navigator.pop(context);
        _verification_key = response.data["key"];
        setState(() {
          _pageType = PageType.codePage;
        });
      }, (DioError error) {
        Navigator.pop(context);
      }, _phoneController.text);
  }
  void _showDialog(){
      getx.Get.dialog(
        LoadingDialog(
          showContent: false,
          backgroundColor: getx.Get.theme.dialogBackgroundColor,
          loadingView: SpinKitCircle(color: getx.Get.theme.accentColor),
        ));
  }
  void _login(String value){
    _showDialog();
    apiService.loginBycodes((Response response) async {
        getx.Get.find<ConstantController>().setToken('Bearer ' + response.data['access_token']);
        await getx.Get.find<UserController>().getUserInfo();
        Navigator.pop(context);
        getx.Get.offAllNamed("/welcome");
    }, (DioError error) {
        Navigator.of(context).pop();
        handleLaravelErrors(error);
    }, _verification_key!,value);
  }
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
  Future<bool> _showHint(){
    setState(() {
      _pageType = PageType.phonePage;
    });
    return Future.value(false);
  }
}
