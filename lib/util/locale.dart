import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supashop/util/local_storage/local_storage.dart';

var localeSelected = Get.deviceLocale!.obs;

var timeFormat = DateFormat.Hm(localeSelected.value.toLanguageTag());
var dateFormat = DateFormat.yMd(localeSelected.value.toLanguageTag());
var dateTimeFormat =
    DateFormat.yMd(localeSelected.value.toLanguageTag()).add_Hms();
var numberFormat = NumberFormat.decimalPatternDigits(
    locale: localeSelected.value.toLanguageTag(), decimalDigits: 1);
var currencyFormat = NumberFormat.simpleCurrency(
    locale: localeSelected.value.toLanguageTag(), name: 'BRL');

void _updateFormaters() {
  timeFormat = DateFormat.Hm(localeSelected.value.toLanguageTag());
  dateFormat = DateFormat.yMd(localeSelected.value.toLanguageTag());
  dateTimeFormat =
      DateFormat.yMd(localeSelected.value.toLanguageTag()).add_Hms();
  numberFormat =
      NumberFormat.decimalPattern(localeSelected.value.toLanguageTag());
  currencyFormat = NumberFormat.simpleCurrency(
      locale: localeSelected.value.toLanguageTag(), name: 'BRL');
}

List<Locale> getSupportedLocales() => [
      Locale('pt', 'BR'),
    ];

Future<Locale> getDefaultLocale() async {
  String? savedLocade = await Get.find<LocalStorage>().read('locale');
  if (savedLocade == null) return localeSelected.value = Get.deviceLocale!;
  var divCountryIndex = savedLocade.indexOf('_');
  var lang = savedLocade.substring(
      0, divCountryIndex.isNegative ? null : divCountryIndex);
  var country = divCountryIndex.isNegative
      ? null
      : savedLocade.substring(divCountryIndex + 1);
  localeSelected.value = Locale(lang, country);
  _updateFormaters();
  return localeSelected.value;
}

Future<void> changeLocale(Locale locale) async {
  if (getSupportedLocales().contains(locale)) {
    try {
      String langCod =
          '${locale.languageCode}${locale.countryCode != null ? '_${locale.countryCode}' : ''}';
      String data = await rootBundle.loadString('i18n/$langCod.json');
      var jsonData = Map<String, String>.from(json.decode(data));
      var translations = {langCod: jsonData};
      Get.appendTranslations(translations);
      Get.updateLocale(locale);
      await Get.find<LocalStorage>().write('locale', langCod);
    } catch (ex, st) {
      print(ex);
      debugPrintStack(stackTrace: st);
    }
  }
  _updateFormaters();
}