import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/util/util.dart';

class VerifyEmailLinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'.tr),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(kPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 100),
            Text('Please check your email to verify your account'.tr),
            SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}