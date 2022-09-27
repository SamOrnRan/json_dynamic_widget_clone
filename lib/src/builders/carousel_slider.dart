import 'package:carousel_slider/carousel_slider.dart';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

class JsonCarouselSliderBuilder extends JsonWidgetBuilder {
  JsonCarouselSliderBuilder(
      {this.aspectRatio,
      this.height,
      this.initialPage,
      this.scrollDirection = Axis.horizontal,
      this.reverse,
      this.autoPlay,
      this.autoPlayAnimationDuration,
      this.autoPlayCurve,
      this.autoPlayInterval,
      this.clipBehavior,
      this.disableCenter,
      this.enableInfiniteScroll,
      this.enlargeCenterPage,
      this.padEnds = true,
      this.pageSnapping,
      this.pauseAutoPlayInFiniteScroll,
      this.pauseAutoPlayOnManualNavigate,
      this.pauseAutoPlayOnTouch,
      this.enlargeStrategy,
      this.viewportFraction,
      this.controller,
      this.scrollPhysics})
      : super(numSupportedChildren: kNumSupportedChildren);
  final double? height;
  final double? aspectRatio;
  final int? initialPage;
  final Axis scrollDirection;

  final CarouselController? controller;
  final double? viewportFraction;
  final bool? enableInfiniteScroll;
  final bool? reverse;
  final bool? autoPlay;
  final Duration? autoPlayInterval;
  final Duration? autoPlayAnimationDuration;
  final Curve? autoPlayCurve;
  final bool? enlargeCenterPage;
  final ScrollPhysics? scrollPhysics;
  final bool? pageSnapping;
  final bool? pauseAutoPlayOnTouch;
  final bool? pauseAutoPlayOnManualNavigate;
  final bool? pauseAutoPlayInFiniteScroll;
  final bool? disableCenter;
  final Clip? clipBehavior;
  final bool padEnds;
  final CenterPageEnlargeStrategy? enlargeStrategy;

  static const kNumSupportedChildren = -1;
  static const type = 'carousel_slider';
  static JsonCarouselSliderBuilder? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonCarouselSliderBuilder? objectCaroulslider;
    if (map != null) {
      objectCaroulslider = JsonCarouselSliderBuilder(
          aspectRatio: JsonClass.parseDouble(map['aspect_ratio']),
          height: JsonClass.parseDouble(map['height']),
          initialPage: JsonClass.parseInt(map['initial_page']),
          scrollDirection: ThemeDecoder.decodeAxis(map['scrollDirection']) ??
              Axis.horizontal,
          autoPlay: JsonClass.parseBool(map['autoPlay']),
          reverse: JsonClass.parseBool(map['reverse']),
          enableInfiniteScroll:
              JsonClass.parseBool(map['enableInfiniteScroll']),
          autoPlayInterval:
              JsonClass.parseDurationFromMillis(map['autoPlayInterval']),
          autoPlayAnimationDuration: JsonClass.parseDurationFromMillis(
            map['autoPlayAnimationDuration'],
          ),
          autoPlayCurve: map['autoPlayCurve'],
          scrollPhysics: ThemeDecoder.decodeScrollPhysics(map['scrollPhysics']),
          pageSnapping: JsonClass.parseBool(map['pageSnapping']),
          pauseAutoPlayInFiniteScroll:
              JsonClass.parseBool(map['pauseAutoPlayInFiniteScroll']),
          pauseAutoPlayOnManualNavigate:
              JsonClass.parseBool(map['pauseAutoPlayOnManualNavigate']),
          pauseAutoPlayOnTouch:
              JsonClass.parseBool(map['pauseAutoPlayOnTouch']),
          padEnds: JsonClass.parseBool(map['padEnds']),
          enlargeCenterPage: JsonClass.parseBool(map['enlargeCenterPage']),
          viewportFraction: JsonClass.parseDouble(map['viewportFraction']),
          clipBehavior:
              ThemeDecoder.decodeClip(map['clipBehavior'], validate: true),
          controller: map['controller']);
    }
    return objectCaroulslider;
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    return CarouselSlider.builder(
      carouselController: controller,
      itemBuilder: (BuildContext context, int index, int realIndex) => data
          .children![index]
          .build(context: context, childBuilder: childBuilder),
      options: CarouselOptions(
        aspectRatio: aspectRatio ?? 16 / 9,
        height: height,
        initialPage: initialPage ?? 0,
        viewportFraction: viewportFraction ?? 0.9,
        scrollDirection: scrollDirection,
        enableInfiniteScroll: enableInfiniteScroll ?? true,
        autoPlay: autoPlay ?? false,
        autoPlayAnimationDuration:
            autoPlayAnimationDuration ?? const Duration(milliseconds: 800),
        autoPlayCurve: autoPlayCurve ?? Curves.fastOutSlowIn,
        autoPlayInterval: autoPlayInterval ?? const Duration(seconds: 4),
        pauseAutoPlayInFiniteScroll: pauseAutoPlayInFiniteScroll ?? true,
        pauseAutoPlayOnManualNavigate: pauseAutoPlayOnManualNavigate ?? true,
        pauseAutoPlayOnTouch: pauseAutoPlayOnTouch ?? true,
        padEnds: true,
        pageSnapping: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        scrollPhysics: scrollPhysics,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
      ),
      itemCount: data.children!.length,
    );
  }
}
