import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/data/model/dynamic_comment_entity.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:flutter_locyin/utils/pop_comment_inputfield.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:flutter_locyin/widgets/collect_button.dart';
import 'package:flutter_locyin/widgets/like_button.dart';
import 'package:flutter_locyin/widgets/lists/comment_item.dart';
import 'package:flutter_locyin/widgets/skeleton_item.dart';
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
    // 获取动态详情数据
    if (!getx.Get.find<DynamicController>().dynamic_running) {
      getx.Get.find<DynamicController>().getDynamicDetail(_id);
    }
    // 获取动态详情下方评论数据
    if (!getx.Get.find<DynamicController>().comment_running) {
      getx.Get.find<DynamicController>().getDynamicCommentList(_id, 1);
    }
    _scroll_controller.addListener(loadMore);
    super.initState();
  }

  @override
  void dispose() {
    getx.Get.find<DynamicController>().clearDynamicDetailAndComments();
    _scroll_controller.removeListener(loadMore);
    super.dispose(); // This will free the memory space allocated to the page
  }
  void loadMore() {

    final bool toLoad = (_scroll_controller.offset) > _scroll_controller.position.maxScrollExtent-_scroll_controller.position.viewportDimension/2;
    print("当前滚动位置：${_scroll_controller.offset}");
    print("最大滚动位置：${_scroll_controller.position.maxScrollExtent}");
    print("设备视口像素：${_scroll_controller.position.viewportDimension}");
    print(toLoad);
    final int _currentPage = getx.Get.find<DynamicController>().commentList!.meta.currentPage;
    if(toLoad && !getx.Get.find<DynamicController>().comment_running && _currentPage < getx.Get.find<DynamicController>().commentList!.meta.lastPage)
      getx.Get.find<DynamicController>().getDynamicCommentList(_id, _currentPage + 1);
    }
  bool _running = false;
  @override
  Widget build(BuildContext context) {
     _running = false;
    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            controller: _scroll_controller,
            slivers: [_getDetailWidget(), _getCommentListView()],
      ),
    ));
  }
  //详情视图
  Widget _getDetailWidget() {
    return SliverToBoxAdapter(
      child: getx.GetBuilder<DynamicController>(
          init: DynamicController(),
          id: "detail",
          builder: (controller) {
            if (controller.dynamicDetail != null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: getx.Get.theme.cardColor))),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
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
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(controller
                                        .dynamicDetail!.data.user.avatar),
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
                                  style: TextStyle(
                                      fontSize: 15,),
                                ),
                                Text(
                                  controller.dynamicDetail!.data.createdAt,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 64,
                            height: 32,
                            child: FlatButton(
                              color: getx.Get.theme.accentColor,
                              highlightColor: getx.Get.theme.highlightColor,
                              colorBrightness: Brightness.dark,
                              splashColor: getx.Get.theme.splashColor,
                              child: Text("私聊"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              onPressed: () async {
                                if(getx.Get.find<UserController>().user!.data.id == controller.dynamicDetail!.data.user.id){
                                  return;
                                }
                                if(!_running){
                                  bool _initWindow = await getx.Get.find<MessageController>().chatFromDetailPage(controller.dynamicDetail!.data.user);
                                  _running = true;
                                  if(_initWindow){
                                    _running = false;
                                    getx.Get.offAndToNamed("/index/message/chat",arguments: {
                                      "id":controller.dynamicDetail!.data.user.id,
                                      "nickname":controller.dynamicDetail!.data.user.nickname,
                                    });
                                  }else{
                                    ToastUtils.error("创建聊天窗口失败");
                                    _running = false;
                                  }
                                }
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
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            /*"烟雨入江南，\n\n山水如墨染，\n\n宛若丹青未干，\n\n乘一叶轻舟，\n\n饮一壶黄酒江南古镇的街头也让人流连忘返。\n\n我和闺蜜也是刚从杭州游玩回来，"
                          "不仅走遍了杭州\n\n而且还去了乌镇南浔水乡，西塘古镇，\n\n很多人都会顾及到安全问题，\n\n在这里可以很负责任的告诉大家，\n\n杭州景区的安全措施做的非常好，\n\n只用出示健康码就可以自由的游玩。"
                          "\n\n( 模拟数据'🐣' )"*/
                            controller.dynamicDetail!.data.content,
                            //maxLines: 4,
                            style:
                                TextStyle(fontSize: 15),
                            //overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        imagesWidgets(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: getx.Get.theme.accentColor,
                            ),
                            Text(
                              /*"乌镇南浔水乡"*/
                              controller.dynamicDetail!.data.location,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CollectButtonWidget(
                                id: _id,
                                count:
                                    controller.dynamicDetail!.data.collectCount,
                                collected:
                                    controller.dynamicDetail!.data.collected ==
                                            1
                                        ? true
                                        : false),
                            //Icon(Icons.star_border_outlined,color: Colors.grey,),
                            Row(
                              children: [
                                LikeButtonWidget(
                                    id: _id,
                                    thumbed: controller
                                                .dynamicDetail!.data.thumbed ==
                                            1
                                        ? true
                                        : false,
                                    like: controller
                                        .dynamicDetail!.data.thumbCount),
                                SizedBox(
                                  width: 8,
                                ),
                                IconButton(
                                    icon: Icon(Icons.mode_comment_outlined),
                                    onPressed: () {
                                      CommentUtils.popCommentTextField(
                                          _id,
                                          controller.dynamicDetail!.data
                                              .user.id,
                                          controller.dynamicDetail!.data
                                              .user.nickname);
                                    }),
                                Text(/*"100"*/
                                    controller.dynamicDetail!.data.commentCount
                                        .toString()),
                                IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () {
                                      Share.share(controller
                                          .dynamicDetail!.data.images[0].path);
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
                      ),
                      child: Text(
                        '热门评论',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SkeletonListItem();
            }
          }),
    );
  }
  //循环渲染图片
  Widget imagesWidgets() {
    List<Widget> images = [];
    Widget content;
    for (var item
        in getx.Get.find<DynamicController>().dynamicDetail!.data.images) {
      images.add(
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: ExtendedImage.network(
            item.path.toString(),
            fit: BoxFit.fill,
            cache: true,
            //border: Border.all(color: Colors.red, width: 1.0),
            //shape: boxShape,
            //borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //cancelToken: cancellationToken,
          ),
        ),
      );
    }
    content = new Column(children: images);
    return content;
  }
  //评论视图
  Widget _getCommentListView() {
    return getx.GetBuilder<DynamicController>(
        init: DynamicController(),
        id: "comment",
        builder: (controller) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                DynamicCommentEntity? _comment_list = controller.commentList;
                if (_comment_list == null) {
                  return SkeletonListItem();
                } else {
                  return CommentListItem(
                    dynamic_id: _id,
                    replier_avatar: _comment_list.data[index].replierAvatar,
                    replier_nickname: _comment_list.data[index].replierNickname,
                    content: _comment_list.data[index].content,
                    count: _comment_list.data[index].thumbCount,
                    time: _comment_list.data[index].updatedAt,
                    receiver_nickname: _comment_list.data[index].receiverNickname,
                    replier_id: _comment_list.data[index].replierId,
                    floor: index + 1,
                    receiver_id: _comment_list.data[index].receiverId,
                    poster_id: _comment_list.data[index].posterId,
                  );
                  //return getDynamicListView(index);
                }
              },
              childCount: controller.commentList == null
                  ? 10
                  : controller.commentList!.data.length,
            ),
          );
        });
  }
}
