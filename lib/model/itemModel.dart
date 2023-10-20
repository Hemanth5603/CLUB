import 'package:get/get.dart';

//String userToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel extends GetxController {
  String? itemId;
  String? itemName;
  String? description;
  String? price;
  String? itemType = 'veg';
  int? quantity;
  int? serving;
  int? discount;
  String? itemImage;
  String? imagePath;
  bool? recomended;
  bool? isAvailable;
  bool? isSpecial;
  ItemModel({
    this.itemId,
    this.description,
    this.quantity,
    this.price,
    this.itemType,
    this.serving,
    this.discount,
    this.isSpecial,
    this.itemImage,
    this.itemName,
    this.imagePath,
    this.recomended,
    this.isAvailable,
  });
}
