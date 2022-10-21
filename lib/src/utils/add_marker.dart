import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../json_dynamic_widget.dart';

class ImplementationMarker extends ValueNotifier {
  ImplementationMarker() : super(null);
  // static List<MarkerData>? markerData;
  // void notifyListeners() {
  //   super.notifyListeners();
  // }
  ValueNotifier<List<MarkerData>> markerModify = ValueNotifier(<MarkerData>[]);
  ValueNotifier chnageIcon = ValueNotifier(Uint8List);

  void updateMarkerLatLng(double lat, double long, {required var index}) {
    // convert [int] from dynamic
    var k = int.parse(index);

    /// Crate object [ImplementationMarker].
    markerModify.value = List.from(markerModify.value);
    if (markerModify.value.isNotEmpty) {
      // Chang value [LatLng] geted new value
      markerModify.value[k].position!.lat = lat;
      markerModify.value[k].position!.long = long;
      log(markerModify.value[k].position!.lat.toString());
      print(markerModify.value[k].position!.long.toString());
    }
  }

  void replaceI() {
    markerModify.value = List.from(markerModify.value);
  }

  void add(dynamic map) {
    markerModify.value = List.from(markerModify.value)
      ..add(MarkerData.dynamicJson(map));
  }

  void clearMarker() {
    markerModify.value = List.from(markerModify.value)..clear();

    // markerData!.clear();
  }

  void addAll(Iterable<MarkerData> value) {
    markerModify.value = List.from(markerModify.value)..addAll(value);
  }
}
