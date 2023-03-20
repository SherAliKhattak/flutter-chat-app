import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/services/local_db.dart';
import 'package:flutter_chat_app/utils/assets/images.dart';
import 'package:flutter_chat_app/utils/consts/consts.dart';
import 'package:flutter_chat_app/ui/custom_widgets/custom_button.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/utils/routes/routes.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';

import '../../custom_widgets/bold_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      body: Container(
        margin: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Get.height * 0.3,
              width: Get.width * 0.9,
              decoration: const BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage(Images.chatAppImage))),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            const SizedBox(
              child: BoldText(
                text: 'Chat With Your Friends',
                textSize: 25,
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                loremIpsum,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.ktextColor,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.05,
            ),
            GetBuilder<AuthController>(builder: (controller) {
              return CustomButton(
                  onTap: () async {
                    AuthController.i.isSignedIn == true
                        ? await Preferences().getDataFromSP().whenComplete(() {
                            Get.offNamed(RouteHelper.getHome());
                          })
                        : Get.offNamed(RouteHelper.getRegistration());
                  },
                  buttonColor: CustomColors.kprimaryColor,
                  text: 'Get Started');
            }),
            SizedBox(
              height: Get.height * 0.03,
            ),
            const SizedBox(
              child: Text(
                'Skip for now',
                style: TextStyle(
                    color: CustomColors.ktextColor2,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
