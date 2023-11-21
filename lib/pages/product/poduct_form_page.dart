import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supashop/entities/complement.dart';
import 'package:supashop/entities/product.dart';
import 'package:supashop/entities/store.dart';
import 'package:supashop/repository/product_repository.dart';
import 'package:supashop/util/currency_input_format.dart';
import 'package:supashop/widgets/count_number_input.dart';
import 'package:supashop/widgets/documents_picker.dart';

import '../../util/util.dart';

class ProductFormPage extends StatefulWidget {
  Store store;
  String? productId;
  List<String> images;
  String name;
  String description;
  int price;
  double preparationTime;
  List<Complement> complements;
  NumberFormat currencyFormat;

  ProductFormPage(this.store, [Product? product])
      : images = product?.images ?? [],
        name = product?.name ?? '',
        description = product?.description ?? '',
        price = product?.price ?? 0,
        preparationTime = product?.preparationTime ?? 0,
        complements = product?.complements ?? [],
        currencyFormat = NumberFormat.simpleCurrency(
          locale: localeSelected.value.toLanguageTag(),
          name: store.currency,
        ),
        productId = product?.id;

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  List<FileDocument> newImages = [];
  ProductRepository productRepository = Get.find();
  var formKey = GlobalKey<FormState>();
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add product'.tr)),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(kPadding),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'.tr),
              initialValue: widget.name,
              validator: defaultValidator,
              onChanged: (value) => widget.name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'.tr),
              initialValue: widget.description,
              onChanged: (value) => widget.description = value!,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price'.tr,
              ),
              initialValue: widget.currencyFormat.format(widget.price / 100),
              validator: defaultValidator,
              onChanged: (value) => widget.price =
                  (widget.currencyFormat.parse(value!) * 100).toInt(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(widget.currencyFormat),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Preparation time'.tr,
                suffixText: 'minutes'.tr,
              ),
              initialValue: widget.preparationTime > 0
                  ? numberFormat.format(widget.preparationTime)
                  : null,
              validator: onlyNumberValidator,
              onChanged: (value) => widget.preparationTime =
                  value!.isEmpty ? 0 : numberFormat.parse(value).toDouble(),
            ),
            DocumentsPickerViewer(
              urls: widget.images,
              onChange: (value) => newImages = value,
              addLabel: 'Add image'.tr,
            ),
            SizedBox(height: kPadding),
            for (var complement in widget.complements)
              buildComplement(complement),
            OutlinedButton(
              onPressed: addComplement,
              child: Text('Add complement'.tr),
            ),
            SizedBox(height: kPadding),
          ],
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: saveProduct,
        child: Text('Save'.tr),
      ).paddingAll(kPadding),
    );
  }

  Future<void> saveProduct() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await productRepository.saveProduct(Product(
        id: widget.productId,
        images: widget.images..addAll(newImages.map((e) => e.path!)),
        name: widget.name,
        description: widget.description,
        price: widget.price,
        preparationTime: widget.preparationTime,
        complements: widget.complements,
        storeId: widget.store.id!,
      ));
      Get.back();
    }
  }

  void addComplement() {
    widget.complements.add(Complement(
      name: '',
      description: '',
      min: 1,
      max: 1,
      itens: [],
    ));
    setState(() {});
  }

  Widget buildComplement(Complement complement) {
    var countItens = complement.itens.map((e) => e.count).sum;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextFormField(
        decoration: InputDecoration(labelText: 'Complement name'.tr),
        initialValue: complement.name,
        onChanged: (value) => complement.name = value,
        validator: defaultValidator,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Description'.tr),
        initialValue: complement.description,
        onChanged: (value) => complement.description = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Min'.tr),
        initialValue: '${complement.min ?? ''}',
        onChanged: (value) => complement.min = toIntMinMax(value),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Max'.tr),
        initialValue: '${complement.max ?? ''}',
        onChanged: (value) => complement.max = toIntMinMax(value),
      ),
      for (var item in complement.itens)
        Card(
            child: buildComplementItem(item, complement, countItens)
                .paddingAll(kPaddingInternal)),
      TextButton(
          onPressed: () => addItemComplement(complement),
          child: Text('Add item'.tr))
    ]).paddingOnly(bottom: 32);
  }

  Widget buildComplementItem(
      ComplementItem item, Complement complement, int countItens) {
    return Container(
      decoration: BoxDecoration(
        border: Border(),
      ),
      child: Row(children: [
        if (item.image.isNotEmpty)
          CachedNetworkImage(
            imageUrl: item.image,
            height: 56,
            width: 56,
            fit: BoxFit.cover,
          ).paddingOnly(right: 8),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Item name'),
            initialValue: item.name,
            onChanged: (value) => item.name = value,
            validator: defaultValidator,
          ),
          TextFormField(
            initialValue: item.description,
            decoration: InputDecoration(labelText: 'Description'.tr),
            onChanged: (value) => item.description = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Price'.tr),
            initialValue: widget.currencyFormat.format(item.price / 100),
            validator: defaultValidator,
            onChanged: (value) => item.price =
                (widget.currencyFormat.parse(value!) * 100).toInt(),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(widget.currencyFormat),
            ],
          ),
        ])),
        if (complement.onlyOne)
          Radio<String?>(
              value: item.id,
              groupValue: complement.id,
              onChanged: (value) {
                for (var i in complement.itens) i.count = 0;
                item.count = 1;
                setState(() {
                  complement.id = value;
                });
              }),
        if (!complement.onlyOne)
          CountNumberInput(
            value: item.count,
            compactIfZero: true,
            max: (complement.max ?? 0) - countItens + item.count,
            onChanged: (v) {
              item.count = v;
              setState(() {});
            },
          ),
      ]),
    );
  }

  void addItemComplement(Complement complement) {
    complement.itens.add(ComplementItem(
      name: '',
      description: '',
      image: '',
      count: 0,
      price: 0,
    ));
    setState(() {});
  }

  int? toIntMinMax(String value) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: 500), () {
      setState(() {});
    });
    return int.tryParse(value);
  }
}