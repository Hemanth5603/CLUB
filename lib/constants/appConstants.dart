import 'package:club/view/authorised/SearchScreen.dart';
import 'package:club/view/authorised/tabs/events/EventScreen.dart';
import 'package:club/view/authorization/login.dart';
import 'package:club/view/authorization/onboarding.dart';
import 'package:club/view/authorization/otp.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';

import '../view/authorised/Booking.dart';
import '../view/authorised/dropdown.dart';
import '../view/authorised/tabs/dj/DJHome.dart';
import '../view/authorised/tabs/profile/ProfilePage.dart';
import '../view/authorised/tabs/home/HomeScreen.dart';
import '../view/authorised/RestaruntPage.dart';
import '../view/authorised/VibeXScreen.dart';

class AppConstants {
  static List<FlashyTabBarItem> flashyTabBarItems = [
    FlashyTabBarItem(
      icon: const Icon(
        Icons.home_rounded,
        color: Color.fromARGB(255, 48, 43, 43),
        size: 25,
      ),
      title: const Text(
        'Home',
        style: TextStyle(color: Colors.black),
      ),
    ),
    FlashyTabBarItem(
      icon: const Icon(
        Icons.event,
        color: Colors.black,
        size: 25,
      ),
      title: const Text(
        'Events',
        style: TextStyle(color: Colors.black),
      ),
    ),
    FlashyTabBarItem(
      icon: const Icon(
        Icons.music_note_outlined,
        size: 25,
        color: Colors.black,
      ),
      title: const Text(
        'DJ',
        style: TextStyle(color: Colors.black),
      ),
    ),
    FlashyTabBarItem(
      icon: const Icon(
        Icons.person_rounded,
        size: 25,
        color: Colors.black,
      ),
      title: const Text(
        'Profile',
        style: TextStyle(color: Colors.black),
      ),
    ),
  ];

  static const List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.event,
    Icons.music_note_rounded,
    Icons.person_rounded,
  ];

  static const List<String> listOfStrings = [
    'Home',
    'Event',
    'Dj',
    'Profile',
  ];

  static List<Widget> tabs = [
    HomeScreen(),
    EventListScreen(),
    DJ(),
    ProfilePage()
  ];
  // static List<Map<String, String>> restaurentItems = [];
  var restaurantItems = [
    {
      "food": "panner",
      'foodImage': "assets/images/paneer.jpg",
      "foodPrice": "${200}+/-",
    }
  ];

  static List<DropdownMenuItem> guestsList = [
    const DropdownMenuItem(value: '1', child: Text("1")),
    const DropdownMenuItem(value: '2', child: Text("2")),
    const DropdownMenuItem(value: '2', child: Text("3")),
  ];

  static List<DropdownMenuItem> ItemType = [
    const DropdownMenuItem(
      value: "Veg",
      child: Text("Veg"),
    ),
    const DropdownMenuItem(
      value: "Non-Veg",
      child: Text("Non-Veg"),
    ),
    const DropdownMenuItem(
      value: "Egg",
      child: Text("Egg"),
    ),
  ];

  static List<Map> timings = [
    {
      'time': '7.00 PM,',
      'isSelected': false,
    },
    {
      'time': '7.30 PM',
      'isSelected': false,
    },
    {
      'time': '8.00 PM',
      'isSelected': false,
    },
    {
      'time': '8.30 PM',
      'isSelected': false,
    },
    {
      'time': '9.00 PM',
      'isSelected': false,
    },
  ];
  
  
  static List<String> djs = [
    "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/e6f0ab176835579.Y3JvcCw3NDksNTg2LDY0Nyw0Ng.jpg",
    "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/fd5e61173896987.Y3JvcCwxOTk5LDE1NjQsMCww.jpg",
    "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/096aa4177010995.Y3JvcCwzMTcwLDI0ODAsMTY0LDA.png",
    "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/8adbfe171900643.Y3JvcCwxOTk5LDE1NjQsMCw4NjY.png",
    "https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/b0f88c174200343.Y3JvcCwxOTIwLDE1MDEsMCwyMDk.jpg",
  ];

  static final banners = [
    'https://img.freepik.com/free-psd/food-menu-restaurant-facebook-cover-template_120329-1688.jpg?w=900&t=st=1691227525~exp=1691228125~hmac=d798b0bf14ccc7f4eb415d4f473fd39c3f82ab879e0d084952c051466adb1de6',
    'https://img.freepik.com/free-psd/food-menu-restaurant-facebook-cover-template_120329-1688.jpg?w=900&t=st=1691227525~exp=1691228125~hmac=d798b0bf14ccc7f4eb415d4f473fd39c3f82ab879e0d084952c051466adb1de6',
    'https://img.freepik.com/free-psd/food-menu-restaurant-facebook-cover-template_120329-1688.jpg?w=900&t=st=1691227525~exp=1691228125~hmac=d798b0bf14ccc7f4eb415d4f473fd39c3f82ab879e0d084952c051466adb1de6',
    'https://img.freepik.com/free-psd/food-menu-restaurant-facebook-cover-template_120329-1688.jpg?w=900&t=st=1691227525~exp=1691228125~hmac=d798b0bf14ccc7f4eb415d4f473fd39c3f82ab879e0d084952c051466adb1de6',
  ];


 

}

final Explore = [
  "Restaurants",
  "VibX",
  "DJ's",
  "BarTendaring",
  "Stays",
  "Ride"
];

