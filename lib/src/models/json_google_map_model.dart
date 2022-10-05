import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_class/json_class.dart';

class MarkerData extends JsonClass {
  MarkerData({
    this.draggable,
    required this.markerId,
    this.onTap,
    this.icon,
    this.onDrag,
    required this.long,
    required this.lat,
  });
  factory MarkerData.dynamicJson(dynamic json) {
    MarkerData? result;
    if (json != null) {
      result = MarkerData(
        lat: JsonClass.parseDouble(json['lat']) ?? 0.0,
        long: JsonClass.parseDouble(json['long']) ?? 0.0,
        draggable: JsonClass.parseBool(json['draggable']),
        markerId: json['markerId'].toString(),
        onTap: json['onTap'],
        icon: json['icon'].toString(),
        onDrag: json['onDrag'],
      );
    }
    return result!;
  }
  bool? draggable;
  double lat, long;
  String markerId;
  Function()? onTap;
  Function(LatLng)? onDrag;
  String? icon;
  @override
  Map<String, dynamic> toJson() {
    return {
      'draggable': draggable,
      'markerId': markerId,
      'onTap': onTap,
      'icon': icon,
      'onDrag': onDrag,
      'lat': lat,
      'long': long
    };
  }
}
