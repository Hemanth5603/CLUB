import 'package:club/view/authorised/tabs/home/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget Carosal(context) {
  PageController pageController = PageController();
  int currentIndex = 0;
  final ScreenWidth = MediaQuery.of(context).size.width;
  final ScreenHeight = MediaQuery.of(context).size.height;
  return Container(
    height: ScreenHeight * 0.25,
    child: Column(
      children: [
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            itemCount: 4,
            itemBuilder: (_, index) => Container(
              height: ScreenHeight * 0.5,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
            ),
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: 4,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.black,
            dotColor: Colors.grey.shade400,
            dotHeight: 8,
            dotWidth: 8,
          ),
        )
      ],
    ),
  );
}
