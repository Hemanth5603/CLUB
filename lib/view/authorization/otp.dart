import 'package:club/controllers/auth_controller.dart';
// import 'package:club/view/authorised/tabs/home/Home.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  AuthController authController = Get.put(AuthController());
  var code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin:const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const SizedBox(
                height: 25,
              ),
            const  Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            const  SizedBox(
                height: 10,
              ),
             const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
             const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value){
                },
                showCursor: true,
                onCompleted: (pin) => {
                  code = pin,
                },
                onSubmitted: (pin) =>{
                  code = pin,
                },
              ),
              
            const  SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async{
                     authController.otpController(code);
                    },
                    child:const Text("Verify Phone Number")),
              ),

            ],
          ),
        ),
      ),
    );
  }
}