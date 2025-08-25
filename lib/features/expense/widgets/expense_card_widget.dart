import 'package:stackfood_multivendor_restaurant/features/expense/domain/models/expense_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseCardWidget extends StatelessWidget {
  final Expense expense;
  const ExpenseCardWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
      ),
      margin: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall), topRight: Radius.circular(Dimensions.radiusSmall)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: -3, blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Row(children: [
            Text('${'order'.tr} # ', style: robotoRegular),
            Text(expense.orderId.toString(), style: robotoBold),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text(
                  DateConverter.dateTimeStringToDateTime(expense.createdAt!),
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                Text('amount'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Row(children: [
                  Text('${'expense_type'.tr} - ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(expense.type!.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
                ]),

                Text(PriceConverter.convertPrice(expense.amount), textDirection: TextDirection.ltr, style: robotoBold.copyWith(fontSize: 17)),

              ]),
            ],
          ),
        ),
      ]),
    );
  }
}