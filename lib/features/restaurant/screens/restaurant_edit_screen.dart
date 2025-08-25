import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_asset_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/validate_check.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_validator.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantEditScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantEditScreen({super.key, required this.restaurant});

  @override
  State<RestaurantEditScreen> createState() => _RestaurantEditScreenState();
}

class _RestaurantEditScreenState extends State<RestaurantEditScreen> with TickerProviderStateMixin{

  final List<TextEditingController> _nameController = [];
  final TextEditingController _contactController = TextEditingController();
  final List<TextEditingController> _addressController = [];
  final List<TextEditingController> _metaTitleController = [];
  final List<TextEditingController> _metaDescriptionController = [];

  final List<FocusNode> _nameNode = [];
  final FocusNode _contactNode = FocusNode();
  final List<FocusNode> _addressNode = [];
  final List<FocusNode> _metaTitleNode = [];
  final List<FocusNode> _metaDescriptionNode = [];
  late Restaurant _restaurant;
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  final List<Translation>? translation = Get.find<ProfileController>().profileModel!.translations!;
  TabController? _tabController;
  final List<Tab> _tabs = [];
  String? _countryDialCode;
  String? _countryCode;

  @override
  void initState() {
    super.initState();

    _contactController.text = widget.restaurant.phone!;
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    _countryCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code;
    _splitPhone(widget.restaurant.phone);
    Get.find<RestaurantController>().initRestaurantBasicData();

    _tabController = TabController(length: _languageList!.length, vsync: this);

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    for(int index=0; index<_languageList.length; index++) {

      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _metaTitleController.add(TextEditingController());
      _metaDescriptionController.add(TextEditingController());
      _nameNode.add(FocusNode());
      _addressNode.add(FocusNode());
      _metaTitleNode.add(FocusNode());
      _metaDescriptionNode.add(FocusNode());

      for (var trans in translation!) {
        if(_languageList[index].key == trans.locale && trans.key == 'name') {
          _nameController[index] = TextEditingController(text: trans.value);
        }else if(_languageList[index].key == trans.locale && trans.key == 'address') {
          _addressController[index] = TextEditingController(text: trans.value);
        }else if (_languageList[index].key == trans.locale && trans.key == 'meta_title') {
          _metaTitleController[index] = TextEditingController(text: trans.value);
        }  else if (_languageList[index].key == trans.locale && trans.key == 'meta_description') {
          _metaDescriptionController[index] = TextEditingController(text: trans.value);
        }
      }
    }
    _restaurant = widget.restaurant;
  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _countryCode = phoneNumber.isoCode.name;
        _contactController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'edit_restaurant'.tr),

