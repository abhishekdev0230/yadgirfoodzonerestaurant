import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/enum/time_type.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/variant_type_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/variation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/vat_tax_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantServiceInterface restaurantServiceInterface;
  RestaurantController({required this.restaurantServiceInterface});

  List<Product>? _productList;
  List<Product>? get productList => _productList;

  List<ReviewModel>? _restaurantReviewList;
  List<ReviewModel>? get restaurantReviewList => _restaurantReviewList;

  List<ReviewModel>? _searchReviewList;
  List<ReviewModel>? get searchReviewList => _searchReviewList;

  List<ReviewModel>? _productReviewList;
  List<ReviewModel>? get productReviewList => _productReviewList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  XFile? _pickedMetaImage;
  XFile? get pickedMetaImage => _pickedMetaImage;

  int? _categoryIndex = 0;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex = 0;
  int? get subCategoryIndex => _subCategoryIndex;

  List<int>? _selectedAddons;
  List<int>? get selectedAddons => _selectedAddons;

  List<VariantTypeModel>? _variantTypeList;
  List<VariantTypeModel>? get variantTypeList => _variantTypeList;

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  bool _isRecommended = true;
  bool get isRecommended => _isRecommended;

  List<Schedules>? _scheduleList;
  List<Schedules>? get scheduleList => _scheduleList;

  bool _scheduleLoading = false;
  bool get scheduleLoading => _scheduleLoading;

  bool? _isGstEnabled;
  bool? get isGstEnabled => _isGstEnabled;

  bool? _freeDeliveryDistanceEnabled;
  bool? get freeDeliveryDistanceEnabled => _freeDeliveryDistanceEnabled;

  bool? _customDateOrderEnabled;
  bool? get customDateOrderEnabled => _customDateOrderEnabled;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  bool _isVeg = false;
  bool get isVeg => _isVeg;

  bool? _isRestVeg = true;
  bool? get isRestVeg => _isRestVeg;

  bool? _isRestNonVeg = true;
  bool? get isRestNonVeg => _isRestNonVeg;

  List<VariationModel>? _variationList;
  List<VariationModel>? get variationList => _variationList;

  List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  List<String?> _restaurantTagList = [];
  List<String?> get restaurantTagList => _restaurantTagList;

  CuisineModel? _cuisineModel;
  CuisineModel? get cuisineModel => _cuisineModel;

  List<int>? _selectedCuisines;
  List<int>? get selectedCuisines => _selectedCuisines;

  List<int?>? _cuisineIds;
  List<int?>? get cuisineIds => _cuisineIds;

  Product? _product;
  Product? get product => _product;

  int _announcementStatus = 0;
  int get announcementStatus => _announcementStatus;

  bool instantOrder = false;
  bool scheduleOrder = false;

  int? _extraPackagingSelectedValue = 0;
  int? get extraPackagingSelectedValue => _extraPackagingSelectedValue;

  List<String?>? _characteristicSuggestionList;
  List<String?>? get characteristicSuggestionList => _characteristicSuggestionList;

  List<int>? _selectedCharacteristics;
  List<int>? get selectedCharacteristics => _selectedCharacteristics;

  List<String?>? _selectedCharacteristicsList;
  List<String?>? get selectedCharacteristicsList => _selectedCharacteristicsList;

  final List<String?> _stockTypeList = ['unlimited_stock', 'limited_stock', 'daily_stock'];
  List<String?> get stockTypeList => _stockTypeList;

  int? _stockTypeIndex = 0;
  int? get stockTypeIndex => _stockTypeIndex;

  bool _stockTextFieldDisable = false;
  bool get stockTextFieldDisable => _stockTextFieldDisable;

  bool _isHalal = false;
  bool get isHalal => _isHalal;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool? _isExtraPackagingEnabled;
  bool? get isExtraPackagingEnabled => _isExtraPackagingEnabled;

  bool _isFabVisible = true;
  bool get isFabVisible => _isFabVisible;

  bool _isTitleVisible = false;
  bool get isTitleVisible => _isTitleVisible;

  List<String>? _categoryNameList;
  List<String>? get categoryNameList => _categoryNameList;

  List<int>? _categoryIdList;

  int? _categoryId = 0;
  int? get categoryId => _categoryId;

  static final List<String> _productTypeList = ['all', 'veg', 'non_veg'];
  List<String> get productTypeList => _productTypeList;

  static final List<String> _foodStockList = ['all', 'stock_out'];
  List<String> get foodStockList => _foodStockList;

  String _selectedFoodType = 'all';
  String get selectedFoodType => _selectedFoodType;

  String _selectedStockType = 'all';
  String get selectedStockType => _selectedStockType;

  bool _isFilterClearLoading = false;
  bool get isFilterClearLoading => _isFilterClearLoading;

  List<String?>? _nutritionSuggestionList;
  List<String?>? get nutritionSuggestionList => _nutritionSuggestionList;

  List<int>? _selectedNutrition;
  List<int>? get selectedNutrition => _selectedNutrition;

  List<String?>? _selectedNutritionList = [];
  List<String?>? get selectedNutritionList => _selectedNutritionList;

  List<String?>? _allergicIngredientsSuggestionList;
  List<String?>? get allergicIngredientsSuggestionList => _allergicIngredientsSuggestionList;

  List<int>? _selectedAllergicIngredients;
  List<int>? get selectedAllergicIngredients => _selectedAllergicIngredients;

  List<String?>? _selectedAllergicIngredientsList = [];
  List<String?>? get selectedAllergicIngredientsList => _selectedAllergicIngredientsList;

  bool? _isDineInEnabled;
  bool? get isDineInEnabled => _isDineInEnabled;

  final List<String> _timeTypes = ['day', 'hours', 'minutes'];
  List<String> get timeTypes => _timeTypes;

  String _selectedTimeType = TimeTypes.day.name;
  String get selectedTimeType => _selectedTimeType;

  bool isDeliveryEnabled = false;

  bool isTakeAwayEnabled = false;

  bool? _isSubscriptionOrderEnabled = false;
  bool? get isSubscriptionOrderEnabled => _isSubscriptionOrderEnabled;

  bool? _isCutleryEnabled = false;
  bool? get isCutleryEnabled => _isCutleryEnabled;

  bool? _isHalalEnabled = false;
  bool? get isHalalEnabled => _isHalalEnabled;

  List<VatTaxModel>? _vatTaxList;
  List<VatTaxModel>? get vatTaxList => _vatTaxList;

  String? _selectedVatTaxName;
  String? get selectedVatTaxName => _selectedVatTaxName;

  final List<String> _selectedVatTaxNameList = [];
  List<String> get selectedVatTaxNameList => _selectedVatTaxNameList;

  final List<int> _selectedVatTaxIdList = [];
  List<int> get selectedVatTaxIdList => _selectedVatTaxIdList;

  final List<double> _selectedTaxRateList = [];
  List<double> get selectedTaxRateList => _selectedTaxRateList;

  void updateSelectedFoodType(String type) {
    _selectedFoodType = type;
    update();
  }

  void updateSelectedStockType(String type) {
    _selectedStockType = type;
    update();
  }

  void applyFilters({bool isClearFilter = false}) async{
    isClearFilter ? _isFilterClearLoading = true : _isLoading = true;
    update();

    await getProductList(offset: '1', foodType: selectedFoodType, stockType: selectedStockType, categoryId: _categoryIndex != 0 ? _categoryIdList![_categoryIndex!] : 0);
    Get.back();

    isClearFilter ? _isFilterClearLoading = false : _isLoading = false;
    update();
  }

  void initSetup() {
    _isHalal = false;
  }

  void initNutritionAndAllergicIngredientsData(Product? product) {
    _getNutritionSuggestionList();
    _getAllergicIngredientsSuggestionList();
    _selectedNutritionList = [];
    _selectedAllergicIngredientsList = [];
    if(product != null) {
      _selectedNutritionList!.addAll(product.nutrition!);
      _selectedAllergicIngredientsList!.addAll(product.allergies!);
    }
  }

  void initRestaurantBasicData() {
    _pickedLogo = null;
    _pickedCover = null;
    _pickedMetaImage = null;
  }

  void initRestaurantData(Restaurant restaurant) {
    _isGstEnabled = restaurant.gstStatus;
    _freeDeliveryDistanceEnabled = restaurant.freeDeliveryDistanceStatus;
    _customDateOrderEnabled = restaurant.customDateOrderStatus;
    _scheduleList = [];
    _scheduleList!.addAll(restaurant.schedules!);
    _isRestVeg = restaurant.veg == 1;
    _isRestNonVeg = restaurant.nonVeg == 1;
    _extraPackagingSelectedValue = restaurant.extraPackagingStatus;
    _getCuisineList(restaurant.cuisines);
    _getCharacteristicSuggestionList();
    _selectedCharacteristicsList = [];
    _selectedCharacteristicsList!.addAll(restaurant.characteristics!);
    _isExtraPackagingEnabled = restaurant.isExtraPackagingActive;
    _isDineInEnabled = (Get.find<SplashController>().configModel?.dineInOrderOption ?? false) && (restaurant.isDineInActive == true);
    setTimeType(type: restaurant.scheduleAdvanceDineInBookingDurationTimeFormat ?? '', shouldUpdate: false);
    _restaurantTagList = [];
    _restaurantTagList.addAll(restaurant.tags ?? []);
    isDeliveryEnabled = restaurant.delivery ?? false;
    isTakeAwayEnabled = restaurant.takeAway ?? false;
    _isSubscriptionOrderEnabled = restaurant.orderSubscriptionActive;
    _isCutleryEnabled = restaurant.cutlery;
    _isHalalEnabled = restaurant.isHalalActive;
  }

  void toggleSubscriptionOrder() {
    _isSubscriptionOrderEnabled = !_isSubscriptionOrderEnabled!;
    update();
  }

  void toggleCutlery() {
    _isCutleryEnabled = !_isCutleryEnabled!;
    update();
  }

  void toggleHalalTag() {
    _isHalalEnabled = !_isHalalEnabled!;
    update();
  }

  Future<void> _getCuisineList(List<Cuisine>? cuisines) async {
    _selectedCuisines = [];
    CuisineModel? cuisineModel = await restaurantServiceInterface.getCuisineList();
    if (cuisineModel != null) {
      _cuisineModel = cuisineModel;
      for (var modelCuisine in _cuisineModel!.cuisines!) {
        for(Cuisine cuisine in cuisines!){
          if(modelCuisine.id == cuisine.id){
            _selectedCuisines!.add(_cuisineModel!.cuisines!.indexOf(modelCuisine));
          }
        }
      }
    }
    update();
  }

  void setExtraPackagingSelectedValue(int value){
    _extraPackagingSelectedValue = value;
    update();
  }

  Future<void> _getCharacteristicSuggestionList() async{
    _characteristicSuggestionList = [];
    _selectedCharacteristics = [];
    List<String?>? suggestionList = await restaurantServiceInterface.getCharacteristicSuggestionList();
    if(suggestionList != null) {
      _characteristicSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_characteristicSuggestionList!.length; index++){
        _selectedCharacteristics!.add(index);
      }
    }
    update();
  }

  void setCharacteristics(String? name, {bool willUpdate = true}){
    _selectedCharacteristicsList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setTag(String? name, {bool willUpdate = true}){
    _tagList.add(name);
    if(willUpdate) {
      update();
    }
  }

  void initializeTags(){
    _tagList = [];
  }

  void removeTag(int index){
    _tagList.removeAt(index);
    update();
  }

  void setRestaurantTag(String? name, {bool willUpdate = true}){
    _restaurantTagList.add(name);
    if(willUpdate) {
      update();
    }
  }

  void initializeRestaurantTags(){
    _restaurantTagList = [];
  }

  void removeRestaurantTag(int index){
    _restaurantTagList.removeAt(index);
    update();
  }

  void setEmptyVariationList(){
    _variationList = [];
  }

  void setExistingVariation(List<Variation>? variationList){
    _variationList = [];
    if(variationList != null && variationList.isNotEmpty) {
      for (var variation in variationList) {
        List<Option> options = [];

        for (var option in variation.variationValues!) {
          options.add(Option(
            optionNameController: TextEditingController(text: option.level),
            optionPriceController: TextEditingController(text: option.optionPrice),
            optionStockController: TextEditingController(text: option.totalStock),
            optionId: option.optionId,
          ),
          );
        }

        _variationList!.add(VariationModel(
          id: variation.id,
          nameController: TextEditingController(text: variation.name),
          isSingle: variation.type == 'single' ? true : false,
          minController: TextEditingController(text: variation.min),
          maxController: TextEditingController(text: variation.max),
          required: variation.required == 'on' ? true : false,
          options: options,
        ));
      }
    }
  }

  void changeSelectVariationType(int index){
    _variationList![index].isSingle = !_variationList![index].isSingle;
    update();
  }

  void setVariationRequired(int index){
    _variationList![index].required = !_variationList![index].required;
    update();
  }

  void addVariation(){
    _variationList!.add(VariationModel(
      id: null, nameController: TextEditingController(), required: false, isSingle: true, maxController: TextEditingController(), minController: TextEditingController(),
      options: [Option(optionId: null, optionNameController: TextEditingController(), optionPriceController: TextEditingController(), optionStockController: TextEditingController())],
    ));
    update();
  }

  void removeVariation(int index){
    _variationList!.removeAt(index);
    update();
  }

  void addOptionVariation(int index){
    _variationList![index].options!.add(Option(optionId: null, optionNameController: TextEditingController(), optionPriceController: TextEditingController(), optionStockController: TextEditingController()));
    update();
  }

  void removeOptionVariation(int vIndex, int oIndex){
    _variationList![vIndex].options!.removeAt(oIndex);
    update();
  }

  Future<void> getRestaurantCategories({bool isUpdate = true}) async {
    if(Get.find<CategoryController>().categoryList == null) {
      await Get.find<CategoryController>().getCategoryList(null);
    }
    _categoryNameList = [];
    _categoryIdList = [];
    _categoryNameList!.add('all');
    _categoryIdList!.add(0);
    if(Get.find<CategoryController>().categoryList != null) {
      for(CategoryModel categoryModel in Get.find<CategoryController>().categoryList!) {
        _categoryNameList!.add(categoryModel.name!);
        _categoryIdList!.add(categoryModel.id!);
      }
    }

    if(isUpdate) {
      update();
    }

  }

  void setCategory({required int index, required String foodType, required String stockType}) {
    _categoryIndex = index;
    _productList == null;
    _categoryId = _categoryIdList![index];
    getProductList(offset: '1', foodType: foodType, stockType: stockType, categoryId: _categoryIndex != 0 ? _categoryIdList![index] : 0);
    update();
  }

  Future<void> getProductList({required String offset, required String foodType, required String stockType, int? categoryId, bool isUpdate = true}) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _selectedFoodType = foodType;
      _selectedStockType = stockType;
      _productList = null;
      if(isUpdate) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ProductModel? productModel = await restaurantServiceInterface.getProductList(offset, foodType, stockType, categoryId);
      if (productModel != null) {
        if (offset == '1') {
          _productList = [];
        }
        _productList!.addAll(productModel.products!);
        _pageSize = productModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Product? product) async {
    _discountTypeIndex = 0;
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _pickedLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    List<int?> addonsIds = await Get.find<AddonController>().getAddonList();
    if(product != null && product.addOns != null) {
      for(int index=0; index<product.addOns!.length; index++) {
        setSelectedAddonIndex(addonsIds.indexOf(product.addOns![index].id), false);
      }
    }
    await Get.find<CategoryController>().getCategoryList(product);
  }

  String? _selectedDiscountType;
  String? get selectedDiscountType => _selectedDiscountType;

  void setSelectedDiscountType(String? type) {
    _selectedDiscountType = type;
    update();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> updateRestaurantBasicInfo(Restaurant restaurant, List<Translation> translation) async {
    _isLoading = true;
    update();

    bool isSuccess = await restaurantServiceInterface.updateRestaurantBasicInfo(restaurant, _pickedLogo, _pickedCover, translation, _pickedMetaImage);
    if(isSuccess) {
      await Get.find<ProfileController>().getProfile();
      Get.back();
      showCustomSnackBar('restaurant_edit_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateRestaurant(Restaurant restaurant, List<String> cuisines) async {
    _isLoading = true;
    update();

    String tags = '';
    for (var element in _restaurantTagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }

    String characteristics = '';
    for (var element in _selectedCharacteristicsList!) {
      characteristics = characteristics + (characteristics.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }

    bool isSuccess = await restaurantServiceInterface.updateRestaurant(restaurant, cuisines, characteristics, tags);
    if(isSuccess) {
      await Get.find<ProfileController>().getProfile();
      Get.back();
      showCustomSnackBar('restaurant_settings_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  void pickMetaImage() async {
    _pickedMetaImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons!.contains(index)) {
      _selectedAddons!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons!.removeAt(index);
    update();
  }

  Future<void> addProduct(Product product, bool isAdd, List<int> deletedVariationIds, List<int> deletedVariationOptionIds) async {
    _isLoading = true;
    update();

    String tags = '';
    for (var element in _tagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }

    String nutrition = '';
    for (var index in _selectedNutritionList!) {
      nutrition = nutrition + (nutrition.isEmpty ? '' : ',') + index!.replaceAll(' ', '');
    }

    String allergicIngredients = '';
    for (var index in _selectedAllergicIngredientsList!) {
      allergicIngredients = allergicIngredients + (allergicIngredients.isEmpty ? '' : ',') + index!.replaceAll(' ', '');
    }

    bool isSuccess = await restaurantServiceInterface.addProduct(product, _pickedLogo, isAdd, tags, deletedVariationIds, deletedVariationOptionIds, nutrition, allergicIngredients);
    if(isSuccess) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(isAdd ? 'product_added_successfully'.tr : 'product_updated_successfully'.tr, isError: false);
      getProductList(offset: '1', foodType: 'all', stockType: 'all');
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteProduct(int productID) async {
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.deleteProduct(productID);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      await getProductList(offset: '1', foodType: 'all', stockType: 'all');
    }
    _isLoading = false;
    update();
  }

  Future<void> getRestaurantReviewList(int? restaurantID, String? searchText, {bool willUpdate = true}) async {
    if (searchText!.isEmpty) {
      _restaurantReviewList = null;
      _isSearching = false;
    } else {
      _searchReviewList = null;
      _isSearching = true;
    }
    if(willUpdate) {
      update();
    }
    _tabIndex = 0;
    List<ReviewModel>? restaurantReviewList = await restaurantServiceInterface.getRestaurantReviewList(restaurantID, searchText);

    if (restaurantReviewList != null) {
      if (searchText.isEmpty) {
        _restaurantReviewList = [];
        _restaurantReviewList!.addAll(restaurantReviewList);
      } else {
        _searchReviewList = [];
        _searchReviewList!.addAll(restaurantReviewList);
      }
    }
    update();
  }


  Future<void> getProductReviewList(int? productID) async {
    _productReviewList = null;
    List<ReviewModel>? productReviewList = await restaurantServiceInterface.getProductReviewList(productID);
    if(productReviewList != null) {
      _productReviewList = [];
      _productReviewList!.addAll(productReviewList);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int? productID) async {
    bool isSuccess = await restaurantServiceInterface.updateProductStatus(productID, _isAvailable ? 0 : 1);
    if(isSuccess) {
      getProductList(offset: '1', foodType: 'all', stockType: 'all');
      _isAvailable = !_isAvailable;
      showCustomSnackBar('food_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setRecommended(bool isRecommended) {
    _isRecommended = isRecommended;
  }

  void toggleRecommendedProduct(int? productID) async {
    bool isSuccess = await restaurantServiceInterface.updateRecommendedProductStatus(productID, _isRecommended ? 0 : 1);
    if(isSuccess) {
      getProductList(offset: '1', foodType: 'all', stockType: 'all');
      _isRecommended = !_isRecommended;
      showCustomSnackBar('food_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled!;
    update();
  }

  void toggleFreeDeliveryDistance() {
    _freeDeliveryDistanceEnabled = !_freeDeliveryDistanceEnabled!;
    update();
  }

  void toggleCustomDateOrder() {
    _customDateOrderEnabled = !_customDateOrderEnabled!;
    update();
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = '${schedule.openingTime!}:00';
    schedule.closingTime = '${schedule.closingTime!}:00';
    _scheduleLoading = true;
    update();
    int? scheduleID = await restaurantServiceInterface.addSchedule(schedule);
    if(scheduleID != null) {
      schedule.id = scheduleID;
      _scheduleList!.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int? scheduleID) async {
    _scheduleLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.deleteSchedule(scheduleID);
    if(isSuccess) {
      _scheduleList!.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool notify = true;
    if(_tabIndex == index) {
      notify = false;
    }
    _tabIndex = index;
    if(notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestVeg(bool? isVeg, bool notify) {
    _isRestVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestNonVeg(bool? isNonVeg, bool notify) {
    _isRestNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

  Future<Product?> getProductDetails(int productId) async {
    _isLoading = true;
    update();
    Product? product = await restaurantServiceInterface.getProductDetails(productId);
    if (product != null) {
      _product = product;
      if(_product?.translations == null || _product!.translations!.isEmpty) {
        _product!.translations = [];
        _product!.translations!.add(Translation(
          locale: Get.find<SplashController>().configModel!.language!.first.key,
          key: 'name', value: _product!.name,
        ));
        _product!.translations!.add(Translation(
          locale: Get.find<SplashController>().configModel!.language!.first.key,
          key: 'description', value: _product!.description,
        ));
      }
      _isLoading = false;
      update();
    }
    _isLoading = false;
    update();
    return _product;
  }

  Future<void> getCuisineList() async {
    _selectedCuisines = [];
    CuisineModel? cuisineModel = await restaurantServiceInterface.getCuisineList();
    if (cuisineModel != null) {
      _cuisineIds = [];
      _cuisineIds!.add(0);
      _cuisineModel = cuisineModel;
      for (var cuisine in _cuisineModel!.cuisines!) {
        _cuisineIds!.add(cuisine.id);
      }
    }
    update();
  }

  void setSelectedCuisineIndex(int index, bool notify) {
    if(!_selectedCuisines!.contains(index)) {
      _selectedCuisines!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeCuisine(int index) {
    _selectedCuisines!.removeAt(index);
    update();
  }

  void setSelectedCharacteristicsIndex(int index, bool notify) {
   if(_selectedCharacteristics!.contains(index)) {
     _selectedCharacteristicsList!.add(_characteristicSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeCharacteristic(int index) {
    _selectedCharacteristicsList!.removeAt(index);
    update();
  }

  Future<void> updateAnnouncement(int status, String announcement) async{
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.updateAnnouncement(status, announcement);
    if(isSuccess){
      Get.back();
      showCustomSnackBar('announcement_updated_successfully'.tr, isError: false);
      Get.find<ProfileController>().getProfile();
    }
    _isLoading = false;
    update();
  }

  void setAnnouncementStatus(int index){
    _announcementStatus = index;
    update();
  }

  Future<void> updateReply(int reviewID, String reply) async {
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.updateReply(reviewID, reply);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('reply_updated_successfully'.tr, isError: false);
      getRestaurantReviewList(Get.find<ProfileController>().profileModel!.restaurants![0].id, '');
    }
    _isLoading = false;
    update();
  }

  void setInstantOrder(bool value){
    if(!checkOrderWarning(value, scheduleOrder)){
      instantOrder = value;
    }
    update();
  }

  void setOrderStatus(bool instant, bool schedule){
    instantOrder = instant;
    scheduleOrder = schedule;
    update();
  }

  void setScheduleOrder(bool value){
    if(!checkOrderWarning(instantOrder, value)){
      scheduleOrder = value;
    }
    update();
  }

  bool checkOrderWarning(bool instantOrder, bool scheduleOrder){
    if(!instantOrder && !scheduleOrder){
      showCustomSnackBar('can_not_disable_both_instance_order_and_schedule_order'.tr, isError: true);
    }
    return (!instantOrder && !scheduleOrder);
  }

  void setHomeDelivery(bool value){
    if(!checkDeliveryWarning(value, isTakeAwayEnabled)){
      isDeliveryEnabled = value;
    }
    update();
  }

  void setTakeAway(bool value){
    if(!checkDeliveryWarning(isDeliveryEnabled, value)){
      isTakeAwayEnabled = value;
    }
    update();
  }

  bool checkDeliveryWarning(bool delivery, bool takeAway){
    if(!delivery && !takeAway){
      showCustomSnackBar('can_not_disable_both_delivery_and_take_away'.tr, isError: true);
    }
    return (!delivery && !takeAway);
  }

  void setStockTypeIndex(int? index, bool notify) {
    _stockTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setStockFieldDisable(bool status, {bool notify = true}) {
    _stockTextFieldDisable = status;
    if(notify) {
      update();
    }
  }

  void toggleHalal({bool willUpdate = true}) {
    _isHalal = !_isHalal;
    if(willUpdate) {
      update();
    }
  }

  void toggleExtraPackaging() {
    _isExtraPackagingEnabled = !_isExtraPackagingEnabled!;
    update();
  }

  Future<void> updateProductStock({required String foodId, required String itemStock, required Product product, required List<List<String>> variationStock}) async {
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.updateProductStock(foodId, itemStock, product, variationStock);
    if(isSuccess) {
      await getProductList(offset: '1', foodType: 'all', stockType: 'all');
      Get.back();
      Get.back();
      showCustomSnackBar('stock_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void showFab() {
    _isFabVisible = true;
    update();
  }

  void hideFab() {
    _isFabVisible = false;
    update();
  }

  void showTitle() {
    _isTitleVisible = true;
    update();
  }

  void hideTitle() {
    _isTitleVisible = false;
    update();
  }

  Future<void> _getNutritionSuggestionList() async{
    _nutritionSuggestionList = [];
    _selectedNutrition = [];
    List<String?>? suggestionList = await restaurantServiceInterface.getNutritionSuggestionList();
    if(suggestionList != null) {
      _nutritionSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_nutritionSuggestionList!.length; index++){
        _selectedNutrition!.add(index);
      }
    }
    update();
  }

  void setNutrition(String? name, {bool willUpdate = true}){
    _selectedNutritionList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setSelectedNutritionIndex(int index, bool notify) {
    if(_selectedNutrition!.contains(index)) {
      _selectedNutritionList!.add(_nutritionSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeNutrition(int index) {
    _selectedNutritionList!.removeAt(index);
    update();
  }

  Future<void> _getAllergicIngredientsSuggestionList() async{
    _allergicIngredientsSuggestionList = [];
    _selectedAllergicIngredients = [];
    List<String?>? suggestionList = await restaurantServiceInterface.getAllergicIngredientsSuggestionList();
    if(suggestionList != null) {
      _allergicIngredientsSuggestionList!.addAll(suggestionList);
      for(int index=0; index<_allergicIngredientsSuggestionList!.length; index++){
        _selectedAllergicIngredients!.add(index);
      }
    }
    update();
  }

  void setAllergicIngredients(String? name, {bool willUpdate = true}){
    _selectedAllergicIngredientsList!.add(name);
    if(willUpdate) {
      update();
    }
  }

  void setSelectedAllergicIngredientsIndex(int index, bool notify) {
    if(_selectedAllergicIngredients!.contains(index)) {
      _selectedAllergicIngredientsList!.add(_allergicIngredientsSuggestionList![index]);
      if(notify) {
        update();
      }
    }
  }

  void removeAllergicIngredients(int index) {
    _selectedAllergicIngredientsList!.removeAt(index);
    update();
  }

  void toggleDineIn() {
    _isDineInEnabled = !_isDineInEnabled!;
    update();
  }

  void setTimeType({required String type, bool shouldUpdate = true}) {
    _selectedTimeType = type;
    if(shouldUpdate){
      update();
    }
  }

  Future<void> getVatTaxList() async {
    List<VatTaxModel>? vatTaxList = await restaurantServiceInterface.getVatTaxList();
    if(vatTaxList != null) {
      _vatTaxList = [];
      _vatTaxList!.addAll(vatTaxList);
    }
    update();
  }

  void setSelectedVatTax(String? vatTaxName, int? vatTaxId, double? taxRate) {
    if (vatTaxName != null && vatTaxId != null) {
      if (_selectedVatTaxNameList.contains(vatTaxName) || _selectedVatTaxIdList.contains(vatTaxId)) {
        showCustomSnackBar('vat_tax_already_added_please_select_another'.tr);
      } else {
        _selectedVatTaxName = vatTaxName;
        _selectedVatTaxNameList.add(vatTaxName);
        _selectedVatTaxIdList.add(vatTaxId);
        _selectedTaxRateList.add(taxRate ?? 0);
        update();
      }
    }
  }

  void removeVatTax(String vatTaxName, int vatTaxId, double taxRate) {
    _selectedVatTaxName = null;
    _selectedVatTaxNameList.remove(vatTaxName);
    _selectedVatTaxIdList.remove(vatTaxId);
    _selectedTaxRateList.remove(taxRate);
    update();
  }

  void clearVatTax() {
    _selectedVatTaxName = null;
    _selectedVatTaxNameList.clear();
    _selectedVatTaxIdList.clear();
    _selectedTaxRateList.clear();
  }

  void preloadVatTax({required List<int> vatTaxList}) {
    _selectedVatTaxNameList.clear();
    _selectedVatTaxIdList.clear();
    _selectedTaxRateList.clear();
    for (int id in vatTaxList) {
      final VatTaxModel? vatTax = _vatTaxList?.firstWhereOrNull((vat) => vat.id == id);
      if (vatTax != null) {
        _selectedVatTaxNameList.add(vatTax.name!);
        _selectedVatTaxIdList.add(vatTax.id!);
        _selectedTaxRateList.add(vatTax.taxRate ?? 0);
      }
    }
  }

}