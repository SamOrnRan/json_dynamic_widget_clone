import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:example/src/components/custom_function/send_sms.dart'
    as send_sms;
import 'package:example/src/components/custom_function/share_build.dart'
    as share_build;
import 'package:example/src/components/custom_function/show_dialog.dart'
    as show_dialog_fun;
import 'package:example/src/components/custom_function/toast_build.dart'
    as toast_build;
import 'package:example/src/full_widget_page.dart';
import 'package:example/src/page/page_detial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
// ignore: implementation_imports
import 'package:json_dynamic_widget/src/utils/add_marker.dart';

class InitialRegistry {
  static void init(JsonWidgetRegistry registry,
      {required GlobalKey<NavigatorState> navigatorKey}) {
    registry.registerFunctions({
      'getImageAsset': ({args, required registry}) =>
          'assets/images/image${args![0]}.jpg',
      'getImageId': ({args, required registry}) => 'image${args![0]}',
      'getImageNavigator': ({args, required registry}) => () async {
            registry.setValue('index', args![0]);
            var dataStr =
                await rootBundle.loadString('assets/pages/image_page.json');
            final imagePageJson = Map.unmodifiable(json.decode(dataStr));
            var imgRegistry = JsonWidgetRegistry(
              debugLabel: 'ImagePage',
              values: {
                'imageAsset': 'assets/images/image${args[0]}.jpg',
                'imageTag': 'image${args[0]}',
              },
            );

            await navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (BuildContext context) => FullWidgetPage(
                  data: JsonWidgetData.fromDynamic(
                    imagePageJson,
                    registry: imgRegistry,
                  )!,
                ),
              ),
            );
          },
      'func1': ({args, required registry}) => () {},
      'noop': ({args, required registry}) => () {},
      'toPageDitail': ({args, required registry}) => () async {
            var getvalue = registry.getValue(args![0]);
            registry.setValue('description', getvalue['disription']);
            registry.setValue('image', getvalue['image']);
            registry.setValue('getvalueName', getvalue['name']);

            final root =
                await rootBundle.loadString('assets/pages/page_detial.json');
            final valueroot = json.decode(root);

            await navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (BuildContext context) => PageDetailJsonDynamicWidget(
                    valueroot: valueroot, registry: registry),
              ),
            );
          },
      'validateForm': ({args, required registry}) => () {
            BuildContext context = registry.getValue(args![0]);

            var valid = Form.of(context)!.validate();
            registry.setValue('form_validation', valid);
          },
      'updateCustomTextStyle': ({args, required registry}) => () {
            registry.setValue(
              'customTextStyle',
              TextStyle(color: Colors.yellow, fontSize: 50),
            );
          },
      'getCustomTweenBuilder': ({args, required registry}) =>
          (BuildContext context, dynamic size, Widget? child) {
            return IconButton(
              icon: child!,
              iconSize: size,
              onPressed: () {
                var _current = registry.getValue('customSize');
                var _size = _current == 50.0 ? 100.0 : 50.0;
                registry.setValue('customSize', _size);
              },
            );
          },
      'getCustomTween': ({args, required registry}) {
        return Tween<double>(begin: 0, end: args![0]);
      },
      'setWidgetByKey': ({args, required registry}) => () {
            var _replace = registry.getValue(args![1]);
            registry.setValue(args[0], _replace);
          },
      'simplePrintMessage': ({args, required registry}) => () {
            var message = 'This is a simple print message';

            if (args?.isEmpty == false) {
              for (var arg in args!) {
                message += ' $arg';
              }
            }

            // ignore: avoid_print
            print(message);
          },
      'testFromGooglemapMarker': ({args, required registry}) => () async {
            ImplementationMarker markers =
                registry.getValue('valueChnageNotifier');

            var index = int.parse(args![0]);

            var message =
                'This is a simple print message : ${markers.markerModify.value.length.toString()}';
            Completer<GoogleMapController> controller =
                registry.getValue('google_map_controller');

            // List<dynamic> marker = registry.getValue('marker');
            // log()
            final controllers = await controller.future;

            await controllers.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        markers.markerModify.value[index].position!.lat!,
                        markers.markerModify.value[index].position!.long!),
                    zoom: 19.0),
              ),
            );
            log(message);
          },

      'zoomtoMap': ({args, required registry}) => () async {
            List<dynamic> obj = registry.getValue(args![0]);
            var count = registry.getValue(args[1]);
            Completer<GoogleMapController> controller =
                registry.getValue('google_map_controller');

            ImplementationMarker instance =
                registry.getValue('valueChnageNotifier');
            final tozoom = await controller.future;
            // count = count++;

            if (count <= obj.length) {
              registry.setValue(args[1], count + 1);
              await tozoom.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(instance.markerModify.value[count].position!.lat!,
                      instance.markerModify.value[count].position!.long!),
                  19.0));
            }
            if (count + 1 == obj.length) {
              registry.setValue(args[1], 0);
            }
          },
      'onDragEnd': ({args, required registry}) => () async {
            ImplementationMarker instance =
                registry.getValue('valueChnageNotifier');
            var index = args![0];
            Completer<GoogleMapController> controller =
                registry.getValue('google_map_controller');
            LatLng latLng = registry.getValue('onDragEndLatlng');

            // registry.setValue(marker[0]['latLng']['long'], latLng.longitude);
            instance.updateMarkerLatLng(latLng.latitude, latLng.longitude,
                index: index);

            final controllers = await controller.future;
            await controllers.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(latLng.latitude, latLng.longitude),
                    zoom: 19.0),
              ),
            );
            // log(' $latLng');
          },
      'negateBool': ({args, required registry}) => () {
            bool value = registry.getValue(args![0]);
            registry.setValue(args[0], !value);
          },
      'buildPopupMenu': ({args, required registry}) {
        const choices = ['First', 'Second', 'Third'];
        return (BuildContext context) {
          return choices
              .map(
                (choice) => PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                ),
              )
              .toList();
        };
      },

      // Custome function
      show_dialog_fun.key: show_dialog_fun.body,
      send_sms.key: send_sms.launchUrlBody,
      share_build.key: share_build.shareBody,
      toast_build.key: toast_build.toastBody,
    });
  }
}
