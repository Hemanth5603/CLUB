import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

//String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends GetxController {
  String? uid;
  String? name = ''.obs();
  String? phone;
  String? email;
  String? gender;
  String? dob;
  String? profile = ''.obs();
  String? profileUrl;
  bool? isOwner;
  bool? isDj;
  double? latitude;
  double? longitude;
  String? location = ''.obs();

  UserModel({
    this.uid,
    this.name,
    this.phone,
    this.email,
    this.latitude,
    this.longitude,
    this.gender,
    this.profileUrl,
    this.isDj,
    this.isOwner,
    this.dob,
    this.profile,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        profile: json["profile"],
        location: json["location"],
      );

  /*Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "profile": profile,
        "location": location,
        "membership": membership,
        "table_bookings": List<dynamic>.from(tableBookings.map((x) => x)),
        "total_booking": totalBooking,
        "reward_points": rewardPoints,
        "liked_restos": List<dynamic>.from(likedRestos.map((x) => x)),
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
    };*/
}
