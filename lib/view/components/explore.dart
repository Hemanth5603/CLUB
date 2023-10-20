import 'package:club/constants/appConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget explore(context) {
  final screenheight = MediaQuery.of(context).size.height;
  final screenwidth = MediaQuery.of(context).size.width;
  return SizedBox(
      height: 10.h,                                                                                                                                                                           
      child: ListView.builder(
          itemCount: Explore.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              print(Explore[index]);
            },
            child: Container(
                height: 2.h,
                width: 80.w,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    borderRadius: const BorderRadius.all(Radius.circular(11),),
                  boxShadow: [
                      BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.grey,style:BorderStyle.solid,width: 0.05)
                ),
                    
                child: Center(child: Text(Explore[index],style: TextStyle(fontSize:11,fontWeight: FontWeight.bold),))),
          ),
        ),
      );
}
