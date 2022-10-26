import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget/src/models/json_google_map_model.dart';

class Containts {
  /// title for Marker google map [TextPainter]

  static Future<Uint8List> getBytesFromCanvas(String? title,
      {double? size}) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.blue;
    final radius = Radius.circular(size! / 2);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.toDouble(), size.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    var painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: title,
      style: TextStyle(fontSize: 65.0, color: Colors.white),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((size * 0.5) - painter.width * 0.5,
            (size * 0.5) - painter.height * 0.5));

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  /// Image icons marker [getMarkerIcon]
  static Future<Uint8List> getMarkerIcon(
    IconMarker imageUrl, {
    double? size,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10,
  }) async {
    Uint8List? imageUint8List;
    ByteData? imageFile;

    //image from asset
    if (imageUrl.assetIcon!.isNotEmpty && imageUrl.assetIcon != 'null') {
      imageFile = await rootBundle.load(imageUrl.assetIcon!);
      imageUint8List = await imageFile.buffer.asUint8List();
    }
    if (imageUrl.netIcon!.isNotEmpty && imageUrl.netIcon != 'null') {
      /// if  path.netIcon [!Empty] it geted image asset
      imageUint8List = await loadNetworkImage(imageUrl.netIcon);
    }

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color;

    final radius = size! / 2;

    //make canvas clip path to prevent image drawing over the circle
    final clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));

    canvas.clipPath(clipPath);
    //paintImage

    final codec = await ui.instantiateImageCodec(imageUint8List!);
    final imageFI = await codec.getNextFrame();
    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint..color = borderColor;
      paint..style = PaintingStyle.stroke;
      paint..strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return data!.buffer.asUint8List();
  }

  /// skip marker  widget to
  // Future<Uint8List> getWidgetToIcon(GlobalKey globalKey) async {
  //   MyMarker(globalKey);
  //   var boundary =
  //       globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   var image = await boundary.toImage(pixelRatio: 2.0);
  //   var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   return byteData!.buffer.asUint8List();
  // }
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

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 3, 0.0);
    path.lineTo(size.width / 2, size.height / 3);
    path.lineTo(size.width - size.width / 3, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
