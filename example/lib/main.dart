import 'dart:convert';
import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:automated_testing_framework_plugin_images/automated_testing_framework_plugin_images.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:example/src/components/clipper.dart';
import 'package:example/src/components/custom_function/send_sms.dart'
    as send_sms;
import 'package:example/src/components/custom_function/share_build.dart'
    as share_build;
import 'package:example/src/components/custom_function/show_dialog.dart'
    as show_dialog_fun;
import 'package:example/src/components/custom_function/toast_build.dart'
    as toast_build;
import 'package:example/src/custom_schemas/dotted_border_schema.dart';
import 'package:example/src/custom_schemas/svg_schema.dart';
import 'package:example/src/dotted_border_builder.dart';
import 'package:example/src/page/hom_page.dart';
import 'package:example/src/page/page_detial.dart';
import 'package:example/src/svg_builder.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme_schemas.dart';
import 'package:logging/logging.dart';
import 'src/full_widget_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TestAppSettings.initialize(appIdentifier: 'JSON Dynamic Widget');
  var testRegistry = TestStepRegistry.instance;
  TestImagesHelper.registerTestSteps(testRegistry);

  if (!kIsWeb &&
      (Platform.isLinux ||
          Platform.isFuchsia ||
          Platform.isMacOS ||
          Platform.isWindows)) {
    await DesktopWindow.setWindowSize(Size(1024, 768));
  }

  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('${record.stackTrace}');
    }
  });

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
    'noop': ({args, required registry}) => () {},
    'toPageDitail': ({args, required registry}) => () async {
          var getvalue = registry.getValue(args![0]);
          registry.setValue('description', getvalue['disription']);
          registry.setValue('image', getvalue['image']);
          registry.setValue('getvalueName', getvalue['name']);

          final root =
              await rootBundle.loadString('assets/pages/page_detial.json');
          final valueroot = json.decode(root);

          await navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (BuildContext context) => PageDetailJsonDynamicWidget(
                  valueroot: valueroot, registry: registry)));
        },
    'validateForm': ({args, required registry}) => () {
          BuildContext context = registry.getValue(args![0]);

          var valid = Form.of(context)!.validate();
          registry.setValue('form_validation', valid);
        },
    'updateCustomTextStyle': ({args, required registry}) => () {
          registry.setValue(
            'customTextStyle',
            TextStyle(
              color: Colors.black,
            ),
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
    show_dialog_fun.key: show_dialog_fun.body,
    send_sms.key: send_sms.launchUrlBody,
    share_build.key: share_build.shareBody,
    toast_build.key: toast_build.toastBody,
  });

  registry.setValue('customRect', Rect.largest);
  registry.setValue('clipper', Clipper());

  var assetTestStore = AssetTestStore(
    testAssetIndex: 'assets/testing/tests/all.json',
  );

  var desktop = !kIsWeb &&
      (Platform.isFuchsia ||
          Platform.isLinux ||
          Platform.isMacOS ||
          Platform.isWindows);

  var ioTestStore = IoTestStore();

  var testController = TestController(
    goldenImageWriter:
        !desktop ? TestStore.goldenImageWriter : ioTestStore.goldenImageWriter,
    navigatorKey: navigatorKey,
    onReset: () async => navigatorKey.currentState!.popUntil(
      (route) => navigatorKey.currentState!.canPop() != true,
    ),
    registry: testRegistry,
    testImageReader: !desktop
        ? TestStore.testImageReader
        : (desktop && kDebugMode)
            ? ioTestStore.testImageReader
            : ({
                required TestDeviceInfo deviceInfo,
                required String imageId,
                String? suiteName,
                required String testName,
                int? testVersion,
              }) async {
                var path = 'assets/testing/images';

                if (suiteName?.isNotEmpty == true) {
                  path = '${path}/_Suite_${suiteName}_';
                } else {
                  path = '$path/';
                }

                path = '${path}Test_${testName}_$imageId.png';

                Uint8List? image;

                try {
                  image = (await rootBundle.load(path)).buffer.asUint8List();
                } catch (e) {
                  // no_op
                }

                return image;
              },
    testReader: kIsWeb || !kDebugMode || !desktop
        ? assetTestStore.testReader
        : ioTestStore.testReader,
    testReporter: !desktop ? TestStore.testReporter : ioTestStore.testReporter,
    testWriter:
        !desktop ? ClipboardTestStore.testWriter : ioTestStore.testWriter,
    variables: {
      CompareGoldenImageStep.kDisableGoldenImageFailOnMissingVariable:
          kIsWeb || kDebugMode,
    },
  );

  runApp(
    TestRunner(
      controller: testController,
      enabled: !kReleaseMode,
      testableRenderController: TestableRenderController(
        gestures: TestableGestures(
          overlayDoubleTap: TestableGestureAction.toggle_global_overlay,
          overlayLongPress: TestableGestureAction.toggle_overlay,
          overlayTap: TestableGestureAction.open_test_actions_page,
          widgetDoubleTap: null,
          widgetLongPress: TestableGestureAction.toggle_overlay,
        ),
      ),
      theme: ThemeData.light(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: kReleaseMode
            ? RootPage()
            : ResetPage(
                navigatorKey: navigatorKey,
              ),
        navigatorKey: navigatorKey,
        theme: ThemeData.light(),
      ),
    ),
  );
}
