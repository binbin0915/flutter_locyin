import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_locyin/data/model/chat_message_entity.dart';
import 'package:flutter_locyin/utils/auxiliaries.dart';
import 'package:flutter_locyin/widgets/appbar.dart';
import 'package:get/get.dart';
class PhotoViewPage extends StatefulWidget {
  final List<ChatMessageData> images;
  final int initPage;

  const PhotoViewPage({Key? key, required this.images, required this.initPage}) : super(key: key);
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  late int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    currentIndex =  widget.initPage;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.cardColor,
      appBar: CustomAppBar(
        left: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
        title: "查看图片",
        right: InkWell(
          onTap: () {
            Auxiliaries.saveFile("assets", widget.images[currentIndex].content);
          },
          child: Icon(Icons.save),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ExtendedImageGesturePageView.builder(
                controller: PageController(
                  initialPage: widget.initPage,
                ),
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
                  currentIndex = index;
                  return ExtendedImage.network(
                    widget.images[index].content,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                    initGestureConfigHandler: (ExtendedImageState state) {
                      return GestureConfig(
                        //you must set inPageView true if you want to use ExtendedImageGesturePageView
                        inPageView: true,
                        initialScale: 1.0,
                        maxScale: 5.0,
                        animationMaxScale: 6.0,
                        initialAlignment: InitialAlignment.center,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}