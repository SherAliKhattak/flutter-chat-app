import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/custom_widgets/custom_button.dart';
import 'package:flutter_chat_app/ui/custom_widgets/user_info_text_field.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_chat_app/utils/assets/images.dart';
import 'package:get/get.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  child: Text(
                    'User Info',
                    style: TextStyle(
                        color: CustomColors.kprimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                GetBuilder<UserInfoController>(builder: (controller) {
                  return CircleAvatar(
                      radius: 80,
                      child: UserInfoController.i.file == null
                          ? const ImageContainer(
                              imageProvider: AssetImage(Images.avatar),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: ImageContainer(
                                imageProvider: FileImage(
                                    UserInfoController.i.file!,
                                    scale: 2.5),
                              ),
                            ));
                }),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                UserInfoTextField(
                    text: 'Enter username',
                    emailController: UserInfoController.i.username,
                    isObsecure: false,
                    icon: const Icon(Icons.person)),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                UserInfoTextField(
                    text: 'Enter About',
                    emailController: UserInfoController.i.about,
                    isObsecure: false,
                    icon: const Icon(Icons.person)),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                CustomButton(
                    onTap: () async {
                      await DBservice()
                          .storeData(UserInfoController.i.file, context);
                    },
                    buttonColor: CustomColors.kprimaryColor,
                    text: 'Continue')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final ImageProvider? imageProvider;
  const ImageContainer({
    Key? key,
    this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider!, fit: BoxFit.fill)),
      child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: GestureDetector(
                onTap: (() => UserInfoController.i.pickImage(
                      context,
                    )),
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: UserInfoController.i.file == null
                      ? CustomColors.kblackcolor
                      : CustomColors.kwhiteColor,
                ),
              ))),
    );
  }
}
