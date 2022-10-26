import 'dart:async';
import 'dart:typed_data';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_dynamic_widget/src/utils/add_marker.dart';
import 'package:json_dynamic_widget/src/utils/convertor_custom.dart';
import 'package:json_theme/json_theme.dart';
import '../models/utils.dart';

// ignore: must_be_immutable
class JsonGoogleMapBuildWidget extends JsonWidgetBuilder {
  JsonGoogleMapBuildWidget({
    this.mapType,
    this.compassEnabled,
    this.layoutDirection,
    this.liteModeEnabled,
    this.mapToolbarEnabled,
    this.myLocationButtonEnabled,
    this.myLocationEnabled,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.zoomControlsEnabled,
    this.zoomGesturesEnabled,
    this.zoomMap,
    this.padding,
    this.buildingsEnabled,
    this.indoorViewEnabled,
    this.trafficEnabled,
    this.marker,
    this.minMaxZoomPreference,
  }) : super(numSupportedChildren: kNumSupportedChildren);

  final dynamic mapType;
  final bool? compassEnabled;
  final bool? mapToolbarEnabled;
  final bool? rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final bool? liteModeEnabled;
  final bool? tiltGesturesEnabled;
  final bool? myLocationEnabled;
  final bool? myLocationButtonEnabled;
  final TextDirection? layoutDirection;
  final EdgeInsets? padding;
  final bool? indoorViewEnabled;
  final bool? trafficEnabled;
  final bool? buildingsEnabled;
  final double? zoomMap; // init zoom when open map
  final List<MarkerData>? marker;
  MinMaxZoomPreference? minMaxZoomPreference;

  static const kNumSupportedChildren = 1;
  static const type = 'google_map';

  static JsonGoogleMapBuildWidget? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonGoogleMapBuildWidget? result;
    if (map != null) {
      result = JsonGoogleMapBuildWidget(
        mapType: map['mapType'],
        compassEnabled:
            JsonClass.parseBool(map['compassEnabled'], whenNull: true),
        mapToolbarEnabled:
            JsonClass.parseBool(map['mapToolbarEnabled'], whenNull: true),
        rotateGesturesEnabled:
            JsonClass.parseBool(map['rotateGesturesEnabled'], whenNull: true),
        scrollGesturesEnabled:
            JsonClass.parseBool(map['scrollGesturesEnabled'], whenNull: true),
        zoomControlsEnabled:
            JsonClass.parseBool(map['zoomControlsEnabled'], whenNull: true),
        zoomGesturesEnabled:
            JsonClass.parseBool(map['zoomGesturesEnabled'], whenNull: true),
        liteModeEnabled:
            JsonClass.parseBool(map['liteModeEnabled'], whenNull: false),
        tiltGesturesEnabled:
            JsonClass.parseBool(map['tiltGesturesEnabled'], whenNull: true),
        myLocationEnabled:
            JsonClass.parseBool(map['myLocationEnabled'], whenNull: false),
        myLocationButtonEnabled:
            JsonClass.parseBool(map['myLocationButtonEnabled'], whenNull: true),
        layoutDirection:
            ThemeDecoder.decodeTextDirection(map['layoutDirection']),
        padding: map['padding'] != null
            ? ThemeDecoder.decodeEdgeInsetsGeometry(map['padding'],
                validate: false) as EdgeInsets
            : EdgeInsets.zero,
        indoorViewEnabled: JsonClass.parseBool(map['indoorViewEnabled']),
        buildingsEnabled:
            JsonClass.parseBool(map['buildingsEnabled'], whenNull: true),
        trafficEnabled:
            JsonClass.parseBool(map['trafficEnabled'], whenNull: false),
        zoomMap: JsonClass.parseDouble(map['zoom'], 12.2),
        minMaxZoomPreference: map['minMaxZoomPreference'] != null
            ? map['minMaxZoomPreference'] = MinMaxZoomPreference.unbounded
            : MinMaxZoomPreference.unbounded,
        marker: map['marker'] != null
            ? (map['marker'] as List)
                .map((e) => MarkerData.dynamicJson(e))
                .toList()
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
      minMaxZoomPreference: minMaxZoomPreference,
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
    this.myLocationButtonEnabled,
    this.myLocationEnabled,
    required this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    required this.tiltGesturesEnabled,
    this.zoomControlsEnabled,
    this.buildingsEnabled,
    this.indoorViewEnabled,
    this.padding,
    this.zoomMap,
    this.trafficEnabled,
    required this.zoomGesturesEnabled,
    this.marker,
    this.minMaxZoomPreference,
  }) : super(key: key);
  final ChildWidgetBuilder? childBuilder;
  final JsonWidgetData data;
  final dynamic mapType;
  final bool? compassEnabled;
  final bool? mapToolbarEnabled;
  final bool? rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? zoomControlsEnabled;
  final bool? zoomGesturesEnabled;
  final bool? liteModeEnabled;
  final bool? tiltGesturesEnabled;
  final bool? myLocationEnabled;
  final bool? myLocationButtonEnabled;
  final TextDirection? layoutDirection;
  final EdgeInsets? padding;
  final bool? indoorViewEnabled;
  final bool? trafficEnabled;
  final bool? buildingsEnabled;
  final double? zoomMap;
  final List<MarkerData>? marker;
  final MinMaxZoomPreference? minMaxZoomPreference;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> googleMapController = Completer();
  final globalKey = GlobalKey();

