import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class Containts {
  static Future<Uint8List?> getBytesFromAsset(
      {required String path, required int width}) async {
    if (path.isNotEmpty || path != 'null') {
      var data = await rootBundle.load(path);
      var code = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      var fi = await code.getNextFrame();

      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    }
    return null;
  }
}
