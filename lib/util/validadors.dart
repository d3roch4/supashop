import 'package:get/get.dart';
import 'package:supashop/util/locale.dart';

import 'string_util.dart';

String? fullNameValidator(String? value) {
  if (value.isEmptyOrNull()) return 'This field is requerid'.tr;
  return value!.split(' ').length < 2 ? 'Fullname is required'.tr : null;
}

String? defaultValidator(dynamic value) {
  if (value == null ||
      ((value is String || value is Iterable) && value.isEmpty))
    return 'This field is requerid'.tr;

  return null;
}

String? onlyNumberValidator(String? value) {
  // if (value.isEmptyOrNull()) return 'This field is requerid'.tr;
  if (value!.isEmpty) return null;
  try {
    var r = numberFormat.parse(value!);
  } catch (_) {
    return 'Only numbers'.tr;
  }
  return null;
}

String? emailValidator(String? value) {
  if (value.isEmptyOrNull()) return 'This field is requerid'.tr;
  if (!value!.contains('@')) return 'e-mail invalid'.tr;
  return null;
}