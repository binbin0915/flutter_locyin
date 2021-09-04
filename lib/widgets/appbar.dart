import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget left;
  final String title;
  final Widget right;
  final double barHeight;
  const CustomAppBar({Key? key, required this.left, required this.title, required this.right, this.barHeight = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Get.theme.cardColor)
              )
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              left,
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold,),
              ),
              right
            ],
          ),
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

  @override
  Size get preferredSize => Size.fromHeight(barHeight);
}
