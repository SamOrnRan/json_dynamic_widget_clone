import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class JsonDisableScrollIndecator extends JsonWidgetBuilder {
  JsonDisableScrollIndecator({this.widgets})
      : super(numSupportedChildren: kNumSupportedChildren);
  final Map<String, JsonWidgetData?>? widgets;
  static const kNumSupportedChildren = -1;
  static const key = 'disable_indecator';
  static JsonDisableScrollIndecator? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonDisableScrollIndecator? result;
    var innerRegistry = registry ?? JsonWidgetRegistry.instance;

    if (map != null) {
      var widgets = <String, JsonWidgetData?>{};
      map.forEach(
        (key, value) => widgets[key] = JsonWidgetData.fromDynamic(value),
      );

      result = JsonDisableScrollIndecator(widgets: widgets);
      registry ??= JsonWidgetRegistry.instance;
      result.widgets
          ?.forEach((key, value) => innerRegistry.setValue(key, value));
    }
    return result;
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    assert(
      data.children?.length == 1 || data.children?.isNotEmpty != true,
      '[JsonSetWidgetBuilder] only supports zero or one child.',
    );
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return false;
        },
        child: data.children?.isNotEmpty == true
            ? data.children![0].build(
                childBuilder: childBuilder,
                context: context,
              )
            : SizedBox(key: key));
  }
}
