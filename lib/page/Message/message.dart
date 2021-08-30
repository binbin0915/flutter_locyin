import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/socket.dart';



class MessagePage extends StatefulWidget {

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

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
      appBar: AppBar(

        title: Text("如何使用Flutter  WebSocket?"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed:() => _send() ,
              child: Text("发送"),
            ),
            RaisedButton(
              onPressed:() => _open() ,
              child: Text("打开websocket连接"),
            ),
            RaisedButton(
              onPressed:() => _close() ,
              child: Text("关闭websocket连接"),
            ),
            RaisedButton(
              onPressed:() => _reconnect() ,
              child: Text("重连websocket连接"),
            ),
            StreamBuilder<StatusEnum>(
              builder: (context, snapshot) {
                if (snapshot.data==StatusEnum.connect){
                  return Container();
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
