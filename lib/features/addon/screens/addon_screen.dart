import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/widgets/addon_delete_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddonScreen extends StatefulWidget {
  const AddonScreen({super.key});

  @override
  State<AddonScreen> createState() => _AddonScreenState();
}

class _AddonScreenState extends State<AddonScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<AddonController>().getAddonList();
    Get.find<AddonController>().getAddonCategoryList();

    if(Get.find<SplashController>().configModel!.systemTaxType == 'product_wise'){
      Get.find<RestaurantController>().getVatTaxList();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: CustomAppBarWidget(title: 'addons'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
            Get.toNamed(RouteHelper.getAddAddonRoute(addon: null));
          }else {
            showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
          }
        },
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),

      body: GetBuilder<AddonController>(builder: (addonController) {
        return addonController.addonList != null ? addonController.addonList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await addonController.getAddonList();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            itemCount: addonController.addonList!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall + 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 3),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))],
                ),
                child: Row(children: [

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        addonController.addonList?[index].name ?? '',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(
                        addonController.addonList![index].price! > 0 ? PriceConverter.convertPrice(addonController.addonList![index].price) : 'free'.tr,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoBold, textDirection: TextDirection.ltr,
                      ),

                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () {
                      if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                        Get.toNamed(RouteHelper.getAddAddonRoute(addon: addonController.addonList![index]));
                      }else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, size: 15, color: Theme.of(context).cardColor),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  InkWell(
                    onTap: () {
                      if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!){
                        showCustomBottomSheet(
                          child: AddonDeleteBottomSheet(addonId: addonController.addonList![index].id!),
                        );
                      }else{
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    child: Icon(CupertinoIcons.delete_solid, size: 22, color: Theme.of(context).colorScheme.error),
                  ),

                ]),
              );
            },
          ),
        ) : Center(child: Text('no_addon_found'.tr)) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}