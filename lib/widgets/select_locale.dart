import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/util.dart';

class SelectLocale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locales = getSupportedLocales();
    return Obx(() => DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
          items: locales
              .map((e) => DropdownMenuItem<Locale>(
                    child: Text(e.toLanguageTag().tr),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (c) => locales
              .map((e) => Row(children: [
                    Icon(Icons.language),
                    SizedBox(width: kPaddingInternal),
                    Text(e.toLanguageTag().tr)
                  ]))
              .toList(),
          onChanged: updateLocale,
          value: locales.contains(localeSelected.value)
              ? localeSelected.value
              : null,
        )));
  }

  void updateLocale(Locale? value) {
    localeSelected.value = value!;
    if (value != null) changeLocale(value);
  }
}