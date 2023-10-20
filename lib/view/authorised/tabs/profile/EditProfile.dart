import 'dart:io';
import 'package:club/controllers/user_controller.dart';
import 'package:club/view/authorised/tabs/profile/ProfilePage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final name = TextEditingController();
final email = TextEditingController();
final mobileNo = TextEditingController();
final birthDate = TextEditingController();
final gender = TextEditingController();

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  UserController userController = Get.put(UserController());
  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file?.path != null) {
      setState(() {
        userController.userModel.value.profile = file!.path;
      });
    }
  }

  @override
  String? numberValidator(String? value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String? gender;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          iconTheme:const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Complete Your Profile",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 18),
                )),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            await userController.uploadProfileImage(userController.userModel.value.profile);
            await userController.registerUser(
                name.text,
                gender.toString(),
                birthDate.text,
                mobileNo.text,
                email.text,
                userController.userModel.value.profile
            );

            await userController.getUserDetails();
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(15)),
            child: const Text(
              "Update Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.maxFinite,
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (userController.userModel.value.profile ==
                                  null)
                                Container(
                                  height: height * 0.2,
                                  width: width * 0.35,
                                  decoration:const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 206, 206, 206),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.add_a_photo_rounded)),
                                )
                              else
                                Container(
                                  height: height * 0.2,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(File(userController
                                            .userModel.value.profile!)),
                                        fit: BoxFit.cover),
                                    color: const Color.fromARGB(
                                        255, 206, 206, 206),
                                  ),
                                ),
                              Positioned(
                                  bottom: 15,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      getImage(source: ImageSource.gallery);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2, color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.black),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                        size: 10,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Basic Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    CustomInput(
                        title: "Full name", hint: "Ex John", controller: name,type: TextInputType.name),
                    CustomInput(
                        title: "Email",
                        hint: "Ex John@gmail.com",
                        controller: email,
                        type: TextInputType.emailAddress
                        ),
                    CustomInput(
                        title: "Mobile Number",
                        hint: "Ex 9184xxxxxxxx",
                        controller: mobileNo,
                        type: TextInputType.phone,
                        ),
                    CustomInput(
                        title: "Date of birth",
                        hint: "7 July 2002",
                        controller: birthDate,
                        widget: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color:const Color.fromARGB(255, 189, 189, 189),width: 1)),
                          child: InkWell(
                            onTap: () async {
                              final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900, 8),
                                  lastDate: DateTime(2100));
                              setState(() {
                                birthDate.text =
                                    '${dateTime!.day}/${dateTime.month}/${dateTime.year}';
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  birthDate.text == ""
                                      ? "DD/MM/YYYY"
                                      : birthDate.text,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const Icon(Icons.arrow_drop_down_rounded)
                              ],
                            ),
                          ),
                        )),
                    CustomInput(
                      title: "Gender",
                      hint: "Ex male / female",
                      controller: gender,
                      widget: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 203, 203, 203),
                                    width: 1),
                              ),
                              title: const Text("Male"),
                              value: "male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RadioListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 203, 203, 203),
                                        width: 1)
                                      ),
                                title: const Text("Female"),
                                value: "female",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
          ),
        ));
  }

  CustomInput(
      {required String title,
      required String hint,
      required controller,
      type,
      Widget? widget}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          widget ??
              TextField(
                controller: controller,
                keyboardType: type ,
                onChanged: (value) => controller = value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black)),
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
