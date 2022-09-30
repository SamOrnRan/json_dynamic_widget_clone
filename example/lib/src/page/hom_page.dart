import 'dart:convert';

import 'package:automated_testing_framework/automated_testing_framework.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:yaon/yaon.dart' as yaon;
import '../full_widget_page.dart';
import '../issue_24_page.dart';
import '../untestable_full_widget_page.dart';

class ResetPage extends StatefulWidget {
  ResetPage({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  ResetPageState createState() => ResetPageState();
}

class ResetPageState extends State<ResetPage> {
  @override
  void initState() {
    super.initState();

    _navigateHome();
  }

  Future<void> _navigateHome() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RootPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(),
      );
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  static final _pages = {
    'align': _onJsonPageSelected,
    'animated_align': _onJsonPageSelected,
    'animated_container': _onJsonPageSelected,
    'animated_cross_fade': _onJsonPageSelected,
    'animated_default_text_style': _onJsonPageSelected,
    'animated_opacity': _onJsonPageSelected,
    'animated_padding': _onJsonPageSelected,
    'animated_physical_model': _onJsonPageSelected,
    'animated_positioned': _onJsonPageSelected,
    'animated_positioned_directional': _onJsonPageSelected,
    'animated_size': _onJsonPageSelected,
    'animated_switcher': _onJsonPageSelected,
    'animated_theme': _onJsonPageSelected,
    'aspect_ratio': _onJsonPageSelected,
    'asset_images': _onJsonPageSelected,
    'bank_example': _onJsonPageSelected,
    'baseline': _onJsonPageSelected,
    'buttons': _onJsonPageSelected,
    'card': _onJsonPageSelected,
    'center': _onJsonPageSelected,
    'checkbox': _onJsonPageSelected,
    'circular_progress_indicator': _onJsonPageSelected,
    'clips': _onJsonPageSelected,
    'conditional': _onJsonPageSelected,
    'cupertino_switch': _onYamlPageSelected,
    'decorated_box': _onJsonPageSelected,
    'directionality': _onJsonPageSelected,
    'dynamic': _onUntestablePageSelected,
    'fitted_box': _onJsonPageSelected,
    'list_pagination_page': _onJsonPageSelected,
    'form': _onJsonPageSelected,
    'fractional_translation': _onJsonPageSelected,
    'fractionally_sized_box': _onJsonPageSelected,
    'gestures': _onJsonPageSelected,
    'grid_view': _onJsonPageSelected,
    'images': _onJsonPageSelected,
    'indexed_stack': _onJsonPageSelected,
    'input_error': _onJsonPageSelected,
    'interactive_viewer': _onJsonPageSelected,
    'intrinsic_height': _onJsonPageSelected,
    'intrinsic_width': _onJsonPageSelected,
    'issue_10': _onJsonPageSelected,
    'issue_11': _onJsonPageSelected,
    'issue_12': _onJsonPageSelected,
    'issue_20_list': _onJsonPageSelected,
    'issue_20_single': _onJsonPageSelected,
    'issue_24': (context, _) async => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Issue24Page(),
          ),
        ),
    'issue_30': _onJsonPageSelected,
    'layout_builder': _onJsonPageSelected,
    'length': _onJsonPageSelected,
    'limited_box': _onJsonPageSelected,
    'linear_progress_indicator': _onJsonPageSelected,
    'list_view': _onJsonPageSelected,
    'measured': _onJsonPageSelected,
    'offstage': _onJsonPageSelected,
    'opacity': _onJsonPageSelected,
    'overflow_box': _onJsonPageSelected,
    'placeholder': _onJsonPageSelected,
    'popup_menu_button': _onJsonPageSelected,
    'scroll_view': _onJsonPageSelected,
    'set_default_value': _onJsonPageSelected,
    'simple_page': _onJsonPageSelected,
    'slivers': _onJsonPageSelected,
    'switch': _onJsonPageSelected,
    'theme': _onJsonPageSelected,
    'tooltip': _onJsonPageSelected,
    'tween_animation': _onJsonPageSelected,
    'variables': _onJsonPageSelected,
    'wrap': _onJsonPageSelected,
    'carousel_slider': _onJsonPageSelected,
    'pdf_view': _onJsonPageSelected,
    'web_view': _onJsonPageSelected,
    'simple_text_textformfile_by_me': _onJsonPageSelected,
    'show_functions': _onJsonPageSelected,
    'google_map': _onJsonPageSelected,
  };

  @override
  Widget build(BuildContext context) {
    var names = _pages.keys.toList();
    names.sort();

    return Scaffold(
      appBar: AppBar(
        actions: !kIsWeb && kDebugMode
            ? [
                IconButton(
                  icon: Icon(Icons.bug_report),
                  onPressed: () async {
                    var testController = TestController.of(context)!;
                    var tests = await testController.loadTests(context);

                    var passed = true;
                    for (var test in tests!) {
                      var report = await testController.executeTest(
                        test: await test.loader.load(ignoreImages: true),
                      );

                      if (report.success) {
                        await testController.goldenImageWriter(report);
                      }

                      passed = passed && report.success;
                    }
                  },
                ),
              ]
            : null,
        title: Text('Select Widget / Page'),
      ),
      body: ListView.builder(
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) => Testable(
          id: 'home_${names[index]}',
          child: Container(
            height: 50,
            width: double.infinity,
            child: Card(
              child: GestureDetector(
                onTap: () => _pages[names[index]]!(context, names[index]),
                child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      names[index],
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _onJsonPageSelected(
    BuildContext context,
    String pageId,
  ) =>
      _onPageSelected(context, pageId, '.json');

  static Future<void> _onPageSelected(
    BuildContext context,
    String pageId,
    String extension,
  ) async {
    var registry = JsonWidgetRegistry.instance.copyWith();
    var pageStr = await rootBundle.loadString(
      'assets/pages/${pageId}$extension',
    );
    var dataJson = yaon.parse(pageStr);

    // This is put in to give credit for when designs from online were used in
    // example files.  It's not actually a valid attribute to exist in the JSON
    // so it needs to be removed before we create the widget.
    dataJson.remove('_designCredit');

    var data = JsonWidgetData.fromDynamic(
      dataJson,
      registry: registry,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => FullWidgetPage(
          data: data!,
        ),
      ),
    );
  }

  static Future<void> _onYamlPageSelected(
    BuildContext context,
    String pageId,
  ) =>
      _onPageSelected(context, pageId, '.yaml');

  static Future<void> _onUntestablePageSelected(
    BuildContext context,
    String themeId,
  ) async {
    var registry = JsonWidgetRegistry.instance.copyWith();
    var pageStr = await rootBundle.loadString('assets/pages/$themeId.json');
    var dataJson = json.decode(pageStr);

    // This is put in to give credit for when designs from online were used in
    // example files.  It's not actually a valid attribute to exist in the JSON
    // so it needs to be removed before we create the widget.
    dataJson.remove('_designCredit');

    var data = JsonWidgetData.fromDynamic(
      dataJson,
      registry: registry,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UntestableFullWidgetPage(
          data: data!,
        ),
      ),
    );
  }
}
