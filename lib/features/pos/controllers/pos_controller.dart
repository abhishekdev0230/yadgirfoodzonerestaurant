import 'package:stackfood_multivendor_restaurant/features/pos/domain/services/pos_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/models/cart_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:get/get.dart';

class PosController extends GetxController implements GetxService {
  final PosServiceInterface posServiceInterface;
  PosController({required this.posServiceInterface});

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  double _amount = 0.0;
  double get amount => _amount;

  List<int>? _variationIndex;
  List<int>? get variationIndex => _variationIndex;

  int? _quantity = 1;
  int? get quantity => _quantity;

  List<bool> _addOnActiveList = [];
  List<bool> get addOnActiveList => _addOnActiveList;

  List<int?> _addOnQtyList = [];
  List<int?> get addOnQtyList => _addOnQtyList;

  double _discount = -1;
  double get discount => _discount;

  double _tax = -1;
  double get tax => _tax;

  Future<List<Product>> searchProduct(String searchText) async {
    List<Product> searchProductList = [];
    if(searchText.isNotEmpty) {
      List<Product>? searchProduct = await posServiceInterface.searchProductList(searchText);
      if (searchProduct != null) {
        searchProductList = [];
        searchProductList.addAll(searchProduct);
      }
    }
    return searchProductList;
  }

  void addToCart(CartModel cartModel, int? index) {
    if(index != null) {
      _amount = _amount - (_cartList[index].discountedPrice! * _cartList[index].quantity!);
      _cartList.replaceRange(index, index+1, [cartModel]);
    }else {
      _cartList.add(cartModel);
    }
    _amount = _amount + (cartModel.discountedPrice! * cartModel.quantity!);
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity! + 1;
      _amount = _amount + _cartList[index].discountedPrice!;
    } else {
      _cartList[index].quantity = _cartList[index].quantity! - 1;
      _amount = _amount - _cartList[index].discountedPrice!;
    }
    update();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index].discountedPrice! * _cartList[index].quantity!);
    _cartList.removeAt(index);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds!.removeAt(addOnIndex);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    update();
  }

  bool isExistInCart(CartModel cartModel, bool willUpdate, int cartIndex) {
    for(int index=0; index<_cartList.length; index++) {
      if(_cartList[index].product!.id == cartModel.product!.id && (_cartList[index].variation!.isNotEmpty ? _cartList[index].variation![0].type
          == cartModel.variation![0].type : true)) {
        if((willUpdate && index == cartIndex)) {
          return false;
        }else {
          return true;
        }
      }
    }
    return false;
  }

  void initData(Product product, CartModel? cart) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    if(cart != null) {
      _quantity = cart.quantity;
      List<String> variationTypes = [];
      if(cart.variation!.isNotEmpty && cart.variation![0].type != null) {
        variationTypes.addAll(cart.variation![0].type!.split('-'));
      }
      List<int?> addOnIdList = [];
      for (var addOnId in cart.addOnIds!) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds![addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      }
    }else {
      _quantity = 1;
      for (var addOn in product.addOns!) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
        customPrint(addOn);
      }
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index]! + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index]! - 1;
    }
    update();
  }

  void setProductQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity! + 1;
    } else {
      _quantity = _quantity! - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex![index] = i;
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  void setDiscount(String discount) {
    try {
      _discount = double.parse(discount);
    }catch(e) {
      _discount = 0;
    }
    update();
  }

  void setTax(String tax) {
    try {
      _tax = double.parse(tax);
    }catch(e) {
      _tax = 0;
    }
    update();
  }

}