import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/toast.dart';

/// 评论列表详情
class CommentListItem extends StatelessWidget {
  //floor
  final int floor;

  //评论ID
  final int dynamic_id;

  //评论人ID
  final int replier_id;

  //评论人头像
  final String replier_avatar;

  //接收人ID
  //final int receiver_id;

  //接收人昵称
  final String receiver_nickname;

  //接收人昵称
  final String replier_nickname;

  //动态文字内容
  final String content;

  //动态喜欢数
  final int count;

  //评论时间
  final String time;

  const CommentListItem(
      {Key? key,
      required this.dynamic_id,
      required this.replier_avatar,
      required this.receiver_nickname,
      required this.replier_id,
      required this.content,
      required this.count,
      required this.time,
      required this.replier_nickname,
      required this.floor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //replier info
              //SizedBox(height: 8,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8,),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(replier_avatar),
                            fit: BoxFit.fitWidth)),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(floor.toString() + "楼"),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  replier_nickname,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  time,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.favorite_outline_outlined, color: Colors.grey),
                          Text(count.toString()),
                        ],
                      ),
                      SizedBox(height: 8,),
                      InkWell(
                        onTap: (){ToastUtils.toast("reply: "+replier_nickname);},
                        child: Text(
                          content,
                          //maxLines: 4,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
