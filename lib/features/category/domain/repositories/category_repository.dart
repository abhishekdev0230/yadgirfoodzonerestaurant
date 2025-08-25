import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;
  CategoryRepository({required this.apiClient});

  @override
  Future<List<CategoryModel>?> getList() async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(AppConstants.categoryUri);
    if(response.statusCode == 200) {
      categoryList = [];
      response.body.forEach((category) => categoryList!.add(CategoryModel.fromJson(category)));
    }
    return categoryList;
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if(response.statusCode == 200) {
      subCategoryList = [];
      response.body.forEach((subCategory) => subCategoryList!.add(CategoryModel.fromJson(subCategory)));
    }
    return subCategoryList;
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}