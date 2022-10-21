import 'dart:async';
import 'dart:core';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

/// Builder that can build an [ListView] widget.  See the [fromDynamic] for the
/// format.
class JsonListViewBuilder extends JsonWidgetBuilder {
  JsonListViewBuilder(
      {required this.addAutomaticKeepAlives,
      required this.addRepaintBoundaries,
      required this.addSemanticIndexes,
      this.cacheExtent,
      required this.clipBehavior,
      this.controller,
      required this.dragStartBehavior,
      this.itemExtent,
      required this.keyboardDismissBehavior,
      this.padding,
      this.physics,
      required this.primary,
      this.prototypeItem,
      this.restorationId,
      required this.reverse,
      required this.scrollDirection,
      this.limits,
      required this.shrinkWrap,
      this.getMoreItmeLoading,
      this.loadingEmptyData})
      : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = -1;
  static const type = 'list_view';
  final int? limits;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final Clip clipBehavior;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final double? itemExtent;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool primary;
  final JsonWidgetData? prototypeItem;
  final String? restorationId;
  final bool reverse;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final JsonWidgetData? getMoreItmeLoading;
  final JsonWidgetData? loadingEmptyData;

  /// Builds the builder from a Map-like dynamic structure.  This expects the
  /// JSON format to be of the following structure:
  ///
  /// ```json
  /// {
  ///   "addAutomaticKeepAlives": <bool>,
  ///   "addRepaintBoundaries": <bool>,
  ///   "addSemanticIndexes": <bool>,
  ///   "cacheExtent": <double>,
  ///   "clipBehavior": <Clip>,
  ///   "controller": <ScrollController>,
  ///   "dragStartBehavior": <DragStartBehavior>,
  ///   "itemExtent": <double>,
  ///   "keyboardDismissBehavior": <ScrollViewKeyboardDismissBehavior>,
  ///   "padding": <EdgeInsetsGeometry>,
  ///   "physics": <ScrollPhysics>,
  ///   "primary": <bool>,
  ///   "prototypeItem": <JsonWidgetData>,
  ///   "restorationId": <String>,
  ///   "reverse": <bool>,
  ///   "scrollDirection": <Axis>,
  ///   "shrinkWrap": <bool>
  /// }
  /// ```
  ///
  /// As a note, the [ScrollController] cannot be decoded via JSON.  Instead,
  /// the only way to bind those values to the builder is to use a function or a
  /// variable reference via the [JsonWidgetRegistry].
  ///
  /// See also:
  ///  * [ThemeDecoder.decodeAxis]
  ///  * [ThemeDecoder.decodeClip]
  ///  * [ThemeDecoder.decodeDragStartBehavior]
  ///  * [ThemeDecoder.decodeEdgeInsetsGeometry]
  ///  * [ThemeDecoder.decodeScrollPhysics]
  static JsonListViewBuilder? fromDynamic(
    dynamic map, {
    JsonWidgetRegistry? registry,
  }) {
    JsonListViewBuilder? result;

    if (map != null) {
      result = JsonListViewBuilder(
        limits: JsonClass.parseInt(map['limits']),
        addAutomaticKeepAlives: map['addAutomaticKeepAlives'] == null
            ? true
            : JsonClass.parseBool(map['addAutomaticKeepAlives']),
        addRepaintBoundaries: map['addRepaintBoundaries'] == null
            ? true
            : JsonClass.parseBool(map['addRepaintBoundaries']),
        addSemanticIndexes: map['addSemanticIndexes'] == null
            ? true
            : JsonClass.parseBool(map['addSemanticIndexes']),
        cacheExtent: JsonClass.parseDouble(map['cacheExtent']),
        clipBehavior: ThemeDecoder.decodeClip(
              map['clipBehavior'],
              validate: false,
            ) ??
            Clip.hardEdge,
        controller: map['controller'],
        dragStartBehavior: ThemeDecoder.decodeDragStartBehavior(
              map['dragStartBehavior'],
              validate: false,
            ) ??
            DragStartBehavior.start,
        itemExtent: JsonClass.parseDouble(map['itemExtent']),
        keyboardDismissBehavior:
            ThemeDecoder.decodeScrollViewKeyboardDismissBehavior(
                  map['keyboardDismissBehavior'],
                  validate: false,
                ) ??
                ScrollViewKeyboardDismissBehavior.manual,
        padding: ThemeDecoder.decodeEdgeInsetsGeometry(
          map['padding'],
          validate: false,
        ) as EdgeInsets?,
        physics: ThemeDecoder.decodeScrollPhysics(
          map['physics'],
          validate: false,
        ),
        primary: JsonClass.parseBool(map['primary']),
        restorationId: map['restorationId'],
        reverse: JsonClass.parseBool(map['reverse']),
        scrollDirection: ThemeDecoder.decodeAxis(
              map['scrollDirection'],
              validate: false,
            ) ??
            Axis.vertical,
        shrinkWrap: JsonClass.parseBool(map['shrinkWrap']),
        getMoreItmeLoading:
            JsonWidgetData.fromDynamic(map['getmoreItemsLoading']),
        loadingEmptyData: JsonWidgetData.fromDynamic(map['loadingItemEmpty']),
      );
    }

    return result;
  }

  @override
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  }) {
    return PaginationAndLoading(
      data: data,
      context: context,
      childBuilder: childBuilder,
      limits: limits,
      clipBehavior: clipBehavior,
      addSemanticIndexes: addAutomaticKeepAlives,
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      itemExtent: itemExtent,
      prototypeItem: prototypeItem,
      restorationId: restorationId,
      reverse: reverse,
      vlaueAddRepaintBoundaries: addAutomaticKeepAlives,
      valuecacheExtent: cacheExtent,
      padding: padding,
      primary: primary,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      scrollViewKeyboardDismissBehavior: keyboardDismissBehavior,
      valueAddAutomaticKeepAlives: addAutomaticKeepAlives,
      getMoreItmeLoading: getMoreItmeLoading,
      loadingEmptyData: loadingEmptyData,
    );
  }
}

