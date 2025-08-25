import 'package:flutter/cupertino.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_form_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_tool_tip_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/switch_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/setting_confirmation_bottom_sheet.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/daily_time_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/type_converter.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantSettingsScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantSettingsScreen({super.key, required this.restaurant});

  @override
  State<RestaurantSettingsScreen> createState() => _RestaurantSettingsScreenState();
}

class _RestaurantSettingsScreenState extends State<RestaurantSettingsScreen> with TickerProviderStateMixin{

  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _minimumChargeController = TextEditingController();
  final TextEditingController _maximumChargeController = TextEditingController();
  final TextEditingController _perKmChargeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _extraPackagingController = TextEditingController();
  TextEditingController _characteristicSuggestionController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final TextEditingController _dineInAdvanceTimeController = TextEditingController();
  final TextEditingController _customerOrderDaysController = TextEditingController();
  final TextEditingController _freeDeliveryDistanceController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _minimumChargeNode = FocusNode();
  final FocusNode _maximumChargeNode = FocusNode();
  final FocusNode _perKmChargeNode = FocusNode();
  final FocusNode _customerOrderDaysNode = FocusNode();
  final FocusNode _freeDeliveryDistanceNode = FocusNode();
  late Restaurant _restaurant;
  List<DropdownItem<int>> timeList = [];

  @override
  void initState() {
    super.initState();

    _getTimeList();
    Get.find<RestaurantController>().initRestaurantData(widget.restaurant);
    _orderAmountController.text = widget.restaurant.minimumOrder.toString();
    _minimumChargeController.text = widget.restaurant.minimumShippingCharge != null ? widget.restaurant.minimumShippingCharge.toString() : '';
    _maximumChargeController.text = widget.restaurant.maximumShippingCharge != null ? widget.restaurant.maximumShippingCharge.toString() : '';
    _perKmChargeController.text = widget.restaurant.perKmShippingCharge != null ? widget.restaurant.perKmShippingCharge.toString() : '';
    _gstController.text = widget.restaurant.gstCode!;
    _extraPackagingController.text = widget.restaurant.extraPackagingAmount != null ? widget.restaurant.extraPackagingAmount.toString() : '';
    _restaurant = widget.restaurant;
    _dineInAdvanceTimeController.text = widget.restaurant.scheduleAdvanceDineInBookingDuration != null ? widget.restaurant.scheduleAdvanceDineInBookingDuration.toString() : '';
    _customerOrderDaysController.text = widget.restaurant.customOrderDate != null ? widget.restaurant.customOrderDate.toString() : '';
    _freeDeliveryDistanceController.text = widget.restaurant.freeDeliveryDistance != null ? widget.restaurant.freeDeliveryDistance.toString() : '';
  }

