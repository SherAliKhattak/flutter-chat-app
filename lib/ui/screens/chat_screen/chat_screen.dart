import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_app/data/controllers/chat_controller.dart';
import 'package:flutter_chat_app/data/controllers/user_info_controller.dart';
import 'package:flutter_chat_app/data/repos/calls_repo.dart';
import 'package:flutter_chat_app/data/repos/chat_repo.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/custom_widgets/message_type_widget.dart';
import 'package:flutter_chat_app/ui/screens/pickup_call_screen/pickup_call_screen.dart';
import 'package:flutter_chat_app/utils/file_extensions.dart';
import 'package:flutter_chat_app/ui/components/enums/message_enum.dart';
import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';
import 'package:flutter_chat_app/ui/custom_widgets/custom_textfield.dart';
import 'package:flutter_chat_app/utils/models/chat_model.dart';
import 'package:flutter_chat_app/utils/models/user_info_model.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final UserInfoModel? targetuser;
  final UserInfoModel? currentUser;
  const ChatScreen({
    super.key,
    this.targetuser,
    this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  FlutterSoundRecorder? flutterSound;
  bool isRecorderInit = false;
  bool isRecording = false;
  void sendMessage() async {
    if (controller.text.isNotEmpty) {
      ChatRepo().sendTextMessage(context, controller.text,
          widget.targetuser!.uid!, widget.currentUser!);
    }
    controller.clear();
  }

  sendFileMessage(
    File? file,
    MessageEnum messageEnum,
  ) {
    ChatRepo().sendImageFile(
        context: context,
        receiverUid: widget.targetuser!.uid!,
        file: file,
        messageEnum: messageEnum,
        sendUserData: widget.currentUser);
  }

  selectFile() async {
    File? file = await UserInfoController.i.pickImage(context);
    log(file!.path);
    if (FileUtils.isrequiredImageExtension(file)) {
      sendFileMessage(file, MessageEnum.image);
    } else if (FileUtils.isrequiredVideoExtension(file)) {
      sendFileMessage(file, MessageEnum.video);
    }
  }

  @override
  void initState() {
    flutterSound = FlutterSoundRecorder();
    openAudio();
    super.initState();
  }

  openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission Not allowed');
    }
    await flutterSound!.openRecorder();
    isRecorderInit = true;
  }

  void sendAudio() async {
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';

    if (!ChatScreenController.i.isRecording) {
      log('start recorder');
      await flutterSound!.startRecorder(toFile: path);
    } else {
      await flutterSound!.stopRecorder();
      sendFileMessage(File(path), MessageEnum.audio);
      log('stop recorder');
    }
    ChatScreenController.i.resetisRecording();
  }

  @override
  void dispose() {
    flutterSound!.dispositionStream();
    flutterSound!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickupCall(
      scaffold: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: CustomColors.kscaffoldColor,
          bottomNavigationBar: GetBuilder<ChatScreenController>(builder: (con) {
            return Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    text: 'Write here...',
                    emailController: controller,
                    isObsecure: false,
                    prefixicon: const Icon(
                      FontAwesomeIcons.faceSmile,
                      color: Colors.grey,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: sendAudio,
                      child: Icon(
                        ChatScreenController.i.isRecording == true
                            ? FontAwesomeIcons.stop
                            : FontAwesomeIcons.microphone,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.04,
                ),
                GestureDetector(
                    onTap: selectFile,
                    child: const Icon(
                      FontAwesomeIcons.paperclip,
                      color: CustomColors.ktextColor2,
                    )),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                InkWell(
                  onTap: () => sendMessage,
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: CustomColors.kprimaryColor,
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.paperPlane,
                        size: 18,
                        color: CustomColors.kwhiteColor,
                      ),
                    ),
                  ),
                )
              ],
            );
          }),
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back,
                color: CustomColors.kblackcolor,
              ),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.phone,
                  size: 20,
                  color: CustomColors.kblackcolor,
                ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 5),
                child: GestureDetector(
                  onTap: () => CallsRepo().callData(
                      context, widget.targetuser!, widget.currentUser!),
                  child: const Icon(
                    FontAwesomeIcons.video,
                    size: 20,
                    color: CustomColors.kblackcolor,
                  ),
                ),
              )
            ],
            automaticallyImplyLeading: true,
            centerTitle: true,
            elevation: 0,
            backgroundColor: CustomColors.kscaffoldColor,
            title: Text(
              widget.targetuser!.username!,
              style: const TextStyle(
                wordSpacing: 0.7,
                fontWeight: FontWeight.w500,
                color: CustomColors.kblackcolor,
                fontSize: 20,
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  StreamBuilder<List<Messages>>(
                      stream: DBservice()
                          .getIndividualChats(widget.targetuser!.uid!),
                      builder: ((context, snapshot) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          if (scrollController.hasClients) {
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          }
                        });
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            return Expanded(
                                child: GroupedListView<Messages, DateTime>(
                              controller: scrollController,
                              elements: snapshot.data!,
                              groupBy: (messages) => DateTime(
                                messages.date!.year,
                                messages.date!.month,
                                messages.date!.day,
                              ),
                              groupHeaderBuilder: (Messages message) =>
                                  SizedBox(
                                height: Get.height * 0.08,
                                width: Get.width * 0.07,
                                child: Center(
                                    child: Text(
                                  ChatScreenUtils.formatTime(
                                    message.date.toString(),
                                  ),
                                  style: const TextStyle(
                                      color: CustomColors.ktextColor),
                                )),
                              ),
                              itemBuilder: (context, Messages? message) {
                                return Column(
                                  crossAxisAlignment:
                                      ChatScreenUtils().isSentbyme(message!)
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: ChatScreenUtils()
                                              .borderSide(message)),
                                      color:
                                          ChatScreenUtils().isSentbyme(message)
                                              ? CustomColors.kprimaryColor
                                              : CustomColors.kwhiteColor,
                                      elevation: 2,
                                      child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: MessageType(
                                            message: message,
                                            type: message.type,
                                          )),
                                    ),
                                    Align(
                                      alignment:
                                          ChatScreenUtils().isSentbyme(message)
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          DateFormat('hh:mm a')
                                              .format(message.date!),
                                          style: const TextStyle(
                                              color: CustomColors.ktextColor,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          } else {
                            return const Center(
                              child: Text('Say hi to your new friend'),
                            );
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                ],
              ),
            ),
          )),
    );
  }
}
