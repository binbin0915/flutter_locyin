import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart' as getx;

class CommentUtils {
  static Future<void> popCommentTextField(int dynamic_id, int receiver_id, String receiver_nickname) async {
    final TextEditingController controller = TextEditingController();
    getx.Get.bottomSheet(Container(
        color:  getx.Get.theme.backgroundColor,
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
        child: Container(
          decoration: BoxDecoration(color: getx.Get.theme.cardColor),
          child: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(fontSize: 16),
            //设置键盘按钮为发送
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.multiline,
            onEditingComplete: () {
              //点击发送调用
              print('onEditingComplete');
              _publishComment(
                  controller.text, dynamic_id, receiver_id, receiver_nickname);
            },
            decoration: InputDecoration(
                fillColor: getx.Get.theme.cardColor,
                filled: true,//重点，必须设置为true，fillColor才有效
                hintText: '回复 $receiver_nickname :',
                isDense: true,
                contentPadding:
                    EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                border: const OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                suffix: SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      _publishComment(controller.text, dynamic_id, receiver_id,
                          receiver_nickname);
                    },
                    child: Text("发送"),
                  ),
                )),
            minLines: 1,
            maxLines: 5,
          ),
        )));
  }
  static void _publishComment(
      String content, int dynamic_id, int receiver_id, String receiver_nickname) {
    apiService.publishComment((Response response) async {
      ToastUtils.success("已发送,系统审核通过后可见.");
    }, (DioError error) {
      print(error);
      //ToastUtils.error("发送失败");
      //handler_laravel_errors(error);
    }, content, dynamic_id, receiver_id, receiver_nickname);
    getx.Get.back();
  }
}