  void _getTimeList() {
    for(int i = 0; i < Get.find<RestaurantController>().timeTypes.length; i++) {
      timeList.add(DropdownItem<int>(value: i, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(Get.find<RestaurantController>().timeTypes[i].tr),
        ),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'restaurant_settings'.tr),

      body: GetBuilder<RestaurantController>(builder: (restController) {

        List<int> cuisines0 = [];
        if(restController.cuisineModel != null) {
          for(int index=0; index<restController.cuisineModel!.cuisines!.length; index++) {
            if(restController.cuisineModel!.cuisines![index].status == 1 && !restController.selectedCuisines!.contains(index)) {
              cuisines0.add(index);
            }
          }
        }

        List<int> characteristicSuggestion = [];
        if(restController.characteristicSuggestionList != null) {
          for(int index = 0; index<restController.characteristicSuggestionList!.length; index++) {
            characteristicSuggestion.add(index);
          }
        }

        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('order_setup'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  SwitchButtonWidget(
                    title: 'home_delivery'.tr,
                    isButtonActive: restController.isDeliveryEnabled,
                    onTap: () {
                      showCustomBottomSheet(
                        child: SettingConfirmationBottomSheet(
                          title: restController.isDeliveryEnabled ? 'want_to_disable_the_home_delivery_option'.tr : 'want_to_enable_the_home_delivery_option'.tr,
                          description: restController.isDeliveryEnabled ? 'if_disabled_the_home_delivery_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_order_food_for_home_delivery'.tr,
                          onConfirm: (){
                            Get.back();
                            restController.setHomeDelivery(!restController.isDeliveryEnabled);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Get.find<SplashController>().configModel!.takeAway! ? SwitchButtonWidget(
                    title: 'take_away'.tr,
                    isButtonActive: restController.isTakeAwayEnabled,
                    onTap: () {
                      showCustomBottomSheet(
                        child: SettingConfirmationBottomSheet(
                          title: restController.isTakeAwayEnabled ? 'want_to_disable_the_takeaway_option'.tr : 'want_to_enable_the_takeaway_option'.tr,
                          description: restController.isTakeAwayEnabled ? 'if_disabled_the_takeaway_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_place_takeaway_self_pickup_orders'.tr,
                          onConfirm: (){
                            Get.back();
                            restController.setTakeAway(!restController.isTakeAwayEnabled);
                          },
                        ),
                      );
                    },
                  ) : const SizedBox(),
                  SizedBox(height: Get.find<SplashController>().configModel!.takeAway! ? Dimensions.paddingSizeLarge : 0),

                  SwitchButtonWidget(
                    title: 'dine_in'.tr,
                    isButtonActive: restController.isDineInEnabled!,
                    onTap: () {
                      showCustomBottomSheet(
                        child: SettingConfirmationBottomSheet(
                          title: restController.isDineInEnabled! ? 'want_to_disable_the_dine_in_option'.tr : 'want_to_enable_the_dine_in_option'.tr,
                          description: restController.isDineInEnabled! ? 'if_disabled_the_dine_in_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_place_dine_in_orders'.tr,
                          onConfirm: (){
                            Get.back();
                            restController.toggleDineIn();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextFormFieldWidget(
                          hintText: 'minimum_time_for_dine_in_order'.tr,
                          controller: _dineInAdvanceTimeController,
                          inputAction: TextInputAction.done,
                          showTitle: false,
                          isEnabled: restController.isDineInEnabled,
                          isBorderEnabled: false,
                          inputType: TextInputType.number,
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radiusDefault),
                              bottomRight: Radius.circular(Dimensions.radiusDefault),
                            ),
                          ),
                          child: CustomDropdownWidget<int>(
                            onChange: (int? value, int index) {
                              restController.setTimeType(type: restController.timeTypes[index]);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 45,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall,
                                horizontal: Dimensions.paddingSizeExtraSmall,
                              ),
                              primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            dropdownStyle: DropdownStyle(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            ),
                            items: timeList,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(restController.selectedTimeType.tr),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Get.find<SplashController>().configModel!.instantOrder! ? Container(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(children: [

                      Expanded(child: Text('instance_order'.tr, style: robotoRegular)),

                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                          value: restController.instantOrder,
                          onChanged: (onChanged){
                            showCustomBottomSheet(
                              child: SettingConfirmationBottomSheet(
                                title: restController.instantOrder ? 'want_to_disable_the_instant_order_option'.tr : 'want_to_enable_the_instant_order_option'.tr,
                                description: restController.instantOrder ? 'if_disabled_customers_can_not_order_instantly'.tr : 'if_enabled_customers_can_order_instantly'.tr,
                                onConfirm: (){
                                  Get.back();
                                  restController.setInstantOrder(onChanged);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ) : const SizedBox(),
                  SizedBox(height: Get.find<SplashController>().configModel!.instantOrder! ? Dimensions.paddingSizeLarge : 0),

                  Get.find<SplashController>().configModel!.scheduleOrder! ? Container(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(children: [

                      Expanded(child: Text('schedule_order'.tr, style: robotoRegular)),

                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                          value: restController.scheduleOrder,
                          onChanged: (onChanged){
                            showCustomBottomSheet(
                              child: SettingConfirmationBottomSheet(
                                title: restController.scheduleOrder ? 'want_to_disable_the_schedule_order_option'.tr : 'want_to_enable_the_schedule_order_option'.tr,
                                description: restController.scheduleOrder ? 'if_disabled_customers_can_not_order_schedule_wise'.tr : 'if_enabled_customers_can_order_schedule_wise'.tr,
                                onConfirm: (){
                                  Get.back();
                                  restController.setScheduleOrder(onChanged);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ) : const SizedBox(),
                  SizedBox(height: Get.find<SplashController>().configModel!.scheduleOrder! ? Dimensions.paddingSizeLarge : 0),

                  SwitchButtonWidget(
                    title: 'subscription_order'.tr,
                    isButtonActive: restController.isSubscriptionOrderEnabled,
                    onTap: () {
                      showCustomBottomSheet(
                        child: SettingConfirmationBottomSheet(
                          title: restController.isSubscriptionOrderEnabled! ? 'want_to_disable_the_subscription_order_option'.tr : 'want_to_enable_the_subscription_order_option'.tr,
                          description: restController.isSubscriptionOrderEnabled! ? 'if_disabled_the_subscription_based_order_option_will_be_hidden_from_your_restaurant'.tr : 'if_enabled_customers_can_order_food_on_a_subscription_basis_from_your_restaurant'.tr,
                          onConfirm: (){
                            Get.back();
                            restController.toggleSubscriptionOrder();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'eg_18'.tr,
                    labelText: '${'minimum_order_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                    controller: _orderAmountController,
                    focusNode: _orderAmountNode,
                    nextFocus: _restaurant.selfDeliverySystem == 1 ? _perKmChargeNode : null,
                    inputAction: _restaurant.selfDeliverySystem == 0 ? TextInputAction.next : TextInputAction.done,
                    inputType: TextInputType.number,
                    isAmount: true,
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('restaurant_types_tag'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Column(children: [

                    Autocomplete<int>(
                      optionsBuilder: (TextEditingValue value) {
                        if(value.text.isEmpty) {
                          return const Iterable<int>.empty();
                        }else {
                          return cuisines0.where((cuisine) => restController.cuisineModel!.cuisines![cuisine].name!.toLowerCase().contains(value.text.toLowerCase()));
                        }
                      },
                      optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                        List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                        return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              color: Theme.of(context).primaryColorLight,
                              elevation: 4.0,
                              child: Container(
                                  color: Theme.of(context).cardColor,
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: result.length,
                                    separatorBuilder: (context, i) {
                                      return const Divider(height: 0,);
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      return CustomInkWellWidget(
                                        onTap: () {
                                          _c.text = '';
                                          restController.setSelectedCuisineIndex(result[index], true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                          child: Text(restController.cuisineModel!.cuisines![result[index]].name!),
                                        ),
                                      );
                                    },
                                  )
                              ),
                            )
                        );
                      },
                      fieldViewBuilder: (context, controller, node, onComplete) {
                        _c = controller;
                        return TextFormField(
                          controller: controller,
                          focusNode: node,
                          onEditingComplete: () {
                            onComplete();
                            controller.text = '';
                          },
                          decoration: InputDecoration(
                            hintText: 'cuisines'.tr,
                            labelText: 'cuisines'.tr,
                            labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                            isDense: true,
                            fillColor: Theme.of(context).cardColor,
                            hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                            ),
                          ),
                        );
                      },
                      displayStringForOption: (value) => restController.cuisineModel!.cuisines![value].name!,
                      onSelected: (int value) {
                        _c.text = '';
                        restController.setSelectedCuisineIndex(value, true);
                      },
                    ),
                    SizedBox(height: restController.selectedCuisines!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                    SizedBox(
                      height: restController.selectedCuisines!.isNotEmpty ? 40 : 0,
                      child: ListView.builder(
                        itemCount: restController.selectedCuisines!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(children: [

                              Text(
                                restController.cuisineModel!.cuisines![restController.selectedCuisines![index]].name!,
                                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                              ),

                              InkWell(
                                onTap: () => restController.removeCuisine(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor),
                                ),
                              ),

                            ]),
                          );
                        },
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(children: [

                      Expanded(
                        flex: 8,
                        child: Autocomplete<int>(
                          optionsBuilder: (TextEditingValue value) {
                            if(value.text.isEmpty) {
                              return const Iterable<int>.empty();
                            }else {
                              return characteristicSuggestion.where((characteristic) => restController.characteristicSuggestionList![characteristic]!.toLowerCase().contains(value.text.toLowerCase()));
                            }
                          },
                          optionsViewBuilder: (context, onAutoCompleteSelect, options) {
                            List<int> result = TypeConverter.convertIntoListOfInteger(options.toString());

                            return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  color: Theme.of(context).primaryColorLight,
                                  elevation: 4.0,
                                  child: Container(
                                      color: Theme.of(context).cardColor,
                                      width: MediaQuery.of(context).size.width - 110,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: result.length,
                                        separatorBuilder: (context, i) {
                                          return const Divider(height: 0,);
                                        },
                                        itemBuilder: (BuildContext context, int index) {
                                          return CustomInkWellWidget(
                                            onTap: () {
                                              if(restController.selectedCharacteristicsList!.length >= 5) {
                                                showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                                              }else {
                                                _characteristicSuggestionController.text = '';
                                                restController.setSelectedCharacteristicsIndex(result[index], true);
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                              child: Text(restController.characteristicSuggestionList![result[index]]!),
                                            ),
                                          );
                                        },
                                      )
                                  ),
                                )
                            );
                          },
                          fieldViewBuilder: (context, controller, node, onComplete) {
                            _characteristicSuggestionController = controller;
                            return TextField(
                              controller: controller,
                              focusNode: node,
                              onEditingComplete: () {
                                onComplete();
                                controller.text = '';
                              },
                              decoration: InputDecoration(
                                hintText: 'ex_indian_food'.tr,
                                labelText: 'characteristics'.tr,
                                labelStyle : robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                isDense: true,
                                fillColor: Theme.of(context).cardColor,
                                hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  borderSide: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.5)),
                                ),
                              ),
                            );
                          },
                          displayStringForOption: (value) => restController.characteristicSuggestionList![value]!,
                          onSelected: (int value) {

                            if(restController.selectedCharacteristicsList!.length >= 5) {
                              showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                            }else {
                              _characteristicSuggestionController.text = '';
                              restController.setSelectedCharacteristicsIndex(value, true);
                            }

                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      CustomButtonWidget(
                        buttonText: '+',
                        fontSize: Dimensions.fontSizeOverLarge,
                        width: 45,
                        color: const Color(0xFF334257),
                        onPressed: () {
                          if(restController.selectedCharacteristicsList!.length >= 5) {
                            showCustomSnackBar('you_can_select_or_add_maximum_5_characteristics'.tr, isError: true);
                          }else{
                            if(_characteristicSuggestionController.text.isNotEmpty) {
                              restController.setCharacteristics(_characteristicSuggestionController.text.trim());
                              _characteristicSuggestionController.text = '';
                            }
                          }
                        },
                      ),

                    ]),
                    SizedBox(height: restController.selectedCharacteristicsList!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                    restController.selectedCharacteristicsList != null ? SizedBox(
                      height: restController.selectedCharacteristicsList!.isNotEmpty ? 40 : 0,
                      child: ListView.builder(
                        itemCount: restController.selectedCharacteristicsList!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall, right: Get.find<LocalizationController>().isLtr ? 0 : Dimensions.paddingSizeSmall),
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Row(children: [

                              Text(
                                restController.selectedCharacteristicsList![index]!,
                                style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                              ),

                              InkWell(
                                onTap: () => restController.removeCharacteristic(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.close, size: 15, color: Theme.of(context).hintColor),
                                ),
                              ),

                            ]),
                          );
                        },
                      ),
                    ) : const SizedBox(),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(children: [

                      Expanded(
                        flex: 8,
                        child: CustomTextFieldWidget(
                          hintText: 'tag'.tr,
                          labelText: 'tag'.tr,
                          showTitle: false,
                          controller: _tagController,
                          inputAction: TextInputAction.done,
                          onSubmit: (name){
                            if(name.isNotEmpty) {
                              restController.setRestaurantTag(name);
                              _tagController.text = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      CustomButtonWidget(
                        buttonText: '+',
                        fontSize: Dimensions.fontSizeOverLarge,
                        width: 45,
                        color: const Color(0xFF334257),
                        onPressed: () {
                          if(_tagController.text.isNotEmpty) {
                            restController.setRestaurantTag(_tagController.text.trim());
                            _tagController.text = '';
                          }
                        },
                      ),

                    ]),
                    SizedBox(height: restController.restaurantTagList.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

                    restController.restaurantTagList.isNotEmpty ? SizedBox(
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true, scrollDirection: Axis.horizontal,
                        itemCount: restController.restaurantTagList.length,
                        itemBuilder: (context, index){
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(color: Theme.of(context).hintColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: Center(child: Row(children: [

                              Text(restController.restaurantTagList[index]!, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              InkWell(onTap: () => restController.removeRestaurantTag(index), child: Icon(Icons.clear, size: 15, color: Theme.of(context).hintColor)),

                            ])),
                          );
                        },
                      ),
                    ) : const SizedBox(),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  SwitchButtonWidget(
                    title: 'halal_tag_status'.tr,
                    isButtonActive: restController.isHalalEnabled,
                    onTap: () {
                      showCustomBottomSheet(
                        child: SettingConfirmationBottomSheet(
                          title: restController.isHalalEnabled! ? 'want_to_disable_the_halal_tag_status'.tr : 'want_to_enable_the_halal_tag_status'.tr,
                          description: restController.isHalalEnabled! ? 'if_disabled_customers_can_not_see_halal_tag_on_product.'.tr : 'if_enabled_customers_can_see_halal_tag_on_product'.tr,
                          onConfirm: (){
                            Get.back();
                            restController.toggleHalalTag();
                          },
                        ),
                      );
                    },
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('other_setup'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Stack(clipBehavior: Clip.none, children: [

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(children: [

                        Expanded(child: InkWell(
                          onTap: () => restController.setRestVeg(!restController.isRestVeg!, true),
                          child: Row(children: [

                            Checkbox(
                              value: restController.isRestVeg,
                              onChanged: (bool? isActive) => restController.setRestVeg(isActive, true),
                              activeColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).hintColor),
                            ),

                            Text('veg'.tr, style: robotoMedium.copyWith(color: restController.isRestVeg! ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

                          ]),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: InkWell(
                          onTap: () => restController.setRestNonVeg(!restController.isRestNonVeg!, true),
                          child: Row(children: [

                            Checkbox(
                              value: restController.isRestNonVeg,
                              onChanged: (bool? isActive) => restController.setRestNonVeg(isActive, true),
                              activeColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).hintColor),
                            ),

                            Text('non_veg'.tr, style: robotoMedium.copyWith(color: restController.isRestVeg! ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),

                          ]),
                        )),
                      ]),
                    ),

                    Positioned(
                      left: 10, top: -10,
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        padding: const EdgeInsets.all(5),
                        child: Text('food_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                      ),
                    ),

                  ]) : const SizedBox(),
                  SizedBox(height: Get.find<SplashController>().configModel!.toggleVegNonVeg! ? Dimensions.paddingSizeLarge : 0),

                  SwitchButtonWidget(
                    title: 'cutlery_on_delivery'.tr,
                    isButtonActive: restController.isCutleryEnabled,
                    onTap: () {
                      restController.toggleCutlery();
                    },
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Text('gst'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                CustomToolTip(message: 'if_enabled_the_gst_number_will_be_shown_in_the_invoice'.tr, size: 16),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Row(children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text('active_gst'.tr, style: robotoRegular),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: restController.isGstEnabled!,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        onChanged: (bool isActive) => restController.toggleGst(),
                      ),
                    ),

                  ]),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      hintText: 'eg_18'.tr,
                      labelText: '${'gst_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                      controller: _gstController,
                      inputAction: TextInputAction.done,
                      showTitle: false,
                      isEnabled: restController.isGstEnabled!,
                      hideEnableText: true,
                      isAmount: true,
                    ),
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('extra_package_charge'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Get.find<SplashController>().configModel!.extraPackagingChargeStatus! ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Row(children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text('active_extra_package_charge'.tr, style: robotoRegular),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: restController.isExtraPackagingEnabled!,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        onChanged: (bool isActive) => restController.toggleExtraPackaging(),
                      ),
                    ),

                  ]),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Stack(clipBehavior: Clip.none, children: [

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Row(children: [

                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  restController.setExtraPackagingSelectedValue(0);
                                },
                                child: Row(children: [

                                  Radio(
                                    value: 0,
                                    groupValue: restController.extraPackagingSelectedValue,
                                    onChanged: (value) {
                                      restController.setExtraPackagingSelectedValue(value!);
                                    },
                                  ),

                                  Text('optional'.tr),

                                ]),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  restController.setExtraPackagingSelectedValue(1);
                                },
                                child: Row(children: [

                                  Radio(
                                    value: 1,
                                    groupValue: restController.extraPackagingSelectedValue,
                                    onChanged: (value) {
                                      restController.setExtraPackagingSelectedValue(value!);
                                    },
                                  ),

                                  Text('mandatory'.tr),

                                ]),
                              ),
                            ),

                          ]),
                        ),

                        Positioned(
                          left: 10, top: -10,
                          child: Container(
                            decoration: BoxDecoration(color: Theme.of(context).cardColor),
                            padding: const EdgeInsets.all(5),
                            child: Text('charge_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                          ),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        hintText: 'eg_18'.tr,
                        labelText: '${'extra_packaging_amount'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                        controller: _extraPackagingController,
                        inputAction: TextInputAction.done,
                        showTitle: false,
                        isAmount: true,
                        isEnabled: restController.isExtraPackagingEnabled!,
                      ),
                    ]),
                  ),

                ]),
              ) : const SizedBox(),
              SizedBox(height: Get.find<SplashController>().configModel!.extraPackagingChargeStatus! ? Dimensions.paddingSizeLarge : 0),

              _restaurant.selfDeliverySystem == 1 ? Text('custom_order'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

              _restaurant.selfDeliverySystem == 1 ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Row(children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text('custom_date_order_status'.tr, style: robotoRegular),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: restController.customDateOrderEnabled!,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        onChanged: (bool isActive) => restController.toggleCustomDateOrder(),
                      ),
                    ),

                  ]),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      hintText: 'eg_18'.tr,
                      labelText: 'customer_can_order_within_days'.tr,
                      showTitle: false,
                      hideEnableText: true,
                      controller: _customerOrderDaysController,
                      focusNode: _customerOrderDaysNode,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.phone,
                      isEnabled: restController.customDateOrderEnabled!,
                    ),
                  ),

                ]),
              ) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

              _restaurant.selfDeliverySystem == 1 ? Text('delivery_charge'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

              _restaurant.selfDeliverySystem == 1 ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  CustomTextFieldWidget(
                    hintText: 'eg_18'.tr,
                    labelText: '${'per_km_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                    controller: _perKmChargeController,
                    focusNode: _restaurant.selfDeliverySystem == 1 ? _perKmChargeNode : null,
                    nextFocus: _restaurant.selfDeliverySystem == 1 ? _minimumChargeNode : null,
                    inputType: TextInputType.number,
                    isAmount: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'eg_18'.tr,
                    labelText: '${'minimum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                    controller: _minimumChargeController,
                    focusNode: _minimumChargeNode,
                    nextFocus: _maximumChargeNode,
                    inputType: TextInputType.number,
                    isAmount: true,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextFieldWidget(
                    hintText: 'eg_18'.tr,
                    labelText: '${'maximum_delivery_charge'.tr} (${Get.find<SplashController>().configModel!.currencySymbol})',
                    controller: _maximumChargeController,
                    focusNode: _maximumChargeNode,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.number,
                    isAmount: true,
                  ),

                ]),
              ) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

              _restaurant.selfDeliverySystem == 1 ? Text('free_delivery'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

              _restaurant.selfDeliverySystem == 1 ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Row(children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Text('free_delivery_distance_km'.tr, style: robotoRegular),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: restController.freeDeliveryDistanceEnabled!,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).hintColor.withValues(alpha: 0.5),
                        onChanged: (bool isActive) => restController.toggleFreeDeliveryDistance(),
                      ),
                    ),

                  ]),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: CustomTextFieldWidget(
                      hintText: 'eg_18'.tr,
                      labelText: 'free_delivery_distance_km'.tr,
                      hideEnableText: true,
                      controller: _freeDeliveryDistanceController,
                      focusNode: _freeDeliveryDistanceNode,
                      inputAction: TextInputAction.done,
                      showTitle: false,
                      isEnabled: restController.freeDeliveryDistanceEnabled!,
                    ),
                  ),

                ]),
              ) : const SizedBox(),
              SizedBox(height: _restaurant.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

              Text('daily_schedule_time'.tr, style: robotoBold),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      DailyTimeWidget(weekDay: index),

                      index != 6 ? const Divider() : const SizedBox(),
                    ]);
                  },
                ),
              ),

            ]),
          )),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: CustomButtonWidget(
              isLoading: restController.isLoading,
              onPressed: () async {
                String minimumOrder = _orderAmountController.text.trim();
                String minimumFee = _minimumChargeController.text.trim();
                String perKmFee = _perKmChargeController.text.trim();
                String gstCode = _gstController.text.trim();
                String maximumFee = _maximumChargeController.text.trim();
                String extraPackagingAmount = _extraPackagingController.text.trim();
                String dineInAdvanceTime = _dineInAdvanceTimeController.text.trim();
                String customOrderDate = _customerOrderDaysController.text.trim();
                String freeDeliveryDistance = _freeDeliveryDistanceController.text.trim();

                if(restController.isExtraPackagingEnabled! && extraPackagingAmount.isEmpty) {
                  showCustomSnackBar('enter_restaurant_extra_packaging_charge'.tr);
                }else if(minimumOrder.isEmpty) {
                  showCustomSnackBar('enter_minimum_order_amount'.tr);
                }else if(_restaurant.selfDeliverySystem == 1 && perKmFee.isNotEmpty && minimumFee.isEmpty) {
                  showCustomSnackBar('enter_minimum_delivery_fee'.tr);
                }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && perKmFee.isEmpty) {
                  showCustomSnackBar('enter_per_km_delivery_fee'.tr);
                }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && (maximumFee.isNotEmpty ? (double.parse(perKmFee) > double.parse(maximumFee)) : false) && double.parse(maximumFee) != 0) {
                  showCustomSnackBar('per_km_charge_can_not_be_more_then_maximum_charge'.tr);
                }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && (maximumFee.isNotEmpty ? (double.parse(minimumFee) > double.parse(maximumFee)) : false)) {
                  showCustomSnackBar('minimum_charge_can_not_be_more_then_maximum_charge'.tr);
                }else if(!restController.isRestVeg! && !restController.isRestNonVeg!){
                  showCustomSnackBar('select_at_least_one_food_type'.tr);
                }else if(restController.isGstEnabled! && gstCode.isEmpty){
                  showCustomSnackBar('enter_gst_code'.tr);
                }else if(_restaurant.selfDeliverySystem == 1 && minimumFee.isNotEmpty && perKmFee.isNotEmpty && maximumFee.isEmpty) {
                  showCustomSnackBar('enter_maximum_delivery_fee'.tr);
                }else {
                  List<String> cuisines = [];
                  List<String> restaurantCharacteristics = [];

                  for (var index in restController.selectedCuisines!) {
                    cuisines.add(restController.cuisineModel!.cuisines![index].id.toString());
                  }

                  for (var index in restController.selectedCharacteristicsList!) {
                    restaurantCharacteristics.add(index!);
                  }

                  _restaurant.minimumOrder = double.parse(minimumOrder);
                  _restaurant.gstStatus = restController.isGstEnabled;
                  _restaurant.gstCode = gstCode;
                  _restaurant.minimumShippingCharge = minimumFee.isNotEmpty ? double.parse(minimumFee) : null;
                  _restaurant.maximumShippingCharge = maximumFee.isNotEmpty ? double.parse(maximumFee) : null;
                  _restaurant.perKmShippingCharge = perKmFee.isNotEmpty ? double.parse(perKmFee) : null;
                  _restaurant.veg = restController.isRestVeg! ? 1 : 0;
                  _restaurant.nonVeg = restController.isRestNonVeg! ? 1 : 0;
                  _restaurant.instanceOrder = restController.instantOrder;
                  _restaurant.scheduleOrder = restController.scheduleOrder;
                  _restaurant.isExtraPackagingActive = restController.isExtraPackagingEnabled;
                  _restaurant.extraPackagingStatus = restController.extraPackagingSelectedValue;
                  _restaurant.extraPackagingAmount = extraPackagingAmount.isNotEmpty ? double.parse(extraPackagingAmount) : 0;
                  _restaurant.isDineInActive = restController.isDineInEnabled;
                  _restaurant.scheduleAdvanceDineInBookingDuration = dineInAdvanceTime.isNotEmpty ? int.parse(dineInAdvanceTime) : 0;
                  _restaurant.scheduleAdvanceDineInBookingDurationTimeFormat = restController.selectedTimeType;
                  _restaurant.customOrderDate = customOrderDate.isNotEmpty ? int.parse(customOrderDate) : 0;
                  _restaurant.freeDeliveryDistanceStatus = restController.freeDeliveryDistanceEnabled;
                  _restaurant.customDateOrderStatus = restController.customDateOrderEnabled;
                  _restaurant.freeDeliveryDistance = freeDeliveryDistance;
                  _restaurant.delivery = restController.isDeliveryEnabled;
                  _restaurant.takeAway = restController.isTakeAwayEnabled;
                  _restaurant.orderSubscriptionActive = restController.isSubscriptionOrderEnabled;
                  _restaurant.cutlery = restController.isCutleryEnabled;
                  _restaurant.isHalalActive = restController.isHalalEnabled;

                  restController.updateRestaurant(_restaurant, cuisines);
                }
              },
              buttonText: 'update'.tr,
            ),
          ),

        ]);
      }),
    );
  }
}