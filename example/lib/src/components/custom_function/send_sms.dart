import 'package:flutter_sms/flutter_sms.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

JsonWidgetFunction launchUrlBody =
    (({args, required JsonWidgetRegistry registry}) => () async {
          if (args != null) {
            var phoneNumber = args[0];
            var message = args[1];
            if (args[1] == 'message') {
              message = registry.getValue(args[1]);
            }

            await sendSMS(
                    message: message.toString(),
                    recipients: ["$phoneNumber"],
                    sendDirect: false)
                .catchError((onError) {
              print(onError);
            });
          }
        });
const String key = 'send_sms';
