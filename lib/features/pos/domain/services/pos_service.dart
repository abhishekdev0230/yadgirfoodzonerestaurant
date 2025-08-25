import 'package:stackfood_multivendor_restaurant/features/pos/domain/repositories/pos_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/services/pos_service_interface.dart';
import 'package:get/get.dart';

class PosService implements PosServiceInterface {
  final PosRepositoryInterface posRepositoryInterface;
  PosService({required this.posRepositoryInterface});

  @override
  Future<Response> searchProductList(String searchText) async {
    return await posRepositoryInterface.searchProductList(searchText);
  }

  @override
  Future<Response> searchCustomerList(String searchText) async {
    return await posRepositoryInterface.searchCustomerList(searchText);
  }

  @override
  Future<Response> placeOrder(String searchText) async {
    return await posRepositoryInterface.placeOrder(searchText);
  }

  @override
  Future<Response> getPosOrders() async {
    return await posRepositoryInterface.getPosOrders();
  }

}