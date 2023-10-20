import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

RestaurantModel userFromJson(String str) => RestaurantModel.fromJson(json.decode(str));
//String userToJson(RestaurantModel data) => json.encode(data.toJson());

class RestaurantModel{

    String? uid; // admin uid
    String? restoId; // current doc uid
    String? restaurantName;
    String? phone;
    String? email;
    String? imagePath;
    String? restaurantImage;
    double? rating;
    int? totalReviews;
    String? startTime;
    String? endTime;
    String? area;
    String? landmark;
    String? pincode;
    String? city;
    double? latitude;
    double? longitude;
    String? address;
    String? currentAddress;
    Position? position;
    String? type;
    bool? isAvailable;
    bool? isOwnew;
    int? bannerCount;

    RestaurantModel({
        this.uid,
        this.restoId,
        this.restaurantName,
        this.phone,
        this.email,
        this.imagePath,
        this.restaurantImage,
        this.rating,
        this.totalReviews,
        this.startTime,
        this.endTime,
        this.area,
        this.landmark,
        this.pincode,
        this.latitude,
        this.longitude,
        this.address,
        this.currentAddress,
        this.position,
        this.city,
        this.type,
        this.isAvailable  = true,
        this.isOwnew = false,
        this.bannerCount,
    });
    factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
        uid: json["uid"],
        restaurantName: json["name"],
        phone: json["phone"],
        email: json["email"],
        
    );

      
}
