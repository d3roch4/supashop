import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/widgets/simple_action_dialog.dart';

import '../util/util.dart';

class ErrorDialog extends StatelessWidget {
  String message;

  ErrorDialog(Object message, [StackTrace? stackTrace])
      : message = message.toString() {
    if (stackTrace != null) printError(info: stackTrace.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SelectableText(message);

    return SimpleActionDialog(
      title: '',
      actionLabel: 'Close'.tr,
      action: () {
        Get.back();
        return true;
      },
      children: [
        Icon(Icons.thumbs_up_down,
            color: Get.theme.colorScheme.error, size: 80),
        SizedBox(height: kPadding),
        Text('Something went wrong!'.tr, style: Get.textTheme.headlineSmall),
        content,
      ],
    );
  }
}