import 'package:flutter/material.dart';
import 'package:flutter_locyin/router/router.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
Widget bannerWidget() {
  return SizedBox(
    height: 200,
    child: Swiper(
      autoplay: true,
      duration: 2000,
      autoplayDelay: 5000,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width-36,
              color: Colors.transparent,
              child: Image.asset('assets/images/loading.gif',fit: BoxFit.fitWidth),
            ),
          ],
        );
      },
      onTap: (value) {
        XRouter.goWeb("https://www.baidu.com","百度一下","false");
      },
      itemCount: 5,
      pagination: SwiperPagination(),
    ),
  );
}