import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/custom_widgets/bold_text.dart';
import 'package:flutter_chat_app/data/controllers/auth_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/utils/models/chat_contact.dart';
import 'package:flutter_chat_app/utils/models/user_info_model.dart';
import 'package:flutter_chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../custom_widgets/circle_with_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kscaffoldColor,
      body: GetBuilder<AuthController>(builder: (contoller) {
        return contoller.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: const BoldText(
                              text: 'Messages',
                              textSize: 20,
                            ),
                          ),
                          const CircleWithIcon(
                            icon: Icons.more_horiz,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      TextField(
                        controller: searchController,
                        style:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        onChanged: ((value) {
                          setState(() {});
                        }),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: CustomColors.ksearchBackground,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: CustomColors.ktextColor2),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 15,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          hintText: 'Search Contacts',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).hintColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).cardColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      GetBuilder<UserInfoController>(builder: (controller) {
                        return Flexible(
                          child: StreamBuilder<List<ChatContact>>(
                              stream: DBservice().getAllChats(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<ChatContact> filter = snapshot.data!;
                                  if (searchController.text != '') {
                                    filter = filter.where((element) {
                                      if (element.name
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchController.text
                                              .toLowerCase())) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    }).toList();
                                  }

                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filter.length,
                                      itemBuilder: ((context, index) {
                                        final data = filter[index];
                                        return UsersListview(
                                          username: data.name,
                                          image: data.profilePic,
                                          uid: data.contactId,
                                          time: data.timeSent.toString(),
                                          lastMessage: data.lastMessage,
                                        );
                                      }));
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        );
                      })
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

class UsersListview extends StatelessWidget {
  final String? uid;
  final String? username;
  final String? image;
  final String? time;
  final String? lastMessage;

  const UsersListview({
    Key? key,
    this.username = 'Hello world',
    this.image,
    this.time,
    this.uid,
    this.lastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () async {
          Get.to(() => ChatScreen(
                targetuser: UserInfoModel(
                    uid: uid, username: username, profilePic: image),
                currentUser: UserInfoModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    username: AuthController.i.userInfoModel.username,
                    profilePic: AuthController.i.userInfoModel.profilePic),
              ));
        },
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20, top: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tileColor: CustomColors.kwhiteColor,
          leading: CircleAvatar(
            backgroundColor: CustomColors.ktextColor2,
            radius: 20,
            backgroundImage: NetworkImage(image!),
          ),
          title: BoldText(
            text: username!,
            textSize: 16,
            textAlign: TextAlign.start,
          ),
          subtitle: Text(lastMessage!),
          trailing: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                    child: Text(
                  ChatScreenUtils.formatTime(time!),
                  style: const TextStyle(color: CustomColors.ktextColor),
                )),
                // const Expanded(
                //     child: Icon(
                //   Icons.done_all,
                //   color: Colors.green,
                // )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
