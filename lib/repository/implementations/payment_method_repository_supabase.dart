import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/repository/payment_method_repository.dart';

class PaymentMethodRepositorySupabase extends PaymentMethodRepository {
  final supabase = Supabase.instance.client;
  var localStorage = SharedPreferencesGotrueAsyncStorage();

  @override
  Future<void> deletePaymentMethod(PaymentMethod item) {
    // TODO: implement deletePaymentMethod
    throw UnimplementedError();
  }

  @override
  Future<Iterable<PaymentMethod>> getAllPaymentMethods() async {
    var result = await supabase.from('payment_methods').select() as List;
    return result.map<PaymentMethod>((e) => PaymentMethod.fromJson(e));
  }

  @override
  Future<PaymentMethod> getLastUsedPaymentMethod() {
    return localStorage
        .getItem(key: 'last_used_payment_method')
        .then((value) async {
      if (value == null) {
        return await getAllPaymentMethods().then((value) => value.first);
      }
      return PaymentMethod.fromJson(jsonDecode(value));
    });
  }

  @override
  Future<void> savePaymentMethod(PaymentMethod paymentMethod) {
    // TODO: implement savePaymentMethod
    throw UnimplementedError();
  }

  @override
  Future<void> saveLastUsedPaymentMethod(PaymentMethod paymentMethod) {
    return localStorage.setItem(
        key: 'last_used_payment_method',
        value: jsonEncode(paymentMethod.toJson()));
  }
}