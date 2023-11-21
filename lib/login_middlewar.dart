import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/services/authentication_service.dart';

class LoginMiddlewar extends GetMiddleware {
  AuthenticationService service = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if (service.currentAccount == null)
      return RouteSettings(
          name: '${LoginPage.routePath}?redirect=$route',
          arguments: Get.arguments);

    return null;
  }
}