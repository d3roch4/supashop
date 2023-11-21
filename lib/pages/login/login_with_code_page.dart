import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/next_focus.dart';
import 'package:supashop/util/util.dart';

class LoginWithCodeCredentials extends StatelessWidget {
  var email = TextEditingController();
  var phone = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 24),
            Text(
              "Access with my data".tr,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                  labelText: 'Whats your e-mail?'.tr,
                  prefixIcon: Icon(Icons.mail),
                  hintText: 'You e-mail'.tr),
              validator: emailValidator,
              maxLines: 1,
              onEditingComplete: nextFocusEditingComplete,
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                  labelText: 'Whats your phone number?'.tr,
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'mask-phone-number'.tr),
              maxLines: 1,
              onEditingComplete: receiverCode,
              validator: defaultValidator,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 24),
            Text(
                "We will send a code to your E-mail and SMS to access your account!"
                    .tr)
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text("Receiver code".tr),
        onPressed: receiverCode,
      ).paddingAll(16),
    );
  }

  Future<void> receiverCode() async {
    if (!formKey.currentState!.validate()) return;
    var result = await Get.to(() => LoginCodeVerifier(),
        routeName: LoginPage.routePath, preventDuplicates: false);
    Get.back(result: result);
  }
}

class LoginCodeVerifier extends StatelessWidget {
  String? code;
  AuthenticationService userManagerService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 24),
          Text(
            "Código de Verificação",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            "Digite o código de verificação recebido via E-mail e SMS abaixo!"
                .tr,
          ),
          SizedBox(height: 16),
          PinCodeTextField(
            appContext: context,
            length: 6,
            autoFocus: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              inactiveFillColor: Colors.transparent,
              inactiveColor: Colors.grey,
              selectedFillColor: Colors.transparent,
              selectedColor: Colors.black,
              activeColor: Colors.grey,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              borderWidth: 1,
              activeBorderWidth: 1,
              inactiveBorderWidth: 1,
              fieldHeight: 56,
              fieldWidth: (Get.width - 52) / 6,
              activeFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              code = v;
              debugPrint("Completed pin: $v");
              verify();
            },
            // onTap: () {
            //   print("Pressed");
            // },
            onChanged: (value) {
              debugPrint(value);
            },
            beforeTextPaste: (text) {
              debugPrint("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        child: Text('Verify code'.tr),
        onPressed: verify,
      ).paddingAll(16),
    );
  }

  Future<void> verify() async {
    if (code != '123456') return;

    var user = null; //await userManagerService.signIn();
    Get.back(result: user);
  }
}