import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //用于骨架加载器的一个阴影类型的列表
    List<BoxShadow> shadowList = [
      BoxShadow(color: Colors.grey[300]!, blurRadius: 30, offset: Offset(0, 10))
    ];

    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          //样式一
          /*Expanded(
                  child: SkeletonAnimation(
                    shimmerColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    shimmerDuration: 1000,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: shadowList,
                      ),
                      margin: EdgeInsets.only(top: 40),
                    ),
                  ),
                ),*/
          //样式二
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey,
                boxShadow: shadowList,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                    child: SkeletonAnimation(
                      borderRadius: BorderRadius.circular(10.0),
                      //shimmerColor: index % 2 != 0 ? Colors.grey : Colors.white54,
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width * 0.35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: SkeletonAnimation(
                        borderRadius: BorderRadius.circular(10.0),
                        //shimmerColor: index % 2 != 0 ? Colors.grey : Colors.white54,
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
