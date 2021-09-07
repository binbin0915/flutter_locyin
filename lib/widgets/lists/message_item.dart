import 'package:badges/badges.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

final Color color1 = Color(0xFF303133); // 颜色需要使用16进制的，0xFF为固定的前缀
final Color color3 = Color(0xFF8D9199);
final Color color4 = Color(0xFFC0C4CC);
final Color red    = Color(0xFFFF4040);

class MessageListItem extends StatelessWidget {

  //头像
  final String strangerAvatar;

  //昵称
  final String strangerNickname;

  //时间
  final String time;

  //动态文字内容
  final String excerpt;

  //连接状态
  final Icon status;

  final Function() onPressed;

  final int count;

  final bool online;

  const MessageListItem({Key? key, required this.strangerAvatar, required this.strangerNickname, required this.excerpt, required this.time,required this.onPressed, required this.count, required this.status, required this.online }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      // 绘制列表的最左边项，这里放了个圆形的图片
      leading: Badge(position: BadgePosition.topEnd(top: -4, end: -4),
        showBadge: count>0,
        toAnimate: true,
        animationType: BadgeAnimationType.slide,
        badgeContent: Text(count.toString(),style: TextStyle(
          color: Colors.white
        ),),
        //badgeColor: Colors.cyan,
        child: ExtendedImage.network(
          strangerAvatar,
          width: 48,
          height: 48,
          fit: BoxFit.fill,
          cache: true,
          border: Border.all(color: Colors.grey, width: 1.0),
          shape: BoxShape.circle,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //cancelToken: cancellationToken,
        )
      ),
      // 绘制消息主体的上半部分，主要是左边的名称和右边的日期，使用row的flex水平布局
      title: Row(
        children: <Widget>[
          Expanded(
              flex: 1, // flex为1就是扩充全部宽度
              child: Text(strangerNickname, style: TextStyle(
                  //color: Get.theme.cardColor,
                  fontSize: 16
              ))
          ),
          Text(time,
              style: TextStyle(
                //color: color4,
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
                child: Text(excerpt, style: TextStyle(
                    //color: color3,
                    fontSize: 12
                ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
            ),
            if(online)status
          ],
        ),
      ),
    );
  }
}