import 'package:example/src/components/clipper.dart';
import 'package:example/src/custom_schemas/dotted_border_schema.dart';
import 'package:example/src/custom_schemas/svg_schema.dart';
import 'package:example/src/dotted_border_builder.dart';
import 'package:example/src/initial_registry.dart';
import 'package:example/src/page/hom_page.dart';
import 'package:example/src/svg_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
// ignore: implementation_imports
import 'package:json_theme/json_theme_schemas.dart';
// import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var navigatorKey = GlobalKey<NavigatorState>();
  // This is needed to adding custom schema validations
  var schemaCache = SchemaCache();
  schemaCache.addSchema(SvgSchema.id, SvgSchema.schema);
  schemaCache.addSchema(DottedBorderSchema.id, DottedBorderSchema.schema);
  var registry = JsonWidgetRegistry.instance;
  registry.navigatorKey = navigatorKey;
  registry.registerCustomBuilder(
    DottedBorderBuilder.type,
    JsonWidgetBuilderContainer(
      builder: DottedBorderBuilder.fromDynamic,
      schemaId: DottedBorderSchema.id,
    ),
  );
  registry.registerCustomBuilder(
    SvgBuilder.type,
    JsonWidgetBuilderContainer(
      builder: SvgBuilder.fromDynamic,
      schemaId: SvgSchema.id,
    ),
  );

  ///[InitialRegistry] is  a class
  /// [init] Is a multi-part method
  /// meaning it working all functions and another procces
  InitialRegistry.init(registry, navigatorKey: navigatorKey);

  // registry.registerFunctions({
  //   'getImageAsset': ({args, required registry}) =>
  //       'assets/images/image${args![0]}.jpg',
  //   'getImageId': ({args, required registry}) => 'image${args![0]}',
  //   'getImageNavigator': ({args, required registry}) => () async {
  //         registry.setValue('index', args![0]);
  //         var dataStr =
  //             await rootBundle.loadString('assets/pages/image_page.json');
  //         final imagePageJson = Map.unmodifiable(json.decode(dataStr));
  //         var imgRegistry = JsonWidgetRegistry(
  //           debugLabel: 'ImagePage',
  //           values: {
  //             'imageAsset': 'assets/images/image${args[0]}.jpg',
  //             'imageTag': 'image${args[0]}',
  //           },
  //         );

  //         await navigatorKey.currentState!.push(
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => FullWidgetPage(
  //               data: JsonWidgetData.fromDynamic(
  //                 imagePageJson,
  //                 registry: imgRegistry,
  //               )!,
  //             ),
  //           ),
  //         );
  //       },
  //   'func1': ({args, required registry}) => () {
  //         ImplementationMarker instance =
  //             registry.getValue('valueChnageNotifier');
  //         // print('value test lat Long ');
  //         var lat = registry.getValue('OnDraglat');
  //         var long = registry.getValue('OnDraglong');
  //         var i = args![0];

  //         instance.updateMarkerLatLng(lat, long, index: i);

  //         // log('$i$lat$long');
  //       },
  //   'noop': ({args, required registry}) => () {},
  //   'toPageDitail': ({args, required registry}) => () async {
  //         var getvalue = registry.getValue(args![0]);
  //         registry.setValue('description', getvalue['disription']);
  //         registry.setValue('image', getvalue['image']);
  //         registry.setValue('getvalueName', getvalue['name']);

  //         final root =
  //             await rootBundle.loadString('assets/pages/page_detial.json');
  //         final valueroot = json.decode(root);

  //         await navigatorKey.currentState!.push(
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => PageDetailJsonDynamicWidget(
  //                 valueroot: valueroot, registry: registry),
  //           ),
  //         );
  //       },
  //   'validateForm': ({args, required registry}) => () {
  //         BuildContext context = registry.getValue(args![0]);

  //         var valid = Form.of(context)!.validate();
  //         registry.setValue('form_validation', valid);
  //       },
  //   'updateCustomTextStyle': ({args, required registry}) => () {
  //         registry.setValue(
  //           'customTextStyle',
  //           TextStyle(color: Colors.yellow, fontSize: 50),
  //         );
  //       },
  //   'getCustomTweenBuilder': ({args, required registry}) =>
  //       (BuildContext context, dynamic size, Widget? child) {
  //         return IconButton(
  //           icon: child!,
  //           iconSize: size,
  //           onPressed: () {
  //             var _current = registry.getValue('customSize');
  //             var _size = _current == 50.0 ? 100.0 : 50.0;
  //             registry.setValue('customSize', _size);
  //           },
  //         );
  //       },
  //   'getCustomTween': ({args, required registry}) {
  //     return Tween<double>(begin: 0, end: args![0]);
  //   },
  //   'setWidgetByKey': ({args, required registry}) => () {
  //         var _replace = registry.getValue(args![1]);
  //         registry.setValue(args[0], _replace);
  //       },
  //   'simplePrintMessage': ({args, required registry}) => () {
  //         var message = 'This is a simple print message';

  //         if (args?.isEmpty == false) {
  //           for (var arg in args!) {
  //             message += ' $arg';
  //           }
  //         }

  //         // ignore: avoid_print
  //         print(message);
  //       },
  //   'testFromGooglemapMarker': ({args, required registry}) => () {
  //         var message = 'This is a simple print message';

  //         List<dynamic> getlatlng = registry.getValue('marker');

  //         print(getlatlng.toString());
  //         log(message);
  //       },

  //   'AddMap': ({args, required registry}) => () async {
  //         var obj = registry.getValue('addvalue');
  //         Completer<GoogleMapController> controller =
  //             registry.getValue('google_map_controller');
  //         log(controller.toString());

  //         /// Craete [ImplementationMarker] for get properties
  //         /// and Controll on
  //         ImplementationMarker instance =
  //             registry.getValue('valueChnageNotifier');

  //         /// Method [updateMarkerLatLng] chang latLng  by assign new value
  //         // instance.updateMarkerLatLng(11.575614187720012, 104.92313789529904,
  //         //     index: 0);
  //         instance.add(obj);

  //         final controllers = await controller.future;
  //         await controllers.animateCamera(
  //           CameraUpdate.newCameraPosition(
  //             CameraPosition(
  //                 target: LatLng(obj['latLng']['lat'], obj['latLng']['long']),
  //                 zoom: 19.0),
  //           ),
  //         );

  //         // log('value LatLng : $latLng');
  //       },
  //   'negateBool': ({args, required registry}) => () {
  //         bool value = registry.getValue(args![0]);
  //         registry.setValue(args[0], !value);
  //       },
  //   'buildPopupMenu': ({args, required registry}) {
  //     const choices = ['First', 'Second', 'Third'];
  //     return (BuildContext context) {
  //       return choices
  //           .map(
  //             (choice) => PopupMenuItem(
  //               value: choice,
  //               child: Text(choice),
  //             ),
  //           )
  //           .toList();
  //     };
  //   },

  //   // Custome function
  //   show_dialog_fun.key: show_dialog_fun.body,
  //   send_sms.key: send_sms.launchUrlBody,
  //   share_build.key: share_build.shareBody,
  //   toast_build.key: toast_build.toastBody,
  // });

  registry.setValue('customRect', Rect.largest);
  registry.setValue('clipper', Clipper());

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: kReleaseMode
          ? RootPage()
          : ResetPage(
              navigatorKey: navigatorKey,
            ),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // ignore: deprecated_member_use
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
    ),
  );
}
