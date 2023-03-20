import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/components/alert_dialog.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_chat_app/utils/assets/images.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kscaffoldColor,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back,
          color: CustomColors.kblackcolor,
        ),
        centerTitle: true,
        title: Title(
          color: CustomColors.kblackcolor,
          child: const Text(
            'Profile',
            style: TextStyle(
                color: CustomColors.kblackcolor,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: (() {
                DBservice().userSignOut();
              }),
              child: const Icon(
                Icons.logout,
                color: CustomColors.kblackcolor,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Center(
          child: GetBuilder<UserInfoController>(builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  AuthController.i.userInfoModel.profilePic == null
                      ? CircleAvatar(
                          radius: 80,
                          backgroundImage: const AssetImage(Images.avatar),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  UserInfoController.i
                                      .updateProfilePic(context);
                                },
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: CustomColors.kblackcolor,
                                ),
                              ),
                            ),
                          ),
                        )
                      : UserInfoController.i.isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  AuthController.i.userInfoModel.profilePic!),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    UserInfoController.i
                                        .updateProfilePic(context);
                                  },
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: CustomColors.kblackcolor,
                                  ),
                                ),
                              ),
                            ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  UserInfoRow(
                    infotype: 'username',
                    value: AuthController.i.userInfoModel.username,
                    controller: UserInfoController.i.username,
                  ),
                  const Divider(
                    height: 1,
                    color: CustomColors.ktextColor2,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  UserInfoRow(
                    infotype: 'About',
                    value: AuthController.i.userInfoModel.about,
                    controller: UserInfoController.i.about,
                  ),
                  const Divider(
                    height: 1,
                    color: CustomColors.ktextColor2,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  UserInfoRow(
                    infotype: 'Phone',
                    value: FirebaseAuth.instance.currentUser!.phoneNumber,
                    controller: UserInfoController.i.phoneNumber,
                  ),
                  const Divider(
                    height: 1,
                    color: CustomColors.ktextColor2,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String? infotype;
  final String? value;
  final TextEditingController? controller;
  const UserInfoRow({
    Key? key,
    this.infotype,
    this.value,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16),
        child: Text(
          infotype!,
          style: const TextStyle(
              color: CustomColors.kblackcolor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      )),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 16, right: 30),
          child: Text(
            value!,
            overflow: TextOverflow.clip,
            style:
                const TextStyle(color: CustomColors.ktextColor, fontSize: 15),
          ),
        ),
      ),
      GestureDetector(
          onTap: (() {
            AlertDialogue.rename(context, infotype, value!, controller!);
          }),
          child: const Icon(Icons.edit))
    ]);
  }
}
