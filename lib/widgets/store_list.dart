import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as sliver;
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';
import 'package:supashop/entities/address.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/store_repository.dart';

import '../util/util.dart';
import 'list_tile_store.dart';

class StoreListByAddress extends StatefulWidget {
  void Function(Store item) openItem;
  Future<Address> address;

  StoreListByAddress(
      {super.key, required this.openItem, required this.address});

  @override
  State<StoreListByAddress> createState() => StoreListByAddressState();
}

class StoreListByAddressState extends State<StoreListByAddress> {
  final pageSize = kDebugMode ? 5 : 20;
  var pagingController = PagingController<int, Store>(firstPageKey: 0);
  StoreRepository repository = Get.find();

  void refresh(Future<Address> address) {
    widget.address = address;
    pagingController.refresh();
  }

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
        builder: (context, constraints) => constraints.crossAxisExtent < 800
            ? buildList(constraints)
            : buildGrid(constraints));
  }

  Widget buildList(sliver.SliverConstraints constraints) {
    return PagedSliverList<int, Store>.separated(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Store>(
        itemBuilder: (context, item, index) => ListTileStore(
          item,
          isGrid: false,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          onTap: (item) => widget.openItem(item),
        ),
        firstPageProgressIndicatorBuilder: (context) => buildSkeleton(),
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }

  Widget buildGrid(sliver.SliverConstraints constraints) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      sliver: PagedSliverGrid(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Store>(
          itemBuilder: (context, item, index) => ListTileStore(item,
              isGrid: true, onTap: (item) => widget.openItem(item)),
          firstPageProgressIndicatorBuilder: (context) => buildSkeleton(),
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: kPadding,
          crossAxisSpacing: kPadding,
          maxCrossAxisExtent: 500,
          childAspectRatio: 132 / 45,
        ),
      ),
    );
  }

  Widget buildSkeleton() {
    return SizedBox(
      height: 800,
      child: Column(children: [
        for (var i = 0; i < 8; i++)
          Container(
            padding: EdgeInsets.all(kPaddingInternal),
            margin: EdgeInsets.symmetric(vertical: kPaddingInternal),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
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
          ),
      ]),
    );
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await repository.getStoresListByAddress(
          await widget.address, pageKey, pageSize);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.toList());
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems.toList(), nextPageKey);
      }
    } catch (error, stackTrace) {
      pagingController.error = error;
      debugPrintStack(label: error.toString(), stackTrace: stackTrace);
    }
  }
}