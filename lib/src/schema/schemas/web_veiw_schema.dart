import 'package:json_theme/json_theme_schemas.dart';

class WebViewSchema {
  static const id = "https://your-url-here.com/schemas/web_view";
  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': 'http://json-schema.org/draft-06/schema#',
    r'$comment': 'https://pub.dev/packages/webview_flutter/example',
    'type': 'object',
    'title': 'web_view',
    'additionalProperties': false,
    'required': [
      'initialUrl',
    ],
    'properties': {
      'initialUrl': SchemaHelper.stringSchema,
      'navigationDelegate': SchemaHelper.stringSchema,
      'debuggingEnabled': SchemaHelper.boolSchema,
      'gestureNavigationEnabled': SchemaHelper.boolSchema,
      'zoomEnabled': SchemaHelper.boolSchema,
    }
  };
}
