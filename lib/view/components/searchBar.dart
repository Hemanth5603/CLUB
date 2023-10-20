import "package:club/controllers/restaurant_controller.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";


Widget searchBar(context,color) {
  final ScreenWidth = MediaQuery.of(context).size.width;
  final ScreenHeight = MediaQuery.of(context).size.height;
  
  return Padding(
    padding: EdgeInsets.all(0),
    child: Container(
      height: ScreenHeight * 0.08,
      width: ScreenWidth * 0.98,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color,
          boxShadow:const [
            BoxShadow(
              color: const Color.fromARGB(255, 213, 213, 213),
              blurRadius: 6,
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.search_rounded, size: 20, color: Colors.black),
          ),
          const SizedBox(
            width: 8,
          ),
          const VerticalDivider(width: 10,color:Colors.grey),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child:RichText(
              overflow: TextOverflow.ellipsis,
              text:const TextSpan(
                text: "Search for resto bars or cuisine and mo... ",
                style: TextStyle(color: Colors.grey),
              )
            )
          )
        ],
      ),
    ),
  );
}


/**/ 