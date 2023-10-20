
import 'dart:async';

import 'package:club/controllers/auth_controller.dart';
import 'package:club/controllers/user_controller.dart';
import 'package:club/model/userModel.dart';
import 'package:club/view/authorization/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}



class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpCode = TextEditingController();
  AuthController controller = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  var code = "";
  
  int start = 60;

  /*void startTimer(){
    const oneSec =  Duration(seconds: 1);
    timer = Timer.periodic(oneSec,
    (Timer timer) { 
      if(start == 0){
        setState(() {
          timer.cancel();
        });
      }else{
        setState(() {
          start--;
        });
      }
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), _tryPasteCurrentPhone);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //timer.cancel();
    super.dispose();
  }

  Future _tryPasteCurrentPhone() async {
    if (!mounted) return;
    try {
      final autoFill = SmsAutoFill();
      final phone = await autoFill.hint;
      if (phone == null) return;
      if (!mounted) return;
      setState(() {
        phoneController.text = phone.toString().substring(3, phone.length);
      });
    }catch (e) {
      print('Failed to get mobile number because of: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    AuthController authController = Get.put(AuthController());

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle:const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color:const Color.fromRGBO(226, 226, 226, 1),
        border: Border.all(color:const Color.fromRGBO(206, 206, 206, 1)),
        borderRadius: BorderRadius.circular(14),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color:const Color.fromRGBO(35, 38, 41, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(222, 222, 222, 1),
      ),
    );

    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 251, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: sw,
                  height: sh * 0.4,
                  decoration:const BoxDecoration(
                    image: DecorationImage( 
                      image: AssetImage("assets/background/loginBg1.png"),
                      fit: BoxFit.cover,
                    )
                  )
                ),
                Container(
                  width: sw,
                  height: sh * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                       const Color.fromARGB(255, 0, 0, 0).withOpacity(0.0),
                       const Color.fromARGB(191, 26, 26, 26),
                      ],stops: const [
                        0.0,
                        1.0
                        ]
                      )
                    ),
                  ),
                  const Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text("Hi there!",style: TextStyle(fontSize: 40,fontFamily: 'metro',fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Login or Sign in with..",style: TextStyle(fontFamily: 'metro',fontSize: 25,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 45,
                      width: sw,
                      decoration:const BoxDecoration(
                        color: Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 7,),
                          const Text("+91",style: TextStyle(fontSize: 16,fontFamily: 'metro'),),
                          const SizedBox(width: 7,),
                          const VerticalDivider(width: 1,color: Color.fromARGB(255, 203, 203, 203),),
                          const SizedBox(width: 10,),
                          SizedBox(
                            height: sh * 0.1,
                            width: sw * 0.7,
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                textAlignVertical: TextAlignVertical.bottom,
                                controller: phoneController,
                                style:const TextStyle(fontFamily: 'metro'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone number",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 50,
                        width: sw * 0.89,
                        decoration:BoxDecoration(
                          border: Border.all(color:const Color.fromARGB(255, 59, 59, 59),width: 2),
                          color:const Color.fromARGB(255, 33, 33, 33),
                          borderRadius:const BorderRadius.all(Radius.circular(10))
                        ),
                        child:const Center(
                          child: Text("Login",style: TextStyle(fontSize: 20,color: Colors.white),),
                        ),
                      ),
                    ),
                    onTap: ()async{
                      //userController.userModel.value.name = "Hemanth Srinivas";
                      userController.userModel.value.phone = phoneController.text;
                      showDialog(
                        barrierDismissible: false,
                        context: context, 
                        builder: (_){
                          return  Dialog(
                            backgroundColor: Colors.white,
                            child: Container(
                              width: sw * 0.4,
                              height: sh * 0.2,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10,),
                                  Text("Please wait while we are verifying"),
                                ],
                              ),
                            ),
                          );
                        }
                      ); 

                      await controller.phoneVerification('+91${userController.userModel.value.phone.toString()}');

                      await Future.delayed(const Duration(seconds: 12));
                      //startTimer();

                      Navigator.of(context).pop();
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen()));
                      // ignore: use_build_context_synchronously 
                      showModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context){
                          return StatefulBuilder(
                            builder: (context, setState){
                              return Container(
                              width: sw,
                              height: sh,
                              decoration:const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                              ),
                              child: Padding(
                                padding:const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 30,
                                        height: 6,
                                        decoration:const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                      )
                                    ),
                                    const SizedBox(height: 10,),
                                    const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Enter OTP ",style: TextStyle(fontFamily: 'sen',fontSize: 30,fontWeight: FontWeight.bold),)
                                    ),
                                    const SizedBox(height: 0,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 0),
                                      child:Pinput(
                                        defaultPinTheme: defaultPinTheme,
                                        focusedPinTheme: focusedPinTheme,
                                        submittedPinTheme: submittedPinTheme,
                                        length: 6,
                                        showCursor: true,
                                        controller:otpCode,
                                        onChanged: (pin){
                                          code = pin!;
                                        },
                                      onCompleted: (pin) => {
                                        code = pin,
                                      },
                                      onSubmitted: (pin) =>{
                                        code = pin,
                                      },
                                    )),
                                    const SizedBox(height: 20,),
                                    const Center(child: Text("Didn't reci eve OTP code ?",style: TextStyle(fontFamily: 'sen',fontSize: 15,color: Colors.grey),)),
                                    const SizedBox(height: 8,),
                                    Center(child: Text("Resending Code  $start",style:const TextStyle(fontFamily:'sen',fontSize: 16,color: Colors.black),),),
                                    SizedBox(height: sh * 0.17,),
                                    GestureDetector(
                                      child: Padding(
                                        padding:const EdgeInsets.all(15),
                                        child: Container(
                                          width: sw * 0.95,
                                          height: sh * 0.07,
                                          decoration:const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            color: Colors.black,
                                          ),
                                          child:const Center(
                                            child: Text("Verify",style: TextStyle(fontFamily:'sen',fontSize: 20,color: const Color.fromARGB(255, 255, 255, 255)),),
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        try{
                                          authController.otpController(code);
                                        }catch(e){
                                          Get.snackbar('Error', 'Enter a valid OTP !');
                                        }
                                        
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                            }
                          );

                        }
                        );

                    },
                  ),
                  const SizedBox(height: 10,),
                  HorizontalOrLine(label: "or", height: 10,sw: sw,),

                  SizedBox(height:sh * 0.05),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: sw * 0.23,),
                      InkWell(
                        child: Container(
                          padding:const EdgeInsets.all(10),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Image.asset('assets/icons/google.png',)       
                        ),
                        onTap: ()=>{
                          controller.signInWithGoogle(),
                          },
                      ),
                      SizedBox(width: 40.w,),
                        Container(
                          padding:const EdgeInsets.all(10),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:const BorderRadius.all(Radius.circular(10)),
        
                          ),
                          child: Image.asset('assets/icons/apple.png',)       
                        ),
                      ],
                  ),
                  SizedBox(height: 95.h,),
                  Container(
                    margin: EdgeInsets.only(left: 80.w),
                    child:const Column(
                      children: [
                        Text("By Continuing you agree ",style: TextStyle(fontSize: 12,color: Colors.grey),),
                        SizedBox(height: 2,),
                        Text("Terms of Service   Privacy Policy ",style: TextStyle(fontSize: 12,color: Colors.grey))
                      ],
                    ) ,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}


class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    required this.label,
    required this.height,
    required this.sw,
  });

  final String label;
  final double height;
  final double sw;

  @override
  Widget build(BuildContext context) {

    return Row(children: <Widget>[
       Container(
        width: 100,
            margin: EdgeInsets.only(left: 50.w, right: 15.0),
            child: Divider(
              color: Colors.grey.shade500,
              height: height,
            )
          ),

      Text(label,style:const TextStyle(color: Color.fromARGB(255, 131, 131, 131),fontWeight: FontWeight.bold),),

    
        Container(
          width: 100,
            margin:const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.grey.shade500,
              height: height,
            )
        )
    ]);
  }
}