class PaginationAndLoading extends StatefulWidget {
  const PaginationAndLoading(
      {Key? key,
      required this.data,
      required this.context,
      this.childBuilder,
      this.addSemanticIndexes,
      this.clipBehavior,
      this.controller,
      this.dragStartBehavior,
      this.itemExtent,
      this.prototypeItem,
      this.restorationId,
      this.reverse,
      this.scrollViewKeyboardDismissBehavior,
      this.shrinkWrap,
      this.valueAddAutomaticKeepAlives,
      this.valuecacheExtent,
      this.vlaueAddRepaintBoundaries,
      this.padding,
      this.primary,
      this.physics,
      this.scrollDirection,
      this.limits,
      this.getMoreItmeLoading,
      this.loadingEmptyData})
      : super(key: key);
  final BuildContext context;
  final ChildWidgetBuilder? childBuilder;
  final JsonWidgetData data;
  final int? limits;
  final bool? valueAddAutomaticKeepAlives;
  final bool? vlaueAddRepaintBoundaries;
  final bool? addSemanticIndexes;
  final double? valuecacheExtent;
  final Clip? clipBehavior;
  final ScrollController? controller;
  final DragStartBehavior? dragStartBehavior;
  final double? itemExtent;
  final ScrollViewKeyboardDismissBehavior? scrollViewKeyboardDismissBehavior;
  final JsonWidgetData? prototypeItem;
  final String? restorationId;
  final bool? reverse;
  final bool? shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Axis? scrollDirection;
  final bool? primary;
  final JsonWidgetData? getMoreItmeLoading;
  final JsonWidgetData? loadingEmptyData;

  @override
  State<PaginationAndLoading> createState() => _PaginationAndLoadingState();
}

class _PaginationAndLoadingState extends State<PaginationAndLoading> {
  final ScrollController controller = ScrollController();

  int offset = 0;
  int? limits;
  int? endAt;
  int page = 1;
  int totalPage = 0;
  bool hideProgress = false;
  List<JsonWidgetData> currentChildren = [];

  @override
  void initState() {
    limits = widget.limits;
    if (limits != null) {
      iniitPage();
      _initScroll();
    } else {
      setState(() {
        currentChildren = widget.data.children!.toList();
      });
    }

    super.initState();
  }

  void _initScroll() {
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        nextPage();
      }
    });
  }

//initail page
  void iniitPage() {
    endAt = offset + limits!;
    totalPage = (widget.data.children!.length / limits!).floor();
    if (widget.data.children!.length / limits! > totalPage) {
      totalPage = totalPage + 1;
    }
    currentChildren = widget.data.children!.getRange(offset, endAt!).toList();
  }

  // when scroll to maximum it add new to [currentChildren]
  void nextPage() {
    if (page < totalPage) {
      setState(() {
        offset = offset;
        endAt = widget.data.children!.length > endAt! + limits!
            ? endAt! + limits!
            : widget.data.children!.length;
        hideProgress = true;
        Timer(Duration(milliseconds: 700), () {
          currentChildren =
              widget.data.children!.getRange(offset, endAt!).toList();
          setState(() {
            hideProgress = false;
          });
        });

        page = page + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: hideProgress == true ? 20 : 0),
          child: ListView.builder(
            addAutomaticKeepAlives: widget.valueAddAutomaticKeepAlives ?? true,
            addRepaintBoundaries: widget.vlaueAddRepaintBoundaries ?? true,
            addSemanticIndexes: widget.addSemanticIndexes ?? true,
            cacheExtent: widget.itemExtent,
            clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
            controller: controller,
            dragStartBehavior:
                widget.dragStartBehavior ?? DragStartBehavior.start,
            itemCount: currentChildren.length,
            itemExtent: widget.itemExtent,
            key: widget.key,
            keyboardDismissBehavior: widget.scrollViewKeyboardDismissBehavior ??
                ScrollViewKeyboardDismissBehavior.manual,
            padding: widget.padding,
            physics: widget.physics,
            primary: widget.primary,
            prototypeItem: widget.prototypeItem != null
                ? widget.prototypeItem!
                    .build(context: context, childBuilder: widget.childBuilder)
                : null,
            restorationId: widget.restorationId,
            reverse: widget.reverse ?? false,
            scrollDirection: widget.scrollDirection ?? Axis.vertical,
            semanticChildCount: currentChildren.length,
            shrinkWrap: widget.shrinkWrap ?? false,
            itemBuilder: (BuildContext context, int index) {
              // var w = widget.data.children![index].build(
              //   childBuilder: widget.childBuilder,
              //   context: widget.context,
              // );
              return currentChildren[index]
                  .build(context: context, childBuilder: widget.childBuilder);
            },
          ),
        ),
        // Empty data
        currentChildren.isEmpty
            ? Align(
                alignment: Alignment.center,
                child: widget.loadingEmptyData != null
                    ? widget.loadingEmptyData!.build(
                        context: context, childBuilder: widget.childBuilder)
                    : CircularProgressIndicator())
            : Container(),
        // get more data
        hideProgress == true
            ? Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Align(
                    alignment: Alignment.center,
                    child: widget.getMoreItmeLoading != null
                        ? widget.getMoreItmeLoading!.build(
                            context: context, childBuilder: widget.childBuilder)
                        : SpinKitThreeBounce(
                            size: 25,
                            color: Colors.lightBlue,
                          )),
              )
            : Container(),
      ],
    );
  }
}
