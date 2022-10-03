import 'dart:async';
import 'dart:developer';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget/src/models/utils.dart';
import 'package:json_theme/json_theme.dart';

class JsonGoogleMapBuildWidget extends JsonWidgetBuilder {
  JsonGoogleMapBuildWidget({
    this.mapType,
    this.compassEnabled,
    this.mapTypeConvert,
    this.latLngMapData,
    this.layoutDirection,
    this.liteModeEnabled = false,
    this.mapToolbarEnabled = true,
    this.myLocationButtonEnabled = true,
    this.myLocationEnabled = true,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled,
    this.zoomMap,
    this.padding,
    this.buildingsEnabled = true,
    this.indoorViewEnabled,
    this.trafficEnabled,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  final String? mapType;
  final String? mapTypeConvert;
  final bool? compassEnabled;
  final List<Map>? latLngMapData;
  final bool mapToolbarEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
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

  static const kNumSupportedChildren = 1;
  static const type = 'google_map';

  static JsonGoogleMapBuildWidget? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonGoogleMapBuildWidget? result;
    if (map != null) {
      result = JsonGoogleMapBuildWidget(
        mapType: map['mapType'].toString(),
        compassEnabled: JsonClass.parseBool(map['compassEnabled']),
        latLngMapData:
            map['latLng'] == null ? [] : List<Map>.from(map['latLng']),
        mapToolbarEnabled: JsonClass.parseBool(map['mapToolbarEnabled']),
        rotateGesturesEnabled:
            JsonClass.parseBool(map['rotateGesturesEnabled']),
        scrollGesturesEnabled:
            JsonClass.parseBool(map['scrollGesturesEnabled']),
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
      getlatlng: latLngMapData,
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
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    Key? key,
    this.compassEnabled,
    this.getlatlng,
    this.mapType,
    this.layoutDirection,
    required this.liteModeEnabled,
    required this.mapToolbarEnabled,
    required this.myLocationButtonEnabled,
    required this.myLocationEnabled,
    required this.rotateGesturesEnabled,
    required this.scrollGesturesEnabled,
    required this.tiltGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.buildingsEnabled,
    this.indoorViewEnabled,
    this.padding,
    this.zoomMap,
    this.trafficEnabled,
    required this.zoomGesturesEnabled,
  }) : super(key: key);
  final String? mapType;
  final bool? compassEnabled;
  final List<Map>? getlatlng;
  final bool mapToolbarEnabled;
  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
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

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> googleMapController = Completer();

  double? _lat;
  double? _lng;

  MapType? _mapType;
  late LatLng _latLng;
  final Set<Marker> marker = {}; // marker is show  on  map
  final List<Map> _currentPositionLaglng = []; // fetch data from <Map>

  @override
  void initState() {
    _init();
    initMapType();
    getMarker();
    _initialCameraPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onTap: (argument) async {
        // click on map it zoom to latlng
        final controller = await googleMapController.future;
        await controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(argument.latitude, argument.longitude), 13.5));
      },
      onMapCreated: _onCreateMap,
      mapType: _mapType ?? MapType.normal,
      markers: marker,
      compassEnabled: widget.compassEnabled ?? true,
      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
      trafficEnabled: widget.trafficEnabled ?? false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
            _currentPositionLaglng[0]['lat'], _currentPositionLaglng[0]['lng']),
        zoom: 1,
      ),
      mapToolbarEnabled: widget.mapToolbarEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled ?? true,
      liteModeEnabled: widget.liteModeEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      myLocationEnabled: widget.myLocationEnabled,
      layoutDirection: widget.layoutDirection,
      padding: widget.padding ?? EdgeInsets.zero,
      buildingsEnabled: widget.buildingsEnabled,
      onCameraMove: (CameraPosition position) {
        marker.add(
          Marker(
              markerId: MarkerId('ee-1'),
              position: _latLng,
              icon: BitmapDescriptor.defaultMarker),
        );
      },
    );
  }

// add all <Map> latlng to[_currentPositionLaglng]
  void _init() {
    _currentPositionLaglng.addAll(widget.getlatlng!);
    widget.mapType;
  }

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
  Future<void> _initialCameraPosition() async {
    _latLng = LatLng(
        _currentPositionLaglng[0]['lat'], _currentPositionLaglng[0]['lng']);
    final controller = await googleMapController.future;
    await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng, widget.zoomMap ?? 5.0));
  }

  // Marker location
  void getMarker() async {
    final iconMarker = await Containts.getBytesFromAsset(
        path: 'assets/images/google_marker.png', width: 80);
    for (var i = 0; i < _currentPositionLaglng.length; i++) {
      _lat = double.parse(_currentPositionLaglng[i]['lat'].toString());
      _lng = double.parse(_currentPositionLaglng[i]['lng'].toString());

      setState(() {
        marker.add(
          Marker(
              draggable: true,
              markerId: MarkerId(_lat.toString()),
              position: LatLng(_lat!, _lng!),
              icon: BitmapDescriptor.fromBytes(iconMarker),
              onTap: () async {
                // when click on event marker it is zoom by current latlng
                final controller = await googleMapController.future;
                await controller.animateCamera(CameraUpdate.newLatLngZoom(
                    LatLng(_currentPositionLaglng[i]['lat'],
                        _currentPositionLaglng[i]['lng']),
                    15.5));
              },
              onDrag: (value) async {
                final controller = await googleMapController.future;

                await controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(value.latitude, value.longitude),
                        zoom: 15.5)));
                log(value.latitude.toString());
              }),
        );
      });
    }
  }

// Menthod called when map is create
  void _onCreateMap(GoogleMapController controller) {
    googleMapController.complete(controller);
  }
}
