import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomAppBar extends StatelessWidget {
  final Widget? left;
  final String title;
  final Widget right;
  const CustomAppBar({Key? key, this.left, required this.title, required this.right}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Get.theme.cardColor))),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            right
          ],
        ),
      );

      /*Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold),
          ),
          right
        ],
      ),
    );*/
  }
}
