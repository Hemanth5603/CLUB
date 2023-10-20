import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/constants/appConstants.dart';
import 'package:club/controllers/auth_controller.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/view/authorised/SearchScreen.dart';
import 'package:club/view/components/HomeListingCard.dart';
import 'package:club/view/components/carousal.dart';
import 'package:club/view/components/explore.dart';
import 'package:club/view/components/location.dart';
import 'package:club/view/components/searchBar.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../../../../controllers/booking_controller.dart';
import '../../../../controllers/cart_controller.dart';
import '../../../../model/userModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RestaurantController restaurantController = Get.put(RestaurantController());
  UserController userController = Get.put(UserController());
  AuthController authController =Get.put(AuthController());
  BookingController bookingController = Get.put(BookingController());
  CartController cartController = Get.put(CartController());
  int activeIndex = 0;
  UserModel userModel = UserModel();
  int bannerLength = 1.obs();

  
  final carousalcontroller = CarouselController();



  @override
  void initState() {
    super.initState();
    //authController.getUserId();
   // userController.getUserDetails();
    //userController.getCurrentPosition();

    /*Timer.periodic(Duration(seconds: 4), (Timer timer) { 
      if(currentIndex <3){
        currentIndex++;
        pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 800), curve: Curves.easeInQuad);
      }else{
        currentIndex = -1;
      }
    });*/
    print(userController.userModel.value.latitude);
    print(userController.userModel.value.longitude);
    

  }
  @override
  void dispose() {
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    PageController pageController = PageController();
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: DefaultTabController(
              length: 1,
              child: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder: (context,isScrolled){
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_sharp,color: Colors.black,size: 25,),  
                            const SizedBox(width: 10,),
                            if(userController.userModel.value.location != null)
                              Container( width : w* 0.73, child: Text(userController.location,style:const TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.black),overflow: TextOverflow.ellipsis)),
                            if(userController.userModel.value.location == null)
                              Container(width: w * 0.73),
                            const SizedBox(width: 5,),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ), 
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: MyDelegate(
                        TabBar(
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6,top: 2),
                              child: Container(
                                height: 50,
                                width: w * 0.9,
                                child: InkWell(
                                  child: searchBar(context,Colors.grey.shade200),
                                  onTap: () {
                                    Get.to(SearchScreen(),duration: Duration(milliseconds: 400),transition: Transition.downToUp);
                                  }
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: Colors.transparent,
                        )
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 45.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("Featured offers for you .. ",style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,fontFamily: 'metro'),
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                    const SliverToBoxAdapter(child: SizedBox(height: 0,)),
                          SliverToBoxAdapter(
                            child: Container(height: h * 0.25,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('banners').snapshots(),
                                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                                        
                                        if(snapshot.hasError){
                                          return const Text("Something is Wrong");
                                        }
                                        if(snapshot.connectionState == ConnectionState.waiting){
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if(snapshot.data!.docs.isEmpty){
                                          return const Center(child:Text("No Restaurants to show",style: TextStyle(fontSize: 20,fontFamily: 'metro'),));
                                        }
                                        if(snapshot.data!=null){
                        
                                        return CarouselSlider.builder(
                                          carouselController: carousalcontroller,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index, realIndex) => Container(
                                            height: h * 0.5,
                                            margin:const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: NetworkImage(snapshot.data!.docs[index]['BannerImage']),
                                                fit: BoxFit.cover
                                              )              
                                            ),
                                          ),
                                          options: CarouselOptions(
                                            height: h * 0.22,
                                            aspectRatio: 16/3,
                                            viewportFraction: 0.9,
                                            autoPlay: true,
                                            autoPlayCurve: Curves.ease,
                                            enableInfiniteScroll: true,
                                            autoPlayAnimationDuration: Duration(seconds: 1),
                                            enlargeCenterPage: false,
                                            onPageChanged: (index,reason){
                                              
                                            }
                                            
                                          ),
                                        );
                                      }
                                      return Container();
                                      }
                                    )
                                  ),
                                  DotsIndicator(
                                    dotsCount: restaurantController.bannerLength,
                                    position: activeIndex,
                                    decorator: DotsDecorator(
                                      activeColor: const Color.fromARGB(255, 44, 44, 44)
                                    ),

                                  )
                                  /*SmoothPageIndicator(
                                    controller: pageController,
                                    count: restaurantController.bannerLength,
                                    effect: ExpandingDotsEffect(
                                      activeDotColor: Colors.black,
                                      dotColor: Colors.grey.shade400,
                                      dotHeight: 8,
                                      dotWidth: 8,
                                    ),
                                  )*/
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 5,),),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text("Explore More than ${restaurantController.totalRestaurants}+ RestoBars",style: TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.black,fontWeight: FontWeight.w600),),
                            ),
                          )
                  ];            
                },
                body: TabBarView(
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('Restaurants').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasError){
                            return const Text("Something is Wrong");
                          }
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if(snapshot.data!.docs.isEmpty){
                            return const Center(child:Text("No Restaurants to show",style: TextStyle(fontSize: 20,fontFamily: 'metro'),));
                          }
                          if(snapshot.data !=null){
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context,index){
                                return HomeRestoListingCard(context, index,snapshot,restaurantController,bookingController,userController,cartController);
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      
    );

  }
}


class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/*
SliverPersistentHeader(
                    delegate: MyDelegate(
                      TabBar(
                        tabs: [
                          Container(
                            height: 50,
                            width: w * 0.9,
                            child: InkWell(
                              child: searchBar(context),
                              onTap: () {
                                Get.to(SearchScreen(),duration: Duration(milliseconds: 400),transition: Transition.downToUp);
                              }
                            ),
                          ),
                        ],
                      )
                    ),
                  ),

*/ 
