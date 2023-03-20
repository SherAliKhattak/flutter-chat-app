import 'dart:io';

class FileUtils {
  static bool isrequiredImageExtension(File image) =>
      image.path.endsWith('.jpg') ||
      image.path.endsWith('.png') ||
      image.path.endsWith('.jpeg');

  static bool isrequiredVideoExtension(File video) =>
      video.path.endsWith('.mp4');
}