      body: GetBuilder<RestaurantController>(builder: (restController) {

        return Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text('restaurant_name'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  SizedBox(
                    height: 40,
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      controller: _tabController,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorWeight: 3,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).hintColor,
                      unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                      labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                      labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                      indicatorPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: _tabs,
                      onTap: (int ? value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Divider(height: 0),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    hintText: '${'restaurant_name'.tr} (${_languageList?[_tabController!.index].value!})',
                    labelText: '${'restaurant_name'.tr} (${_languageList?[_tabController!.index].value!})',
                    controller: _nameController[_tabController!.index],
                    capitalization: TextCapitalization.words,
                    focusNode: _nameNode[_tabController!.index],
                    nextFocus: _tabController!.index != _languageList!.length-1 ? _addressNode[_tabController!.index] : _contactNode,
                    showTitle: false,
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('contact'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  CustomTextFieldWidget(
                    hintText: 'xxx-xxxxxxx',
                    labelText: 'phone_number'.tr,
                    controller: _contactController,
                    focusNode: _contactNode,
                    nextFocus: _addressNode[0],
                    required: true,
                    showTitle: false,
                    inputType: TextInputType.phone,
                    isPhone: true,
                    onCountryChanged: (CountryCode countryCode) {
                      _countryDialCode = countryCode.dialCode;
                    },
                    countryDialCode: _countryCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                    validator: (value) => ValidateCheck.validateEmptyText(value, null),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  CustomTextFieldWidget(
                    hintText: 'address'.tr,
                    labelText: 'address'.tr,
                    controller: _addressController[0],
                    focusNode: _addressNode[0],
                    capitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    nextFocus: _metaTitleNode[0],
                    showTitle: false,
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'restaurant_logo'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      TextSpan(
                        text: '*',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text('image_format_and_ratio_for_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Align(alignment: Alignment.center, child: Stack(children: [

                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: restController.pickedLogo != null ? GetPlatform.isWeb ? Image.network(
                          restController.pickedLogo!.path, width: 120, height: 120, fit: BoxFit.cover,
                        ) : Image.file(
                          File(restController.pickedLogo!.path), width: 120, height: 120, fit: BoxFit.cover,
                        ) : widget.restaurant.logoFullUrl != null ? CustomImageWidget(
                          image: '${widget.restaurant.logoFullUrl}',
                          height: 120, width: 120, fit: BoxFit.cover,
                        ) : SizedBox(
                          width: 120, height: 120,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            CustomAssetImageWidget(image: Images.pictureIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(
                              'click_to_add'.tr,
                              style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                            ),

                          ]),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => restController.pickImage(true, false),
                        child: DottedBorder(
                          color: Theme.of(context).hintColor,
                          strokeWidth: 1,
                          strokeCap: StrokeCap.butt,
                          dashPattern: const [5, 5],
                          padding: const EdgeInsets.all(0),
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          child: const SizedBox(width: 120, height: 120),
                        ),
                      ),
                    ),

                  ])),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault - 2),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'restaurant_cover'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                      TextSpan(
                        text: '*',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.red),
                      ),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text('image_format_and_ratio_for_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 20,
                    ),
                    child: Stack(children: [

                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: restController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                            restController.pickedCover!.path, width: context.width, height: 140, fit: BoxFit.cover,
                          ) : Image.file(
                            File(restController.pickedCover!.path), width: context.width, height: 140, fit: BoxFit.cover,
                          ) : widget.restaurant.coverPhotoFullUrl != null ? CustomImageWidget(
                            image: '${widget.restaurant.coverPhotoFullUrl}',
                            height: 140, width: context.width * 0.7, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: context.width, height: 140,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                              CustomAssetImageWidget(image: Images.pictureIcon, height: 30, width: 30, color: Theme.of(context).hintColor),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Text(
                                'click_to_add'.tr,
                                style: robotoMedium.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),

                            ]),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => restController.pickImage(false, false),
                          child: DottedBorder(
                            color: Theme.of(context).hintColor,
                            strokeWidth: 1,
                            strokeCap: StrokeCap.butt,
                            dashPattern: const [5, 5],
                            padding: const EdgeInsets.all(0),
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                            child: SizedBox(width: context.width, height: 140),
                          ),
                        ),
                      ),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('meta_data'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      SizedBox(
                        height: 40,
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).hintColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                          labelPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                          indicatorPadding: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          tabs: _tabs,
                          onTap: (int ? value) {
                            setState(() {});
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                        child: Divider(height: 0),
                      ),

                      CustomTextFieldWidget(
                        hintText: '${'meta_title'.tr} (${_languageList[_tabController!.index].value!})',
                        labelText: 'title'.tr,
                        controller: _metaTitleController[_tabController!.index],
                        capitalization: TextCapitalization.words,
                        focusNode: _metaTitleNode[_tabController!.index],
                        nextFocus: _tabController!.index != _languageList.length-1 ? _metaDescriptionNode[_tabController!.index] : _metaDescriptionNode[0],
                        showTitle: false,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      CustomTextFieldWidget(
                        hintText: '${'meta_description'.tr} (${_languageList[_tabController!.index].value!})',
                        labelText: 'description'.tr,
                        controller: _metaDescriptionController[_tabController!.index],
                        focusNode: _metaDescriptionNode[_tabController!.index],
                        capitalization: TextCapitalization.sentences,
                        maxLines: 5,
                        inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                        nextFocus: _tabController!.index != _languageList.length-1 ? _metaDescriptionNode[_tabController!.index + 1] : null,
                        showTitle: false,
                      ),

                    ]),
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('meta_image'.tr, style: robotoMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraLarge),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                ),
                child: Column(children: [

                  Stack(clipBehavior: Clip.none, children: [

                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: restController.pickedMetaImage != null ? GetPlatform.isWeb ? Image.network(
                            restController.pickedMetaImage!.path, width: 120, height: 120, fit: BoxFit.cover) : Image.file(
                            File(restController.pickedMetaImage!.path), width: 120, height: 120, fit: BoxFit.cover) : CustomImageWidget(
                          image: '${widget.restaurant.metaImageFullUrl}',
                          height: 120, width: 120, fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => restController.pickMetaImage(),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(Dimensions.radiusDefault),
                          dashPattern: const [8, 4],
                          strokeWidth: 1,
                          color: Theme.of(context).hintColor,
                          child: const SizedBox(width: 120, height: 120),
                        ),
                      ),
                    ),

                    Positioned(
                      top: -10, right: -10,
                      child: InkWell(
                        onTap: () => restController.pickMetaImage(),
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 0.5),
                          ),
                          child: const Icon(Icons.edit, color: Colors.blue, size: 16),
                        ),
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall), children: [
                      TextSpan(text: 'jpg_jpeg_png_less_than_1mb'.tr),
                      TextSpan(text: ' (${'ratio_1_1'.tr})'.tr, style: robotoBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                    ]),
                  ),

                ]),
              ),

            ]),
          )),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Get.isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.3), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 1))],
            ),
            child: CustomButtonWidget(
              isLoading: restController.isLoading,
              onPressed: () async {
                bool defaultNameNull = false;
                bool defaultAddressNull = false;
                bool defaultMetaTitleNull = false;
                bool defaultMetaDescriptionNull = false;
                for(int index=0; index<_languageList.length; index++) {
                  if(_languageList[index].key == 'en') {
                    if (_nameController[index].text.trim().isEmpty) {
                      defaultNameNull = true;
                    }
                    if(_addressController[index].text.trim().isEmpty){
                      defaultAddressNull = true;
                    }
                    if(_metaTitleController[index].text.trim().isEmpty){
                      defaultMetaTitleNull = true;
                    }
                    if(_metaDescriptionController[index].text.trim().isEmpty){
                      defaultMetaDescriptionNull = true;
                    }
                    break;
                  }
                }
                String contact = _contactController.text.trim();

                String numberWithCountryCode = _countryDialCode! + contact;
                PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
                numberWithCountryCode = phoneValid.phone;

                if(defaultNameNull) {
                  showCustomSnackBar('enter_your_restaurant_name'.tr);
                }else if(defaultAddressNull) {
                  showCustomSnackBar('enter_restaurant_address'.tr);
                }else if(contact.isEmpty) {
                  showCustomSnackBar('enter_restaurant_contact_number'.tr);
                }else if(defaultMetaTitleNull) {
                  showCustomSnackBar('enter_meta_title'.tr);
                }else if(defaultMetaDescriptionNull) {
                  showCustomSnackBar('enter_meta_description'.tr);
                }else {

                  List<Translation> translation = [];

                  for(int index=0; index<_languageList.length; index++) {
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'name',
                      value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim() : _nameController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'address',
                      value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim() : _addressController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_title',
                      value: _metaTitleController[index].text.trim().isNotEmpty ? _metaTitleController[index].text.trim() : _metaTitleController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_description',
                      value: _metaDescriptionController[index].text.trim().isNotEmpty ? _metaDescriptionController[index].text.trim() : _metaDescriptionController[0].text.trim(),
                    ));
                  }

                  _restaurant.phone = numberWithCountryCode;

                  restController.updateRestaurantBasicInfo(_restaurant, translation);
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