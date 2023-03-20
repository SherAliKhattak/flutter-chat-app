// ignore_for_file: use_build_context_synchronously, library_prefixes
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/repos/calls_repo.dart';
import 'package:flutter_chat_app/utils/agora_config/agora_config.dart';
import 'package:flutter_chat_app/utils/models/call_model.dart';
import 'package:get/get.dart';

import '../../components/themes/themes.dart';

class CallScreen extends StatefulWidget {
  final String? channelId;
  final CallModel? call;

  // ignore: use_key_in_widget_constructors
  const CallScreen({Key? key, required this.channelId, required this.call});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: 'helloworld',
        tempToken: AgoraConfig.token),
  );
  @override
  void initState() {
    super.initState();
    client.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CustomColors.kblackcolor,
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(
                client: client,
                disconnectButtonChild: GestureDetector(
                  onTap: () {
                    CallsRepo().endCall(widget.call!.callerId!, context,
                        widget.call!.receiverId!);
                    Get.back();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.call_end,
                      color: CustomColors.kwhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
