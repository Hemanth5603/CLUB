import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CouponController extends GetxController{

  TextEditingController couponCode = TextEditingController();
  String code = '';
  List<String> coupons = [];

  RestaurantController restaurantController = Get.put(RestaurantController());

  Future<bool> checkCouponAvailable() async{

    print(couponCode.text.toUpperCase());
    print(restaurantController.restaurantModel.value.restoId);
    final ref = FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantController.restaurantModel.value.restoId)
      .collection('offers')
      .doc(couponCode.text.toUpperCase());
    final doc = await ref.get();
    
    if(!doc.exists){
      return false;
    }
    return true;
  }
}