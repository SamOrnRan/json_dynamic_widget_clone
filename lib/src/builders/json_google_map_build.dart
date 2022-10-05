import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';

import '../models/json_google_map_model.dart';
import '../models/utils.dart';

class JsonGoogleMapBuildWidget extends JsonWidgetBuilder {
  JsonGoogleMapBuildWidget({
    this.mapType,
    this.compassEnabled,
    this.layoutDirection,
    this.liteModeEnabled = false,
    this.mapToolbarEnabled = true,
    this.myLocationButtonEnabled = true,
    this.myLocationEnabled = true,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled,
    this.zoomMap,
    this.padding,
    this.buildingsEnabled = true,
    this.indoorViewEnabled,
    this.trafficEnabled,
    this.marker,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  final String? mapType;

  final bool? compassEnabled;

  final bool mapToolbarEnabled;
  final bool rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final bool liteModeEnabled;
  final bool tiltGesturesEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final TextDirection? layoutDirection;
  final EdgeInsets? padding;
  final bool? indoorViewEnabled;
  final bool? trafficEnabled;
  final bool buildingsEnabled;
  final double? zoomMap; // init zoom when open map
  final MarkerData? marker;

  static const kNumSupportedChildren = 1;
  static const type = 'google_map';

  static JsonGoogleMapBuildWidget? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonGoogleMapBuildWidget? result;
    if (map != null) {
      result = JsonGoogleMapBuildWidget(
        mapType: map['mapType'].toString(),
        compassEnabled: JsonClass.parseBool(map['compassEnabled']),
        mapToolbarEnabled: JsonClass.parseBool(map['mapToolbarEnabled']),
        rotateGesturesEnabled:
            JsonClass.parseBool(map['rotateGesturesEnabled']),
        scrollGesturesEnabled: map['scrollGesturesEnabled'] != null
            ? JsonClass.parseBool(map['scrollGesturesEnabled'])
            : true,
        zoomControlsEnabled: JsonClass.parseBool(map['zoomControlsEnabled']),
        zoomGesturesEnabled: map['zoomGesturesEnabled'] != null
            ? JsonClass.parseBool(map['zoomGesturesEnabled'])
            : true,
        liteModeEnabled: JsonClass.parseBool(map['liteModeEnabled']),
        tiltGesturesEnabled: JsonClass.parseBool(map['tiltGesturesEnabled']),
        myLocationEnabled: JsonClass.parseBool(map['myLocationEnabled']),
        myLocationButtonEnabled:
            JsonClass.parseBool(map['myLocationButtonEnabled']),
        layoutDirection:
            ThemeDecoder.decodeTextDirection(map['layoutDirection']),
        padding: map['padding'] != null
            ? ThemeDecoder.decodeEdgeInsetsGeometry(map['padding'],
                validate: false) as EdgeInsets
            : EdgeInsets.zero,
        indoorViewEnabled: JsonClass.parseBool(map['indoorViewEnabled']),
        buildingsEnabled: JsonClass.parseBool(map['buildingsEnabled']),
        zoomMap: map['zoom'] != null ? JsonClass.parseDouble(map['zoom']) : 5.0,
        marker: map['marker'] != null
            ? MarkerData.dynamicJson(map['marker'])
            : null,
      );
    }
    return result;
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    return GoogleMapWidget(
      zoomMap: zoomMap,
      mapType: mapType,
      compassEnabled: compassEnabled,
      mapToolbarEnabled: mapToolbarEnabled,
      rotateGesturesEnabled: rotateGesturesEnabled,
      scrollGesturesEnabled: scrollGesturesEnabled,
      zoomControlsEnabled: zoomControlsEnabled,
      liteModeEnabled: liteModeEnabled,
      tiltGesturesEnabled: tiltGesturesEnabled,
      myLocationButtonEnabled: myLocationButtonEnabled,
      myLocationEnabled: myLocationEnabled,
      layoutDirection: layoutDirection,
      trafficEnabled: trafficEnabled,
      zoomGesturesEnabled: zoomGesturesEnabled,
      padding: padding,
      indoorViewEnabled: indoorViewEnabled,
      buildingsEnabled: buildingsEnabled,
      marker: marker,
      childBuilder: childBuilder,
      data: data,
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    Key? key,
    required this.data,
    this.childBuilder,
    this.compassEnabled,
    this.mapType,
    this.layoutDirection,
    required this.liteModeEnabled,
    required this.mapToolbarEnabled,
    required this.myLocationButtonEnabled,
    required this.myLocationEnabled,
    required this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    required this.tiltGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.buildingsEnabled,
    this.indoorViewEnabled,
    this.padding,
    this.zoomMap,
    this.trafficEnabled,
    required this.zoomGesturesEnabled,
    this.marker,
  }) : super(key: key);
  final ChildWidgetBuilder? childBuilder;
  final JsonWidgetData data;
  final String? mapType;
  final bool? compassEnabled;
  final bool mapToolbarEnabled;
  final bool rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final bool liteModeEnabled;
  final bool tiltGesturesEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final TextDirection? layoutDirection;
  final EdgeInsets? padding;
  final bool? indoorViewEnabled;
  final bool? trafficEnabled;
  final bool buildingsEnabled;
  final double? zoomMap;
  final MarkerData? marker;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> googleMapController = Completer();

  MapType? _mapType;
  final Set<Marker> _marker = {};
  MarkerData? markerData;
  Uint8List? iconMarker;

  @override
  void initState() {
    markerData = widget.marker;
    initMarker();
    initMapType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onCreateMap,
      mapType: _mapType ?? MapType.normal,
      compassEnabled: widget.compassEnabled ?? true,
      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
      trafficEnabled: widget.trafficEnabled ?? false,
      initialCameraPosition: CameraPosition(
        target: LatLng(11.530676481705706, 104.85269557748151),
        zoom: 1,
      ),
      mapToolbarEnabled: widget.mapToolbarEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled!,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled ?? true,
      liteModeEnabled: widget.liteModeEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      myLocationEnabled: widget.myLocationEnabled,
      layoutDirection: widget.layoutDirection,
      padding: widget.padding ?? EdgeInsets.zero,
      buildingsEnabled: widget.buildingsEnabled,
      markers: _marker,
    );
  }

