import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantImages extends StatefulWidget {
  const RestaurantImages({super.key});

  @override
  State<RestaurantImages> createState() => _RestaurantImagesState();
}

class _RestaurantImagesState extends State<RestaurantImages> {

  RestaurantController restaurantController = Get.put(RestaurantController());
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: w * 0.96,
                height: h * 0.08,
                child: Row(
                  children: [
                    IconButton(onPressed:(){} , icon:const Icon(Icons.arrow_back_ios_new_rounded)),
                    const SizedBox(width: 10,),
                   const Text("Restaurant Images",style: TextStyle(fontFamily: 'metro',fontSize: 18,),)
                  ],
                ),
              ),
            const  SizedBox(height: 10,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('banners').snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return const Text("Something Wrong");
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.data!.docs.isEmpty){
                    return Text("No images to Show");
                  }
                  if(snapshot.data != null){
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 1,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: w * 2,
                            height: w * 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data!.docs[index]['RestaurantImage'])
                              )
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return Container();
                }
              )                       
            ],
          ),
        ),
      ),
    );
  }
}