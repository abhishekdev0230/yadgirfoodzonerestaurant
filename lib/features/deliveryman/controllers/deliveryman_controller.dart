import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_list_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';


class DeliveryManController extends GetxController implements GetxService {
  final DeliverymanServiceInterface deliverymanServiceInterface;
  DeliveryManController({required this.deliverymanServiceInterface});

  List<DeliveryManModel>? _deliveryManList;
  List<DeliveryManModel>? get deliveryManList => _deliveryManList;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  List<XFile> _pickedIdentities = [];
  List<XFile> get pickedIdentities => _pickedIdentities;

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  List<String> get identityTypeList => _identityTypeList;

  int _identityTypeIndex = 0;
  int get identityTypeIndex => _identityTypeIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ReviewModel>? _dmReviewList;
  List<ReviewModel>? get dmReviewList => _dmReviewList;

  bool _isSuspended = false;
  bool get isSuspended => _isSuspended;

  List<DeliveryManListModel> _selectableDeliveryman = [];
  List<DeliveryManListModel> get selectableDeliveryman => _selectableDeliveryman;

  List<DeliveryManListModel>? _availableDeliveryManList;
  List<DeliveryManListModel>? get availableDeliveryManList => _availableDeliveryManList;

  DeliveryManListModel? _selectedDeliveryman;
  DeliveryManListModel? get selectedDeliveryMan => _selectedDeliveryman;

  Future<void> getDeliveryManList() async {
    List<DeliveryManModel>? deliveryManList = await deliverymanServiceInterface.getDeliveryManList();
    if(deliveryManList != null) {
      _deliveryManList = [];
      _deliveryManList!.addAll(deliveryManList);
    }
    update();
  }

  Future<void> addDeliveryMan(DeliveryManModel deliveryMan, String pass, String token, bool isAdd) async {
    _isLoading = true;
    update();
    bool isSuccess = await deliverymanServiceInterface.addDeliveryMan(deliveryMan, pass, _pickedImage, _pickedIdentities, token, isAdd);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar(isAdd ? 'delivery_man_added_successfully'.tr : 'delivery_man_updated_successfully'.tr, isError: false);
      getDeliveryManList();
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteDeliveryMan(int deliveryManID) async {
    _isLoading = true;
    update();
    bool isSuccess = await deliverymanServiceInterface.deleteDeliveryMan(deliveryManID);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('delivery_man_deleted_successfully'.tr, isError: false);
      getDeliveryManList();
    }
    _isLoading = false;
    update();
  }

  void setSuspended(bool isSuspended) {
    _isSuspended = isSuspended;
  }

  void toggleSuspensionDeliveryMan(int? deliveryManID) async {
    _isLoading = true;
    update();
    bool isSuccess = await deliverymanServiceInterface.updateDeliveryManStatus(deliveryManID, _isSuspended ? 1 : 0);
    if(isSuccess) {
      Get.back();
      getDeliveryManList();
      showCustomSnackBar(_isSuspended ? 'delivery_man_unsuspended_successfully'.tr : 'delivery_man_suspended_successfully'.tr, isError: false);
      _isSuspended = !_isSuspended;
    }
    _isLoading = false;
    update();
  }

  Future<void> getDeliveryManReviewList(int? deliveryManID) async {
    _dmReviewList = null;
    List<ReviewModel>? dmReviewList = await deliverymanServiceInterface.getDeliveryManReviews(deliveryManID);
    if(dmReviewList != null) {
      _dmReviewList = [];
      _dmReviewList!.addAll(dmReviewList);
    }
    update();
  }

  void setIdentityTypeIndex(String? identityType, bool notify) {
    int index0 = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        index0 = index;
        break;
      }
    }
    _identityTypeIndex = index0;
    if(notify) {
      update();
    }
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isLogo) {
        _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(xFile != null) {
          _pickedIdentities.add(xFile);
        }
      }
      update();
    }
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }

  Future<List<DeliveryManListModel>> searchDeliveryMan(String text) async {
    _selectableDeliveryman = [];
    if(text.isNotEmpty) {
      for (var deliveryMan in _availableDeliveryManList!) {
        if(deliveryMan.name!.startsWith(text)){
          _selectableDeliveryman.add(deliveryMan);
        }
      }
    }
    return _selectableDeliveryman;
  }

  void selectDeliveryManInMap(DeliveryManListModel? deliveryMan, {bool canUpdate = true}) {
    _selectedDeliveryman = deliveryMan;
    if(canUpdate) {
      update();
    }
  }

  Future<void> getAvailableDeliveryManList() async {
    _availableDeliveryManList = null;
    List<DeliveryManListModel>? availableDeliveryManList = await deliverymanServiceInterface.getAvailableDeliveryManList();
    if(availableDeliveryManList != null) {
      _availableDeliveryManList = [];
      _availableDeliveryManList!.addAll(availableDeliveryManList);
    }
    update();
  }

  Future<bool> assignDeliveryMan(int? deliveryManId, int? orderId) async {
    _isLoading = true;
    update();
    bool isSuccess = await deliverymanServiceInterface.assignDeliveryMan(deliveryManId, orderId);
    bool success;
    if(isSuccess) {
      success = true;
      Get.find<OrderController>().setOrderDetails(OrderModel(id: orderId));
      Get.back();
    }else {
      success = false;
    }
    _isLoading = false;
    update();
    return success;
  }

}