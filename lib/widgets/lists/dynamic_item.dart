import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
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
  final String? imageUrl;

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
                color: getx.Get.theme.cardColor,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: getx.Get.theme.cardColor,
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
                            style: TextStyle(fontSize: 15,),
                          ),
                          Text(
                            widget.time,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,

                          )
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert,)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.imageUrl!=null?InkWell(
                      onTap: () {
                        getx.Get.toNamed(
                            "/index/dynamic/detail?id=${Uri.encodeComponent(widget.id.toString())}");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child:
                        ExtendedImage.network(
                          widget.imageUrl.toString(),
                          fit: BoxFit.fill,
                          cache: true,
                          width: double.maxFinite,
                          //border: Border.all(color: Colors.red, width: 1.0),
                          //shape: boxShape,
                          //borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          //cancelToken: cancellationToken,
                        ),
                      ),
                    ):Container(),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        getx.Get.toNamed(
                            "/index/dynamic/detail?id=${Uri.encodeComponent(widget.id.toString())}");
                      },
                      child: Text(
                        widget.content,
                        maxLines: 4,
                        style:
                        TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                              Share.share("https://lotvin.com");
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