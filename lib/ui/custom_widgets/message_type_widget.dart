import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/image_viewer.dart';
import 'package:flutter_chat_app/ui/custom_widgets/video_player_item.dart';
import 'package:flutter_chat_app/utils/chat_screen_utils/chat_screen_utils.dart';
import 'package:flutter_chat_app/utils/models/chat_model.dart';
import 'package:flutter_chat_app/ui/components/enums/message_enum.dart';
import 'package:get/get.dart';
import '../components/themes/themes.dart';

class MessageType extends StatelessWidget {
  final Messages? message;
  final MessageEnum? type;
  const MessageType({super.key, this.message, this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    if (type == MessageEnum.image) {
      log('this is executed');
      return GestureDetector(
        onTap: () => Get.to(() => ImageViewer(imageUrl: message!.message!)),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: message!.message!,
              width: Get.width * 0.5,
              fit: BoxFit.fill,
              key: UniqueKey(),
            ),
          ],
        ),
      );
    } else if (message!.type == MessageEnum.text) {
      return Text(
        message!.message!,
        style: TextStyle(
            color: ChatScreenUtils().isSentbyme(message!)
                ? CustomColors.kwhiteColor
                : CustomColors.kblackcolor),
      );
    } else if (message!.type == MessageEnum.video) {
      log('i am over here');
      return VideoPlayerWidget(
        videoUrl: message!.message!,
      );
    } else {
      return StatefulBuilder(
        builder: (context, setState) {
          return IconButton(
            constraints: const BoxConstraints(maxWidth: 100),
            icon: isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow),
            onPressed: (() async {
              if (isPlaying == false) {
                await audioPlayer.play(UrlSource(message!.message!));
                setState(
                  () {
                    isPlaying = true;
                    log(isPlaying.toString());
                  },
                );
              } else {
                audioPlayer.pause();
                setState(
                  () {
                    isPlaying = false;
                    log(isPlaying.toString());
                  },
                );
              }
            }),
          );
        },
      );
    }
  }
}
