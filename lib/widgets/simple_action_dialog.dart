import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/util.dart';
import 'error_dialog.dart';

class SimpleActionDialogFuture<T> extends SimpleActionDialog {
  Future<T> future;
  List<Widget> Function(T) buildChildrenFuture;

  SimpleActionDialogFuture(
      {required this.future,
      required super.title,
      required super.actionLabel,
      required super.action,
      required this.buildChildrenFuture,
      super.children}) {
    children ??= [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return SimpleActionDialog(
            title: super.title,
            actionLabel: 'Close'.tr,
            action: () {
              Get.back();
              return true;
            },
            children: [...children!, CircularProgressIndicator()],
          );
        }
        if (snap.hasError) return ErrorDialog(snap.error.toString());
        children!.addAll(buildChildrenFuture(snap.data as T));
        return super.build(context);
      },
    );
  }
}

class SimpleActionDialog extends StatelessWidget {
  String title;
  String actionLabel;
  FutureOr<bool?> Function() action;
  List<Widget>? children;
  Color? actionColor;
  var loadding = false.obs;

  SimpleActionDialog({
    required this.title,
    required this.actionLabel,
    required this.action,
    this.children,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(kPadding),
      title: Text(
        title,
        style: Get.textTheme.headlineMedium,
      ),
      children: [
        for (var c in children ?? []) c,
        SizedBox(height: kPadding),
        Obx(
          () => ElevatedButton(
            onPressed: loadding.value ? null : actionDialog,
            child: Text(loadding.value ? 'Wait...'.tr : actionLabel),
          ),
        ),
        SizedBox(height: kPadding),
        OutlinedButton(
          child: Text('Cancel'.tr),
          onPressed: Get.back,
        )
      ],
    );
  }

  void actionDialog() async {
    bool? result;
    loadding.trigger(true);
    try {
      result = await action();
    } catch (ex, st) {
      print(st);
      Get.dialog(ErrorDialog(ex));
    }
    loadding.trigger(false);
    if (result != false) Get.back();
  }
}