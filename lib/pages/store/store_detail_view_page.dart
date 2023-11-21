import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/opening_hour.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/widgets/back_button_blur.dart';
import 'package:supashop/widgets/classification_view.dart';
import 'package:supashop/widgets/image_cover_and_logo_establishment.dart';

import '../../util/util.dart';

class EstablishmentDetailViewPage extends StatelessWidget {
  final Store establishment;
  var styleHour = Get.textTheme.labelSmall;

  EstablishmentDetailViewPage({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(children: [
          ImageCoverAndLogoEstablhishment(establishment),
          Positioned(top: 16, left: 16, child: BackButtonBlur()),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  establishment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ClassificationView(establishment.classification),
            ],
          ),
          Text(
            '${'Document number'.tr}: ${establishment.documentNumber}',
          ),
          SizedBox(height: 48),
          if (establishment.openingHours.isNotEmpty)
            Text(
              'Opening hours'.tr,
            ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (var weekday in establishment.openingHours.keys)
                    Text(dateFormat.dateSymbols.WEEKDAYS[weekday],
                        style: styleHour),
                ]),
                SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (var hour in establishment.openingHours.values)
                    Text(openingHourString(hour), style: styleHour),
                ]),
              ])),
          SizedBox(height: 56),
          Text(
            'Address'.tr,
          ),
          Text(
            '${establishment.address.toString()}',
          ),
          SizedBox(height: 16),
          Center(
              child: Chip(
            label: Text('The store delivers to your region!'.tr,
                overflow: TextOverflow.ellipsis),
          )),
          SizedBox(height: 64),
          Text(
            'The prices practiced are stipulated by the establishment itself.'
                .tr,
          )
        ]).paddingAll(16),
      ]),
    );
  }

  String openingHourString(List<OpeningHour> openingHour) {
    return '${openingHour.map((e) => '${timeFormat.format(e.start)} ás ${timeFormat.format(e.end)}').join(' - ')}';
  }
}