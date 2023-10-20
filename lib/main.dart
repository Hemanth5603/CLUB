import 'package:club/view/authorised/Booking.dart';
import 'package:club/view/authorised/tabs/home/Home.dart';
import 'package:club/view/authorised/tabs/home/HomeScreen.dart';
import 'package:club/view/authorised/RestaruntPage.dart';
import 'package:club/view/authorised/RestaruntPage.dart';
import 'package:club/view/authorised/VibeXScreen.dart';
import 'package:club/view/authorization/login.dart';
import 'package:club/view/authorization/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 14, 14, 14)
    )
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MainApp()); 
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final FirebaseAuth auth = FirebaseAuth.instance;
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, index) {
          if(auth.currentUser != null){
            return GetMaterialApp(
            theme: ThemeData.light(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            home:const Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: null,
              body: Home(),
            ), 
          );
        }else{
           return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(useMaterial3: true),
            home:Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: null,
              body: OnBoarding(),
            ),
          );
        }
      }
    );
  }
}
