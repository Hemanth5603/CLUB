import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../view/authorised/tabs/profile/ProfilePage.dart';

class NotificationServices{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final FlutterLocalNotificationsPlugin  flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    void requestNotificationPermission() async {
      NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true, 
      criticalAlert: true,
      provisional: true,
      sound: true, 
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('user granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }else{
      AppSettings.openAppSettings();
      print("user denied permission");
    }
   }


    void initLocalNotifications(dynamic context,RemoteMessage message)  async{
      var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();

      var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );  

      await flutterLocalNotificationPlugin.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: (payload){
          handleMessage(message);
        }
      );
    }

   void firebaseInit(context){
    FirebaseMessaging.onMessage.listen((message) {
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
      }
      showNotification(message);
    });
   }



    Future<void> showNotification(RemoteMessage message) async{

      AndroidNotificationChannel channel = AndroidNotificationChannel(
          Random.secure().nextInt(10000).toString(),
          'High Importance notification',
      );

      AndroidNotificationDetails androidNotificationDetails  = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'Channel Description',
        icon: 'assets/icons/club.png',
        importance: Importance.max,
        priority: Priority.max,
        ticker: 'ticker',
        enableVibration: true,
        playSound: true,
      );

      DarwinNotificationDetails darwinNotificationDetails =const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      );


      Future.delayed(Duration.zero, (){
        flutterLocalNotificationPlugin.show(
          DateTime.now().millisecond,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
        );
      });
    }

    Future<String> getDeviceToken() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await messaging.getToken();
      await prefs.setString('token', token.toString());
      return token!;
    }

    void isTokenRefresh() async{
      messaging.onTokenRefresh.listen((event) {
        event.toString();
      });
    }


    // Handle message when app is terminated
    Future<void> setupInteractMessage(Build) async{
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if(initialMessage != null){
        handleMessage(initialMessage);
      }

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(event);
      });
    }
    // handle message when app is active
    void handleMessage(RemoteMessage message){
      if(message.data['type'] == 'msg'){
        Get.to(ProfilePage());
      }

    }


    void sendBookingNotification() async{
      getDeviceToken().then((value) async {
        var data = {
          'to': value.toString(),
          'priority': 'high',
          'notification': {
            'title': 'Hemanth',
            'body': "I am a programmer",
          }

        };
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),

          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'key=AAAA_AEicoI:APA91bEBh80mPQuFibRSeFHn9DK3bvmzBaCv262C4fU32Uwt7rMRhUIl0Hd3krky0nIdexQorkgSYtLonVH00w2Jez-q_IJPp6sukf6tjdOeK4USfkuZhwX__Yn0EjuTlHrZE5U00nNd',
          }
        );
      });
    }
}
