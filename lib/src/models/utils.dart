import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/src/models/json_google_map_model.dart';

class Containts {
  /// Image IconMarker has are two from network image and asset
  static Future<Uint8List?> getBytesFromImageIcon(
      {required int width,
      required int height,
      required IconMarker path}) async {
    dynamic data;
    if (path.assetIcon!.isNotEmpty && path.assetIcon != 'null') {
      data = await rootBundle.load('assets/images/${path.assetIcon}');
    } else if (path.netIcon!.isNotEmpty && path.netIcon != 'null') {
      /// if  path.netIcon [!Empty] it geted image asset
      data = await loadNetworkImage('${path.netIcon}');
    }

    var code = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    var nextFrame = await code.getNextFrame();

    return (await nextFrame.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /// title for Marker google map [TextPainter]

  static Future<Uint8List> getBytesFromCanvas(String? title,
      {int? width, int? height}) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.blue;
    final radius = Radius.circular(20.0);
    
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width!.toDouble(), height!.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);
    var painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: title.toString(),
      style: TextStyle(fontSize: 30.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}

Future<Uint8List> loadNetworkImage(path) async {
  final completed = Completer<ImageInfo>();
  var image = NetworkImage(path);
  image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((info, _) => completed.complete(info)));
  final imageInfo = await completed.future;
  final byteData =
      await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
