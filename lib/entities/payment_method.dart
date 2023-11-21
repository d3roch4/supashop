import 'package:supashop/entities/entity.dart';

enum PaymentMethodType { unknow, creditCard, debitCard, cash }

class PaymentMethod extends Entity {
  String name;
  PaymentMethodType type;
  bool onApp;
  String? brand;
  String? cardNumber;
  String? holderName;
  String? expirationDate;
  String? cvv;
  bool withProblems;
  String? documentNumber;

  factory PaymentMethod.cash() => PaymentMethod(
        id: 'cash',
        name: 'Money',
        type: PaymentMethodType.cash,
        onApp: false,
      );

  PaymentMethod({
    super.id,
    required this.name,
    required this.type,
    required this.onApp,
    this.brand,
    this.cardNumber,
    this.holderName,
    this.expirationDate,
    this.cvv,
    this.documentNumber,
    this.withProblems = false,
  }) {
    if (type == PaymentMethodType.cash)
      assert(onApp == false, 'onApp must be false if type is MONEY');
    if (type == PaymentMethodType.cash) name = 'Money';
  }

  String get operationName {
    switch (type) {
      case PaymentMethodType.creditCard:
        return 'Credit';
      case PaymentMethodType.debitCard:
        return 'Debit';
      default:
        return '';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.index,
      'onApp': onApp,
      if (brand != null) 'brand': brand,
      if (cardNumber != null) 'cardNumber': cardNumber,
      if (holderName != null) 'holderName': holderName,
      if (expirationDate != null) 'expirationDate': expirationDate,
      if (cvv != null) 'cvv': cvv,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (withProblems) 'withProblems': withProblems,
    };
  }

  static fromJson(json) {
    return PaymentMethod(
      name: json['name'],
      type: PaymentMethodType.values[json['type']],
      onApp: json['onApp'],
      brand: json['brand'],
      cardNumber: json['cardNumber'],
      holderName: json['holderName'],
      expirationDate: json['expirationDate'],
      cvv: json['cvv'],
      documentNumber: json['documentNumber'],
      withProblems: json['withProblems'] ?? false,
    );
  }
}