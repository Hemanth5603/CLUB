import 'package:club/constants/appConstants.dart';
import 'package:club/controllers/auth_controller.dart';
import 'package:club/controllers/restaurant_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/services/notificationServices.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  var currentIndex = 0;
  RestaurantController restaurantController = Get.put(RestaurantController());
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  NotificationServices notificationServices = NotificationServices();

  late bool isLoading = false;
  

  @override
  void initState() {
    super.initState();
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      await initializeHome();
      /*Future.delayed(const Duration(milliseconds:3000 ),(){
        setState(() {
          isLoading = false;
        });
      });*/
    });
  }


  late double h,w;
  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: FlashyTabBar(
            showElevation: true,
            selectedIndex: currentIndex,
            animationCurve: Curves.easeInCubic,
            onItemSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            height: 55,
            iconSize: 18,
            items: AppConstants.flashyTabBarItems
          ),
      body:  Skeletonizer(
        enabled: isLoading,
        child: Stack(
          children: [
            SafeArea(
              child: IndexedStack(index: currentIndex, children: AppConstants.tabs,)
            ),
          ],
        ),
      ),
    );
  }
  

  Future initializeHome() async{
    setState(() {
      isLoading = true;
    });
    await userController.getCurrentPosition();
    await authController.getUserId();
    await userController.updateUserLocation();
    if(await userController.checkRegisteredAtHome() ==false){
      await userController.getUserDetails();
    }
    await restaurantController.getBannerLength();
    await restaurantController.getRestaurants();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(BuildContext);
    notificationServices.setupInteractMessage(BuildContext);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print("Device token $value");
    });
    setState(() {
      isLoading = false;
    });
  }
}

