import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';

class AdsSectionWidget extends StatelessWidget {
  const AdsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomCard(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [

            const CustomAssetImageWidget(image: Images.adsImage, height: 70, width: 70,),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text('want_to_get_highlighted'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              'create_ads_to_get_highlighted_on_the_app_and_web_browser'.tr,
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomButtonWidget(
              margin: EdgeInsets.symmetric(horizontal: context.width*0.2),
              buttonText: 'create_ads'.tr,
              onPressed: (){
                if(Get.find<ProfileController>().modulePermission!.newAds!){
                  Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
                    if(trialEnd) {
                      Get.toNamed(RouteHelper.getCreateAdvertisementRoute());
                    }
                  });
                }else{
                  showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                }
              },
            ),

          ]),
        ),

        Positioned(top: 0, right: 0,
          child: CustomAssetImageWidget(image: Images.adsRoundShape, height: 100),
        ),

        Positioned(bottom: 0, left: 0,
          child: CustomAssetImageWidget(image: Images.adsCurveShape, height: 100),
        ),

      ],
    );
  }
}

