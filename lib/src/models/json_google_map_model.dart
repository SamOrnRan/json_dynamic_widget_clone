import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_class/json_class.dart';
import 'package:json_theme/json_theme.dart';

class MarkerData extends JsonClass {
  MarkerData(
      {this.draggable,
      required this.markerId,
      this.onTap,
      this.icon,
      this.onDrag,
      this.position,
      this.alpha = 1.0,
      this.anchor,
      this.flat = false,
      this.rotation,
      this.visible,
      this.zIndex,
      this.infoWindow,
      this.onDragEnd,
      this.onDragStart,
      this.initialCameraPosition,
      this.iconMark});
  factory MarkerData.dynamicJson(dynamic json) {
    MarkerData? result;
    if (json != null) {
      result = MarkerData(
          draggable: JsonClass.parseBool(json['draggable']),
          markerId: json['markerId'].toString(),
          onTap: json['onTap'],
          onDrag: json['onDrag'],
          anchor: ThemeDecoder.decodeOffset(json['anchor']) ??
              const Offset(0.5, 1.0),
          position: LatLngPosition.dynamicJson(json['latLng']),
          flat: JsonClass.parseBool(json['flat']),
          rotation: JsonClass.parseDouble(json['rotation']) ?? 0.0,
          visible: JsonClass.parseBool(json['visible'], whenNull: true),
          zIndex: JsonClass.parseDouble(json['zIndex']) ?? 0.0,
          infoWindow: fromDynamicInfoWindow(json['infoWindow']),
          icon: json['icon'] != null
              ? IconMarker.dynamicJson(json['icon'])
              : null,
          onDragStart: json['onDragStart'],
          onDragEnd: json['onDragEnd'],
          initialCameraPosition: json['initialCameraPosition'] != null
              ? dynamicCameraPositin(json['initialCameraPosition'])
              : null);
    }

    return result!;
  }
  bool? draggable;
  String markerId;
  LatLngPosition? position;
  double alpha;
  bool flat;
  double? zIndex;
  double? rotation;
  bool? visible;
  Offset? anchor;
  InfoWindow? infoWindow;
  IconMarker? icon;
  CameraPosition? initialCameraPosition;
  Uint8List? iconMark;

  Function()? onTap;
  Function()? onDrag;
  Function()? onDragStart;
  Function()? onDragEnd;

  @override
  Map<String, dynamic> toJson() {
    return {
      'draggable': draggable,
      'markerId': markerId,
      'onTap': onTap,
      'onDrag': onDrag,
      'latLong': position,
      'infoWindow': infoWindow,
      'flat': flat,
      'rotation': rotation,
      'visible': visible,
      'anchor': anchor,
      'icon': icon
    };
  }
}

CameraPosition? dynamicCameraPositin(dynamic map) {
  CameraPosition? result;
  if (map != null) {
    result = CameraPosition(
        target: decoderLatLng(map['target']) ?? LatLng(0.0, 0.0),
        zoom: JsonClass.parseDouble(map['zoom']) ?? 0.0,
        tilt: JsonClass.parseDouble(map['tilt']) ?? 0.0,
        bearing: JsonClass.parseDouble(map['bearing']) ?? 0.0);
  } else {
    result = CameraPosition(
        target: LatLng(0.0, 0.0), zoom: 0.0, tilt: 0.0, bearing: 0.0);
  }
  return result;
}

// LatLng
LatLng? decoderLatLng(dynamic map) {
  LatLng? result;
  if (map != null) {
    result = LatLng(JsonClass.parseDouble(map['lat']) ?? 0.0,
        JsonClass.parseDouble(map['long']) ?? 0.0);
  }
  return result;
}

InfoWindow? fromDynamicInfoWindow(dynamic map) {
  InfoWindow? result;
  if (map != null) {
    result = InfoWindow(
        title: map['title'].toString(),
        snippet: map['snippet'].toString(),
        anchor:
            ThemeDecoder.decodeOffset(map['anchor']) ?? const Offset(0.5, 1.0),
        onTap: map['onTap'] ?? () {});
  }

  return result;
}

// Map
class LatLngPosition extends JsonClass {
  LatLngPosition({required this.lat, required this.long});
  factory LatLngPosition.dynamicJson(dynamic map) {
    LatLngPosition? result;

    if (map != null) {
      result = LatLngPosition(
          lat: JsonClass.parseDouble(map['lat'], 0.0),
          long: JsonClass.parseDouble(map['long'], 0.0));
    }
    return result!;
  }

  double? lat, long;

  @override
  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };
}

// not use  create for testing
class IconMarker extends JsonClass {
  IconMarker({
    this.width = 75,
    this.height = 140,
    this.assetIcon = 'null',
    this.netIcon = 'null',
    this.text = 'null',
  });
  factory IconMarker.dynamicJson(dynamic map) {
    IconMarker? result;

    if (map != null) {
      result = IconMarker(
        assetIcon: map['src'].toString(),
        netIcon: map['network_image'].toString(),
        height: JsonClass.parseInt(map['height'], 140),
        width: JsonClass.parseInt(map['width'], 76),
        text: map['title'].toString(),
      );
    }
    return result!;
  }

  int? width, height;
  String? assetIcon;
  String? netIcon;
  String? text;

  @override
  Map<String, dynamic> toJson() =>
      {'height': height, 'width': width, 'src': assetIcon};
}
