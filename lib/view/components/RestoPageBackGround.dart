import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/appConstants.dart';
import '../authorised/tabs/home/HomeScreen.dart';

Widget restoPageBackground(context,h,w) {
  var index = 2;
  return Container(
    height:h * 0.35,
    width: w,
    decoration:const BoxDecoration(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
      color: Color.fromARGB(223, 237, 237, 237),
      
    ),

  );
}
