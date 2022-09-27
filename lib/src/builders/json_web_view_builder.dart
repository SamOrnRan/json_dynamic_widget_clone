import 'dart:async';
import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JsonWebViewBuilder extends JsonWidgetBuilder {
  JsonWebViewBuilder(
      {this.initialUrl,
      this.navigationDelegate,
      this.debuggingEnabled,
      this.gestureNavigationEnabled,
      this.zoomEnabled})
      : super(numSupportedChildren: kNumSupportedChildren);
  static const kNumSupportedChildren = 1;
  static const type = 'web_view';
  final String? initialUrl;
  final String? navigationDelegate;
  final bool? debuggingEnabled;
  final bool? gestureNavigationEnabled;
  final bool? zoomEnabled;

  static JsonWebViewBuilder? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonWebViewBuilder? webViewBuilder;
    if (map != null) {
      webViewBuilder = JsonWebViewBuilder(
          initialUrl: map['initialUrl'].toString(),
          navigationDelegate: map['navigationDelegate'],
          debuggingEnabled: JsonClass.parseBool(map['debuggingEnabled']),
          gestureNavigationEnabled:
              JsonClass.parseBool(map['gestureNavigationEnabled']),
          zoomEnabled: JsonClass.parseBool(['zoomEnabled']));
    }

    return webViewBuilder;
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    return WebViewWidget(
      newInitialUrl: initialUrl ?? "",
      data: data,
      childBuilder: childBuilder,
      newNavigationDelegate: navigationDelegate,
      newZoomEnabled: zoomEnabled,
    );
  }
}

class WebViewWidget extends StatefulWidget {
  const WebViewWidget(
      {Key? key,
      required this.newInitialUrl,
      this.childBuilder,
      required this.data,
      this.newNavigationDelegate,
      this.newDebuggingEnabled,
      this.newGestureNavigationEnabled,
      this.newZoomEnabled})
      : super(key: key);
  final String newInitialUrl;
  final String? newNavigationDelegate;
  final bool? newDebuggingEnabled;
  final bool? newGestureNavigationEnabled;
  final bool? newZoomEnabled;
  final ChildWidgetBuilder? childBuilder;
  final JsonWidgetData data;

  @override
  State<WebViewWidget> createState() => _WebViewWidget();
}

class _WebViewWidget extends State<WebViewWidget> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String url = "";

  @override
  void initState() {
    url = widget.newInitialUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container();
    } else {
      return WebView(
        initialUrl: url,
        debuggingEnabled: widget.newDebuggingEnabled ?? false,
        gestureNavigationEnabled: widget.newGestureNavigationEnabled ?? false,
        zoomEnabled: widget.newZoomEnabled ?? true,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onWebResourceError: (error) {
          print(error.toString());
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      );
    }
  }
}
