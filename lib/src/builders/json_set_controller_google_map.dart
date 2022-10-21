import 'dart:async';

import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_dynamic_widget/builders.dart';
import 'package:json_dynamic_widget/src/components/json_widget_registry.dart';
import 'package:json_dynamic_widget/src/models/json_widget_data.dart';

class JsonSetControllerGoogleMap extends JsonWidgetBuilder {
  JsonSetControllerGoogleMap({this.googleMapController})
      : super(numSupportedChildren: kNumSupportedChildren);

  static const kNumSupportedChildren = 1;
  static const type = 'google_map_controller';

  final GoogleMapController? googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  static JsonSetControllerGoogleMap? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonSetControllerGoogleMap? result;
    if (map != null) {
      result = JsonSetControllerGoogleMap(googleMapController: map['controller ']);
    }
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    throw UnimplementedError();
  }
}