  void initMarker() async {
    //
    if (markerData!.icon != 'null') {
      // Conver marker icon [Uint8List]
      iconMarker = await Containts.getBytesFromAsset(
          path: markerData!.icon ?? '', width: 70);
    }
    setState(() {
      
      _marker.add(
        Marker(
            markerId: MarkerId(
              markerData!.markerId,
            ),
            position: LatLng(markerData!.lat, markerData!.long),
            draggable: widget.marker!.draggable ?? false,
            icon: iconMarker == null
                ? BitmapDescriptor.defaultMarker
                : BitmapDescriptor.fromBytes(iconMarker!),
            onTap: markerData!.onTap ?? () {},
            onDrag: ((value) => markerData!.onDrag!(value))),
      );
    });
  }

  // Marker createMarker() {
  //   return Marker(
  //       markerId: MarkerId(
  //         markerData!.markerId,
  //       ),
  //       position: LatLng(markerData!.lat, markerData!.long),
  //       draggable: widget.marker!.draggable ?? false,
  //       icon: iconMarker == null
  //           ? BitmapDescriptor.defaultMarker
  //           : BitmapDescriptor.fromBytes(iconMarker!),
  //       onTap: markerData!.onTap ?? () {},
  //       onDrag: ((value) => markerData!.onDrag!(value)));
  // }

// It working choise from json  by MapType
  void initMapType() {
    if (widget.mapType != null || widget.mapType!.isNotEmpty) {
      switch (widget.mapType) {
        case 'none':
          _mapType = MapType.none;
          break;
        case 'satellite':
          _mapType = MapType.satellite;
          break;
        case 'terrain':
          _mapType = MapType.terrain;
          break;
        case 'hybrid':
          _mapType = MapType.hybrid;
          break;
        case 'normal':
          _mapType = MapType.normal;
          break;

        default:
          MapType.normal;
      }
    }
  }

// Firt start on map it zoom show all marker
  // Future<void> _initialCameraPosition() async {
  //   _latLng = LatLng(11.53282066503005, 104.87046248902234);
  //   final controller = await googleMapController.future;
  //   await controller.animateCamera(CameraUpdate.newLatLngZoom(_latLng, 10));
  // }

// Menthod called when map is create
  void _onCreateMap(GoogleMapController controller) {
    googleMapController.complete(controller);
  }
}
