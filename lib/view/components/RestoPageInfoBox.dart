import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:like_button/like_button.dart';
import 'package:get/get.dart';


Widget restoInfoBox(context, h, w, name, distance, image,restaurantController,couponController) {
  UserController userController = Get.put(UserController());
  bool isLiked = false;
  return Positioned(
      top: h * 0.06,
      child: Container(
        width: w * 0.95,
        height: h * 0.25,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
              )
            ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: w * 0.5,
                        child: Text(
                          name.toString(),
                          style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'metro',
                              fontWeight: FontWeight.bold),
                        )),
                        SizedBox(width: w * 0.08,),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
                    IconButton(onPressed: () async{
                      await userController.likeRestaurant(restaurantController.restaurantModel.value.restoId);

                    }, icon: const Icon(Icons.favorite)),
                      
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "North Indian, Chinese, Continental",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'metro',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 133, 133, 133)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Jagadamba Junction, Vizag",
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'metro',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "$distance KM",
                          style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'metro',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 40, 40, 40)),
                        )
                      ],
                    ),
                    Container(
                      height: 65,
                      width: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "4.1",
                                  style: TextStyle(
                                      fontFamily: 'metro',
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  size: 10,
                                  color: Colors.white,
                                )
                              ],
                            )),
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 230, 230, 230)),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: const Center(
                              child: Text(
                                "2.2K",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'metro',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                /*Row(
                  children: [
                    Stack(children: [
                      Container(
                        height: h * 0.07,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 220, 220, 220),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                                image: NetworkImage(image.toString()),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: h * 0.07,
                        width: w * 0.4,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(110, 0, 0, 0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      Container(
                        height: h * 0.07,
                        width: w * 0.4,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          "More Images",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'metro',
                              color: Colors.white),
                        )),
                      ),
                    ]),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: const Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions,
                              color: Colors.blue,
                              size: 32,
                            ),
                            Text(
                              "Directions",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'metro',
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )*/
                SizedBox(
                  width: w * 0.9,
                  height: h * 0.09,
                  child: StreamBuilder(
                    stream: restaurantController.offerStream,
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Something is Wrong");
                      }
                      if (snapshot.connectionState ==ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No Offers Available",style: TextStyle(fontSize: 20, fontFamily: 'metro'),
                        ));
                      }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return SizedBox( 
                        width: w * 0.53,
                        height: h * 0.1,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: w * 0.5,
                                height: h * 0.065,
                                decoration: BoxDecoration(
                                  borderRadius:const BorderRadius.all(Radius.circular(15)),
                                  color:const Color.fromARGB(255, 245, 250, 255),
                                  border: Border.all(color: const Color.fromARGB(255, 179, 221, 255))
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Image.asset('assets/icons/ticket.png',color: Color.fromARGB(207, 37, 80, 223),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(snapshot.data!.docs[index]['Heading'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 11,fontFamily: 'sen',fontWeight: FontWeight.bold),),
                                          
                                          Text("use code "+snapshot.data!.docs[index]['Code'],overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 8,fontFamily: 'sen',fontWeight: FontWeight.bold),),
                    
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                left: -5,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration:const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                    }
                  );
                }
              ),
            )
          ],
        )
      ),
    )
  );
}
