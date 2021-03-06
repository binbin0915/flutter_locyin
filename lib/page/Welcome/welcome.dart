import 'package:flutter/material.dart';
import '../index.dart';
import 'data.dart';
import 'indicator.dart';
import 'package:get/get.dart';


class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int currentPage = 0;
  bool lastPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
    _animationController = AnimationController(
        duration: Duration(microseconds: 1000), vsync: this);
    _scaleAnimation = Tween(begin: 0.3, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF485563), Color(0xFF29323C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
            stops: [0.0, 1.0],
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              itemCount: pageList.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  if (index == pageList.length - 1) {
                    _animationController.forward();
                    lastPage = true;
                  } else {
                    _animationController.reset();
                    lastPage = false;
                  }
                });
              },
              itemBuilder: (context, index) {
                var page = pageList[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    //var delta;
                    var y = 1.0;

                    /*if (_pageController.position.haveDimensions) {
                      delta = _pageController.page - index;
                      y = 1 - delta.toDouble().abs().clamp(0.0, 1.0);
                    }*/
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(page.imageUrl),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 20.0),
                          child: Text(page.title,
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w900)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 0.0),
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 50.0 * (1 - y), 0.0),
                              child: Text(page.body,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Positioned(
              bottom: currentPage == 3 ? 80 : 40,
              left: 30,
              child: Container(
                width: 200,
                child: PageIndicator(currentPage, pageList.length),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: lastPage
                    ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Get.offAndToNamed("/index");
                  },
                )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


