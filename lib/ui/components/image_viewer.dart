import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ui/components/themes/themes.dart';
import 'package:get/get.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;
  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kblackcolor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.kblackcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (() => Get.back()),
        ),
      ),
      body: Center(
        child: CachedNetworkImage(imageUrl: imageUrl),
      ),
    );
  }
}
