abstract class CategoryServiceInterface {
  Future<dynamic> getCategoryList();
  Future<dynamic> getSubCategoryList(int? parentID);
}