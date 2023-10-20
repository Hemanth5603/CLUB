import 'package:club/controllers/auth_controller.dart';
import 'package:club/view/authorised/tabs/profile/EditProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../controllers/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());

  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    initializeProfileScreen();
    
    
  }

  Future<void> initializeProfileScreen() async{
    setState(() {
      isLoading = true;
    });
    userController.checkRegistered();
    userController.getUserDetails();
    setState(() {
      isLoading = false;
    });
    print("called init profile");

  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 239, 246, 248),
      body: Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SafeArea(
              child: Column(
            children: [
              PhysicalModel(
                color: Colors.white,
                elevation: 10,
                shadowColor: Color.fromARGB(121, 162, 162, 162),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userController.userModel.value.name.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20,fontFamily: 'metro'),
                              ),
                              Text(
                                  userController.userModel.value.email.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w400,fontFamily: 'metro')),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () => Get.to(const EditProfile()),
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Stack(children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userController
                                    .userModel.value.profile.toString()),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    border:
                                        Border.all(width: 3, color: Colors.black)),
                              )
                            ]),
                            onLongPress: (){
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromARGB(255, 239, 246, 248),
                                builder: (context) => 
                                  Container(
                                    width: w,
                                    height: h * 0.5,

                                    child: Padding(
                                      padding:const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          const Center(
                                            child: Text("Your Digital CLUB ID",style: TextStyle(fontFamily:'metro',fontSize: 25,fontWeight: FontWeight.bold),),
                                          ),
                                          SizedBox(height: 20,),
                                          Container(
                                            decoration:const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                            ),
                                            child: QrImageView(
                                              backgroundColor: Color.fromARGB(255, 247, 247, 247),
                                              data : userController.qrCodeData(),
                                              gapless: false,
                                              //embeddedImage:const AssetImage('assets/icons/club.png'),
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Center(
                                            child: Text("Please verify yourself before entry",style: TextStyle(fontFamily: 'metro',fontSize: 15,color: Colors.grey),),
                                          )
                                        ],
                                      ),
                                    ),

                                  ),
                              );
                            },
                          ),
                          
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite_border_rounded),
                                  Text("Like",style: TextStyle(fontSize: 12,fontFamily: 'metro'),)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.card_membership_rounded),
                                  Text("Membership",style: TextStyle(fontSize: 12,fontFamily: 'metro'))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.payment_rounded),
                                  Text("Payments",style: TextStyle(fontSize: 12,fontFamily: 'metro'))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 80,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.history), Text("History",style: TextStyle(fontSize: 12,fontFamily: 'metro'))],
                              ),
                            ),
                          ),
                        ],
                      ),
      
                      //settings
                      additionalInformation(),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Container additionalInformation() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.maxFinite,
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
                border:
                    Border(left: BorderSide(width: 3, color: Colors.black))),
            child: const Text(
              "Addtional Info",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,fontFamily: 'metro'),
            ),
          ),
          const SizedBox(height: 10),
          OptionTile(
              onTap: () {},
              title: "Privacy Policy",
              widget: const Icon(Icons.privacy_tip_rounded)),
          const SizedBox(height: 10),
          OptionTile(
              onTap: () {},
              title: "Term of Usage",
              widget: const Icon(Icons.data_usage_rounded)),
          const SizedBox(height: 10),
          OptionTile(
              onTap: () {},
              title: "About App",
              widget: const Icon(Icons.bubble_chart_outlined)),
          const SizedBox(height: 10),
          OptionTile(
            onTap: () {
              setState(() {
                authController.logOut();
              });
            },
            title: "Login Out",
            widget: const Icon(Icons.android_rounded),
            isLast: true,
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}


class OptionTile extends StatelessWidget {
  const OptionTile(
      {super.key,
      required this.onTap,
      required this.title,
      required this.widget,
      this.isLast});
  final Function onTap;
  final Widget widget;
  final String title;
  final bool? isLast;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            border: isLast == null
                ? const Border(
                    bottom: BorderSide(
                        width: 1, color: Color.fromARGB(255, 208, 206, 206)))
                : null),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              widget,
              const SizedBox(width: 20),
              Text(title),
            ]),
            const Icon(Icons.keyboard_arrow_right_rounded)
          ],
        ),
      ),
    );
  }
}


