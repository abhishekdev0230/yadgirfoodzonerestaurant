import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_cancellation_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_details_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/running_order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/models/subscription_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderController extends GetxController implements GetxService {
  final OrderServiceInterface orderServiceInterface;
  OrderController({required this.orderServiceInterface});

  List<OrderModel>? _runningOrderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;

  List<RunningOrderModel>? _runningOrders;
  List<RunningOrderModel>? get runningOrders => _runningOrders;

  List<OrderModel>? _historyOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;

  List<OrderDetailsModel>? _orderDetailsModel;
  List<OrderDetailsModel>? get orderDetailsModel => _orderDetailsModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _orderIndex = 0;
  int get orderIndex => _orderIndex;

  bool _campaignOnly = false;
  bool get campaignOnly => _campaignOnly;

  bool _subscriptionOnly = false;
  bool get subscriptionOnly => _subscriptionOnly;

  String _otp = '';
  String get otp => _otp;

  int _historyIndex = 0;
  int get historyIndex => _historyIndex;

  final List<String> _statusList = ['all', 'delivered', 'refunded', 'canceled', 'failed'];
  List<String> get statusList => _statusList;

  bool _paginate = false;
  bool get paginate => _paginate;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<int> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  List<CancellationData>? _orderCancelReasons;
  List<CancellationData>? get orderCancelReasons => _orderCancelReasons;

  String? _cancelReason = '';
  String? get cancelReason => _cancelReason;

  SubscriptionModel? _subscriptionModel;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  bool _isFirstTimeSubOrder = true;

  bool _showDeliveryImageField = false;
  bool get showDeliveryImageField => _showDeliveryImageField;

  List<XFile> _pickedPrescriptions = [];
  List<XFile> get pickedPrescriptions => _pickedPrescriptions;

  bool _hideNotificationButton = false;
  bool get hideNotificationButton => _hideNotificationButton;

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  Future<bool> sendDeliveredNotification(int? orderID) async {
    _hideNotificationButton = true;
    update();
    bool success = await orderServiceInterface.sendDeliveredNotification(orderID);
    bool isSuccess;
    success ? isSuccess = true : isSuccess = false;
    _hideNotificationButton = false;
    update();
    return isSuccess;
  }

  void changeDeliveryImageStatus({bool willUpdate = true}){
    _showDeliveryImageField = !_showDeliveryImageField;
    if(willUpdate) {
      update();
    }
  }

  void pickPrescriptionImage({required bool isRemove, required bool isCamera}) async {
    if(isRemove) {
      _pickedPrescriptions = [];
    }else {
      XFile? xFile = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 50);
      if(xFile != null) {
        _pickedPrescriptions.add(xFile);
        if(Get.isDialogOpen!){
          Get.back();
        }
      }
      update();
    }
  }

  void removePrescriptionImage(int index) {
    _pickedPrescriptions.removeAt(index);
    update();
  }

  void setOrderCancelReason(String? reason){
    _cancelReason = reason;
    update();
  }

  Future<void> getOrderCancelReasons() async {
    List<CancellationData>? orderCancelReasons = await orderServiceInterface.getCancelReasons();
    if (orderCancelReasons != null) {
      _orderCancelReasons = [];
      _orderCancelReasons!.addAll(orderCancelReasons);
    }
    update();
  }


  Future<void> setOrderDetails(OrderModel orderModel) async {
    if(orderModel.orderStatus != null && orderModel.customer != null && orderModel.deliveryMan != null){
      _orderModel = orderModel;
    }else{
      OrderModel? order = await orderServiceInterface.getOrderWithId(orderModel.id);
      if(order != null) {
        _orderModel = order;
      }
      update();
    }
  }

  Future<void> getCurrentOrders() async {
    List<OrderModel>? runningOrderList = await orderServiceInterface.getCurrentOrders();
    if(runningOrderList != null) {
      _runningOrderList = [];
      _runningOrders = [
        RunningOrderModel(status: 'pending', orderList: []),
        RunningOrderModel(status: 'confirmed', orderList: []),
        RunningOrderModel(status: 'cooking', orderList: []),
        RunningOrderModel(status: 'ready_for_handover', orderList: []),
        RunningOrderModel(status: 'food_on_the_way', orderList: []),
      ];

      if((Get.find<ProfileController>().modulePermission?.regularOrder ?? false) && (Get.find<ProfileController>().modulePermission?.subscriptionOrder ?? false)){
        _runningOrderList!.addAll(runningOrderList);
      }else if(Get.find<ProfileController>().modulePermission?.regularOrder ?? false) {
        _runningOrderList!.addAll(runningOrderList.where((order) => order.subscriptionId == null));
      }else if(Get.find<ProfileController>().modulePermission?.subscriptionOrder ?? false) {
        _runningOrderList!.addAll(runningOrderList.where((order) => order.subscriptionId != null));
      }

      _campaignOnly = true;
      toggleCampaignOnly();
    }
    update();
  }

  Future<void> getPaginatedOrders(int offset, bool reload, {required int isSubscription}) async {
    if(offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if(reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      PaginatedOrderModel? historyOrderModel = await orderServiceInterface.getPaginatedOrderList(offset: offset, status: _statusList[_historyIndex], isSubscription: isSubscription);
      if (historyOrderModel != null) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        _historyOrderList!.addAll(historyOrderModel.orders!);
        _pageSize = historyOrderModel.totalSize;
        _paginate = false;
        update();
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<bool> updateOrderStatus(int? orderID, String status, {bool back = false, String? processingTime, String? reason}) async {
    _isLoading = true;
    update();
    List<MultipartBody> multiParts = [];
    for(XFile file in _pickedPrescriptions) {
      multiParts.add(MultipartBody('order_proof[]', file));
    }
    UpdateStatusModel updateStatusBody = UpdateStatusModel(
      orderId: orderID, status: status,
      otp: status == 'delivered' ? _otp : null,
      processingTime: processingTime,
      reason: reason,
    );
    ResponseModel responseModel = await orderServiceInterface.updateOrderStatus(updateStatusBody, multiParts);
    Get.back(result: responseModel.isSuccess);
    if(responseModel.isSuccess) {
      if(back) {
        Get.back();
      }
      getCurrentOrders();
      showCustomSnackBar(responseModel.message, isError: false);
    }else{
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return responseModel.isSuccess;
  }

  Future<void> getOrderDetails(int orderID) async {
    _orderDetailsModel = null;
    Response response = await orderServiceInterface.getOrderDetails(orderID);
    if(response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body['order']['details'].forEach((orderDetails) => _orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
      if(response.body['order']['subscription'] != null){
        _subscriptionModel = SubscriptionModel.fromJson(response.body['order']['subscription']);
      }
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    update();
  }

  void toggleCampaignOnly() {
    if(_subscriptionOnly){
      _subscriptionOnly = !_subscriptionOnly;
    }
    _campaignOnly = !_campaignOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if(order.orderStatus == 'pending' && (Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman'
          || order.orderType == 'take_away' || Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1)
          && (_campaignOnly ? order.foodCampaign == 1 :  order.subscriptionId == null)) {
        _runningOrders![0].orderList.add(order);
      }else if((order.orderStatus == 'confirmed' || (order.orderStatus == 'accepted' && (order.confirmed != null || order.accepted != null)))
          && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![1].orderList.add(order);
      }else if(order.orderStatus == 'processing' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![2].orderList.add(order);
      }else if(order.orderStatus == 'handover' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![3].orderList.add(order);
      }else if(order.orderStatus == 'picked_up' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void toggleSubscriptionOnly() {

    if(_campaignOnly && !_isFirstTimeSubOrder){
      _campaignOnly = !_campaignOnly;
    }
    _isFirstTimeSubOrder = false;
    _subscriptionOnly = !_subscriptionOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if(order.orderStatus == 'pending' && (Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman'
          || order.orderType == 'take_away' || Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1)
          && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![0].orderList.add(order);
      }else if((order.orderStatus == 'confirmed' || (order.orderStatus == 'accepted' && order.confirmed != null))
          && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![1].orderList.add(order);
      }else if(order.orderStatus == 'processing' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![2].orderList.add(order);
      }else if(order.orderStatus == 'handover' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![3].orderList.add(order);
      }else if(order.orderStatus == 'picked_up' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if(otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(1, true, isSubscription: _orderTypeIndex == 1 ? 1 : 0);
    update();
  }

  String? getBluetoothMacAddress() => orderServiceInterface.getBluetoothAddress();

  void setBluetoothMacAddress(String? address) => orderServiceInterface.setBluetoothAddress(address);

  Future<void> addDineInTableAndTokenNumber({int? orderId, String? tableNumber, String? tokenNumber}) async {
    _isLoading = true;
    update();
    bool isSuccess = await orderServiceInterface.addDineInTableAndTokenNumber(orderId, tableNumber, tokenNumber);
    if(isSuccess){
      await setOrderDetails(_orderModel!);
      showCustomSnackBar('table_token_added_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void changeOrderTypeIndex(int index, {bool isUpdate = true}) {
    _orderTypeIndex = index;
    getPaginatedOrders(1, true, isSubscription: index == 1 ? 1 : 0);
    if(isUpdate) {
      update();
    }
  }

}