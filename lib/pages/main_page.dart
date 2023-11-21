import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/pages/home_page.dart';
import 'package:supashop/pages/login/login_page.dart';
import 'package:supashop/pages/order/order_list_page.dart';
import 'package:supashop/pages/profile/profile_page.dart';
import 'package:supashop/pages/search_page.dart';
import 'package:supashop/services/authentication_service.dart';
import 'package:supashop/widgets/logo_app.dart';

import '../util/util.dart';

class MainPage extends StatefulWidget {
  static var routePath = '/';
  int selectedTab;

  MainPage({this.selectedTab = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AuthenticationService authServive = Get.find();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      useDrawer: false,
      selectedIndex: widget.selectedTab,
      onSelectedIndexChange: onSelectedIndexChange,
      leadingExtendedNavRail: LogoApp(),
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home'.tr,
          tooltip: 'Home page'.tr,
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          selectedIcon: Icon(Icons.saved_search),
          label: 'Search'.tr,
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.list),
          label: 'Orders'.tr,
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'Profile'.tr,
        ),
      ],
      body: (context) => SafeArea(
        bottom: false,
        child: buildBody(),
      ),
      bodyRatio: 9 / 16,
    );
  }

  void exit() {
    AuthenticationService service = Get.find();
    service.logout();
  }

  Future<void> onSelectedIndexChange(int index) async {
    if (index > 0 && authServive.currentAccount == null) {
      var user = await Get.toNamed(LoginPage.routePath);
      if (user == null) return;
    }
    setState(() => widget.selectedTab = index);
  }

  Widget buildBody() {
    switch (widget.selectedTab) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return OrderListPage();
      case 3:
        return ProfilePage();
    }
    return skeleton();
  }

  void showNotifications() {}

  Widget skeleton() {
    return ListView(
      padding: EdgeInsets.all(kPadding),
      children: [
        for (var i = 0; i < 5; i++)
          Container(
            padding: EdgeInsets.all(kPaddingInternal),
            margin: EdgeInsets.all(kPaddingInternal),
            // decoration: BoxDecoration(color: Colors.white),
            child: SkeletonItem(
                child: Column(
              children: [
                Row(
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          shape: BoxShape.circle, width: 50, height: 50),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SkeletonParagraph(
                        style: SkeletonParagraphStyle(
                            lines: 3,
                            spacing: 6,
                            lineStyle: SkeletonLineStyle(
                              randomLength: true,
                              height: 10,
                              borderRadius: BorderRadius.circular(8),
                              minLength: MediaQuery.of(context).size.width / 6,
                              maxLength: MediaQuery.of(context).size.width / 3,
                            )),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                      lines: 3,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        randomLength: true,
                        height: 10,
                        borderRadius: BorderRadius.circular(8),
                        minLength: MediaQuery.of(context).size.width / 2,
                      )),
                ),
                SizedBox(height: 12),
                SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    minHeight: MediaQuery.of(context).size.height / 8,
                    maxHeight: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                        SizedBox(width: 8),
                        SkeletonAvatar(
                            style: SkeletonAvatarStyle(width: 20, height: 20)),
                      ],
                    ),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 16,
                          width: 64,
                          borderRadius: BorderRadius.circular(8)),
                    )
                  ],
                )
              ],
            )),
          ),
      ],
    );
  }
}