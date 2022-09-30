import 'package:flutter_share/flutter_share.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

JsonWidgetFunction shareBody = ({
  List<dynamic>? args,
  required JsonWidgetRegistry registry,
}) =>
    () async {
      if (args != null) {
        var title = args[0];
        dynamic valueLinkUrl = args[1];
        await FlutterShare.share(title: title ?? "", linkUrl: valueLinkUrl);
      }
    };
const String key = 'share';
