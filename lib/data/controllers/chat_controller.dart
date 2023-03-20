import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController implements GetxService {
  bool isPlaying = false;
  bool isRecording = false;
  AudioPlayer player = AudioPlayer();

  resetisRecording() {
    isRecording = !isRecording;
    update();
  }

  resetisPlaying(bool value) {
    isPlaying = !isPlaying;
    update();
  }

  static ChatScreenController get i => Get.put(ChatScreenController());
}
