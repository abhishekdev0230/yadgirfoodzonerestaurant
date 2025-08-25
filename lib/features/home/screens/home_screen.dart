import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_card.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/ads_section_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_summary_card.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppLifecycleListener _listener;
  bool _isNotificationPermissionGranted = true;
  bool _isBatteryOptimizationGranted = true;

  @override
  void initState() {
    super.initState();

    // Initialize the AppLifecycleListener class and pass callbacks
    _listener = AppLifecycleListener(
      onStateChange: _onStateChanged,
    );

    _loadData();

    Future.delayed(const Duration(milliseconds: 200), () {
      checkPermission();
    });
  }

  // Listen to the app lifecycle state changes
  void _onStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        Future.delayed(const Duration(milliseconds: 200), () {
          checkPermission();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
  }

  Future<void> checkPermission() async {
    var notificationStatus = await Permission.notification.status;
    var batteryStatus = await Permission.ignoreBatteryOptimizations.status;

    if(notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      setState(() {
        _isNotificationPermissionGranted = false;
        _isBatteryOptimizationGranted = true;
      });
    } else if(batteryStatus.isDenied) {
      setState(() {
        _isBatteryOptimizationGranted = false;
        _isNotificationPermissionGranted = true;
      });
    } else {
      setState(() {
        _isNotificationPermissionGranted = true;
        _isBatteryOptimizationGranted = true;
      });
      Get.find<ProfileController>().setBackgroundNotificationActive(true);
    }

    if(batteryStatus.isDenied) {
      Get.find<ProfileController>().setBackgroundNotificationActive(false);
    }
  }

  final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>(
     (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.black : Colors.white);
      }
      return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.white: Colors.black);
    },
  );

  Future<void> requestNotificationPermission() async {

    if (await Permission.notification.request().isGranted) {
      return;
    } else {
      await openAppSettings();
    }

    checkPermission();
  }

  void requestBatteryOptimization() async {
    var status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) {
      return;
    } else if(status.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    } else {
      openAppSettings();
    }

    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0,
        surfaceTintColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
        elevation: 2,
        title: Image.asset(Images.logoName, width: 120),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {

            bool hasNewNotification = false;

            if(notificationController.notificationList != null) {
              hasNewNotification = notificationController.notificationList!.length != notificationController.getSeenNotificationCount();
            }

            return Stack(children: [

              Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),

              hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),

            ]);
          }),
          onPressed: () {
            Get.find<SubscriptionController>().trialEndBottomSheet().then((trialEnd) {
              if(trialEnd) {
                Get.toNamed(RouteHelper.getNotificationRoute());
              }
            });
          },
        )],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: Column(
          children: [

            if(!_isNotificationPermissionGranted)
              permissionWarning(isBatteryPermission: false, onTap: requestNotificationPermission, closeOnTap: () {
                setState(() {
                  _isNotificationPermissionGranted = true;
                });
              }),

            if(!_isBatteryOptimizationGranted)
              permissionWarning(isBatteryPermission: true, onTap: requestBatteryOptimization, closeOnTap: () {
                setState(() {
                  _isBatteryOptimizationGranted = true;
                });
              }),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                physics: const AlwaysScrollableScrollPhysics(),
                child: GetBuilder<ProfileController>(builder: (profileController) {
                  return profileController.profileModel != null ? Column(children: [

                    profileController.modulePermission?.restaurantConfig ?? false ? CustomCard(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(children: [

                        Expanded(child: Text(
                          'restaurant_temporarily_closed'.tr, style: robotoMedium,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        )),

                        profileController.profileModel != null ? Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: profileController.profileModel!.restaurants![0].active!,
                            activeTrackColor: Theme.of(context).primaryColor,
                            inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                            onChanged: (bool isActive) {
                              if(Get.find<ProfileController>().modulePermission!.restaurantConfig!){
                                Get.dialog(ConfirmationDialogWidget(
                                  icon: Images.warning,
                                  description: !isActive ? 'are_you_sure_to_close_restaurant'.tr : 'are_you_sure_to_open_restaurant'.tr,
                                  onYesPressed: () {
                                    Get.back();
                                    Get.find<AuthController>().toggleRestaurantClosedStatus();
                                  },
                                ));
                              }else{
                                showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                              }
                            },
                          ),
                        ) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),

                      ]),
                    ) : const SizedBox(),
                    SizedBox(height: profileController.modulePermission?.restaurantConfig ?? false ? Dimensions.paddingSizeDefault : 0),

                    profileController.modulePermission?.myWallet ?? false ? OrderSummaryCard(profileController: profileController) : const SizedBox(),
                    SizedBox(height: profileController.modulePermission?.myWallet ?? false ? Dimensions.paddingSizeLarge : 0),

                    profileController.modulePermission?.newAds ?? false ? const AdsSectionWidget() : const SizedBox(),
                    SizedBox(height: profileController.modulePermission?.newAds ?? false ? Dimensions.paddingSizeLarge : 0),

                   (profileController.modulePermission?.regularOrder ?? false) ||  (profileController.modulePermission?.subscriptionOrder ?? false) ? GetBuilder<OrderController>(builder: (orderController) {

                      List<OrderModel> orderList = [];

                      if(orderController.runningOrders != null) {
                        orderList = orderController.runningOrders![orderController.orderIndex].orderList;
                      }

                      return CustomCard(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(children: [

                          orderController.runningOrders != null ? SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: orderController.runningOrders!.length,
                              itemBuilder: (context, index) {
                                return OrderButtonWidget(
                                  title: orderController.runningOrders![index].status.tr, index: index,
                                  orderController: orderController, fromHistory: false,
                                );
                              },
                            ),
                          ) : const SizedBox(),

                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                              orderController.runningOrders != null ? InkWell(
                                onTap: () => orderController.toggleCampaignOnly(),
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: orderController.campaignOnly ? Colors.green : Theme.of(context).cardColor,
                                      border: Border.all(color: orderController.campaignOnly ? Colors.transparent : Theme.of(context).hintColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check, size: 14, color: orderController.campaignOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                                  ),

                                  Text(
                                    'campaign_order'.tr,
                                    style: orderController.campaignOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                        : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ]),
                              ) : const SizedBox(),

                              orderController.runningOrders != null ? InkWell(
                                onTap: () {
                                  if(profileController.modulePermission?.subscriptionOrder ?? false) {
                                    orderController.toggleSubscriptionOnly();
                                  } else {
                                    showCustomSnackBar('you_have_no_permission_to_access_this_feature'.tr);
                                  }
                                },
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: orderController.subscriptionOnly ? Colors.green : Theme.of(context).cardColor,
                                      border: Border.all(color: orderController.subscriptionOnly ? Colors.transparent : Theme.of(context).hintColor),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.check, size: 14, color: orderController.subscriptionOnly ? Theme.of(context).cardColor :Theme.of(context).hintColor,),
                                  ),

                                  Text(
                                    'subscription_order'.tr,
                                    style: orderController.subscriptionOnly ? robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)
                                        : robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                  ),
                                ]),
                              ) : const SizedBox(),

                            ]),
                          ),

                          const Divider(height: Dimensions.paddingSizeOverLarge),

                          orderController.runningOrders != null ? orderList.isNotEmpty ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                            },
                          ) : Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Center(child: Text('no_order_found'.tr)),
                          ) : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return OrderShimmerWidget(isEnabled: orderController.runningOrders == null);
                            },
                          ),

                        ]),
                      );
                    }) : const SizedBox(),

                  ]) : Column(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 50, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 200, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 150, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: Shimmer(
                        child: Container(
                          height: 70, width: double.infinity,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),

                  ]);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget permissionWarning({required bool isBatteryPermission, required Function() onTap, required Function() closeOnTap}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [

                if(isBatteryPermission)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.warning_rounded, color: Colors.yellow,),
                  ),

                Expanded(
                  child: Row(children: [
                    Flexible(
                      child: Text(
                        isBatteryPermission ? 'for_better_performance_allow_notification_to_run_in_background'.tr
                            : 'notification_is_disabled_please_allow_notification'.tr,
                        maxLines: 2, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    const Icon(Icons.arrow_circle_right_rounded, color: Colors.white, size: 24,),
                  ]),
                ),

                const SizedBox(width: 20),
              ]),
            ),

            Positioned(
              top: 5, right: 5,
              child: InkWell(
                onTap: closeOnTap,
                child: const Icon(Icons.clear, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}