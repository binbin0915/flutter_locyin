import 'package:dio/dio.dart';
import 'package:flutter_locyin/common/config.dart';
import 'package:flutter_locyin/utils/handle_laravel_errors.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart' as getx;
import 'getx.dart';

//二次封装 Dio
class BaseNetWork {
  // 工厂模式
  factory BaseNetWork() => _getInstance();

  static BaseNetWork get instance => _getInstance();

  static final BaseNetWork _instance =  BaseNetWork._internal();

  late final Dio dio;

  BaseOptions? options ;

  BaseNetWork._internal() {
    dio = Dio()
      ..options = BaseOptions(
          baseUrl: LocyinConfig.baseUrl,
          connectTimeout: 30000,
          receiveTimeout: 1000 * 60 * 60 * 24,
          responseType: ResponseType.json,
          headers: {"Content-Type": "application/json;charset=utf-8",},
      )
    //网络状态拦截
      ..interceptors.add(AuthInterceptor())
      ..interceptors.add(HttpLog())
      ..interceptors.add(ErrorInterceptor());
  }

  static BaseNetWork _getInstance() {
    return _instance;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = getx.Get.find<ConstantController>().token;
    if (accessToken != null && accessToken != '') {
      print("获取到本地Token："+ accessToken);
      options.headers["Authorization"] = accessToken;
    }else{
      print("没有获取到本地Token");
    }
    options.headers["AcceptLanguage"] = getx.Get.find<LocaleController>().locale ?? "";
    return super.onRequest(options,handler);
  }
}

class HttpLog extends Interceptor{
  @override
  Future onRequest(RequestOptions options,RequestInterceptorHandler handler) async{
    print("\n ---------Start Http Request---------");
    print("Request_BaseUrl:${options.baseUrl}");
    print("Request_Path:${options.path}");
    print("Request_Method:${options.method}");
    print("Request_Headers:${options.headers}");
    print("Request_Data:${options.data}");
    print("Request_QueryParameters:${options.queryParameters}");
    print("---------End Http Request---------");
    return super.onRequest(options,handler);
  }

  @override
  Future onResponse(Response response,ResponseInterceptorHandler handler) async{
    print("---------Start Http Response---------");
    print("Response_BaseUrl:${response.requestOptions.baseUrl}");
    print("Response_Path:${response.requestOptions.path}");
    print("Response_StatusCode:${response.statusCode}");
    print("Response_StatusMessage:${response.statusMessage}");
    print("Response_Headers:${response.headers.toString()}");
    print("---------End Http Response---------");

    if(response.headers["authorization"] != null){
      BaseNetWork.instance.dio.lock();
      print("正在刷新Token");
      print("新的Token值 => "+response.headers["authorization"]![0]);
      getx.Get.find<ConstantController>().setToken(response.headers["authorization"]![0]);
      BaseNetWork.instance.dio.unlock();
      BaseNetWork.instance.dio.clear();
    }
    return super.onResponse(response,handler);
  }
}
class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError error , ErrorInterceptorHandler handler) async {
    print(error.response);
    print('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
    if (error.response != null && error.response!.statusCode == 401 && getx.Get.find<ConstantController>().token!=null ) {
      print("响应token");
      print(error.requestOptions.headers['Authorization']);
      print("新的token:");
      print(getx.Get.find<ConstantController>().token);
      print(error.requestOptions.headers['Authorization'] != getx.Get.find<ConstantController>().token);
      if(error.requestOptions.headers['Authorization'] != getx.Get.find<ConstantController>().token){
        print("请求path");
        print(error.requestOptions.path);
        print("请求方法：");
        print( error.requestOptions.method);
        print("请求数据：");
        print( error.requestOptions.data);
        print("请求query:");
        print( error.requestOptions.queryParameters);
        /*BaseNetWork.instance.dio.request(error.requestOptions.path,options: Options(
          method: error.requestOptions.method
        ) ,data: error.requestOptions.data,queryParameters: error.requestOptions.queryParameters);
        return ;*/
      }else{
        getx.Get.find<ConstantController>().clearToken();
        getx.Get.find<UserController>().clearUser();
        if(getx.Get.find<ConstantController>().appIsRunning){
          getx.Get.offAllNamed("/login");
        }
      }
    }
    if(getx.Get.find<ConstantController>().appIsRunning){
      switch (error.type) {
        case DioErrorType.connectTimeout:
          ToastUtils.error("连接超时");
          print("连接超时");
          break;
        case DioErrorType.sendTimeout:
          ToastUtils.error("请求超时");
          print("请求超时");
          break;
        case DioErrorType.receiveTimeout:
          ToastUtils.error("响应超时");
          print("响应超时");
          break;
        case DioErrorType.response:
          handleLaravelErrors(error);
          print("出现异常");
          break;
        case DioErrorType.cancel:
          ToastUtils.error("请求取消");
          print("请求取消");
          break;
        default:
          ToastUtils.error("未知错误");
          print("未知错误");
          break;
      }
    }
    return super.onError(error, handler);
  }
}
/*onError(DioError error , ErrorInterceptorHandler handler) async {
    print(error);
    //判读异常状态  401未登录过期或者未登录状态的异常
    if (error.response != null && error.response.statusCode == 401) {
      String token = await SharedPreferencesUtil.getData(Constants.ACCESS_TOKEN);//获取本地存储的Token
      if (token != null && token.trim() != '') {//Token存在则说明Token过期需要刷新，否则是未登录状态不做处理
        Dio dio = BaseNetWork.instance.dio;//获取应用的Dio对象进行锁定  防止后面请求还是未登录状态下请求
        dio.lock();
        String accessToken = await getToken();//重新获取Token
        dio.unlock();
        if (accessToken != '') {
          Dio tokenDio2 = new Dio(BaseNetWork.instance.dio.options); //创建新的Dio实例
          var request = error.request;
          request.headers['Authorization'] = 'JWT $accessToken';
          var response = await tokenDio2.request(request.path,
              data: request.data,
              queryParameters: request.queryParameters,
              cancelToken: request.cancelToken,
              options: request.,
              onReceiveProgress: request.onReceiveProgress);
          return response;
        }
      }
    }
    super.onError(error, handler);*/


/*Future<String> getToken() async {
    //获取当前的refreshToken，一般后台会在登录后附带一个刷新Token用的reToken
    String refreshToken =
    await SharedPreferencesUtil.getData(Constants.REFRESH_TOKEN);
    //因为App单例的Dio对象已被锁定，所以需要创建新的Dio实例
    Dio tokenDio = new Dio(BaseNetWork.instance.dio.options);
    Map<String, String> map = {
      "rft": refreshToken,
    }; //设置当前的refreshToken
    try {
      //发起请求，获取Token
      var response = await tokenDio.post("/api/v1/user/refresh_token", data: map);
      if (response.statusCode == 201) {
        LoginBean loginbean = LoginBean.fromJson(response.data);
        SharedPreferencesUtil.putData(Constants.ACCESS_TOKEN, loginbean.data.token);
        if (loginbean.data.rft != null && loginbean.data.rft.trim() != '') {
          SharedPreferencesUtil.putData(Constants.REFRESH_TOKEN, loginbean.data.rft);
        }
        return loginbean.data.token;
      }
      return '';
    } on DioError catch (e) {
      print("Token刷新失败:$e");
      SharedPreferencesUtil.putData(Constants.ACCESS_TOKEN, '');
      SharedPreferencesUtil.putData(Constants.REFRESH_TOKEN, '');
      return '';
    }
  }*/
