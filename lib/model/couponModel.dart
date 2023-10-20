import 'package:get/get.dart';

class CoupounModel extends GetxController{
  String? heading;
  int? offer;
  int? maxOffer;
  String? code;
  CoupounModel({
    this.heading,
    this.offer,
    this.code,
    this.maxOffer,
  });
}