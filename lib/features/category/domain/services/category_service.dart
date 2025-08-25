import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/categoty_service_interface.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface categoryRepositoryInterface;
  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<List<CategoryModel>?> getCategoryList() async {
    return await categoryRepositoryInterface.getList();
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(int? parentID) async {
    return await categoryRepositoryInterface.getSubCategoryList(parentID);
  }

}