  ///[ImplementationMarker] create object
  ImplementationMarker implementMaker = ImplementationMarker();

  /// [CameraPosition] usage  for init google map
  CameraPosition? _cameraPosition;

  ///[MapType] Create object for usage get values from map
  MapType? _mapType;
  final Set<Marker> _marker = {};
  Uint8List? iconMarker;
  BitmapDescriptor? customIcon;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    ///[widget.marker] assigned new current [ implementMaker.markerModify.value]
    implementMaker.markerModify.value = widget.marker!;

    /// [MapType]  convert by  method [formDynamicMapType]
    /// assign [widget.mapType] into _maptype
    _mapType = ConvertorCustome.formDynamicMapType(widget.mapType);
    createMarker(implementMaker.markerModify.value);

    /// set [ImplementationMarker] into  jsonWidgetRegistry
    widget.data.registry.setValue('valueChnageNotifier', implementMaker);

    /// set [GoogleMapController] into  jsonWidgetRegistry
    widget.data.registry.setValue('google_map_controller', googleMapController);
    await initCameraPosition();
  }

  @override
  void dispose() {
    implementMaker.dispose();

    /// when out  google map it set 'null' into registry
    widget.data.registry.setValue('google_map_controller', '');

    widget.data.registry.setValue('valueChnageNotifier', '');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MyMarker(globalKey);

    /// get from  [List]
    implementMaker.markerModify.value =
        List.from(implementMaker.markerModify.value);

    ///[CameraPosition] set into CameraUpade
    ///  Properties [implementMaker.markerModify.value[0]] it get latLng first of array
    /// when open the google map
    _cameraPosition = CameraPosition(
      target: LatLng(implementMaker.markerModify.value[0].position!.lat ?? 0.0,
          implementMaker.markerModify.value[0].position!.long ?? 0.0),
      zoom: widget.zoomMap!,
    );
    // initIcon(implementMaker.markerModify.value);

    /// [ValueListenableBuilder] helper for change value
    return ValueListenableBuilder(
        valueListenable: implementMaker.markerModify,
        builder: (context, List<MarkerData> entry, childWidget) {
          return GoogleMap(
            onMapCreated: _onCreateMap,
            mapType: _mapType ?? MapType.normal,
            compassEnabled: widget.compassEnabled!,
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            trafficEnabled: widget.trafficEnabled!,
            initialCameraPosition: CameraPosition(
              target: LatLng(entry[0].position!.lat ?? 0.0,
                  entry[0].position!.long ?? 0.0),
              zoom: 0.0,
            ),
            mapToolbarEnabled: widget.mapToolbarEnabled!,
            rotateGesturesEnabled: widget.rotateGesturesEnabled!,
            scrollGesturesEnabled: widget.scrollGesturesEnabled!,
            zoomControlsEnabled: widget.zoomControlsEnabled!,
            zoomGesturesEnabled: widget.zoomGesturesEnabled!,
            liteModeEnabled: widget.liteModeEnabled!,
            tiltGesturesEnabled: widget.tiltGesturesEnabled!,
            myLocationButtonEnabled: widget.myLocationButtonEnabled!,
            myLocationEnabled: widget.myLocationEnabled!,
            layoutDirection: widget.layoutDirection,
            padding: widget.padding!,
            buildingsEnabled: widget.buildingsEnabled!,
            // markers: createMarker(entry),
            markers: _marker,
          );
        });
  }

  // Method create marker
  Set<Marker> createMarker(List<MarkerData> entry) {
    entry.forEach((element) async {
      if (element.icon != null) {
        if (element.icon!.assetIcon != 'null' ||
            element.icon!.netIcon != 'null') {
          iconMarker = await Containts.getMarkerIcon(
            element.icon!,
            size: element.icon!.size!,
            addBorder: true,
            borderColor: Colors.red,
          );
        } else if (element.icon!.text!.isNotEmpty &&
            element.icon!.text != 'null') {
          iconMarker = await Containts.getBytesFromCanvas(
              element.icon!.text ?? 'null',
              size: element.icon!.size!);
        }

        setState(() {});
      }

      /// add[Marker]
      _marker.add(
        Marker(
          markerId: MarkerId(element.markerId),
          alpha: element.alpha,
          position: LatLng(element.position!.lat!, element.position!.long!),
          anchor: element.anchor!,
          flat: element.flat,
          rotation: element.rotation!,
          visible: element.visible!,
          zIndex: element.zIndex!,
          infoWindow: element.infoWindow ?? InfoWindow.noText,
          onTap: element.onTap,
          draggable: element.draggable!,
          // icon: customIcon!,
          icon: iconMarker != null
              ? BitmapDescriptor.fromBytes(iconMarker!)
              : BitmapDescriptor.defaultMarker,
          onDrag: element.onDrag == null
              ? null
              : (value) {
                  /// Set [OnDragLatlong] into jsonwidgetRegistry
                  widget.data.registry.setValue('OnDragLatlong', value);
                  element.onDrag!();
                },
          onDragStart: element.onDragStart != null
              ? (latlng) {
                  ///Set [onDragStartLatlng] into JsonwidgetRegistry
                  widget.data.registry.setValue('onDragStartLatlng', latlng);
                  element.onDragStart!();
                }
              : null,
          onDragEnd: element.onDragEnd != null
              ? (value) {
                  /// Set [onDragEndLatlng] into jsonWidgetRegistry
                  widget.data.registry.setValue('onDragEndLatlng', value);
                  element.onDragEnd!();
                }
              : null,
        ),
      );
    });

    ///[_marker] if marker is  Null it return _marker null
    /// if marker !Null it return values's marker

    return _marker;
  }

// Menthod called when map is create
  void _onCreateMap(GoogleMapController controller) {
    googleMapController.complete(controller);
  }

  ///[initCameraPosition] zoom first when open google map,
  Future<void> initCameraPosition() async {
    final controller = await googleMapController.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
  }
}

class MyMarker extends StatelessWidget {
  // declare a global key and get it trough Constructor

  MyMarker(this.globalKeyMyWidget);
  final GlobalKey globalKeyMyWidget;

  @override
  Widget build(BuildContext context) {
    // wrap your widget with RepaintBoundary and
    // pass your global key to RepaintBoundary
    return RepaintBoundary(
      key: globalKeyMyWidget,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 180,
            decoration:
                BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          Container(
              width: 220,
              height: 150,
              decoration:
                  BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.accessibility,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    'Widget',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
