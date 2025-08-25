enum NotificationType{
  message,
  order,
  general,
  advertisement,
  block,
  unblock,
  withdraw,
  campaign,
}

class NotificationBodyModel {
  NotificationType? notificationType;
  int? orderId;
  int? customerId;
  int? deliveryManId;
  int? conversationId;
  String? type;
  int? adminId;
  int? advertisementId;
  int? campaignId;

  NotificationBodyModel({
    this.notificationType,
    this.orderId,
    this.customerId,
    this.deliveryManId,
    this.conversationId,
    this.type,
    this.adminId,
    this.advertisementId,
    this.campaignId,
  });

  NotificationBodyModel.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    customerId = json['customer_id'];
    deliveryManId = json['delivery_man_id'];
    conversationId = json['conversation_id'];
    type = json['type'];
    adminId = json['admin_id'];
    advertisementId = json['advertisement_id'];
    campaignId = json['data_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['delivery_man_id'] = deliveryManId;
    data['conversation_id'] = conversationId;
    data['type'] = type;
    data['admin_id'] = adminId;
    data['advertisement_id'] = advertisementId;
    data['data_id'] = campaignId;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    if(enumString == NotificationType.general.toString()) {
      return NotificationType.general;
    }else if(enumString == NotificationType.order.toString()) {
      return NotificationType.order;
    }else if(enumString == NotificationType.message.toString()) {
      return NotificationType.message;
    }else if(enumString == NotificationType.advertisement.toString()) {
      return NotificationType.advertisement;
    }else if(enumString == NotificationType.block.toString()) {
      return NotificationType.block;
    }else if(enumString == NotificationType.unblock.toString()) {
      return NotificationType.unblock;
    }else if(enumString == NotificationType.withdraw.toString()) {
      return NotificationType.withdraw;
    }else if(enumString == NotificationType.campaign.toString()) {
      return NotificationType.campaign;
    }
    return NotificationType.general;
  }
}