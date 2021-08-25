import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/like_button.dart';
import 'package:share/share.dart';
import 'package:get/get.dart' as getx;

/// 游记列表详情
class DynamicListItem extends StatefulWidget {
  //id
  final int id;
  //头像
  final String avatar;

  //昵称
  final String nickname;

  //动态图片内容
  final String imageUrl;

  //动态文字内容
  final String content;

  //动态喜欢数
  final int like;

  //动态评论数
  final int comment;

  //动态时间
  final String time;
  //已赞
  final bool thumbed;

  const DynamicListItem({Key? key, required this.id, required this.avatar, required this.nickname, required this.imageUrl, required this.content, required this.like, required this.comment, required this.time, required this.thumbed}) : super(key: key);



  @override
  _DynamicListItemState createState() => _DynamicListItemState();

}
class _DynamicListItemState extends State<DynamicListItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Container(
                //padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 45,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image:NetworkImage(widget.avatar),fit: BoxFit.fitWidth)
                      ),
                    ),

                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.nickname,
                            style: TextStyle(fontSize: 15,color: Colors.cyan),
                          ),
                          Text(
                            widget.time,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert,color: Colors.grey,)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getx.Get.toNamed(
                            "/index/dynamic/detail?id=${Uri.encodeComponent(widget.id.toString())}");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl:widget.imageUrl,
                          width: double.maxFinite,
                          placeholder:(context,url)=> Image.asset('assets/images/loading.gif',fit: BoxFit.cover),
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.content,
                      maxLines: 4,
                      style:
                      TextStyle(fontSize: 15, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              Share.share(widget.imageUrl);
                            }),
                        Row(
                          children: [
                            //Icon(Icons.favorite,color: thumbed? Colors.cyan : Colors.grey,),
                            LikeButtonWidget(id: widget.id, like: widget.like, thumbed: widget.thumbed),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: Icon(Icons.mode_comment_outlined),
                              //iconSize: 16,
                              color: Colors.grey,
                              onPressed: (){
                                //ToastUtils.toast("跳转到游记详情页");
                                getx.Get.toNamed(
                                    "/index/dynamic/detail?id=${Uri.encodeComponent(widget.id.toString())}");
                              },
                            ),
                            Text("${widget.comment}"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}