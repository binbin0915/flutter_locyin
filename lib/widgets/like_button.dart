import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/getx.dart';
import 'package:get/get.dart';
class LikeButtonWidget extends StatefulWidget {
  //所属游记
  final int id;
  //点赞数
  final int like;
  //判断是否已经点赞
  final bool thumbed;
  const LikeButtonWidget({Key? key, required this.id, required this.like, required this.thumbed}) : super(key: key);


  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  //记录是否已经点赞
  late bool _thumbed;

  @override
  void initState() {
    // TODO: implement initState
    _thumbed = widget.thumbed;

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
        GetBuilder<DynamicController>(
        init: DynamicController(),id: "thumb",
          builder: (controller) {
          //print("正在刷新thumb");
          //print(controller.dynamicList!.data.firstWhere( (element) => element.id == widget.id).thumbed);
          return IconButton(
            icon: Icon(Icons.favorite),
            //根据是否点赞修改颜色
            color: controller.dynamicList!.data.firstWhere( (element) => element.id == widget.id).thumbed == 1 ?Colors.cyan:Colors.grey,
            onPressed: (){
              controller.thumb(widget.id);
            },
          );
          }),
          Text(widget.like.toString()),
        ],
      ),
    );
  }
}
