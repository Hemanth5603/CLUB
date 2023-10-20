import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


Widget location(location){

  return Row(
    children: [
      const Icon(Icons.location_on_sharp,color: Colors.black,size: 25,),  
      const SizedBox(width: 10,),
      Text(location,style:const TextStyle(fontFamily: 'metro',fontSize: 18),overflow: TextOverflow.ellipsis),
      const SizedBox(width: 5,),
      const Icon(Icons.arrow_drop_down)
    ],
  ); 
}