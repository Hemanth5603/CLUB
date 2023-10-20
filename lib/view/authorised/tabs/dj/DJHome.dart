import 'dart:async';

import 'package:club/constants/appConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class DJ extends StatefulWidget {
  const DJ({Key? key}) : super(key: key);

  @override
  _DJState createState() => _DJState();
}

class _DJState extends State<DJ> {
  var date = DateFormat.MMMMd().format(DateTime.now());
  var time = DateFormat.jm().format(DateTime.now());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer =Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
  void _update() {
    date = DateFormat.MMMMd().format(DateTime.now());
    time = DateFormat.jm().format(DateTime.now());
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic height = MediaQuery.sizeOf(context).height;
    dynamic width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 249, 249, 249),
      body: CustomScrollView(
        slivers: [
           SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10,left: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Container(
                          width: width * 0.9,
                          child:const Text(
                            "Explore DJ's and Events around you",
                            style: TextStyle(fontSize: 18,
                            color: Color.fromARGB(255, 25, 25, 25),
                            fontFamily: 'metro',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:const EdgeInsets.all(18),
              child: Container(
                height: height * 0.06,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 35, 35, 35),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 18,color: Color.fromARGB(255, 220, 220, 220),fontFamily: 'sen')
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Color.fromARGB(255, 220, 220, 220),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: SizedBox(
                height: height * 0.04,
                child:const Text("Active DJ's near you..",style: TextStyle(fontFamily: 'metro',fontSize: 18,fontWeight: FontWeight.bold),)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left:10.0),
              width: width,
              height: height * 0.12,
              
              child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Color.fromARGB(255, 57, 57, 57),width: 2),
                      ),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage("https://static.vecteezy.com/system/resources/thumbnails/024/308/318/small/cool-dj-with-headphones-illustration-ai-generative-free-photo.jpg"),
                      ),
                    )
                  ],
                ),
              ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 10),
              child: Text("Featured Events",
                  style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 31, 31, 31),fontFamily: 'metro',fontWeight: FontWeight.bold)),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(left: 10,top: 12),
              height: height * 0.35,
              width: width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: width * 0.6,
                    height: height * 0.3,
                    decoration:const BoxDecoration(
                      color:Color.fromARGB(255, 26, 26, 26),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.24,
                          width: width * 0.6,
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage("https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/2bfef6152588005.Y3JvcCwxMDgwLDg0NCwwLDEyOA.png"),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8,left: 8),
                          child: Text("Night Agenda",style: TextStyle(fontFamily: 'metro',fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded,color: Colors.grey,size: 15,),
                              SizedBox(width: 6,),
                              Text("Vizag",style: TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.grey,),),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: width * 0.6,
                    height: height * 0.3,
                    decoration:const BoxDecoration(
                      color:Color.fromARGB(255, 26, 26, 26),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.24,
                          width: width * 0.6,
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                            image: DecorationImage(
                              image: NetworkImage("https://mir-s3-cdn-cf.behance.net/projects/max_808_webp/23751d174131623.Y3JvcCwyNTk5LDIwMzMsNjE3LDI5NQ.png"),
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8,left: 8),
                          child: Text("Night Agenda",style: TextStyle(fontFamily: 'metro',fontSize: 16,color: Colors.grey,fontWeight: FontWeight.bold),),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded,color: Colors.grey,size: 15,),
                              SizedBox(width: 6,),
                              Text("Vizag",style: TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.grey,),),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}
