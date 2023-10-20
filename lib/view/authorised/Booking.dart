import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/constants/appConstants.dart';
import 'package:club/controllers/booking_controller.dart';
import 'package:club/controllers/cart_controller.dart';
import 'package:club/controllers/coupon_controller.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/services/notificationServices.dart';
import 'package:club/view/authorised/RestaruntPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

String? guestValue = '1';
DateTime selectedDate = DateTime.now();
String? timeSlot;
final TimeSlotController = TextEditingController();
final TextEditingController couponCode = TextEditingController();


class _BookingState extends State<Booking> {

  RestaurantController restaurantController = Get.put(RestaurantController());
  BookingController bookingController = Get.put(BookingController());
  NotificationServices notificationServices = NotificationServices();
  UserController userController = Get.put(UserController());
  CartController cartController = Get.put(CartController());
  CouponController couponController = Get.put(CouponController());
  double total = 0;

  @override
  void initState() {
    super.initState();
    

  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w =  MediaQuery.of(context).size.width;
    

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          child: Container(
            width: w,
            height: h * 0.05,
            decoration:const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromARGB(255, 40, 113, 244)
            ),
            child:const Center(
              child: Text("Book",style: TextStyle(fontFamily: 'metro',fontSize: 18,color: Colors.white),),
            ),
          ),
          onTap: () async{
            await bookingController.calculateBill(couponController.code.toUpperCase());
            showModalBottomSheet(
              context: context,
              builder: (_){
                return StatefulBuilder(
                  builder: (_,setState){
                    return Padding(
                      padding:EdgeInsets.all(15),
                      child:Container(
                        width: w,
                        height: h * 0.21,
                        child: Padding(
          padding:const EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: [
              const SizedBox(height: 18,),
              Padding(
                padding: EdgeInsets.only(left: 10,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Items Total",style: TextStyle(fontFamily: 'metro',fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                    Text("₹"+bookingController.total.toString(),style: TextStyle(fontFamily: 'metro',fontSize: 13,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Padding(
                padding: EdgeInsets.only(left: 10,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Coupon Discount",style: TextStyle(fontFamily: 'metro',fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                    Text( bookingController.totalDiscount == 0 ?
                      "-₹"+bookingController.totalDiscount.toString() 
                      : "-₹"+bookingController.totalDiscount.toString().substring(0,5),
                      style: TextStyle(fontFamily: 'metro',fontSize: 13,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("To Pay",style: TextStyle(fontFamily: 'metro',fontSize: 12,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 31, 31, 31)),),
                    Text("₹"+bookingController.totalAfterDiscount.toString().substring(0,5),style: TextStyle(fontFamily: 'metro',fontSize: 13,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 0),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: List.generate(30, (_) {
                              return SizedBox(
                                height: h * 0.002,
                                width: w * 0.015,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300]),
                                ),
                              );
                            }),
                          ),
                        ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left:0),
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: w * 0.4,
                        height: h *0.05,
                        decoration:const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 28, 166, 114),
                        ),
                        child:const Center(
                          child: Text("Book Table",style: TextStyle(fontFamily: 'metro',color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      onTap: ()async{
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        bookingController.bookingModel.value.date = selectedDate.toString();
                        await bookingController.bookRestaurant();
                        await bookingController.bookRestaurantNotification(prefs.getString('token'),bookingController.bookingModel.value.numberOfGuests.toString());
                        print("Booking clicked");
                      },
                    ),
                    SizedBox(width: w * 0.05,),
                    GestureDetector(
                      child: Container(
                        width: w * 0.4,
                        height: h *0.05,
                        decoration:const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:  Color.fromARGB(255, 40, 113, 244)
                        ),
                        child: Center(child: Text("Take Away",style: TextStyle(fontFamily: 'metro',color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)),
                      ),
                      onTap: (){
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
                      )
                    );
                  },
                );
              }
            );
          },
        ),
      ),
      
    

      backgroundColor:const Color.fromARGB(255,241, 240, 245),
      body:SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: w,
                height: h * 0.07,
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                     Get.back();
                    }, icon:const Icon(Icons.arrow_back_rounded),iconSize: 35,),
                    const SizedBox(width: 15,),
                     Text(restaurantController.restaurantModel.value.restaurantName.toString(),style:const TextStyle(fontSize: 18,fontFamily: 'metro',fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              SingleChildScrollView(  
                child: Padding(
                  padding:const EdgeInsets.only(left: 15,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: h * 0.02,),
                      const Text("Booking Details",style: TextStyle(fontSize: 20,fontFamily: 'metro',fontWeight: FontWeight.bold),),
                      const SizedBox(height: 15,),
                      Container(
                        height: h * 0.36,
                        width: w * 0.92,
                        decoration:const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                                    BoxShadow(color: Color.fromARGB(98, 203, 203, 203),blurRadius: 10,)
                                  ]
                        ),
                        child: Padding(
                          padding:const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: w * 0.25,
                                    height: h * 0.09,
                                    decoration: BoxDecoration(
                                      borderRadius:const BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(restaurantController.restaurantModel.value.restaurantImage.toString()),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                  SizedBox(width: w * 0.05,),
                                   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(restaurantController.restaurantModel.value.restaurantName.toString(),style:const TextStyle(fontSize: 20,fontFamily: 'metro',fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 5,),
                                      Text(restaurantController.restaurantModel.value.area.toString(),style:const TextStyle(fontSize: 12,fontFamily: 'metro',color: Colors.grey),),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text("No. of Guest",style: TextStyle(fontSize: 15,fontFamily: 'metro'),),
                                            const SizedBox(height: 10,),
                                            Container(
                                              width: w * 0.34,
                                              height: h * 0.05,
                                              decoration:const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                color:  Color.fromARGB(255, 241, 241, 241),
                                              ),
                                              child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left:0.0,right: 0),
                                                child:  DropdownButton<String>(
                                                  hint: const Text('1'),
                                                  underline:const SizedBox(),
                                                  value: bookingController.bookingModel.value.numberOfGuests,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      bookingController.bookingModel.value.numberOfGuests = newValue.toString();
                                                      print(bookingController.bookingModel.value.numberOfGuests);
                                                    });
                                                  },
                                                  items:const [
                                                    DropdownMenuItem(
                                                      value: '1',
                                                      child: Text('1'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: '2',
                                                      child: Text('2'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: '3',
                                                      child: Text('3'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 15,),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          width: w * 0.4,
                                          height: h * 0.09,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Date',style:TextStyle(fontSize: 15,fontFamily: 'metro'),),
                                              const SizedBox(height: 10,),
                                              InkWell(
                                                child: Container(
                                                  width: w * 0.4,
                                                  height: h * 0.05,
                                                  decoration:const  BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    color: Color.fromARGB(255, 241, 241, 241),
                                                  ),
                                                  child: Row(children: [
                                                    const SizedBox(width: 10,),
                                                    const Icon(Icons.date_range,),
                                                    const SizedBox(width: 15,),
                                                    Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",style:const TextStyle(fontFamily: 'metro',fontSize: 15),)
                                                  ]),
                                                ),
                                                onTap: (){
                                                  selectDate(context);
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15,),
                                    const Text('Time',style: TextStyle(fontSize: 15,fontFamily: 'metro'),),
                                    const SizedBox(height: 5,),
                                    SizedBox(
                                      height: h * 0.06,
                                      width: w * 0.8,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: 5,
                                        itemBuilder: ((context, index){
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: InkWell(
                                              child: Container(
                                                width: w * 0.25,
                                                height: h * 0.06,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: const Color.fromARGB(255, 219, 219, 219),),
                                                  borderRadius:const BorderRadius.all(Radius.circular(10)),
                                                  color: AppConstants.timings[index]['isSelected'] == true 
                                                    ? const Color.fromARGB(255, 40, 40, 40) 
                                                    : Colors.transparent,
                                                ),
                                                child: Center(child: Text(AppConstants.timings[index]['time'],style: TextStyle(
                                                  color: AppConstants.timings[index]['isSelected'] == true 
                                                    ? const Color.fromARGB(255, 255, 255, 255) 
                                                    : Colors.black, 
                                                ),),),
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  bookingController.bookingModel.value.time = AppConstants.timings[index]['time'];
                                                  AppConstants.timings[index]['isSelected'] = !AppConstants.timings[index]['isSelected'];
                                                });
      
                                              },
                                            ),
                                          );
                                        }
                                        ),
                                      ),
                                    )
                                  ]
                                ),
                              )
                              ),
                              const SizedBox(height: 15,),
                              const Text('Guest Details',style: TextStyle(fontSize: 20,fontFamily: 'metro',fontWeight: FontWeight.bold),),
                              SizedBox(height:h * 0.01,),
                              Container(
                                height: h * 0.12,
                                width: w * 0.92,
                                decoration:const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Color.fromARGB(98, 203, 203, 203),blurRadius: 10,)
                                  ]
                                ),
                                child:Padding(
                                  padding:const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
      
                                    children: [
                                      Text(userController.userModel.value.name.toString(),style:const TextStyle(fontFamily: 'metro',fontSize: 20,fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 4,),
                                      Text("+91 ${userController.userModel.value.phone.toString()}",style:const TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.grey),),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Text("Cart Items",style: TextStyle(fontFamily: 'metro',fontSize: 20,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Container(
                                width: w * 0.92,
                                height: cartController.cartItemsLength * w * 0.21,
                                decoration:const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(color: Color.fromARGB(98, 203, 203, 203),blurRadius: 10,)
                                  ]
                                ),
                                child:
                                    Padding(
                                      padding:const EdgeInsets.all(20),
                                      child: StreamBuilder(
                                        stream: cartController.cartItemsStream,
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
                                            return const Center(child:Text("No Items Added",style: TextStyle(fontSize: 20,fontFamily: 'metro'),));
                                          }
                                          if(snapshot.data !=null){

                                            return ListView.builder(
                                              
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (context,index){
                                                  return SizedBox(
                                                  width: w * 0.89,
                                                  height: h * 0.06,
                                                  child: Row(
                                                    children: [
                                                      if(snapshot.data!.docs[index]["ItemType"] == "Veg")
                                                        Image.asset('assets/icons/veg.png',width: 20,),
                                                      if(snapshot.data!.docs[index]["ItemType"] == "Non-Veg")
                                                        Image.asset('assets/icons/nonveg.png',width:20),
                                                      SizedBox(width: w * 0.03,),
                                                      SizedBox(
                                                        width: w * 0.35,
                                                        child: Text(snapshot.data!.docs[index]["ItemName"],style:const TextStyle(fontFamily: 'metro',fontSize: 12,fontWeight: FontWeight.w600),),
                                                      ),
                                                      Container(
                                                        width: w * 0.2,
                                                        height: h * 0.035,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color:const Color.fromARGB(255, 202, 202, 202),width: 1),
                                                          borderRadius:const BorderRadius.all(Radius.circular(8)),
                                                        ),
                                                        child:Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding:const EdgeInsets.only(bottom: 0,right: 7),
                                                                child: InkWell(
                                                                  child:const Icon(Icons.remove,size: 16,color:Color.fromARGB(225,73, 166, 135)),
                                                                  onTap: (){
                                                                    if(snapshot.data!.docs[index]['Quantity'] > 0){
                                                                      cartController.decrementQuantity(snapshot.data!.docs[index]['ItemId']);
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:const EdgeInsets.only(bottom:1.0,right: 7),
                                                                child: Text(snapshot.data!.docs[index]['Quantity'].toString(),style:const TextStyle(fontFamily: 'metro',fontSize: 15,color:Color.fromARGB(225,73, 166, 135)),),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(bottom: 0,right: 5),
                                                                child: InkWell(
                                                                  child: Icon(Icons.add,size: 16,color: Color.fromARGB(225,73, 166, 135),),
                                                                  onTap: (){
                                                                    cartController.incrementQuantity(snapshot.data!.docs[index]['ItemId']);
                                                                  },
                                                                ),
                                                                
                                                              ),
                                                              
                                                            ],
                                                          ),
                                                        
                                                      ),
                                                      const SizedBox(width: 15,),
                                                      Text("₹${ snapshot.data!.docs[index]["ItemPrice"]}",style:const TextStyle(fontSize: 12,fontFamily: 'metro',fontWeight: FontWeight.w800), )
                                                    ],
                                                  )
                                                );
                                              },
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                              ),
                              SizedBox(height: 15,),
                              GestureDetector(
                                child: Container(
                                  width: w * 0.92,
                                  height: h * 0.06,
                                  decoration:const  BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color : Color.fromARGB(255, 252, 252, 252),
                                    boxShadow: [
                                      BoxShadow(color: Color.fromARGB(98, 203, 203, 203),blurRadius: 10,)
                                    ]
                                  ),
                                  child:const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Add more Items",style: TextStyle(fontFamily: 'metro',fontSize: 15),),
                                        Icon(Icons.add_circle_outline_outlined,color: Colors.grey,)
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  Get.back();
                                },
                              ),
                              SizedBox(height: h * 0.02,),
                              Text("Coupon & Offers",style: TextStyle(fontFamily: 'metro',fontSize: 18,fontWeight: FontWeight.bold),),
                              SizedBox(height: h * 0.02,),
                              Container(
                                alignment: Alignment.center,
                                height: h * 0.07,
                                width: w * 0.92,
                                decoration:const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12,top: 0),
                                  child: Center(
                                    child:Row(
                                      children: [
                                        Container(
                                          width: w* 0.65,
                                          child: TextField(
                                            controller: couponController.couponCode,
                                            decoration:const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Coupon code",
                                              hintStyle: TextStyle(fontFamily: 'metro',fontSize: 15),
                                              
                                            ),
                                            
                                          )
                                        ),
                                        SizedBox(width: 5,),
                                        TextButton(onPressed: () async{
                                          bool check = false;
                                          check = await couponController.checkCouponAvailable();
                                          if(check){
                                            print("Coupon available");
                                            couponController.code = couponController.couponCode.text;
                                          }else{
                                            print("Coupon not available");
                                            couponController.code = '';
                                          }
                                          
                                        },
                                          child: Text("Apply",style: TextStyle(fontSize: 15,fontFamily: 'metro',color: Colors.blue),)
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(height: h * 0.2,)

                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
      ),
    );
  }


  Future<void> selectDate(context) async{
    final DateTime? picked = await showDatePicker(
      context: context,      
      initialDate: selectedDate,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2040),
    );
    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

