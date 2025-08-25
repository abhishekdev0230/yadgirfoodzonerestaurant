import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/add_coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/widgets/coupon_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponCardDialogueWidget extends StatelessWidget {
  final CouponBodyModel couponBody;
  final int index;
  const CouponCardDialogueWidget({super.key, required this.couponBody, required this.index});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 500,
        child: Container(
          width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.52,
          padding: const EdgeInsets.only(
            left: Dimensions.paddingSizeExtraLarge,
            top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraLarge,
          ),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.transparent,
            image: DecorationImage(image: const AssetImage(Images.couponDetails), fit: BoxFit.fill,
              colorFilter: Get.isDarkMode ? ColorFilter.mode(Colors.black.withValues(alpha: 0.2), BlendMode.dstATop) : null,
            ),
          ),
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [

                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: Theme.of(context).hintColor, size: 20),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(children: [

                    SizedBox(
                      height: 50, width: 50,
                      child: Image.asset(couponBody.discountType == 'percent' ? Images.couponVertical : Images.cashIcon),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${'${couponBody.couponType == 'free_delivery' ? 'free_delivery'.tr : couponBody.discountType != 'percent' ?
                      PriceConverter.convertPrice(double.parse(couponBody.discount.toString())) :
                      couponBody.discount}'} ${couponBody.couponType == 'free_delivery' ? '' : couponBody.discountType == 'percent' ? '% ' : ''}'
                          '${couponBody.couponType == 'free_delivery' ? '' : 'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: 20), textDirection: TextDirection.ltr,
                      ),
                      Text('${couponBody.code}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]),
                    const Spacer(),

                    GetBuilder<CouponController>(builder: (couponController) {
                      return Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeTrackColor: Theme.of(context).primaryColor,
                          value: couponController.couponList![index].status == 1 ? true : false,
                          onChanged: (bool status){
                            couponController.changeStatus(couponController.couponList![index].id, status).then((success) {
                              if(success){
                                couponController.getCouponList();
                              }
                            });
                          },
                        ),
                      );
                    }),

                  ]),
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Container(
                   padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'start_date'.tr} : ${DateConverter.stringToLocalDateOnly(couponBody.startDate!)}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'end_date'.tr} :  ${DateConverter.stringToLocalDateOnly(couponBody.startDate!)}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'total_user'.tr} : ${couponBody.totalUses.toString()}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'limit_for_same_user'.tr} : ${couponBody.limit.toString()}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'discount'.tr} : ${'${couponBody.couponType == 'free_delivery' ? 'free_delivery'.tr : couponBody.discountType != 'percent' ?
                  PriceConverter.convertPrice(double.parse(couponBody.discount.toString())) :
                  couponBody.discount}'} ${couponBody.couponType == 'free_delivery' ? '' : couponBody.discountType == 'percent' ? '% ' : ''}'
                      '${couponBody.couponType == 'free_delivery' ? '' : 'off'.tr}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'maximum_discount'.tr} : ${PriceConverter.convertPrice(double.parse(couponBody.maxDiscount.toString()))}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('${'minimum_order_amount'.tr} : ${PriceConverter.convertPrice(double.parse(couponBody.minPurchase.toString()))}',
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ]),

              Align(
                alignment: Alignment.bottomCenter,
                child: GetBuilder<CouponController>(builder: (couponController) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraLarge),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                      InkWell(
                        onTap: (){
                          Get.back();
                          Get.to(()=> AddCouponScreen(coupon: couponController.couponList![index]));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                      InkWell(
                        onTap: (){
                          Get.back();
                          showCustomBottomSheet(
                            child: CouponDeleteBottomSheet(
                              couponId: couponController.couponList![index].id!,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.error, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(CupertinoIcons.trash_fill, color: Theme.of(context).colorScheme.error, size: 20),
                        ),
                      ),

                    ]),
                  );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}