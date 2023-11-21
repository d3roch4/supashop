import 'package:supashop/entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<PaymentMethod> getLastUsedPaymentMethod();

  Future<Iterable<PaymentMethod>> getAllPaymentMethods();

  Future<void> savePaymentMethod(PaymentMethod paymentMethod);

  Future<void> saveLastUsedPaymentMethod(PaymentMethod paymentMethod);

  Future<void> deletePaymentMethod(PaymentMethod item);
}