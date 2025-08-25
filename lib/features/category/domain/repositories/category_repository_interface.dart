import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class CategoryRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getSubCategoryList(int? parentID);
}