import 'package:flutter/material.dart';

final Color color1 = Color(0xFF303133); // 颜色需要使用16进制的，0xFF为固定的前缀
final Color color3 = Color(0xFF8D9199);
final Color color4 = Color(0xFFC0C4CC);
final Color red    = Color(0xFFFF4040);

class MessageListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('点击列表');
      },
      // 绘制列表的最左边项，这里放了个圆形的图片
      leading: Container(
        // 图片宽高
          width: 50,
          height: 50,
          // 描述图片的圆形，需要使用背景图来做
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://upload.jianshu.io/users/upload_avatars/7911324/0a04007f-7e74-4756-9b85-ac1d229d3b5c.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp')
              )
          )
      ),
      // 绘制消息主体的上半部分，主要是左边的名称和右边的日期，使用row的flex水平布局
      title: Row(
        children: <Widget>[
          Expanded(
              flex: 1, // flex为1就是扩充全部宽度
              child: Text('我是消息', style: TextStyle(
                  color: color1,
                  fontSize: 16
              ))
          ),
          Text('20-02-06',
              style: TextStyle(
                color: color4,
                fontSize: 12,
              ),
          )
        ],
      ),
      // 子标题，给一个向上的5px的间距，同时右边有一个红色的未读消息的标示
      subtitle: Padding(
        padding: EdgeInsets.only(top: 5),
        // 每一个需要两个以上的组件构成的组件，都需要使用Row或者Column或者Flex的组件来实现
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Text('消息内容啦啦啦消息内消息内容啦啦啦消息内容啦啦啦', style: TextStyle(
                    color: color3,
                    fontSize: 12
                ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            // 小圆点，使用Container类似div的方式实现
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.circular(5)
              ),
            )
          ],
        ),
      ),
    );
  }
}