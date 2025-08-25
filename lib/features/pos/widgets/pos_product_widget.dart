import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/controllers/pos_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/widgets/quantity_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  const PosProductWidget({super.key, required this.cart, required this.cartIndex, required this.isAvailable, required this.addOns});

  @override
  Widget build(BuildContext context) {

    String addOnText = '';
    int index = 0;
    List<int?> ids = [];
    List<int?> qtys = [];

    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }

    for (var addOn in cart.product!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index == 0) ? '' : ',  '}${addOn.name} (${qtys[index]})';
        index = index + 1;
      }
    }

    String? variationText = '';
    if(cart.variation!.isNotEmpty) {
      variationText = cart.product!.variations![0].type;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.error, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: Stack(children: [

          const Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: Colors.white, size: 50),
          ),

          Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) => Get.find<PosController>().removeFromCart(cartIndex),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
              ),
              child: Column(children: [

                Row(children: [

                  Stack(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${cart.product!.imageFullUrl}',
                        height: 65, width: 70, fit: BoxFit.cover,
                      ),
                    ),

                    isAvailable ? const SizedBox() : Positioned(
                      top: 0, left: 0, bottom: 0, right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.black.withValues(alpha: 0.6)),
                        child: Text('not_available_now_break'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(
                          color: Colors.white, fontSize: 8,
                        )),
                      ),
                    ),

                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(
                        cart.product!.name!,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      RatingBarWidget(rating: cart.product!.avgRating, size: 12, ratingCount: cart.product!.ratingCount),
                      const SizedBox(height: 5),

                      Text(
                        PriceConverter.convertPrice(cart.discountedPrice!+cart.discountAmount!),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                      ),

                    ]),
                  ),

                  Row(children: [

                    QuantityButtonWidget(
                      onTap: () {
                        if (cart.quantity! > 1) {
                          Get.find<PosController>().setQuantity(false, cart);
                        }else {
                          Get.find<PosController>().removeFromCart(cartIndex);
                        }
                      },
                      isIncrement: false,
                    ),

                    Text(cart.quantity.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),

                    QuantityButtonWidget(
                      onTap: () => Get.find<PosController>().setQuantity(true, cart),
                      isIncrement: true,
                    ),

                  ]),

                  !ResponsiveHelper.isMobile(context) ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: IconButton(
                      onPressed: () {
                        Get.find<PosController>().removeFromCart(cartIndex);
                      },
                      icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                    ),
                  ) : const SizedBox(),

                ]),

                addOnText.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [

                    const SizedBox(width: 80),

                    Text('${'addons'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                    Flexible(child: Text(
                      addOnText,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    )),

                  ]),
                ) : const SizedBox(),

                cart.product!.variations!.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [

                    const SizedBox(width: 80),

                    Text('${'variations'.tr}: ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                    Flexible(child: Text(
                      variationText!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                    )),

                  ]),
                ) : const SizedBox(),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}