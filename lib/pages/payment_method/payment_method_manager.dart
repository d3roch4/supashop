import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supashop/entities/payment_method.dart';
import 'package:supashop/pages/payment_method/payment_method_card_form_page.dart';
import 'package:supashop/repository/payment_method_repository.dart';
import 'package:supashop/util/util.dart';
import 'package:supashop/widgets/bottom_conteiner.dart';
import 'package:supashop/widgets/modal_bottom_sheet.dart';
import 'package:supashop/widgets/payment_method_view.dart';
import 'package:supashop/widgets/simple_action_dialog.dart';

class PaymentMethodManagerPage extends StatefulWidget {
  PaymentMethod? paymentMethod;

  PaymentMethodManagerPage({
    this.paymentMethod,
  });

  @override
  State<PaymentMethodManagerPage> createState() =>
      _PaymentMethodManagerPageState();
}

class _PaymentMethodManagerPageState extends State<PaymentMethodManagerPage> {
  var allPaymentMethodsFuture =
      Get.find<PaymentMethodRepository>().getAllPaymentMethods();
  PaymentMethodRepository repository = Get.find<PaymentMethodRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment method'.tr)),
      body: FutureBuilder<Iterable<PaymentMethod>>(
        future: allPaymentMethodsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var paymentMethods = snapshot.data!;
            return ListView(
              children: paymentMethods
                  .where((e) => e.onApp)
                  .map((e) => ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: e == widget.paymentMethod
                                      ? Colors.primaries.first
                                      : Colors.grey),
                              borderRadius: BorderRadius.circular(8)),
                          title: PaymentMethodView(paymentMethod: e),
                          onTap: widget.paymentMethod == null
                              ? null
                              : () => Get.back(result: e),
                          trailing: IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () => optionsItem(e),
                          ))
                      .paddingOnly(
                          left: kPadding, right: kPadding, bottom: kPadding))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'.tr));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomConteiner(
          child:
              ElevatedButton(child: Text('Add card'.tr), onPressed: addCard)),
    );
  }

  void addCard() {
    ModalBottomSheet.show(
        context: Get.context!,
        title: 'Choose a way to pay'.tr,
        content: Column(
          children: [
            ListTile(
              title: Text('Credit'.tr),
              leading: Icon(Icons.credit_card),
              onTap: () => newCard(PaymentMethodType.creditCard),
            ),
            Divider(),
            ListTile(
              title: Text('Debit'.tr),
              leading: Icon(Icons.credit_card),
              onTap: () => newCard(PaymentMethodType.debitCard),
            ),
          ],
        ));
  }

  Future<void> newCard(PaymentMethodType type) async {
    Get.back();
    var newCard = await Get.to(() => PaymentMethodCardFormPage(type: type));
    if (newCard == null) return;
    widget.paymentMethod = newCard;
    allPaymentMethodsFuture =
        Get.find<PaymentMethodRepository>().getAllPaymentMethods();
    if (widget.paymentMethod == null)
      Get.back(result: widget.paymentMethod);
    else
      setState(() {});
  }

  void optionsItem(PaymentMethod item) {
    ModalBottomSheet.show(
        context: context,
        title: item.name,
        content: Column(
          children: [
            ListTile(
              title: Text('Edit'.tr),
              leading: Icon(Icons.edit),
              onTap: () => editItem(item),
            ),
            Divider(),
            ListTile(
              title: Text('Delete'.tr, style: TextStyle(color: Colors.red)),
              leading: Icon(Icons.delete, color: Colors.red),
              onTap: () => deleteItem(item),
            ),
          ],
        ));
  }

  Future<void> deleteItem(PaymentMethod item) async {
    Get.back();
    var confirm = await Get.dialog(SimpleActionDialog(
      title:
          "Are you sure you want to remove the card '%s'?".trArgs([item.name]),
      actionLabel: 'Yes, remove'.tr,
      actionColor: Colors.red,
      action: () async {
        await repository.deletePaymentMethod(item);
        setState(() {
          allPaymentMethodsFuture = repository.getAllPaymentMethods();
        });
      },
    ));
  }

  Future<void> editItem(PaymentMethod item) async {
    Get.back();
    var edited = await Get.to(
        () => PaymentMethodCardFormPage(type: item.type, paymentMethod: item));
    if (edited == null) return;
    setState(() {
      allPaymentMethodsFuture = repository.getAllPaymentMethods();
    });
  }
}