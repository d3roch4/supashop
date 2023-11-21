import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:medartor/medartor.dart';
import 'package:supashop/operations/add_product_to_cart.dart';
import 'package:supashop/repository/address_repository.dart';
import 'package:supashop/repository/cart_repository.dart';
import 'package:supashop/repository/implementations/address_repository_localstorage.dart';
import 'package:supashop/repository/implementations/cart_repository_localstorage.dart';
import 'package:supashop/repository/implementations/order_repository_supabase.dart';
import 'package:supashop/repository/implementations/payment_method_repository_supabase.dart';
import 'package:supashop/repository/implementations/product_repository_supabase.dart';
import 'package:supashop/repository/implementations/profile_repository_supabase.dart';
import 'package:supashop/repository/implementations/store_repository_supabase.dart';
import 'package:supashop/repository/order_repository.dart';
import 'package:supashop/repository/payment_method_repository.dart';
import 'package:supashop/repository/product_repository.dart';
import 'package:supashop/repository/profile_repository.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/services/supabase_authenticaton_service.dart';
import 'package:supashop/util/http_client_auth.dart';
import 'package:supashop/util/local_storage/local_storage.dart';
import 'package:supashop/util/local_storage/local_storage_shared_preference_impl.dart';
import 'package:supashop/util/locale.dart';

import 'widgets/snack_messages.dart';

Future<void> configureApp() async {
  await Get.putAsync<AuthenticationService>(() async {
    var service = SupabaseAuthenticationService();
    await service.initialize();
    // await service.logout();
    return service;
  }, permanent: true);

  Get.lazyPut<http.Client>(() => HttpClientAuth(), fenix: true);
  await configureLocalStorage();
  await configureRepositories();
  configureMediator();

  //Future.delayed(Duration(seconds: 30), defaultErrorHandler);

  var user = await Get.find<AuthenticationService>().loadUser();
  if (user != null) Get.put(user, permanent: true);
  await initializeDateFormatting();
  var locale = await getDefaultLocale();
  await changeLocale(locale);
}

void configureMediator() {
  var mediator = Medartor();
  mediator.register(AddProductToCartHandler());
  Get.put(mediator, permanent: true);
}

Future<void> configureLocalStorage() async {
  await LocalStorageSharedPreferencesImpl.init();
  Get.lazyPut<LocalStorage>(() => LocalStorageSharedPreferencesImpl(),
      fenix: true);
}

Future<void> configureRepositories() async {
  Get.lazyPut<StoreRepository>(() => StoreRepositorySupabase(), fenix: true);
  Get.lazyPut<CartRepository>(() => LocalStorageCartRepository(), fenix: true);
  Get.lazyPut<AddressRepository>(() => AddressRepositoryLocalstorage(),
      fenix: true);
  Get.lazyPut<PaymentMethodRepository>(() => PaymentMethodRepositorySupabase(),
      fenix: true);
  Get.lazyPut<OrderRepository>(() => OrderRepositorySupabase(), fenix: true);
  Get.lazyPut<ProductRepository>(() => ProductRepositorySupabase(),
      fenix: true);
  Get.lazyPut<ProfileRepository>(() => ProfileRepositorySupabase(),
      fenix: true);
}

void defaultErrorHandler() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    snackError(details.exception.toString(), stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    snackError(error.toString(), stackTrace: stack);
    return true;
  };
}