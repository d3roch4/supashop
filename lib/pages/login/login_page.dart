import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/pages/login/verify_email_link_page.dart';
import 'package:supashop/pages/main_page.dart';
import 'package:supashop/pages/profile/profile_edit_personal_data.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/util/validadors.dart';

class LoginPage extends StatefulWidget {
  static var routePath = '/login';
  String? redirect;

  LoginPage({super.key}) {
    redirect = Get.parameters['redirect'];
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSent = false;
  late final TextEditingController _emailController = TextEditingController();
  AuthenticationService auth = Get.find();
  final supabase = Supabase.instance.client;
  var formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    if (!formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isSent = true;
      });
      Get.to(() => VerifyEmailLinkPage());
      sendEmail();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSent = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'.tr)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Text('Sign in via the magic link with your email below'.tr),
            SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onEditingComplete: _signIn,
              validator: emailValidator,
            ),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isSent ? null : _signIn,
              child: Text(_isSent ? 'Loading'.tr : 'Send link of login'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    var result = await auth.signIn(
      email: _emailController.text.trim(),
      emailRedirectTo:
          kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
    );
    if (result == null) return;

    if (result.name.isEmpty) {
      await Get.off(() => ProfileEditPersonalData());
    }

    Get.offAllNamed(widget.redirect ?? MainPage.routePath);
  }
}