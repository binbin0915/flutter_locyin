import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_locyin/data/model/chat_message_entity.dart';
import 'package:flutter_locyin/widgets/appbar.dart';

class PhotoViewPage extends StatefulWidget {
  final List<ChatMessageData> images;
  final int initPage;

  const PhotoViewPage({Key? key, required this.images, required this.initPage}) : super(key: key);
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: '查看图片', right: Icon(Icons.save)),
            Expanded(
              child: ExtendedImageGesturePageView.builder(
                controller: PageController(
                  initialPage: widget.initPage,
                ),
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int index) {
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