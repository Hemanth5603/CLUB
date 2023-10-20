import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/model/bookingModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingController extends GetxController{
  Rx<BookingModel> bookingModel = BookingModel().obs;
  UserController userController = Get.put(UserController());
  RestaurantController restaurantController = Get.put(RestaurantController());
  double total = 0;
  double totalAfterDiscount = 0;
  double totalDiscount = 0;
  int discount = 0;
  int count = 0.obs();

  Future<void> decrementQuantity(itemId) async{
    bool exist = false;

    await FirebaseFirestore.instance.
      collection('users')
      .doc(userController.userModel.value.uid)
      .collection('cart')
      .doc(itemId).get()
      .then((value) {
        exist = value.exists;
        Map<String,dynamic>? data = value.data();
        count = data?['Quantity'];
        update();
      });

    final ref = await FirebaseFirestore.instance
      .collection('users')
      .doc(userController.userModel.value.uid)
      .collection('cart')
      .doc(itemId);
    
    if(exist){
      await ref.update({
        "Quantity":FieldValue.increment(-1),
      });
    }
  }

  Future<void> incrementQuantity(itemId) async{
    bool exist = false;
    await FirebaseFirestore.instance.
      collection('users')
      .doc(userController.userModel.value.uid)
      .collection('cart')
      .doc(itemId).get()
      .then((value) {
        exist = value.exists;
        Map<String,dynamic>? data = value.data();
        count = data?['Quantity'];
        update();
      });

    final ref = await FirebaseFirestore.instance
      .collection('users')
      .doc(userController.userModel.value.uid)
      .collection('cart')
      .doc(itemId);
    
    if(exist){
      await ref.update({
        "Quantity":FieldValue.increment(1),
      });
    }
  }

  Future<void> addItemToCart(itemId) async{

    final ref = await FirebaseFirestore.instance
      .collection('users')
      .doc(userController.userModel.value.uid)
      .collection('cart')
      .doc(itemId);
      await ref.set({
        "ItemId":itemId,
        "Quantity":1,
      });
    }
  
  Future<void> bookRestaurantNotification(restoToken,guests) async{
    var data = {
      'to': restoToken,
      'priority': 'high',
      'notification': {
        'title': 'New Booking Recieved',
        'body': "No of Guests: $guests",
    }
  };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: jsonEncode(data),

      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=AAAA_AEicoI:APA91bEBh80mPQuFibRSeFHn9DK3bvmzBaCv262C4fU32Uwt7rMRhUIl0Hd3krky0nIdexQorkgSYtLonVH00w2Jez-q_IJPp6sukf6tjdOeK4USfkuZhwX__Yn0EjuTlHrZE5U00nNd',
      }
    );
  }


  Future<void> bookRestaurant() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userBooking = FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('bookings')
      .doc();
    print(restaurantController.restaurantModel.value.restoId);

    final restoBooking = FirebaseFirestore.instance
      .collection('RestaurantOwner')
      .doc(restaurantController.restaurantModel.value.uid)
      .collection('RestaurantDetails')
      .doc(restaurantController.restaurantModel.value.restoId)
      .collection('bookings')
      .doc(userBooking.id);

    Map<String,dynamic> data = ({
      'uid':userBooking.id,
      'GuestName':userController.userModel.value.name,
      'NumberOfGuests':bookingModel.value.numberOfGuests,
      'Date':bookingModel.value.date,
      'Time':bookingModel.value.time,
      'Phone':userController.userModel.value.phone,

    });

    try{
      await userBooking.set(data);
      await restoBooking.set(data);
    }catch(e){
      print("Booking failed Please try Again");
    }
  }

  Future<void> applyCoupon(couponCode) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var document = FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantController.restaurantModel.value.restoId)
      .collection('offers');

    var doc = await  document.doc(couponCode).get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data();
        discount = data?['Offer']; // <-- The value you want to retrieve. 
  // Call setState if needed.
      }
      print(discount);
      
  }



  Future<void> calculateBill(couponCode) async{
    total = 0;
    totalAfterDiscount = 0;
    totalDiscount = 0;
    if(couponCode != ''){
      await applyCoupon(couponCode);
    }
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('cart')
      .get();
    
    for(int i=0; i<querySnapshot.docs.length ;i++){
      total += double.parse(querySnapshot.docs[i]['ItemPrice']);
    }
    totalDiscount = (discount/100) * total;
    totalAfterDiscount = (total-totalDiscount).abs();
    
    
  }
  





}
