import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/model/userModel.dart';
import 'package:club/view/authorization/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../view/authorised/tabs/home/Home.dart';
import '../view/authorization/login.dart';

// ignore: camel_case_types
class AuthController extends GetxController {
  UserController userController = Get.put(UserController());
  

  final auth = FirebaseAuth.instance;
  var verificationID = ''.obs;
  var resendToken;

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth currentUser = FirebaseAuth.instance;
    final User? user = currentUser.currentUser;
    final uid = user?.uid;
    userController.userModel.value.uid = uid;
    await prefs.setString('uid', uid.toString());
    print("Current user: $uid");
  }

  Future<void> phoneVerification(String phoneNo) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number'){
            Get.snackbar('Error', 'The Given Phone Number is Invalid');
          } else {
            Get.snackbar('Error', 'Something went Wrong, Try Again');
          }
        },
        codeSent: (verificationID, resendToken) {
          this.verificationID.value = verificationID;
          resendToken = resendToken;
        },
        timeout: const Duration(seconds: 55),
        forceResendingToken: resendToken,
        codeAutoRetrievalTimeout: (verificationID) {
          this.verificationID.value = verificationID;
        });
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await auth.signInWithCredential(
      PhoneAuthProvider.credential(verificationId: verificationID.value,
      smsCode: otp)
    );
    return credentials.user != null ? true : false;
  }

  void otpController(String otp) async {
    var isVerified = await verifyOtp(otp);
    await getUserId();
    if(await checkUserDocExists() == false){
      await registerUser(userController.userModel.value.uid); 
    }
    isVerified ? Get.offAll(const Home(),transition: Transition.downToUp,duration:const Duration(milliseconds: 400)) : Get.back();
  }




  void signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential response =
      await FirebaseAuth.instance.signInWithCredential(credential);
      try {
        await getUserId();
        //userController.userModel.value.name = response.additionalUserInfo?.username.toString();
        //userController.userModel.value.profile =response.additionalUserInfo?.profile.toString();

        if(await checkUserDocExists() == false){
          await registerUser(userController.userModel.value.uid); 
        }
      }catch (e) {
        print("Cannot get user information");
        print(e);
      }
      
    if(response.credential!= null){
      Get.offAll(const Home(),duration:const Duration(milliseconds: 400),transition: Transition.downToUp);
    }else{
      Get.snackbar('Error', 'Google sign in error');
    }
  }

  Future<bool> checkUserDocExists() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final ref = await FirebaseFirestore.instance
        .collection('users')
        .doc(prefs.getString('uid').toString())
        .get();
    if(!ref.exists){
      return false;
    }
    return true;

  }

  Future<void> registerUser(uid) async{
    final ref = FirebaseFirestore.instance
      .collection('users')
      .doc(userController.userModel.value.uid);
    
    try{
      await ref.set({
        "uid":uid,
        "Name":'null',
      });
      print("BASE USER REGISTERED ");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logOut() async {
    await auth.signOut();
    Get.offAll(OnBoarding());
  }
}
