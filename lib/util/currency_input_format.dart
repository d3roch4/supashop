import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  NumberFormat currencyFormat;

  CurrencyInputFormatter(this.currencyFormat);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var valorFinal = newValue.text;
    var number = double.parse(valorFinal);
    number /= math.pow(10, currencyFormat.decimalDigits ?? 1);
    valorFinal = currencyFormat.format(number);

    var sufix = number.isNegative
        ? currencyFormat.negativeSuffix.length
        : currencyFormat.positiveSuffix.length;

    var offset = valorFinal.length - sufix;

    return TextEditingValue(
      text: valorFinal,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}