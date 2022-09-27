import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

class JsonPlaceHolderImageBuilder extends JsonWidgetBuilder {
  JsonPlaceHolderImageBuilder({
    required this.image,
    required this.placeholder,
    this.errorImage,
    this.boxFit,
    this.excludeFromSemantics,
    this.fadeInCurve,
    this.fadeInDuration,
    this.fadeOutCurve,
    this.fadeOutDuration,
    this.height,
    this.imageCacheHeight,
    this.imageCacheWidth,
    this.imageScale,
    this.imageSemanticLabel,
    this.placeholderCacheHeight,
    this.placeholderCacheWidth,
    this.placeholderScale,
    this.width,
  }) : super(numSupportedChildren: kNumSupportedChildren);
  final String? image;
  final String? placeholder;
  final String? errorImage;
  final BoxFit? boxFit;
  final double? imageScale;
  final bool? excludeFromSemantics;
  final double? placeholderScale;
  final int? placeholderCacheWidth;
  final int? placeholderCacheHeight;
  final int? imageCacheWidth;
  final int? imageCacheHeight;
  final double? width;
  final double? height;
  final Duration? fadeOutDuration, fadeInDuration;
  final Curve? fadeInCurve, fadeOutCurve;
  final String? imageSemanticLabel;

  static JsonPlaceHolderImageBuilder? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonPlaceHolderImageBuilder? placeHolderBuilder;
    if (map != null) {
      placeHolderBuilder = JsonPlaceHolderImageBuilder(
        image: map['image'].toString(),
        placeholder: map['placeholder'].toString(),
        boxFit: ThemeDecoder.decodeBoxFit(map['boxFit']),
        errorImage: map['errorImage'].toString(),
        imageCacheHeight: JsonClass.parseInt(map['imageCacheHeight']),
        imageCacheWidth: JsonClass.parseInt(map['imageCacheWidth']),
        imageScale: JsonClass.parseDouble(map['imageScale']),
        imageSemanticLabel: map['imageSemanticLabel'].toString(),
        excludeFromSemantics: JsonClass.parseBool(map['excludeFromSemantics']),
        width: JsonClass.parseDouble(map['width']),
        height: JsonClass.parseDouble(map['height']),
        placeholderCacheHeight:
            JsonClass.parseInt(map['placeholderCacheHeight']),
        placeholderCacheWidth: JsonClass.parseInt(map['placeholderCacheWidth']),
        placeholderScale: JsonClass.parseDouble(map['placeholderScale']),
        fadeInCurve: map['fadeInCurve'],
        fadeOutCurve: map['fadeOutCurve'],
        fadeInDuration:
            JsonClass.parseDurationFromMillis(map['fadeInDuration']),
        fadeOutDuration:
            JsonClass.parseDurationFromMillis(map['fadeOutDuration']),
      );
    }

    return placeHolderBuilder;
  }

  static const kNumSupportedChildren = 0;
  static const type = 'placeholder_network';

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    return FadeInImage.assetNetwork(
      placeholderErrorBuilder: (context, error, stackTrace) =>
          Image(image: AssetImage(errorImage ?? '')),
      placeholder: placeholder ?? '',
      image: image ?? '',
      fadeInCurve: fadeInCurve ?? Curves.easeIn,
      fadeOutCurve: fadeOutCurve ?? Curves.easeOut,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 700),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      height: height,
      width: width,
      imageCacheHeight: imageCacheHeight,
      imageCacheWidth: imageCacheWidth,
      imageScale: imageScale ?? 1.0,
      imageSemanticLabel: imageSemanticLabel,
      placeholderCacheHeight: placeholderCacheHeight,
      placeholderCacheWidth: placeholderCacheWidth,
      placeholderScale: placeholderScale,
      fit: boxFit,
    );
  }
}
