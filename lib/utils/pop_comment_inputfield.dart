import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locyin/data/api/apis_service.dart';
import 'package:flutter_locyin/utils/toast.dart';
import 'package:get/get.dart' as getx;

class CommentUtils {
  static Future<void> popCommentTextField(
      int dynamic_id, int replier_id, String replier_nickname) async {
    final TextEditingController controller = TextEditingController();
    getx.Get.bottomSheet(Container(
        color: Color(0xFFF4F4F4),
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
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
                  controller.text, dynamic_id, replier_id, replier_nickname);
            },
            decoration: InputDecoration(
                hintText: '回复 $replier_nickname :',
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
                      _publishComment(controller.text, dynamic_id, replier_id,
                          replier_nickname);
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
      String content, int dynamic_id, int replier_id, String replier_nickname) {
    apiService.publishComment((Response response) async {
      ToastUtils.success("已发送,系统审核通过后可见.");
    }, (DioError error) {
      print(error);
      //ToastUtils.error("发送失败");
      //handler_laravel_errors(error);
    }, content, dynamic_id, replier_id, replier_nickname);
    getx.Get.back();
  }
}
