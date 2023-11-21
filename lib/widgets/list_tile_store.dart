import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/store.dart';

import '../util/util.dart';
import 'classification_view.dart';

var nameStyle = Get.textTheme.titleLarge!;
var info1Style = Get.textTheme.bodySmall;
var info2Style = Get.textTheme.labelMedium;

class ListTileStore extends StatelessWidget {
  Store item;
  bool isGrid;
  EdgeInsets padding;
  ValueChanged<Store>? onTap;

  ListTileStore(this.item,
      {this.isGrid = false, this.padding = EdgeInsets.zero, this.onTap});

  @override
  Widget build(BuildContext context) {
    var tags = [
      for (var tag in item.tags)
        Chip(
          label: Text(tag),
        ).paddingOnly(right: kPaddingInternal, top: kPaddingInternal),
    ];
    Widget tile = Row(children: [
      if (item.image != null)
        Hero(
          tag: 'image-${item.id}',
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: item.image!,
            width: 56,
            height: 56,
          ),
        ),
      SizedBox(width: kPaddingInternal),
      Expanded(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                  child: Hero(
                    tag: 'title-${item.id}',
                    child: Text(item.name, style: nameStyle),
                  )),
              ClassificationView(item.classification),
            ]),
            Text(item.description, style: info1Style),
            isGrid
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tags,
              ),
            )
                : Wrap(children: tags),
          ])),
    ]);

    if (isGrid)
      tile = Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: tile,
        ),
      );

    tile = Padding(
      padding: padding,
      child: tile,
    );

    if (onTap != null)
      tile = InkWell(
        child: tile,
        onTap: () => onTap!(item),
      );

    return tile;
  }
}