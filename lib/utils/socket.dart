import 'dart:async';
import 'dart:convert';
import 'package:flutter_locyin/common/config.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart' as getx;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dio/dio.dart';

enum StatusEnum{
  connect,connecting,close,closing
}
class WebsocketManager{
  static final WebsocketManager _singleton = WebsocketManager._internal();

  factory WebsocketManager() {
    return _singleton;
  }

  WebsocketManager._internal();

  StreamController<StatusEnum> socketStatusController = StreamController<StatusEnum>();



  static void init() async {
    /*if (_singleton == null) {
      _singleton = WebsocketManager._internal();
    }*/
  }
  StatusEnum isConnect=StatusEnum.close ;  //默认为未连接.

  //String _url="wss://api.locyin.com/wss";
  //String _url="ws://192.168.10.10:8282";

  late  WebSocketChannel channel;

  String? _client_id ;

  Map<String, dynamic> headers = new Map();

  Future connect() async{
    print("正在启动 Socket 服务...");
    headers['origin'] = 'https://api.locyin.com'; // 加上一个origin，防止被拦截
    if(isConnect==StatusEnum.close){
      print("Socket未连接,尝试正在连接 Socket 服务器...");
      isConnect=StatusEnum.connecting;
      socketStatusController.add(StatusEnum.connecting);
      channel= IOWebSocketChannel.connect(
          Uri.parse(LocyinConfig.socketUrl),
          // 可以设置请求头
          headers: headers
      );
      channel.stream.listen(
        //监听服务器消息
        (data) {
            print('onData: $data');
            final Map<String, dynamic> mesData = json.decode(data.toString());
            switch (mesData['type']){
              case "init" :
                _initMessage(mesData['client_id']).then((value) => {
                    isConnect=StatusEnum.connect,
                    socketStatusController.add(StatusEnum.connect)
                });
                break;
              case "status" :
                getx.Get.find<MessageController>().updateSrangerStatus(mesData['data']['id'], mesData['data']['status']);
                break;
              case "notice" :
                if(mesData['code'] == 0){
                  //ToastUtils.success(mesData['msg']);
                }else{
                  //ToastUtils.error(mesData['msg']);
                }
                break;
                case "offline" :

                break;
              case "chatMessage" :
                print(mesData['data']['type'].runtimeType);
                print(mesData['data']['window_id'].runtimeType);
                print(mesData['data']['content'].runtimeType);
                getx.Get.find<MessageController>().receiveMessage(mesData['data']['type'], mesData['data']['window_id'],mesData['data']['content'],mesData['data']['uuid'],mesData['data']['thumbnail']);
                break;
              default:break;
            }
      },//关闭时调用
        onDone: () {
          //await disconnect();
          //connect();
          /*if(isConnect == StatusEnum.connect){
            isConnect=StatusEnum.close;
            socketStatusController.add(StatusEnum.close);
          }*/
          print("onDone");
      },//连接错误时调用
        onError: (err, stack) async {
          print("onError");
          await disconnect();
          await connect();
        },
        cancelOnError: true,
      );
      return true;
    }
  }

  Future disconnect() async{
    print("正在关闭...");
    if(isConnect==StatusEnum.connect){
      print("Socket已连接,尝试主动关闭...");
      isConnect=StatusEnum.closing;
      socketStatusController.add(StatusEnum.closing);
      await channel.sink.close(3000,"主动关闭");
      isConnect=StatusEnum.close;
      socketStatusController.add(StatusEnum.close);
    }
  }

  bool send(String text){
    if(isConnect==StatusEnum.connect) {
      print("发送消息:$text");
      channel.sink.add(text);
      return true;
    }
    return false;
  }

  void printStatus(){
    if(isConnect==StatusEnum.connect){
      print("websocket 已连接");
    }else if(isConnect==StatusEnum.connecting){
      print("websocket 连接中");
    }else if(isConnect==StatusEnum.close){
      print("websocket 已关闭");
    }else if(isConnect==StatusEnum.closing){
      print("websocket 关闭中");
    }
  }

  void dispose(){
    socketStatusController.close();
  }
  Future<void> _initMessage (String _clientID) async{
    await apiService.initMessage((Response response){
      print("初始化成功");
      print(response.data);
    }, (DioError error) {
      print(error);
    },_clientID);
  }

}