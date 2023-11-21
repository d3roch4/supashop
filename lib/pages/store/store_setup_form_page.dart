import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/store_repository.dart';
import 'package:supashop/util/currency_input_format.dart';

import '../../util/util.dart';

class StoreSetupFormPage extends StatefulWidget {
  Store store;

  StoreSetupFormPage({required this.store});

  @override
  State<StoreSetupFormPage> createState() => _StoreSetupFormPageState();
}

class _StoreSetupFormPageState extends State<StoreSetupFormPage> {
  StoreRepository storeRepository = Get.find();
  var percentFeeController = TextEditingController();
  var fixedFeeController = TextEditingController();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.store.name)),
      body: ListView(
        padding: EdgeInsets.all(kPadding),
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Activate store'.tr),
            value: widget.store.activated,
            onChanged: activateStore,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Percentagem fee'.tr, suffixText: '%'),
            controller: percentFeeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: saveSetup,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Fixed fee'.tr, suffixText: widget.store.currency),
            controller: fixedFeeController,
            keyboardType: TextInputType.number,
            onChanged: saveSetup,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(currencyFormat),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    storeRepository.getStoreSetup(widget.store.id!).then((value) {
      percentFeeController.text = value.percentFee.toString();
      fixedFeeController.text = value.fixedFee.toString();
    });
  }

  @override
  void dispose() {
    percentFeeController.dispose();
    fixedFeeController.dispose();
    super.dispose();
  }

  Future<void> activateStore(bool? value) async {
    await storeRepository.saveActiveStatus(widget.store.id!, value == true);
    setState(() => widget.store.activated = value == true);
  }

  void saveSetup(_) {
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), () async {
      var setup = StoreSetup(
        storeId: widget.store.id!,
        percentFee: double.parse(percentFeeController.text),
        fixedFee: int.parse(fixedFeeController.text),
      );
      await storeRepository.saveStoreSetup(setup);
    });
  }
}