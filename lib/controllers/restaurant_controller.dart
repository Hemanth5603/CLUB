
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import '../model/restaurantModel.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class RestaurantController extends GetxController{
  Rx<RestaurantModel> restaurantModel = RestaurantModel().obs;
  final fire = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>>? restaurantsDataStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? menuItemsStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? offerStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? restaurantInteriorImagesStream;
  Stream<QuerySnapshot<Map<String, dynamic>>>? vegFilterStream;
  Stream searchStream = FirebaseFirestore.instance.collection('Restaurants').snapshots().obs();
  Map<String,dynamic>? restaurantDetails;

  String hour = DateFormat("HH").format(DateTime.now());
  String min = DateFormat("mm").format(DateTime.now());

  List<String> timeSlots = [];
  var selection = 0;
  int bannerLength = 0;
  int totalRestaurants = 0;


  Future<void> getBannerLength() async {
    
    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('banners').get();
    final int length = snap.docs.length;

    QuerySnapshot ref = await FirebaseFirestore.instance.collection('Restaurants').get();
    final int len = ref.docs.length;
    bannerLength =  length;
    totalRestaurants = len;


  }

  Future<void> getRestaurants() async {
    restaurantsDataStream = await fire.collection('Restaurants').snapshots();
    print("Data stream: ${restaurantsDataStream}");

  }

  Future<void> getRestaurantsDetails() async{
    final ref = await FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantModel.value.restoId).get();
    restaurantDetails = ref.data();
    restaurantModel.value.restaurantName = restaurantDetails?['RestaurantName'];
    restaurantModel.value.area = restaurantDetails?['Area'];
    restaurantModel.value.restaurantImage = restaurantDetails?['RestaurantLogo'];
    restaurantModel.value.restoId = restaurantDetails?['RestoId'];
    restaurantModel.value.uid = restaurantDetails?['uid'];
    restaurantModel.value.latitude = double.parse(restaurantDetails?['Latitude']);
    restaurantModel.value.longitude = double.parse(restaurantDetails?['Longitude']);
    restaurantModel.value.startTime = restaurantDetails?['StartTime'];
    restaurantModel.value.endTime = restaurantDetails?['EndTime'];
  }

  Future<void> getMenuItems() async{
    var searchKey = "";
    if(selection == 1) {
      searchKey = "Veg";
    } else if(selection == 2) {
      searchKey = "Non-Veg";
    }
    
    menuItemsStream =  FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantModel.value.restoId)
      .collection('menu')
      .where('ItemType',isGreaterThanOrEqualTo: searchKey)
      .where('ItemType',isLessThan: searchKey + 'z')
      .snapshots();
  }

  Future<void> getOffers() async{
    offerStream =  FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantModel.value.restoId)
      .collection('offers')
      .snapshots();
  }


  Future<void> searchRestaurants(searchKey) async{
    searchStream = fire.collection('Restaurants')
      .where('RestaurantName',isGreaterThanOrEqualTo: searchKey)
      .where('RestaurantName',isLessThan: searchKey + 'z')
      .snapshots();
  }
  


  Future<dynamic> getRestaurantsInteriorImages() async{
    restaurantInteriorImagesStream = FirebaseFirestore.instance
      .collection('Restaurants')
      .doc(restaurantModel.value.restoId)
      .collection('images')
      .snapshots();
  }

  

  void createTimeSlots(start,end){
    
    int start = int.parse(restaurantModel.value.startTime.toString().substring(0,3));
    for(var i = start;i < end;i++){
      String slot = (i + 30).toString();
      timeSlots.insert(i,slot);
    }
  }


  // To Calculate the distance between the user and each restaurant

  double toRadians(double degrees) => degrees * pi/180;

  num _haversin(double radians) => pow(sin(radians/2),2);

  String calculateDistance(double lat1,double lon1, double lat2,double lon2){
    const r = 6372.8;
    
    final dLat = toRadians(lat2 - lat1);
    final dLon = toRadians(lon2 - lon2);
    final lat1Radians = toRadians(lat1);
    final lat2Radians = toRadians(lat2);

    final a = _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return (r * c).toStringAsFixed(2);
  }
}