import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/repository/payment_method_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/bottom_conteiner.dart';
import 'package:supashop/widgets/card_brand_icon.dart';

class PaymentMethodCardFormPage extends StatelessWidget {
  PaymentMethodType type;
  var formKey = GlobalKey<FormState>();
  var cardNumber = TextEditingController();
  var expirationDate = TextEditingController();
  var cvv = TextEditingController();
  var holderName = TextEditingController();
  var documentNumber = TextEditingController();
  var cardName = TextEditingController();
  var maskDocumentNumber = MaskTextInputFormatter(
    mask: "###.###.###-##",
    filter: {"#": RegExp(r'[0-9]')},
  );
  var paymentMethod =
      PaymentMethod(name: 'name', type: PaymentMethodType.unknow, onApp: true)
          .obs;
  PaymentMethodRepository repository = Get.find();

  PaymentMethodCardFormPage(
      {super.key, required this.type, PaymentMethod? paymentMethod}) {
    if (paymentMethod != null) {
      this.paymentMethod.value = paymentMethod;
      cardNumber.text = paymentMethod.cardNumber ?? '';
      expirationDate.text = paymentMethod.expirationDate ?? '';
      cvv.text = paymentMethod.cvv ?? '';
      holderName.text = paymentMethod.holderName ?? '';
      documentNumber.text = paymentMethod.documentNumber ?? '';
      cardName.text = paymentMethod.name;
    }
    this.paymentMethod.value.type = type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card'.tr)),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(kPadding),
            children: [
              TextFormField(
                controller: cardNumber,
                decoration: InputDecoration(
                  labelText: 'Card number'.tr,
                  hintText: '0000 0000 0000 0000',
                  prefixIcon: Obx(() => CardBrandIcon(
                        paymentMethod: paymentMethod.value,
                      )),
                ),
                validator: defaultValidator,
                keyboardType: TextInputType.number,
                onChanged: detectBrandCard,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "#### #### #### ####",
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
              ).paddingOnly(bottom: 16),
              Row(children: [
                Flexible(
                    child: TextFormField(
                  controller: expirationDate,
                  decoration: InputDecoration(
                    labelText: 'Expiration date'.tr,
                    hintText: 'MM/YY'.tr,
                  ),
                  keyboardType: TextInputType.number,
                  validator: defaultValidator,
                  inputFormatters: [MaskTextInputFormatter(mask: "##/##")],
                )),
                const SizedBox(width: 16),
                Flexible(
                    child: TextFormField(
                  controller: cvv,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '000',
                  ),
                  keyboardType: TextInputType.number,
                  validator: defaultValidator,
                  inputFormatters: [MaskTextInputFormatter(mask: "###")],
                )),
              ]).paddingOnly(bottom: 16),
              TextFormField(
                controller: holderName,
                decoration: InputDecoration(
                  labelText: 'Cardholder name'.tr,
                  hintText: 'Full name'.tr,
                ),
                keyboardType: TextInputType.name,
                validator: fullNameValidator,
              ).paddingOnly(bottom: 16),
              TextFormField(
                controller: documentNumber,
                decoration: InputDecoration(
                  labelText: 'Holder\'s document number'.tr,
                  hintText: '000.000.000-00'.tr,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: defaultValidator,
                onChanged: updateMaskDocumentNumber,
              ).paddingOnly(bottom: 16),
              TextFormField(
                controller: cardName,
                decoration: InputDecoration(
                  labelText: 'Card nickname (optional)'.tr,
                  hintText: 'Ex.: Cartão de Crédito Verde'.tr,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ).paddingOnly(bottom: 16),
            ],
          )),
      bottomNavigationBar: BottomConteiner(
          child: ElevatedButton(child: Text('Save'.tr), onPressed: save)),
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    paymentMethod.value.cardNumber = cardNumber.text;
    paymentMethod.value.holderName = holderName.text;
    paymentMethod.value.cvv = cvv.text;
    paymentMethod.value.expirationDate = expirationDate.text;
    paymentMethod.value.documentNumber = documentNumber.text;
    paymentMethod.value.name = cardName.text;
    await repository.savePaymentMethod(paymentMethod.value);
    Get.back(result: paymentMethod.value);
  }

  void updateMaskDocumentNumber(String value) {
    if (value.length < 15) {
      maskDocumentNumber.updateMask(mask: "###.###.###-##");
    } else {
      maskDocumentNumber.updateMask(mask: "##.###.###/####-##");
    }
    value = maskDocumentNumber.maskText(value);
    documentNumber.text = value;
    documentNumber.selection = TextSelection.fromPosition(
        TextPosition(offset: documentNumber.text.length));
  }

  void detectBrandCard(String value) {
    var types = detectCCType(value);
    if (types.isNotEmpty && value.length > 3) {
      var type = types.first;
      paymentMethod.value.brand = type.type;
      if (paymentMethod.value.brand == 'american_express')
        paymentMethod.value.brand = 'amex';
    } else {
      paymentMethod.value.brand = '';
    }
    paymentMethod.refresh();
  }
}