
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/model/itemModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController{

  RestaurantController restaurantController = Get.put(RestaurantController());
  Stream<QuerySnapshot<Map<String, dynamic>>>? cartItemsStream;
  List<String> CartList = [];
  List<String> finalCartList = [];
  var isAddedToCart = false.obs();
  int cartItemsLength = 0;

  

  Future<void> addItemsToCart() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(CartList.length);
    final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc('cartItems');
    
    print(prefs.getString('uid'));
    
    try{
      await ref.set({
        'ItemId':CartList,
      });
    }catch(e){
      print(e);
    }
    
    /*CartList.forEach((element) async {
      await ref.set({
        'ItemId':element,
      });
    });*/
      
  }

  /*Future<void> getCartItemsLength() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc('cartItems').get().then((value){
        List.from(value.data()!['ItemId']).forEach((element) {
          finalCartList.add(element);
        });
      });
    print(finalCartList);
  }*/


  Future<void> getCartItemsLength() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('cart').get();

    cartItemsLength = snap.docs.length;
    print(cartItemsLength.toString());
  }


  Future<void> getCartItemsStream() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();  
    print(prefs.getString('uid'));
    cartItemsStream = FirebaseFirestore.instance
      .collection('users')
      .doc(prefs.getString('uid'))
      .collection('cart')
      .snapshots();
  }


  Future<void> addItemToCart(id,type,name,price) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc(id);

    await ref.set({
      "ItemId":id,
      "ItemName":name,
      "ItemType":type,
      "ItemPrice":price,
      "Quantity":1,
    });
  }

  Future<bool> checkDocExists(id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool exists = false;
    await FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc(id).get().then((value){
        exists = value.exists;
      });
    return exists;
  }

  Future<void> removeItemFromCart(id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final deleteItem = FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc(id);
      await deleteItem.delete();
  }

  Future<void> incrementQuantity(id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double price = 0;
    final ref = FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc(id);
    var doc = await ref.get();
    Map<String, dynamic>? data = doc.data();
    price = double.parse(data?["ItemPrice"]) * 2;
    await ref.update({
      "Quantity": FieldValue.increment(1),
      "ItemPrice": price.toString(),

    });
  }

  Future<void> decrementQuantity(id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double price = 0;
    final ref = FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart')
      .doc(id);
    var doc = await ref.get();
    Map<String, dynamic>? data = doc.data();
    price = double.parse(data?["ItemPrice"]) / 2;
    await ref.update({
      "Quantity": FieldValue.increment(-1),
      "ItemPrice":price.toString(),
    });
  }

  Future<void> refreshCart() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = FirebaseFirestore.instance
      .collection("users")
      .doc(prefs.getString('uid'))
      .collection('cart').get().then((snapshot){
        for(DocumentSnapshot ds in snapshot.docs){
          ds.reference.delete();
        }
      });
  }


  
}