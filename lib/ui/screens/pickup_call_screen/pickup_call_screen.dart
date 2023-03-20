import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/data/repos/calls_repo.dart';
import 'package:flutter_chat_app/data/services/db_service.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:flutter_chat_app/utils/models/call_model.dart';
import 'package:get/get.dart';
import '../call_screen/call_screen.dart';

class PickupCall extends StatefulWidget {
  final Widget scaffold;
  const PickupCall({super.key, required this.scaffold});

  @override
  State<PickupCall> createState() => _PickupCallState();
}

class _PickupCallState extends State<PickupCall> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DBservice().callStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            CallModel call = CallModel.fromMap(map: snapshot.data!.data()!);

            if (!call.hasDialled!) {
              return Scaffold(
                backgroundColor: CustomColors.kblackcolor,
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Incoming Call',
                        style: TextStyle(
                            fontSize: 30, color: CustomColors.kwhiteColor),
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic!),
                        radius: 60,
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      Text(
                        call.callerName.toString(),
                        style: const TextStyle(
                            fontSize: 30, color: CustomColors.kwhiteColor),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              CallsRepo().endCall(
                                  call.callerId!, context, call.receiverId!);
                            },
                            icon: const Icon(
                              Icons.call_end_rounded,
                              size: 40,
                            ),
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: Get.width * 0.04,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.call_sharp,
                              size: 40,
                            ),
                            color: Colors.green,
                            onPressed: () {
                              Get.to(() => CallScreen(
                                    call: call,
                                    channelId: call.callId!,
                                  ));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return widget.scaffold;
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return widget.scaffold;
          } else {
            return widget.scaffold;
          }
        });
  }
}
