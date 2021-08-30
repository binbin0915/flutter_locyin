import 'package:flutter/material.dart';
import 'package:flutter_locyin/widgets/lists/message_item.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        // 加载12个
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            if(index == 11) {
              // 做请求加载下一页的内容
            }
            // 还可以做加载到最后一条的判断，就是全部数据都渲染完了，就显示加载完成
            return MessageListItem();
          }
      ),
    );
  }
}
