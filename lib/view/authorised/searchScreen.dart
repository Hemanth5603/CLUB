import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/view/components/searchBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/restaurant_controller.dart';
import 'RestaruntPage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();  
  RestaurantController restaurantController = Get.put(RestaurantController());
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding:const EdgeInsets.all(0),
                child: Container(
                  height: h* 0.06,
                  width: w * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade200),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.search_rounded, size: 20, color: Colors.black),
                        ),
                        const SizedBox(width: 8,),
                        const VerticalDivider(width: 10,color:Colors.grey),
                        const SizedBox(width: 8,),
                        Flexible(
                          child:TextField(
                            controller: searchController,
                            decoration:const InputDecoration(
                              hintText: 'Search for RestoBars, Dishes',
                              border: InputBorder.none,
                            ),
                            onChanged: (val){
                              setState(() {
                                restaurantController.searchRestaurants(val);
                              });
                            },
                          )
                        )
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 0,),
              Divider(color: Colors.grey.shade300,thickness: 1),
              Container(
                width: w * 0.9,
                height: h * 0.85,
                child: StreamBuilder(
                  stream: restaurantController.searchStream,
                  builder: (context, AsyncSnapshot<dynamic> snapshot){
                    if(snapshot.hasError){
                      return const Text("Something is Wrong");
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.data!.docs.isEmpty){
                      return const Center(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: 200,
                              image: NetworkImage('https://img.freepik.com/free-vector/flat-illustration-person-shrugging_23-2149330504.jpg?w=740&t=st=1690830984~exp=1690831584~hmac=c2664d75b6d2d71cc83af3e1e6b1f24fa5285d395c4a63d5a6cd3ad888f023af'),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10,),
                            Text("No Restaurants Found",style: TextStyle(fontFamily: 'metro',fontSize: 20),)
                          ],
                        )
                      );
                    }
                    if(snapshot.data !=null){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          return InkWell(
                            child: Container(
                              width: w * 0.8,
                              height: h * 0.1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Container(
                                      width: w * 0.2,
                                      height: h * 0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        image: DecorationImage(
                                          image:NetworkImage(snapshot.data!.docs[index]['RestaurantLogo']),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                    ),
                                  const SizedBox(width: 10,),
                                  Text(snapshot.data!.docs[index]['RestaurantName']),
                                ],
                              ),
                            ),
                            onTap: () async {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              restaurantController.restaurantModel.value.restoId = snapshot.data!.docs[index]['RestoId'];
                              await prefs.setString('token', snapshot.data!.docs[index]['token']);
                              //bookingController.bookRestaurant(snapshot.data!.docs[index]['token']);
                              await restaurantController.getRestaurantsDetails();
                              await restaurantController.getMenuItems();
                              Get.to(RestaurantPage(),transition: Transition.rightToLeft,duration:const Duration(milliseconds: 100),popGesture:true );
                            },
                          );
                        },
                      );
                    }
                    return Container();
                  } ,
                ),
              )
            ],
          )
        ),
      )
    );
  }
}
