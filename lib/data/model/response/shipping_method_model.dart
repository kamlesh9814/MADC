class ShippingMethodModel {
  int? id;
  int? creatorId;
  String? creatorType;
  String? title;
  double? cost;
  String? duration;
  int? status;
  String? createdAt;
  String? updatedAt;

  ShippingMethodModel(
      {this.id,
        this.creatorId,
        this.creatorType,
        this.title,
        this.cost,
        this.duration,
        this.status,
        this.createdAt,
        this.updatedAt});


  ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    creatorType = json['creator_type'];
    title = json['title'];
    cost = json['cost'].toDouble();
    duration = json['duration'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['creator_id'] = creatorId;
    data['creator_type'] = creatorType;
    data['title'] = title;
    data['cost'] = cost;
    data['duration'] = duration;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}







//
// class ShippingMethodModel {
//   int? id;
//   String? cartGroupId;
//   int? shippingMethodId;
//   int? shippingAddressId;
//   int? shippingCost;
//   String? createdAt;
//   String? updatedAt;
//
//   ShippingMethodModel(
//       {this.id,
//         this.cartGroupId,
//         this.shippingMethodId,
//         this.shippingAddressId,
//         this.shippingCost,
//         this.createdAt,
//         this.updatedAt});
//
//   ShippingMethodModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     cartGroupId = json['cart_group_id'];
//     shippingMethodId = json['shipping_method_id'];
//     shippingAddressId = json['shipping_address_id'];
//     shippingCost = json['shipping_cost'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['cart_group_id'] = cartGroupId;
//     data['shipping_method_id'] = shippingMethodId;
//     data['shipping_address_id'] = shippingAddressId;
//     data['shipping_cost'] = shippingCost;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
