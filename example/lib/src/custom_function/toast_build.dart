import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import '../ultil/constand.dart';

JsonWidgetFunction toastBody =
    (({args, required JsonWidgetRegistry registry}) => () {
          var value = registry.getValue(args![0]);

          var fromDynamic = {
            'message': value['content'],
            //
            'backgroundColor': value['backgroundColor'] != null
                ? HexColor(value['backgroundColor'])
                : Colors.grey,
            //
            'textColor': value['textColor'] != null
                ? HexColor(value['textColor'])
                : Colors.white,
            //
            'fontSize': value['fontSize'] != null
                ? double.parse(value['fontSize'].toString())
                : 16.0,
            'gravity': value['gravity'],
            //
            'webShowClose': value['webShowClose'] ?? false,
            //
            'timeInSecForIosWeb': value['timeInSecForIosWeb'],
          };
          //

          if (fromDynamic['timeInSecForIosWeb'] != null) {
            fromDynamic['timeInSecForIosWeb'] =
                int.parse(value['timeInSecForIosWeb'].toString());
          } else {
            fromDynamic['timeInSecForIosWeb'] = int.parse(1.toString());
          }

          switch (fromDynamic['gravity']) {
            case 'top':
              fromDynamic['gravity'] = ToastGravity.TOP;
              break;
            case 'bottom':
              fromDynamic['gravity'] = ToastGravity.BOTTOM;
              break;
            case 'center':
              fromDynamic['gravity'] = ToastGravity.CENTER;
              break;
            default:
              fromDynamic['gravity'] = ToastGravity.BOTTOM;
          }
          if (value['toastLength'] != null) {
            switch (value['toastLength']) {
              case 'length_long':
                fromDynamic['toastLength'] = Toast.LENGTH_LONG;
                break;
              case 'length_short':
                fromDynamic['toastLength'] = Toast.LENGTH_SHORT;
                break;
              default:
            }
          } else {
            fromDynamic['toastLength'] = Toast.LENGTH_SHORT;
          }
          Fluttertoast.showToast(
              msg: fromDynamic['message'] ?? "",
              toastLength: fromDynamic['toastLength'],
              backgroundColor: fromDynamic['backgroundColor'],
              fontSize: fromDynamic['fontSize'],
              webBgColor: fromDynamic['webShowClose'],
              timeInSecForIosWeb: fromDynamic['timeInSecForIosWeb'],
              gravity: fromDynamic['gravity'],
              textColor: fromDynamic['textColor']);
        });
const String key = "toast_show";
