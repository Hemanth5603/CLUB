import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club/controllers/cart_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/view/authorised/tabs/home/HomeScreen.dart';
import 'package:club/view/authorised/RestaruntPage.dart';
import 'package:club/view/components/carousal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget HomeRestoListingCard(context, index,snapshot,restaurantController,bookingController,userController,cartController){
  return InkWell(
    child: Container(
      height: 170.h,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: const Color.fromARGB(255, 237, 237, 237),
              style: BorderStyle.solid,
              width: 1),
          color: const Color.fromARGB(255, 244, 244, 244),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ]),
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: 110.w,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 30,
                            offset: const Offset(0, 5),
                          ),
                        ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl:snapshot.data!.docs[index]["RestaurantLogo"] ,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius:const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      errorWidget: (context, url, error) =>const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    width: 110.w,
                    decoration: BoxDecoration(
                        borderRadius:const BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              const Color.fromARGB(255, 210, 210, 210)
                                  .withOpacity(0.0),
                              const Color.fromARGB(166, 31, 31, 31),
                            ],
                            stops:const [
                              0.0,1.0
                            ]
                          )
                        ),
                  ),
                  Positioned(
                    bottom: 14,
                    child: offer(index),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(snapshot.data!.docs[index]['RestaurantName'],style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'metro'),),
                    SizedBox(height: 8.h,),
                    Rating(index),
                    SizedBox(
                      height: 7.h,
                    ),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: snapshot.data!.docs[index]['Area'],
                          style:
                              TextStyle(fontSize: 11, color: const Color.fromARGB(255, 100, 100, 100),fontFamily: 'metro',fontWeight: FontWeight.bold),
                        )
                      ),
                    SizedBox(
                      height: 5.h,
                    ),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: snapshot.data!.docs[index]['RestaurantType'],
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey,fontFamily: 'metro'),
                        )),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Container(
                        height: .5,
                        width: 180.w,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,color: Colors.blue,size: 16,),
                        const SizedBox(width: 5,),
                        Text(snapshot.data!.docs[index]['StartTime'] + " - ",style: TextStyle(fontFamily: 'metro',fontSize: 12),),
                        Text(snapshot.data!.docs[index]['EndTime'] ,style: TextStyle(fontFamily: 'metro',fontSize: 12),),
                      ],
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
              SizedBox(
                width: 25.w,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      child: LikeButton(
                        
                        size: 22.w,
                        onTap: (isLiked) async {
                          await userController.likeRestaurant(snapshot.data!.docs[index]['RestoId']);
                        },
                        likeBuilder: (bool isLiked) {
                        return Icon(
                            Icons.favorite,
                            color: isLiked ? Color.fromARGB(255, 227, 41, 91) : Colors.grey,
                            size: 25,
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    ),
    onTap: () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      restaurantController.restaurantModel.value.restoId = snapshot.data!.docs[index]['RestoId'];
      await prefs.setString('token', snapshot.data!.docs[index]['token']);
      await cartController.refreshCart();
      await restaurantController.getRestaurantsDetails();
      await restaurantController.getMenuItems();
      await restaurantController.getOffers();
      Get.to(RestaurantPage(),transition: Transition.rightToLeft,duration:const Duration(milliseconds: 100),popGesture:true );
    },
  );
}

Widget offer(index) {
  return Container(
    height: 20.h,
    width: 60.h,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
      color: Color.fromARGB(255, 0, 140, 255),
    ),
    child: Center(
      child: Text(
        "50% off",
        style: TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget Rating(index) {
  return Container(
    height: 20,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Color.fromARGB(255, 56, 165, 60),
    ),
    child: const Padding(
      padding: EdgeInsets.all(4.0),
      child: Center(
        child: Row(
          children: [
            Text(
              " 4.2",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 14,
            )
          ],
        ),
      ),
    ),
  );
}
