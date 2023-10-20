import 'dart:math';
import 'dart:ui';

// import 'package:bottom_picker/bottom_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/constants/textConstants.dart';
import 'package:club/controllers/booking_controller.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/view/authorised/Booking.dart';
import 'package:club/view/authorization/login.dart';
import 'package:club/view/components/RestoPageBackGround.dart';
import 'package:club/view/components/RestoPageInfoBox.dart';
import 'package:club/view/components/RestoPageOffers.dart';
import 'package:club/view/components/searchBar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:time_slot/model/time_slot_Interval.dart';
import 'package:time_slot/time_slot_from_interval.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/coupon_controller.dart';

class RestaurantPage extends StatefulWidget {
  RestaurantPage({Key? key}) : super(key: key);
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

TextEditingController searchController = TextEditingController();

class _RestaurantPageState extends State<RestaurantPage> {
  RestaurantController restaurantController = Get.put(RestaurantController());
  CouponController couponController = Get.put(CouponController());
  CartController cartController = Get.put(CartController());
  
  DateTime selectTime = DateTime.now();
  bool vegClicked = false;
  bool nonVegClicked = false;
  bool beerClick = false;
  bool isLoading = false;
  int index = 1;
  int count = 0;
  DateTime reservationDate = DateTime.now() ;
  bool datetext = false;
  int noofGuests = 1;
  final  guestController = FixedExtentScrollController();
  

  @override
  void initState() {
    super.initState();
  }

  Map<int, bool> cartList = new Map<int, bool>();
  Color _currentColor = Colors.blue; // Initial color
  final Color _secondColor = Colors.green; // Second color
  bool _isFirstColor = true;

