
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/auth_controller.dart';
import 'package:club/view/authorised/tabs/home/Home.dart';
import 'package:club/view/authorised/tabs/profile/EditProfile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/userModel.dart';

class UserController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  final fire = FirebaseFirestore.instance;
  String location = ''.obs();

  Future<void> getCurrentPosition() async {
    bool serviceEnabled = false;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please keep your location enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location Permission denied!');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location Permission denied Forever!');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      userModel.value.latitude = position.latitude;
      userModel.value.longitude = position.longitude;
      userModel.value.location ="${place.street},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}".obs();
      location =  "${place.street},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}".obs();
      prefs.setString('loaction', location);
    } catch (e) {
      print(e);
    }
    print("Address : ${userModel.value.location}");
    print(userModel.value.latitude);
    print(userModel.value.longitude);

  }

  Future<void> updateUserLocation() async{
    final SharedPreferences prefs =await SharedPreferences.getInstance();
    final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid')).update({
        'location': userModel.value.location,
        'latitude' : userModel.value.latitude,
        'longitude': userModel.value.longitude
      });
  }


  Future<void> registerUser(name, gender, dob, phone, email, profile) async {
    final ref = fire.collection('users').doc(userModel.value.uid)
    .update({
        "uid": userModel.value.uid,
        "Name": name,
        "Gender": gender,
        "Phone": phone,
        "DOB": dob,
        "Email": email,
        "ProfileImage": userModel.value.profileUrl,
        "isDJ": false,
    });
    
    await getUserDetails();
    Get.offAll(const Home(),duration:const Duration(milliseconds: 400),transition: Transition.downToUp);
  }


  Future<String> uploadProfile(file) async {
    String url = '';
    String uniquename = DateTime.now().microsecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_Images')
        .child(uniquename);
    try {
      await ref.putFile(File(file));
      userModel.value.profile = await ref.getDownloadURL();
    } catch (e) {
      print("Cannot upload profile or get link");
      print(e);
    }
    return url;
  }

  Future<bool> checkRegistered() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('uid').toString())
        .get();
    Map<String, dynamic>? data = ref.data();
    print("called");
    if (data?['Name'] == 'null') {
      Get.to(const EditProfile());
      return true;
    }
    return false;
  }

  Future<bool> checkRegisteredAtHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('uid').toString())
        .get();
    Map<String, dynamic>? data = ref.data();
    print("called");
    if (data?['Name'] == 'null') {
      return true;
    }
    return false;
  }

  Future<void>  getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ref = await FirebaseFirestore.instance
        .collection("users")
        .doc(prefs.getString('uid'))
        .get();

    Map<String, dynamic>? userData = ref.data();
    userModel.value.name = userData?['Name'];
    userModel.value.email =userData?['Email'];
    userModel.value.phone = userData?['Phone'];
    userModel.value.profile = userData?['ProfileImage'];
    userModel.value.latitude = userData?['latitude'];
    userModel.value.longitude = userData?['longitude'];
    userModel.value.dob = userData?['DOB'];
    userModel.value.gender = userData?['Gender'];
    
  }

    Future<String> uploadProfileImage(file) async {
    String url = '';
    String uniqueName = DateTime.now().microsecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_profile_images')
        .child(uniqueName);

    try{
      await ref.putFile(File(file));
      userModel.value.profileUrl = await ref.getDownloadURL();
    }catch(e){
      print("Cannot Upload Image or Get link");
      print(e);
    }
    return url; 
  }

  String qrCodeData(){
    var data = {
      "name":userModel.value.name.toString(),
      "gender":userModel.value.gender.toString(),
      "age":userModel.value.dob.toString(),
      "phone":userModel.value.phone.toString()
    };
    return data.toString();
  }

  Future<void> likeRestaurant(uid) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('liked')
      .doc(uid);

      var data = {
        "uid":uid,
      };
      ref.set(data);
  }

}
