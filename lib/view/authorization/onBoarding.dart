import 'package:club/view/authorization/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late Image image1;
  late Image image2;
  late Image image3;

  @override
  void initState() {
    image1 = Image.asset("assets/background/onBoardBg2.jpg");
    image2 = Image.asset("assets/background/onBoardBg4.jpg");
    image3 = Image.asset("assets/background/onBoardBg5.jpg");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("called");
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    

    return Scaffold(
      body: Stack(
          children:[
            PageView(
              controller: pageController,
              //physics: BouncingScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              scrollDirection: Axis.horizontal,
              children: [
                onBoardpage(sh,sw,image1.image),
                onBoardpage(sh,sw,image2.image),
                onBoardpage(sh,sw,image3.image),
              ],
            ),
            Positioned(
              bottom: sh * 0.12,
              left: sw /2 - 25,
              child: SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: SwapEffect(
                  activeDotColor: const Color.fromARGB(255, 255, 255, 255),
                  dotColor: Colors.grey.shade400,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: sw/10 - 10,
              child: Container(
                height: 50.h,
                width: sw-50,
                //margin:EdgeInsets.only(left: 10,right: 10),
                decoration:const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color:Colors.black
                ),
                child: InkWell(
                  onTap: (){
                    Get.to(Login(),transition: Transition.downToUp,duration: Duration(milliseconds: 400));
                  },
                  child: Center(
                    child: Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),)
                  ),
                ),
              )
            )
          ]
        ),
      );
  }
}

Widget onBoardpage(h,w,path){
  return Stack(
    children: [
      Container(
        decoration:BoxDecoration(
          image: DecorationImage(
            image:path,
            fit:BoxFit.cover,
          )
        ),
      ),
      Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color.fromARGB(0, 0, 0, 0),
              Color.fromARGB(134, 0, 0, 0),
            ],
            stops: [0.0,.9]
          )
        ),
      ),
      Positioned(
        top: h * 0.65,
        left: 10,
        child: SizedBox(
          width: w -20,
          child:const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Night Life ,",style: TextStyle(fontSize: 40,color:Colors.white,fontWeight: FontWeight.bold),),
              Text("at your finger tips..",style: TextStyle(fontSize: 30,color:Colors.white,fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              Text("Nightlife is a collective term for entertainment that is available and generally more popular from the late evening into the early hours of the morning. It includes pubs, bars, nightclubs, parties, live music, concerts, cabarets, theatre, cinemas, and shows. These venues often require a cover charge for admission.",
                style: TextStyle(fontSize: 10,color:Colors.white), 
                maxLines: 5, 
                overflow:TextOverflow.ellipsis,  
              ),
            ],
          ),
        ),
      )
    ],
  );
}

