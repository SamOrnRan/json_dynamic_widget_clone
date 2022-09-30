import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class PageDetailJsonDynamicWidget extends StatelessWidget {
  PageDetailJsonDynamicWidget(
      {Key? key, required this.registry, this.valueroot})
      : assert(valueroot != null),
        super(key: key);
  final Map? valueroot;
  final JsonWidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    final data = JsonWidgetData.fromDynamic(valueroot, registry: registry);
    if (data == null) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
    return data.build(
      context: context,
    );
  }
}
