import 'dart:convert';
import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/repositories/addon_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/services/addon_service.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/services/addon_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/controllers/advertisement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/domain/repositories/advertisement_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/domain/repositories/advertisement_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/domain/services/advertisement_service.dart';
import 'package:stackfood_multivendor_restaurant/features/advertisement/domain/services/advertisement_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/auth_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/forgot_password_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/forgot_password_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/location_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/location_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/auth_service.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/auth_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/forgot_password_service.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/forgot_password_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/location_service.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/location_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/repositories/business_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/repositories/business_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/services/business_service.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/services/business_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/repositories/campaign_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/services/campaign_service.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/services/campaign_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/repositories/category_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/category_service.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/services/categoty_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/repositories/chat_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/services/chat_service.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/services/coupon_service.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/repositories/deliveryman_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/services/deliveryman_service.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/controllers/disbursement_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/repositories/disbursement_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/services/disbursement_service.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/domain/services/disbursement_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/controllers/expense_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/repositories/expense_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/repositories/expense_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/services/expense_service.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/domain/services/expense_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/repositories/language_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/repositories/language_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/services/language_service.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/services/language_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/repositories/notification_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/services/notification_service.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/domain/services/notification_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/repositories/order_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_service.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/services/order_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/repositories/payment_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/services/payment_service.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/domain/services/payment_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/controllers/pos_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/repositories/pos_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/repositories/pos_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/services/pos_service.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/domain/services/pos_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/repositories/profile_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/services/profile_service.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/services/profile_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/repositories/report_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/repositories/report_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/services/report_service.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/services/report_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/domain/repositories/splash_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/domain/repositories/splash_repository_service.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/domain/services/splash_service.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/domain/services/splash_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/services/subscription_service.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/features/language/domain/models/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {

  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  /// Repo Interfaces
  AuthRepositoryInterface authRepoInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepoInterface);

  LocationRepositoryInterface locationRepositoryInterface = LocationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => locationRepositoryInterface);

  AddonRepositoryInterface addonRepoInterface = AddonRepository(apiClient: Get.find());
  Get.lazyPut(() => addonRepoInterface);

  AdvertisementRepositoryInterface advertisementRepositoryInterface = AdvertisementRepository(apiClient: Get.find());
  Get.lazyPut(() => advertisementRepositoryInterface);

  BusinessRepositoryInterface businessPlanRepoInterface = BusinessRepository(apiClient: Get.find());
  Get.lazyPut(() => businessPlanRepoInterface);

  SubscriptionRepositoryInterface subscriptionRepositoryInterface = SubscriptionRepository(apiClient: Get.find());
  Get.lazyPut(() => subscriptionRepositoryInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);

  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(sharedPreferences: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => splashRepositoryInterface);

  CampaignRepositoryInterface campaignRepositoryInterface = CampaignRepository(apiClient: Get.find());
  Get.lazyPut(() => campaignRepositoryInterface);

  CategoryRepositoryInterface categoryRepositoryInterface = CategoryRepository(apiClient: Get.find());
  Get.lazyPut(() => categoryRepositoryInterface);

  ChatRepositoryInterface chatRepositoryInterface = ChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => chatRepositoryInterface);

  CouponRepositoryInterface couponRepositoryInterface = CouponRepository(apiClient: Get.find());
  Get.lazyPut(() => couponRepositoryInterface);

  DeliverymanRepositoryInterface deliverymanRepositoryInterface = DeliverymanRepository(apiClient: Get.find());
  Get.lazyPut(() => deliverymanRepositoryInterface);

  DisbursementRepositoryInterface disbursementRepositoryInterface = DisbursementRepository(apiClient: Get.find());
  Get.lazyPut(() => disbursementRepositoryInterface);

  ExpenseRepositoryInterface expenseRepositoryInterface = ExpenseRepository(apiClient: Get.find());
  Get.lazyPut(() => expenseRepositoryInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);

  ReportRepositoryInterface reportRepositoryInterface = ReportRepository(apiClient: Get.find());
  Get.lazyPut(() => reportRepositoryInterface);

  LanguageRepositoryInterface languageRepositoryInterface = LanguageRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => languageRepositoryInterface);

  OrderRepositoryInterface orderRepositoryInterface = OrderRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => orderRepositoryInterface);

  PosRepositoryInterface posRepositoryInterface = PosRepository(apiClient: Get.find());
  Get.lazyPut(() => posRepositoryInterface);

  PaymentRepositoryInterface paymentRepositoryInterface = PaymentRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => paymentRepositoryInterface);

  RestaurantRepositoryInterface restaurantRepositoryInterface = RestaurantRepository(apiClient: Get.find());
  Get.lazyPut(() => restaurantRepositoryInterface);

  ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface = ForgotPasswordRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => forgotPasswordRepositoryInterface);

  /// Service Interfaces
  AuthServiceInterface authServiceInterface = AuthService(authRepoInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  LocationServiceInterface locationServiceInterface = LocationService(locationRepositoryInterface: Get.find());
  Get.lazyPut(() => locationServiceInterface);

  AddonServiceInterface addonServiceInterface = AddonService(addonRepoInterface: Get.find());
  Get.lazyPut(() => addonServiceInterface);

  AdvertisementServiceInterface advertisementServiceInterface = AdvertisementService(advertisementRepositoryInterface: Get.find());
  Get.lazyPut(() => advertisementServiceInterface);

  BusinessServiceInterface businessServiceInterface = BusinessService(businessRepositoryInterface: Get.find());
  Get.lazyPut(() => businessServiceInterface);

  SubscriptionServiceInterface subscriptionServiceInterface = SubscriptionService(subscriptionRepositoryInterface: Get.find());
  Get.lazyPut(() => subscriptionServiceInterface);

  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: Get.find());
  Get.lazyPut(() => splashServiceInterface);

  CampaignServiceInterface campaignServiceInterface = CampaignService(campaignRepositoryInterface: Get.find());
  Get.lazyPut(() => campaignServiceInterface);

  CategoryServiceInterface categoryServiceInterface = CategoryService(categoryRepositoryInterface: Get.find());
  Get.lazyPut(() => categoryServiceInterface);

  ChatServiceInterface chatServiceInterface = ChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => chatServiceInterface);

  CouponServiceInterface couponServiceInterface = CouponService(couponRepositoryInterface: Get.find());
  Get.lazyPut(() => couponServiceInterface);

  DeliverymanServiceInterface deliverymanServiceInterface = DeliverymanService(deliverymanRepositoryInterface: Get.find());
  Get.lazyPut(() => deliverymanServiceInterface);

  DisbursementServiceInterface disbursementServiceInterface = DisbursementService(disbursementRepositoryInterface: Get.find());
  Get.lazyPut(() => disbursementServiceInterface);

  ExpenseServiceInterface expenseServiceInterface = ExpenseService(expenseRepositoryInterface: Get.find());
  Get.lazyPut(() => expenseServiceInterface);

  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  ReportServiceInterface reportServiceInterface = ReportService(reportRepositoryInterface: Get.find());
  Get.lazyPut(() => reportServiceInterface);

  LanguageServiceInterface languageServiceInterface = LanguageService(languageRepositoryInterface: Get.find());
  Get.lazyPut(() => languageServiceInterface);

  OrderServiceInterface orderServiceInterface = OrderService(orderRepositoryInterface: Get.find());
  Get.lazyPut(() => orderServiceInterface);

  PosServiceInterface posServiceInterface = PosService(posRepositoryInterface: Get.find());
  Get.lazyPut(() => posServiceInterface);

  PaymentServiceInterface paymentServiceInterface = PaymentService(paymentRepositoryInterface: Get.find());
  Get.lazyPut(() => paymentServiceInterface);

  RestaurantServiceInterface restaurantServiceInterface = RestaurantService(restaurantRepositoryInterface: Get.find());
  Get.lazyPut(() => restaurantServiceInterface);

  ForgotPasswordServiceInterface forgotPasswordServiceInterface = ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find());
  Get.lazyPut(() => forgotPasswordServiceInterface);

  /// Services
  Get.lazyPut(() => AuthService(authRepoInterface: Get.find()));
  Get.lazyPut(() => LocationService(locationRepositoryInterface: Get.find()));
  Get.lazyPut(() => AddonService(addonRepoInterface: Get.find()));
  Get.lazyPut(() => AdvertisementService(advertisementRepositoryInterface: Get.find()));
  Get.lazyPut(() => BusinessService(businessRepositoryInterface: Get.find()));
  Get.lazyPut(() => SubscriptionService(subscriptionRepositoryInterface: Get.find()));
  Get.lazyPut(() => ProfileService(profileRepositoryInterface: Get.find()));
  Get.lazyPut(() => SplashService(splashRepositoryInterface: Get.find()));
  Get.lazyPut(() => CampaignService(campaignRepositoryInterface: Get.find()));
  Get.lazyPut(() => CategoryService(categoryRepositoryInterface: Get.find()));
  Get.lazyPut(() => ChatService(chatRepositoryInterface: Get.find()));
  Get.lazyPut(() => CouponService(couponRepositoryInterface: Get.find()));
  Get.lazyPut(() => DeliverymanService(deliverymanRepositoryInterface: Get.find()));
  Get.lazyPut(() => DisbursementService(disbursementRepositoryInterface: Get.find()));
  Get.lazyPut(() => ExpenseService(expenseRepositoryInterface: Get.find()));
  Get.lazyPut(() => NotificationService(notificationRepositoryInterface: Get.find()));
  Get.lazyPut(() => ReportService(reportRepositoryInterface: Get.find()));
  Get.lazyPut(() => LanguageService(languageRepositoryInterface: Get.find()));
  Get.lazyPut(() => OrderService(orderRepositoryInterface: Get.find()));
  Get.lazyPut(() => PosService(posRepositoryInterface: Get.find()));
  Get.lazyPut(() => PaymentService(paymentRepositoryInterface: Get.find()));
  Get.lazyPut(() => RestaurantService(restaurantRepositoryInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find()));

  /// Controller
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => LocationController(locationServiceInterface: Get.find()));
  Get.lazyPut(() => AddonController(addonServiceInterface: Get.find()));
  Get.lazyPut(() => AdvertisementController(advertisementServiceInterface: Get.find()));
  Get.lazyPut(() => BusinessController(businessServiceInterface: Get.find()));
  Get.lazyPut(() => SubscriptionController(subscriptionServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => SplashController(splashServiceInterface: Get.find()));
  Get.lazyPut(() => CampaignController(campaignServiceInterface: Get.find()));
  Get.lazyPut(() => CategoryController(categoryServiceInterface: Get.find()));
  Get.lazyPut(() => ChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => CouponController(couponServiceInterface: Get.find()));
  Get.lazyPut(() => DeliveryManController(deliverymanServiceInterface: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementServiceInterface: Get.find()));
  Get.lazyPut(() => ExpenseController(expenseServiceInterface: Get.find()));
  Get.lazyPut(() => LocalizationController(languageServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => ReportController(reportServiceInterface: Get.find()));
  Get.lazyPut(() => OrderController(orderServiceInterface: Get.find()));
  Get.lazyPut(() => PosController(posServiceInterface: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => PaymentController(paymentServiceInterface: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantServiceInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordController(forgotPasswordServiceInterface: Get.find()));

  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}