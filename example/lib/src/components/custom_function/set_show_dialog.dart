import 'package:example/src/components/custom_function/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class CustomDialog {
  void showCustomDialog({
    required dynamic buildContextVarName,
    required dynamic dialogDataVarName,
    required JsonWidgetRegistry registry,
  }) async {
    BuildContext context = registry.getValue(buildContextVarName);
    var dialogData = DialogData.fromJson(registry.getValue(dialogDataVarName));

    var title = JsonWidgetData.fromDynamic(
      dialogData.title,
      registry: registry,
    )!
        .build(
      context: context,
    );
    var content = JsonWidgetData.fromDynamic(
      dialogData.content,
      registry: registry,
    )!
        .build(context: context);
    List<Widget> actions = dialogData.actions
        .map(
          (actionData) => TextButton(
            onPressed: () {
              actionData.onPressed();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: JsonWidgetData.fromDynamic(
              actionData.title,
              registry: registry,
            )!
                .build(context: context),
          ),
        )
        .toList();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}
