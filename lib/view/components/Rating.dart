import 'package:flutter/material.dart';


import '../authorised/tabs/home/HomeScreen.dart';

Widget Rating(index, double size) {
  return Container(
    margin: EdgeInsets.only(top: 60, left: 10),
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Color.fromARGB(255, 56, 165, 60),
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
          child: Row(
        children: [
          Text(
            '4.2',
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
          SizedBox(
            width: 5,
          ),
          Positioned(
              child: Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: size,
          ))
        ],
      )),
    ),
  );
}
