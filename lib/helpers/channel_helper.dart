import 'package:flutter/services.dart';

class Channel {
  MethodChannel _channel = const MethodChannel('com.custom.imagepicker');

  getImageFromCamera() async {
    var data = await _channel.invokeMethod('camera');

    if (data != null && data != 'denied') {
      if (data.toString().endsWith('.png') ||
          data.toString().endsWith('.jpg') ||
          data.toString().endsWith('.jpeg')) {
        return data;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  getImageFromGallery() async {
    return await _channel.invokeMethod('gallery');
  }
}
