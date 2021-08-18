import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/like_button.dart';
import 'package:flutter_locyin/widgets/skeleton.dart';
import 'package:share/share.dart';
import 'package:get/get.dart' as getx;
class DynamicDetailPage extends StatefulWidget {
  @override
  _DynamicDetailPageState createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState extends State<DynamicDetailPage> {
  //从路由参数获取文章 id
  int _id = int.parse(getx.Get.parameters['id'].toString());
  final ScrollController _scroll_controller = ScrollController(keepScrollOffset: false);
  @override
  void initState() {
    // TODO: implement initState
    // 获取数据
    getx.Get.find<DynamicController>().getDynamicDetail(_id);
    super.initState();
  }

  String followButtonText = "关注";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            controller: _scroll_controller,
            slivers: <Widget>[
              SliverToBoxAdapter(child: _getDetailWidget(),),
            ],
          ),
        )
    );
  }

  Widget _getDetailWidget() {
    return Padding(padding: const EdgeInsets.all(8.0), child: _getChild());
  }

  Widget _getChild() {
      return getx.GetBuilder<DynamicController>(
          init: DynamicController(),id:"detail",
          builder: (controller) {
            if(controller.dynamicDetail!=null){
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black12))),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            getx.Get.back();
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        Text(
                          controller.dynamicDetail!.data.user.nickname,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.more_vert)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    //padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 45,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      controller.dynamicDetail!.data.user.avatar),
                                  fit: BoxFit.fitWidth)),
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
                                controller.dynamicDetail!.data.user.nickname,
                                style: TextStyle(fontSize: 15, color: Colors.cyan),
                              ),
                              Text(
                                controller.dynamicDetail!.data.createdAt,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 64,
                          height: 32,
                          child: FlatButton(
                            color: Colors.cyan,
                            highlightColor: Colors.blue[700],
                            colorBrightness: Brightness.dark,
                            splashColor: Colors.grey,
                            child: Text(followButtonText),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            onPressed: () {
                              setState(() {
                                followButtonText = "私聊";
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4,right: 4),
                        child: Text(
                          /*"烟雨入江南，\n\n山水如墨染，\n\n宛若丹青未干，\n\n乘一叶轻舟，\n\n饮一壶黄酒江南古镇的街头也让人流连忘返。\n\n我和闺蜜也是刚从杭州游玩回来，"
                      "不仅走遍了杭州\n\n而且还去了乌镇南浔水乡，西塘古镇，\n\n很多人都会顾及到安全问题，\n\n在这里可以很负责任的告诉大家，\n\n杭州景区的安全措施做的非常好，\n\n只用出示健康码就可以自由的游玩。"
                      "\n\n( 模拟数据'🐣' )"*/
                          controller.dynamicDetail!.data.content,
                          //maxLines: 4,
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: /*"https://locyin.oss-cn-beijing.aliyuncs.com/apps/luoxun_flutter/images/dynamic/dynamic_2.jpg"*/
                          controller.dynamicDetail!.data.images.isEmpty?"https://locyin.oss-cn-beijing.aliyuncs.com/apps/luoxun_flutter/images/loading.gif":controller.dynamicDetail!.data.images[0].path.toString(),
                          width: double.maxFinite,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            /*"乌镇南浔水乡"*/
                            controller.dynamicDetail!.data.location,
                            style: TextStyle(color: Colors.cyan),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.star),
                            //iconSize: 16,
                            color: Colors.grey,
                            onPressed: () {
                              ToastUtils.toast("收藏");
                            },
                          ),
                          //Icon(Icons.star_border_outlined,color: Colors.grey,),
                          Row(
                            children: [
                              LikeButtonWidget(id: _id, thumbed: controller.dynamicDetail!.data.thumbed == 1 ? true : false, like: controller.dynamicDetail!.data.thumbCount),
                              SizedBox(
                                width: 8,
                              ),
                              IconButton(
                                  icon: Icon(Icons.mode_comment_outlined),
                                  onPressed: () {
                                    ToastUtils.toast("跳转到评论页");
                                  }),
                              Text(/*"100"*/ controller.dynamicDetail!.data.commentCount.toString()),
                              IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {
                                    Share.share(controller.dynamicDetail!.data.images[0].path);
                                  }),
                              //Text(/*"100"*/controller.dynamicDetail!.data.collectCount.toString()),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 48,
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Text(
                      '热门评论',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            }
            else {
              return SkeletonWidget();
        }
    });
  }
}
