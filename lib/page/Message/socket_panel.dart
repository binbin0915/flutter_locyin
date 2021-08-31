import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/socket.dart';

class SocketPanelPage extends StatefulWidget {

  @override
  _SocketPanelPageState createState() => _SocketPanelPageState();
}

class _SocketPanelPageState extends State<SocketPanelPage> {

  @override
  void initState() {
    super.initState();
    //初始化
    WebsocketManager.init();
  }

  @override
  void dispose() {
    WebsocketManager().dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed:() => _send() ,
                child: Text("发送消息测试WS连接"),
              ),
              RaisedButton(
                onPressed:() => _open() ,
                child: Text("打开 WebSocket 连接"),
              ),
              RaisedButton(
                onPressed:() => _close() ,
                child: Text("关闭 WebSocket 连接"),
              ),
              RaisedButton(
                onPressed:() => _reconnect() ,
                child: Text("重连 WebSocket 连接"),
              ),
              StreamBuilder<StatusEnum>(
                builder: (context, snapshot) {
                  if (snapshot.data==StatusEnum.connect){
                    return Text("已连接");
                  }else if(snapshot.data==StatusEnum.connecting){
                    return Text("连接中");
                  }else if(snapshot.data==StatusEnum.close){
                    return Text("已关闭");
                  }else if(snapshot.data==StatusEnum.closing){
                    return Text("关闭中");
                  }else{
                    return Container();
                  }
                },
                initialData: StatusEnum.close,
                stream:WebsocketManager().socketStatusController.stream,
              )
            ],
          ),
        ),
      ),
    );
  }
  _open()async {
    await WebsocketManager().connect();
  }
  _close() async{
    await WebsocketManager().disconnect();
  }
  int i=0;
  _send() {
    WebsocketManager().send("哈哈${i+=1}");
  }
  _reconnect() async{
    await _close();
    await _open();
  }
}