  void _changeColor() {
    setState(() {
      _currentColor = _isFirstColor ? _secondColor : Colors.blue;
      _isFirstColor = !_isFirstColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // BookingController bookingController = Get.put(BookingController());
    UserController userController = Get.put(UserController());
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Skeletonizer(
          enabled: isLoading,
          child: SafeArea(
            child: DefaultTabController(
              length: 1,
              child: NestedScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  headerSliverBuilder: (context, isScrolled) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colors.white,
                        collapsedHeight: h * 0.32,
                        expandedHeight: h * 0.32,
                        flexibleSpace: Container(
                          height: h * 0.32,
                          width: 300.w,
                          color: Colors.transparent,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              restoPageBackground(context, h, w),
                              restoInfoBox(
                                context,
                                h,
                                w,
                                restaurantController.restaurantDetails?['RestaurantName'],
                                restaurantController.calculateDistance(
                                  double.parse(userController.userModel.value.latitude.toString()),
                                  double.parse(userController.userModel.value.longitude.toString()),
                                  double.parse(restaurantController.restaurantDetails?['Latitude']),
                                  double.parse(restaurantController.restaurantDetails?['Longitude']),
                                ),
                                restaurantController.restaurantDetails?['RestaurantLogo'],
                                restaurantController,
                                couponController,
                              ),
                              // RestoPgBackButton(context)
                            ],
                          ),
                        ),
                      ),
                      //SliverToBoxAdapter(child: Offers(h, w)),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 15),
                      ),
                      const SliverToBoxAdapter(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Reservation Details",
                            style: TextStyle(
                                fontFamily: 'metro',
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      )),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 15),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: h * 0.06,
                          width: w,
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {
                                   
                                    Get.dialog(
                                        barrierColor: Colors.grey[80],
                                        transitionCurve: Curves.linearToEaseOut,
                                        Container(
                                            height: h * 0.25,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 260,
                                              horizontal: 35,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: DatePickerWidget(
                                              dateFormat: "yyyy-MMMM-dd",
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2023, 08, 25),
                                              lastDate: DateTime(2023, 12, 1),
                                              pickerTheme:
                                                  const DateTimePickerTheme(
                                                      backgroundColor:
                                                          Colors.white),
                                              onChange: (value, _) {
                                                setState(() {
                                                    reservationDate = value;
                                                });
                                              },
                                            )));
                                             setState(() {
                                      datetext = true;
                                    });
                                
                                  },
                                  child: Container(
                                      height: h * 0.065,
                                      width: w * 0.4,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0)
                                          ]),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                        const  Icon(Icons.calendar_month_rounded),
                                          if(datetext == false)
                                         const Text(
                                            "Today",
                                            style: TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800),
                                          )
                                          else
                                          Text(
                                            DateFormat.MMMd().format(reservationDate),
                                            style:const TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800),
                                          ),
                                         const Icon(Icons.arrow_drop_down_rounded)
                                        ],
                                      )),
                                ),
                                InkWell(
                                  splashColor: Colors.grey,
                                  onTap: () {
                                    showModalBottomSheet(
                                      enableDrag: true,
                                      showDragHandle: true,
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.grey[200],
                                      builder: (context) {
                                        return Container(
                                            height: h * 0.3,
                                            color: Colors.grey[200],
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: h * 0.35,
                                                  width: w * 0.8,
                                                ),
                                                Positioned(
                                                  top: h * 0.113,
                                                  left: w * 0.05,
                                                  right: w * 0.05,
                                                  child: Container(
                                                    width: w * 0.75,
                                                    height: h * 0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:BorderRadius.circular(20),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade300,
                                                            blurRadius: 15.0,
                                                            spreadRadius: 1.0,
                                                          )
                                                        ]),
                                                  ),
                                                ),
                                                Container(
                                                  height: h * 0.3,
                                                  padding:const EdgeInsets.all(10),
                                                  child: ListWheelScrollView.useDelegate(
                                                          controller:guestController,
                                                          perspective: 0.002,
                                                          diameterRatio: 2.6,
                                                          physics:const FixedExtentScrollPhysics(),
                                                          useMagnifier: true,
                                                          magnification: 1.5,
                                                          itemExtent: 50,
                                                          childDelegate:ListWheelChildBuilderDelegate(
                                                            childCount: 26,
                                                            builder: (context,index) =>
                                                                Container(
                                                              // color: Colors.red,
                                                              margin: const EdgeInsets.symmetric(vertical: 12),
                                                              child: Center(
                                                                  child: Text(index.toString(),
                                                                style: const TextStyle(
                                                                    fontFamily:'metro',
                                                                    fontSize:14,
                                                                    fontWeight:FontWeight.w500),
                                                              )),
                                                            ),
                                                          ),
                                                          onSelectedItemChanged:(value) {
                                                            setState(() {
                                                              noofGuests =value;
                                                            });
                                                          }),
                                                ),
                                              ],
                                            ));
                                      },
                                    );
                                  },
                                  child: Container(
                                      height: h * 0.065,
                                      width: w * 0.4,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            )
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.people_rounded),
                                          Text("$noofGuests Guests",
                                            style: const TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800),
                                          ),
                                          const Icon(Icons.arrow_drop_down_rounded)
                                        ],
                                      )),
                                )
                              ]),
                        ),
                      ),
                      /*SliverToBoxAdapter(
                        child: Container(
                          height: h * 0.2,
                          width: w * 0.97,
                          child: TimesSlotGridViewFromInterval(
                            locale: "en",
                            initTime: selectTime, 
                            crossAxisCount: 4,
                            onChange: (value){
                              setState(() {
                                selectTime = value;
                              });
                            }, 
                            timeSlotInterval:  TimeSlotInterval(
                              start: TimeOfDay(hour:10, minute: 00), 
                              end:const TimeOfDay(hour: 22,minute: 0), 
                              interval:const Duration(hours: 0,minutes: 30),
                            )
                          ),
                        ),
                      ),*/
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: MyDelegate(TabBar(
                          tabs: [
                            SizedBox(
                              height: 80,
                              width: w * 0.9,
                              child: Padding(
                                padding:const EdgeInsets.only(bottom: 0, top: 00),
                                child: SizedBox(
                                  height: 60,
                                  width: w * 0.9,
                                  child: SearchBar(h, w, searchController,restaurantController),
                                ),
                              ),
                            ),
                          ],
                          indicatorColor: Colors.transparent,
                          dividerColor: Colors.transparent,
                        )),
                        floating: true,
                        pinned: true,
                      ),
                      
                      
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: SizedBox(
                              height: 35.h,
                              width: 30,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        child: Container(
                                          width: w * 0.18,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              border: vegClicked? Border.all(
                                                      color:const Color.fromARGB(255,139,174,140)): null,
                                              borderRadius:const BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: vegClicked? const Color.fromARGB(255, 139, 174, 140)
                                                      : const Color.fromARGB(255, 221, 221, 221),
                                                  blurRadius: 2.0,
                                                )
                                              ]),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image(image: AssetImage('assets/icons/veg.png'),width: 20,),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("Veg",
                                                  style: TextStyle(
                                                      fontFamily: 'metro',
                                                      fontWeight:FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            restaurantController.selection = 1;
                                            vegClicked = !vegClicked;
                                            nonVegClicked = false;
                                            beerClick = false;
                                          });
                                          restaurantController.getMenuItems();
                                          print('caller');
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        child: Container(
                                          width: w * 0.26,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              border: nonVegClicked? Border.all(
                                                      color:const Color.fromARGB(155,248,152,145)): null,
                                              borderRadius:const BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: nonVegClicked
                                                      ? const Color.fromARGB(148, 248, 152, 145)
                                                      : const Color.fromARGB(255, 221, 221, 221),
                                                  blurRadius: 2.0,
                                                )
                                              ]),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image(image: AssetImage('assets/icons/nonveg.png'),width: 20,),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Non-Veg",
                                                  style: TextStyle(
                                                      fontFamily: 'metro',
                                                      fontWeight:FontWeight.bold),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            // bottomSheet = !bottomSheet;
                                            restaurantController.selection = 2;
                                            nonVegClicked = !nonVegClicked;
                                            vegClicked = false;
                                            beerClick = false;
                                          });
                                          restaurantController.getMenuItems();
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        child: Container(
                                          width: w * 0.2,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              border: beerClick? Border.all(color:const Color.fromARGB(173,248,243,145)): null,
                                              borderRadius:
                                                  const BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                 
                                                  color: beerClick
                                                      ? const Color.fromARGB(173, 248, 243, 145)
                                                      : const Color.fromARGB(255, 221, 221, 221),
                                                  blurRadius: 2.0,
                                                )
                                              ]),
                                          child: const Center(
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.center,
                                              children: [
                                                Image(
                                                  image: AssetImage('assets/icons/beer.png'),
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Beer",
                                                  style: TextStyle(
                                                      fontFamily: 'metro',
                                                      fontWeight:FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            //restaurantController.selection = 3;
                                            beerClick = !beerClick;
                                            vegClicked = false;
                                            nonVegClicked = false;
                                          });
                                          restaurantController.getMenuItems();
                                        },
                                      ),
                                    ],
                                  )))),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(children: [
                    StreamBuilder(
                        stream: restaurantController.menuItemsStream,
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
                            return const Center(
                                child: Text(
                              "No Items Added",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'metro'),
                            ));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    height: 130.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      border: Border.all(
                                          color: const Color.fromARGB(255, 223, 223, 223),
                                          width: 1.w,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (snapshot.data!.docs[index]['ItemType'] =='Veg')
                                                      Image.asset('assets/icons/veg.png',width: 18,),
                                                    if (snapshot.data!.docs[index]['ItemType'] =='Non-Veg')
                                                      Image.asset('assets/icons/nonveg.png',width: 18,),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    SizedBox(
                                                        width: w * 0.5,
                                                        child: Text(
                                                          snapshot.data!.docs[index]['ItemName'],
                                                          style: const TextStyle(
                                                              fontFamily:'metro',
                                                              fontSize: 16,
                                                              fontWeight:FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8.w,
                                                ),
                                                Text(
                                                  "₹ ${snapshot.data!.docs[index]['ItemPrice']}.0",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontFamily: 'metro',
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                SizedBox(
                                                  width: w * 0.5,
                                                  child: Text(
                                                    snapshot.data!.docs[index]["ItemDescription"],
                                                    style: const TextStyle(
                                                      fontFamily: 'metro',
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                )
                                              ]),
                                          Stack(
                                            children: [
                                              Container(
                                                height: 120.h,
                                                width: 110.w,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot.data!.docs[index]["ItemImage"],
                                                  imageBuilder: (context,imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:const BorderRadius.all(
                                                                Radius.circular(8)),
                                                        image: DecorationImage(image:imageProvider,fit: BoxFit.cover)),),
                                                  errorWidget: (context, url,error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 5.h,
                                                  right: 7.w,
                                                  child: InkWell(
                                                      child: Container(
                                                        width: w * 0.09,
                                                        height: 35,
                                                        decoration:const BoxDecoration(
                                                          color: Color.fromARGB(255,255,255,255),
                                                          borderRadius:
                                                              BorderRadius.all(Radius.circular(20)),
                                                        ),
                                                        child: Center(
                                                          child: !cartController.CartList.contains(snapshot.data!.docs[index]['ItemId'])
                                                              ? const Icon(
                                                                  Icons.add,
                                                                  color: Colors.blue)
                                                              : const Icon(
                                                                  Icons.delete_outline_outlined,
                                                                  color: Colors.red,
                                                                  size: 18,
                                                                ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        setState(() {
                                                          if (cartController.CartList.contains(snapshot.data!.docs[index]['ItemId'])) {
                                                            cartController.CartList.remove(snapshot.data!.docs[index]['ItemId']);
                                                            cartController.removeItemFromCart(snapshot.data!.docs[index]['ItemId']);
                                                            const removeItem =SnackBar(
                                                              content: Text('Item Removed'),
                                                              backgroundColor:
                                                                  Color.fromARGB(255,255,62,36),
                                                              elevation: 10,
                                                              behavior:SnackBarBehavior.floating,
                                                              margin: EdgeInsets.all(5),
                                                              duration:Duration(seconds:1),
                                                            );
                                                            ScaffoldMessenger.of(context).showSnackBar(removeItem);
                                                          } else {
                                                            cartController.CartList.add(snapshot.data!.docs[index]['ItemId']);
                                                            cartController.addItemToCart(
                                                              snapshot.data!.docs[index]['ItemId'],
                                                              snapshot.data!.docs[index]['ItemType'],
                                                              snapshot.data!.docs[index]['ItemName'],
                                                              snapshot.data!.docs[index]['ItemPrice'],
                                                            );
                                                            const addItem =
                                                                SnackBar(
                                                              content: Text(
                                                                'Item Added',
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                              ),
                                                              backgroundColor:
                                                                  Color.fromARGB(255,95,219,99),
                                                              elevation: 10,
                                                              behavior:SnackBarBehavior.floating,
                                                              margin: EdgeInsets.all(5),
                                                              duration:Duration(seconds:1),
                                                            );
                                                            ScaffoldMessenger.of(context).showSnackBar(addItem);
                                                          }
                                                          print(cartController.CartList);
                                                        });
                                                      }))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                  ])),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await cartController.getCartItemsStream();
                    await cartController.getCartItemsLength();
                    Get.to(const Booking(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        popGesture: true);
                  },
                  child: Container(
                    width: w,
                    height: h * 0.055,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color.fromARGB(255, 40, 113, 244)),
                    child: const Center(
                      child: Text(
                        "Book Table",
                        style: TextStyle(
                            fontFamily: 'metro',
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ));
  }

  Widget SearchBar(h, w, searchController, restaurantController) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: h * 0.06,
        width: w * 0.95,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(255, 243, 243, 243)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.search_rounded, size: 20, color: Colors.black),
            ),
            const SizedBox(
              width: 8,
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
                child: TextField(
              controller: searchController,
              style: const TextStyle(fontFamily: 'metro'),
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontFamily: 'metro', fontSize: 15),
                hintText: 'Search for RestoBars, Dishes',
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  restaurantController.searchMenuItem(val);
                });
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget foodType(w, h, icon, type) {
    return Container(
      width: w,
      height: 35,
      decoration: BoxDecoration(
          border: beerClick
              ? Border.all(color: const Color.fromARGB(255, 228, 221, 154))
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: beerClick
                  ? const Color.fromARGB(255, 228, 221, 154)
                  : Colors.grey,
              blurRadius: 2.0,
            )
          ]),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(icon),
              width: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              type,
              style: const TextStyle(
                  fontFamily: 'metro', fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

MaterialStateProperty<Color> getColor(Color color, Color scolor) {
  getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return scolor;
    } else {
      return color;
    }
  }

  return MaterialStateProperty.resolveWith(getColor);
}

Widget Offers(h, w) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      width: w * 0.9,
      height: h * 0.12,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: const Color.fromARGB(2, 230, 230, 230),
          border: Border.all(color: const Color.fromARGB(255, 184, 184, 184))),
      child: const Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TextConstants.offersForYou,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'metro',
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            SizedBox(height: 8),
            //DottedLine(dashColor: Color.fromARGB(255, 62, 62, 62),dashGapLength: 8,),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: const Color.fromARGB(255, 255, 255, 255), child: tabBar);
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
