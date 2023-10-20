import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class VibeScreen extends StatefulWidget {
  const VibeScreen({super.key});
  @override
  State<VibeScreen> createState() => _VibeScreenState();
}


class _VibeScreenState extends State<VibeScreen> {
  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.of(context).size.height;
    double sw = MediaQuery.of(context).size.width;
    return  Scaffold(
    backgroundColor: const Color.fromARGB(255, 252, 255, 255),
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 180,
            child: Transform.rotate(
              angle: -8 * 3.14 / 180, 
              child: Center(
                child: SwipeCard('https://images.unsplash.com/photo-1503443207922-dff7d543fd0e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=327&q=80','Martin  26'),
              ),
            ),
          ),
          Positioned(
            left: 140,
            bottom: 220,
            child: Transform.rotate(
              angle: 12 * 3.14 / 180, 
              child: Center(
                child: SwipeCard('https://images.unsplash.com/photo-1481214110143-ed630356e1bb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80','Lina  24'),
              ),
            ),
          ),
          SizedBox(
            height: 900,
            width: 500,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left:sw / 2 -140.w ,
            bottom: 120,
            child: Column(
              children: [
                Text("Find a Clubber",style: TextStyle(fontSize:25,color: const Color.fromARGB(255, 0, 0, 0)),),
                Text("\"Vibe with your Tribe\"",style: TextStyle(fontSize:25,color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Positioned(
            top: sh / 2 - 140,
            left: sw /2 - 110,
            child: Transform.rotate(
              angle: -10 * 3.14/180,
              child: Text("Comming \n Soon..",style: TextStyle(fontSize: 80,color: const Color.fromARGB(255, 123, 250, 127)),)),
          )
        ],
      )
    );
  }
}



Widget SwipeCard(path,name){
  return Container(
    height: 400.h,
    width: 250.w,
    decoration:const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.grey
    ),
    child: Stack(
      children: [
        Container(
          height: 400.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(path),
              fit: BoxFit.cover,
            )
          ),
        ),
        Positioned(
          left: 20.w,
          bottom: 90.h,
          child: Text(name,style: TextStyle(fontSize: 25,color: Colors.white)),
        ),
        Positioned(
          left: 40.w,
          bottom: 30.h,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration:const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.white
            ),
            child:const Icon(Icons.close,color: Colors.red,),
          )
        ),
        Positioned(
          right: 40.w,
          bottom: 30.h,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration:const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.white
            ),
            child:const Icon(Icons.favorite,color: Colors.pink,),
          )
        )
      ],
    ),
  );
}