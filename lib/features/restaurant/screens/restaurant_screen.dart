import 'package:flutter/rendering.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/filter_data_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  final bool? _review = Get.find<ProfileController>().profileModel!.restaurants![0].reviewsSection;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _review! ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController!.index);
    });
    Get.find<RestaurantController>().getProductList(offset: '1', foodType: 'all', stockType: 'all', categoryId: 0, isUpdate: false);
    Get.find<RestaurantController>().getRestaurantReviewList(Get.find<ProfileController>().profileModel!.restaurants![0].id, '');
    Get.find<RestaurantController>().getRestaurantCategories();

    _scrollController.addListener(_scrollListener);

  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!Get.find<RestaurantController>().isTitleVisible && _scrollController.offset > 100) {
        Get.find<RestaurantController>().showTitle();
      }
    } else if(_scrollController.position.userScrollDirection == ScrollDirection.forward && _scrollController.offset < 100) {
      if (Get.find<RestaurantController>().isTitleVisible) {
        Get.find<RestaurantController>().hideTitle();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<ProfileController>(builder: (profileController) {

        Restaurant? restaurant = profileController.profileModel != null ? profileController.profileModel!.restaurants![0] : null;

        return Get.find<ProfileController>().modulePermission!.myRestaurant! ? Scaffold(
          backgroundColor: Theme.of(context).cardColor,

          floatingActionButton: GetBuilder<RestaurantController>(builder: (restaurantController) {
            return restaurantController.isFabVisible ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [

              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getAnnouncementRoute(announcementStatus: restaurant!.isAnnouncementActive!, announcementMessage: restaurant.announcementMessage ?? '')),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).cardColor, width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Image.asset(Images.announcementIcon, height: 25, width: 25, color: Theme.of(context).cardColor),
                ),
              ),

            ]) : const SizedBox();
          }),

          body: restaurant != null ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: 230, toolbarHeight: 70,
                pinned: true, floating: false,
                surfaceTintColor: Theme.of(context).cardColor,
                backgroundColor: Theme.of(context).cardColor,
                shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                elevation: 2,

                title: restController.isTitleVisible ? Row(
                  children: [

                    ClipOval(
                      child: CustomImageWidget(
                        image: '${restaurant.logoFullUrl}',
                        height: 50, width: 50, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      restaurant.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ) : null,

                actions: restController.isTitleVisible ? [
                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getRestaurantEditRoute(restaurant)),
                    child: Container(
                      height: 35, width: 35, alignment: Alignment.center,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                      ),
                      child: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 20),
                    ),
                  ),

                  const SizedBox(width: Dimensions.paddingSizeDefault),
                ] : null,

                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(clipBehavior: Clip.none, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault)),
                      child: CustomImageWidget(
                        fit: BoxFit.cover, placeholder: Images.restaurantCover,
                        image: '${restaurant.coverPhotoFullUrl}',
                        height: 190, width: context.width,
                      ),
                    ),

                    Positioned(
                      bottom: -5, left: 0, right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Row(children: [

                          ClipOval(
                            child: CustomImageWidget(
                              image: '${restaurant.logoFullUrl}',
                              height: 70, width: 70, fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text(
                              restaurant.name ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),

                            Text(
                              restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(children: [

                              Icon(Icons.star_rounded, color: Theme.of(context).primaryColor, size: 18),

                              Text(
                                restaurant.avgRating!.toStringAsFixed(1),
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall + 1),

                              Container(
                                height: 10, width: 1, color: Theme.of(context).hintColor,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall + 1),

                              Text(
                                '${restaurant.ratingCount ?? 0} ${'ratings'.tr}',
                                style: robotoBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color,
                                  decoration: TextDecoration.underline, decorationColor: Theme.of(context).textTheme.bodyLarge?.color,
                                  height: 1.3, fontWeight: FontWeight.w600,
                                ),
                              ),

                            ]),


                          ])),
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                          InkWell(
                            onTap: () => Get.toNamed(RouteHelper.getRestaurantEditRoute(restaurant)),
                            child: Container(
                              height: 35, width: 35, alignment: Alignment.center,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                              ),
                              child: Icon(Icons.edit, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),

                        ]),
                      ),
                    ),
                  ]),
                ),
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [
                  restaurant.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(
                        '${restaurant.discount!.discount}% ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),

                      Text(
                        '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(height: (restaurant.discount!.minPurchase != 0 || restaurant.discount!.maxDiscount != 0) ? 5 : 0),

                      restaurant.discount!.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                      restaurant.discount!.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                    ]),
                  ) : const SizedBox(),

                  (restaurant.delivery! && restaurant.freeDelivery!) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ) : const SizedBox(),

                ]),
              ))),

              Get.find<ProfileController>().modulePermission!.food! ? SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Column(children: [
                      SizedBox(height: restController.isTitleVisible ? 10 : 0),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                          Text('all_foods'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 20),

                          InkWell(
                            onTap: () {
                              showCustomBottomSheet(child: const FilterDataBottomSheet());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.tune, color: Theme.of(context).primaryColor),
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      restController.categoryNameList != null ? SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: restController.categoryNameList!.length,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => restController.setCategory(index: index, foodType: 'all', stockType: 'all'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                                  color: index == restController.categoryIndex ? Theme.of(context).primaryColor.withValues(alpha: 0.25) : Colors.transparent,
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(
                                   index == 0 ? 'all'.tr : restController.categoryNameList![index],
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: index == restController.categoryIndex ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                                      fontWeight: index == restController.categoryIndex ? FontWeight.w700 : FontWeight.w400,
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      ) : SizedBox(
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                                color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Container(
                                  height: 10, width: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),

                    ]),
                  ),
                ),
              ) : const SliverToBoxAdapter(child: SizedBox()),

              Get.find<ProfileController>().modulePermission!.food! ? SliverToBoxAdapter(
                child: ProductViewWidget(scrollController: _scrollController, type: restController.selectedFoodType, onVegFilterTap: (String type) {
                  Get.find<RestaurantController>().getProductList(offset: '1', foodType: type, stockType: restController.selectedStockType, categoryId: restController.categoryId);
                }),
              ) : const SliverToBoxAdapter(child: SizedBox()),

            ],
          ) : const Center(child: CircularProgressIndicator()),
        ) : Scaffold(
          body: Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium)),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 100 || oldDelegate.minExtent != 100 || child != oldDelegate.child;
  }
}