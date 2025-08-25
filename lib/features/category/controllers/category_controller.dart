import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/categoty_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  List<int?> _categoryIds = [];
  List<int?> get categoryIds => _categoryIds;

  List<int?> _subCategoryIds = [];
  List<int?> get subCategoryIds => _subCategoryIds;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  int? _categoryIndex = 0;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex = 0;
  int? get subCategoryIndex => _subCategoryIndex;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  Future<void> getCategoryList(Product? product) async {

    _categoryIds = [];
    _subCategoryIds = [];
    _categoryIds.add(0);
    _subCategoryIds.add(0);

    List<CategoryModel>? categoryList = await categoryServiceInterface.getCategoryList();

    if(categoryList != null) {
      _categoryList = [];
      _categoryList!.addAll(categoryList);
      if(_categoryList != null){
        for(int index=0; index<_categoryList!.length; index++) {
          _categoryIds.add(_categoryList![index].id);
        }
        if(product != null) {
          setCategoryIndex(_categoryIds.indexOf(int.parse(product.categoryIds![0].id!)), false);
          await getSubCategoryList(int.parse(product.categoryIds![0].id!), product);
        }
      }
    }
    update();
  }

  Future<void> getSubCategoryList(int? categoryID, Product? product) async {

    _subCategoryIndex = 0;
    _subCategoryList = [];
    _subCategoryIds = [];
    _subCategoryIds.add(0);

    if(categoryID != 0) {
      List<CategoryModel>? subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
      if(subCategoryList != null){
        _subCategoryList = [];
        _subCategoryList!.addAll(subCategoryList);
        if(_subCategoryList != null){
          for(int index=0; index<_subCategoryList!.length; index++) {
            _subCategoryIds.add(_subCategoryList![index].id);
          }
          if(product != null && product.categoryIds!.length > 1) {
            setSubCategoryIndex(_subCategoryIds.indexOf(int.parse(product.categoryIds![1].id!)), false);
          }
        }
      }
    }
    update();
  }

  void setCategoryIndex(int? index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int? index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      update();
    }
  }

  void expandedUpdate(bool status){
    _isExpanded = status;
    update();
  }

  int? _categoryIndex0 = 0;
  int? get categoryIndex0 => _categoryIndex0;

  int? _selectedCategoryIndex = 0;
  int? get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    update();
  }

  void setCategory(int index) {
    _categoryIndex0 = index;
    Get.find<RestaurantController>().productList == null;
    Get.find<RestaurantController>().getProductList(offset: '1', foodType: Get.find<RestaurantController>().selectedFoodType, stockType: Get.find<RestaurantController>().selectedStockType, categoryId: _categoryIndex0 != 0 ? _categoryList![index].id : 0);
    update();
  }

}