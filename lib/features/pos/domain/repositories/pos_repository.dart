import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/repositories/pos_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class PosRepository implements PosRepositoryInterface {
  final ApiClient apiClient;
  PosRepository({required this.apiClient});

  @override
  Future<List<Product>?> searchProductList(String searchText) async {
    List<Product>? searchProductList;
    Response response = await apiClient.postData(AppConstants.searchProductListUri, {'name': searchText});
    if (response.statusCode == 200) {
      searchProductList = [];
      response.body.forEach((food) => searchProductList!.add(Product.fromJson(food)));
    }
    return searchProductList;
  }

  @override
  Future<Response> searchCustomerList(String searchText) async {
    return await apiClient.getData('${AppConstants.searchCustomersUri}?search=$searchText');
  }

  @override
  Future<Response> placeOrder(String searchText) async {
    return await apiClient.postData(AppConstants.placeOrderUri, {});
  }

  @override
  Future<Response> getPosOrders() async {
    return await apiClient.getData(AppConstants.posOrdersUri);
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
  Future getList() {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}