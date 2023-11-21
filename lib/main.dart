import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/purchase_item.dart';
import 'package:supashop/login_middlewar.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/pages/main_page.dart';
import 'package:supashop/pages/product/product_view_page.dart';
import 'package:supashop/pages/profile/profile_page.dart';
import 'package:supashop/pages/store/store_view_page.dart';
import 'package:supashop/repository/product_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/loadding_widget.dart';

import 'configure.dart' if (dart.library.html) 'configure_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var middlewares = [LoginMiddlewar()];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Precast template',
      theme: getThemeLight(),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.light,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: getSupportedLocales(),
      //initialRoute:  ProfilePage.routePath,
      getPages: [
        GetPage(name: LoginPage.routePath, page: () => LoginPage()),
        GetPage(name: '/', page: () => MainPage()),
        GetPage(name: MainPage.routePath, page: () => MainPage()),
        GetPage(
            name: EstablishmentViewPage.routePath,
            page: () => EstablishmentViewPage()),
        GetPage(
          name: ProductViewPage.routePath,
          page: openProductViewPage,
        ),
        GetPage(
          name: ProfilePage.routePath,
          page: () => MainPage(selectedTab: 4),
          middlewares: middlewares,
        ),
      ],
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }

  var tileTheme = ListTileThemeData(
    iconColor: Colors.grey,
    leadingAndTrailingTextStyle: TextStyle(color: Colors.grey),
    titleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    subtitleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
    ),
  );

  ThemeData getThemeLight() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget openProductViewPage() {
    var editCartItem = Get.parameters.containsKey('editCartItem');
    Product? product = editCartItem
        ? (Get.arguments as PurchaseItem?)?.product
        : Get.arguments;
    if (product != null) {
      return ProductViewPage(
        product: product,
        editCartItem: editCartItem,
        countProduct: int.parse(Get.parameters['count'] ?? '1'),
      );
    }
    var id = Get.parameters['id']!;
    return LoaddingWidget.future(
      future: Get.find<ProductRepository>().getProductById(id),
      builder: (product) => ProductViewPage(product: product),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}